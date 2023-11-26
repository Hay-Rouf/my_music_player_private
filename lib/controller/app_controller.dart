import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart' as rx;

import '../constants.dart';

enum Loop { all, one, off }

MainController mainController = Get.find<MainController>();

class MainController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    // LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    // audioQuery.setLogConfig(logConfig);
    await checkAndRequestPermissions().whenComplete(() async {
      await getAlbums();
      await getAllFolders();
      await getArtist();
    });
  }

  final GetStorage box = GetStorage('data');

  // String fileFolder = 'HayRouf/$appName/'.replaceAll(' ', '_');

  // List<String> readFavourites() {
  //   List<String> fav = preferences.getStringList('fav') ?? [];
  //   return fav;
  // }

  checkPlaying(bool value) {
    playing.value = value;
  }

  RxBool playing = false.obs;

  // RxBool favSurah = false.obs;
  //
  // checkFav(SurahModel model) {
  //   List<String> favourite = readFavourites();
  //   String value = json.encode(model.toMap());
  //   favSurah.value = favourite.contains(value);
  // }
  //
  // writeFavourites(SurahModel model) async {
  //   List<String> favourite = readFavourites();
  //   String value = json.encode(model.toMap());
  //   String fav = favSurah.value ? 'Removed from' : 'Added to';
  //   favSurah.value ? favourite.remove(value) : favourite.add(value);
  //   favSurah.value = favourite.contains(value);
  //   // await controller.box.write('fav', favourite);
  //   await preferences.setStringList('fav', favourite);
  //   // print('fav: $favourite\ncon: ${favourite.contains(value)}');
  //   snackBar('Success',
  //       txt1: '${model.englishName} $fav Favourites');
  // }

  final AudioPlayer player = AudioPlayer();

  get playLength => player.sequence?.length;

  Stream<PlayerState> get playerStateStream => player.playerStateStream;

  Stream<double> get speedStream => player.speedStream;

  double get speed => player.speed;

  deleteFile(String fileName) {
    File(fileName).delete();
    print(fileName);
    snackBar('Success', txt1: '$fileName has been deleted');
  }

  initSize(Size size) {
    size = size;
  }

  setSpeed(value) => player.setSpeed(value);

  bool tapA = false;

  Stream get currentIndexStream => player.currentIndexStream;

  // getMetadata(String path) async {
  //   final metadata = await MetadataRetriever.fromFile(File(path));
  //   print(
  //       'albumName: ${metadata.albumName}, ${metadata.trackName}, ${metadata.trackArtistNames}, ${metadata.albumArt}');
  // }

  List<AudioSource> list = [];

  Rx<Loop> loop = Loop.all.obs;

  changeLoop() async {
    if (loop.value == Loop.all) {
      loop.value = Loop.one;
      await player.setLoopMode(LoopMode.one);
    } else if (loop.value == Loop.one) {
      loop.value = Loop.off;
      await player.setLoopMode(LoopMode.off);
    } else if (loop.value == Loop.off) {
      loop.value = Loop.all;
      await player.setLoopMode(LoopMode.all);
    }
  }

  bool checkFiles(String filename) {
    bool value = false;
    try {
      List<FileSystemEntity> files = dir.listSync();
      for (var element in files) {
        if (element.path.contains(filename)) {
          value = true;
        }
      }
    } catch (e) {
      value = false;
    }
    return value;
  }

  // RxString currentFile = ''.obs;

  // set currentFileIndexSetter(String value) => currentFile.value = value;

  Duration defaultDuration = const Duration(seconds: 2);

  Future<void> play() async {
    await player.play();
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> skipToNext() async {
    await player.seekToNext();
  }

  Future<void> skipToPrevious() async {
    await player.seekToPrevious();
  }

  Future<void> seek(Duration position) async {
    player.seek(position);
  }

  stop() async {
    await player.stop();
  }

  seekAudio(durationToSeek) async {
    if (durationToSeek is double) {
      await player.seek(Duration(milliseconds: durationToSeek.toInt()));
      play();
    } else if (durationToSeek is Duration) {
      await player.seek(durationToSeek);
      play();
    }
  }

  int total = 100;

  // getValue(double value) {
  //   return value;
  // }

  snackBar(String txt, {String? txt1}) {
    Get.snackbar(
      txt,
      txt1 ?? '',
      margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
      padding: const EdgeInsets.all(10),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  Stream<PositionData> get positionDataStream {
    return rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
            position, bufferedPosition, duration ?? Duration.zero));
  }

  getDownloads() {
    List<String> downloadedFiles = [];
    try {
      List<FileSystemEntity> files = dir.listSync();
      for (var element in files) {
        downloadedFiles.add(element.path);
      }
    } catch (e) {
      // value = false;
    }
    return downloadedFiles;
  }

  // Rx<String?> displaySurahEng = details[player.currentIndex!]['title'].obs;
  RxString displaySurahAr = ''.obs;

  List<Map<String, dynamic>> details = [];

  RxInt get currentPlayerIndex => player.currentIndex!.obs;

  RxList<MusicModel> currentFolder = <MusicModel>[].obs;

  setPlayer({
    required List<MusicModel> filesData,
    required int initIndex,
  }) async {
    currentFolder.value = filesData;
    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: filesData
          .map(
            (e) => AudioSource.file(
              e.data,
              tag: MediaItem(
                id: e.id.toString(),
                title: e.title,
                artist: e.artist,
                artUri: File(e.imageUri).uri,
              ),
            ),
          )
          .toList(),
    );
    Get.toNamed(PlayerScreen.id);
    await player.setAudioSource(playlist,
        initialIndex: initIndex, initialPosition: Duration.zero);
    await play();
  }

  String formatTime(Duration? duration) {
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    if (duration != null) {
      final hour = twoDigit(duration.inHours);
      final minutes = twoDigit(duration.inMinutes.remainder(60));
      final seconds = twoDigit(duration.inSeconds.remainder(60));
      return [
        if (duration.inHours > 0) hour,
        minutes,
        seconds,
      ].join(':');
    } else {
      return '';
    }
  }

  // Future<Uint8List> getImageList() async {
  //   final byteData = await rootBundle.load(assetImage);
  //   final buffer = byteData.buffer;
  //   Directory folder = await getApplicationDocumentsDirectory();
  //   var filePath = '${folder.path}/logo.png';
  //   File file = File(filePath);
  //   await file.create(recursive: true).whenComplete(
  //         () async => await file.writeAsBytes(
  //           buffer.asUint8List(
  //             byteData.offsetInBytes,
  //             byteData.lengthInBytes,
  //           ),
  //         ),
  //       );
  //   return file.readAsBytesSync();
  // }

  RxList<FileSystemEntity> musics = <FileSystemEntity>[].obs;

  RxList<String> musicsFolder = <String>[].obs;

  // List<String> getFolderMusic(String dir) {
  //   List<String> folderMusic = [];
  //   musics.forEach((element) {
  //     element.path.startsWith(dir) ? folderMusic.add(element.path) : null;
  //   });
  //   folderMusic.sort();
  //   return folderMusic;
  // }

  final OnAudioQuery audioQuery = OnAudioQuery();
  RxBool hasPermission = false.obs;

  Future checkAndRequestPermissions({bool retry = false}) async {
    hasPermission.value = await audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    hasPermission;
  }

  RxList<SongModel> folderMusic = <SongModel>[].obs;

  RxList<AlbumModel> albumModels = <AlbumModel>[].obs;

  RxList<ArtistModel> artistModels = <ArtistModel>[].obs;

  RxList<String> paths = <String>[].obs;

  Future getAlbums() async {
    albumModels.value = await audioQuery.queryAlbums(
      sortType: AlbumSortType.ALBUM,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    print('albumModel.length: ${albumModels.length}');
  }

  Future getArtist() async {
    artistModels.value = await audioQuery.queryArtists(
      sortType: ArtistSortType.ARTIST,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    print('albumModel.length: ${albumModels.length}');
  }

  List<MusicModel> getAlbumAudio(AlbumModel albumModel) {
    return musicModels.where((e) => e.albumId == albumModel.id).toList();
  }

  List<MusicModel> getArtistAudio(ArtistModel artistModel) {
    return musicModels.where((e) => e.artistId == artistModel.id).toList();
  }

  Future getAllFolders() async {
    // audioModel.value =
    paths.value = await audioQuery.queryAllPath();
    print('path.length: ${paths.length}');
  }

  List<MusicModel> getFolderMusics(String path) {
    // print('path: $path');
    return musicModels.where((e) => e.data.startsWith(path)).toList();
  }
}
