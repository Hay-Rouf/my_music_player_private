import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as rx;

import '../constants.dart';

enum Loop { all, one, off }

class MainController extends GetxController {
  @override
  Future<void> onInit() async {
    await getPermission().whenComplete(() => getAllMusics());

    super.onInit();
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

  RxList<AudioModel> currentFolder = <AudioModel>[].obs;

  setPlayer({
    required List<AudioModel> filesData,
    required int initIndex,
  }) async {
    currentFolder.value = filesData;
    Get.toNamed(PlayerScreen.id);
    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: filesData
          .map((e) => AudioSource.file(e.path,
              tag: MediaItem(
                id: e.id,
                title: e.title,
                artist: e.artist,
                artUri: appImage
              )))
          .toList(),
    );
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

  Future<Uint8List> getImageList() async {
    final byteData = await rootBundle.load(assetImage);
    final buffer = byteData.buffer;
    Directory folder = await getApplicationDocumentsDirectory();
    var filePath = '${folder.path}/logo.png';
    File file = File(filePath);
    await file.create(recursive: true).whenComplete(
          () async => await file.writeAsBytes(
            buffer.asUint8List(
              byteData.offsetInBytes,
              byteData.lengthInBytes,
            ),
          ),
        );
    return file.readAsBytesSync();
  }

  RxList<FileSystemEntity> musics = <FileSystemEntity>[].obs;

  RxList<String> musicsFolder = <String>[].obs;

  List<String> getFolderMusics(String dir) {
    List<String> folderMusic = [];
    musics.forEach((element) {
      element.path.startsWith(dir) ? folderMusic.add(element.path) : null;
    });
    folderMusic.sort();
    return folderMusic;
  }

  List<AudioModel> allMusicData = [];

  Future<bool> getAllMusics() async {
    print('starts');
    List<FileSystemEntity> files;
    List<FileSystemEntity> songs = [];
    List<String> songsFolder = [];
    List<String> folders = [];
    List<Metadata> metadatas = [];
    List<AudioModel> musicData = [];
    files = dir.listSync(recursive: false);
    for (FileSystemEntity entity in files) {
      entity is File ||
              entity.path.contains('.') ||
              entity.path.contains('Android')
          ? null
          : folders.add(entity.path);
    }
    // print(files);
    folders.forEach((element) {
      try {
        List<FileSystemEntity> musicFiles =
            Directory(element).listSync(recursive: true);
        musicFiles.forEach((entity) async {
          String path = entity.path;
          // String pathFolder = entity.parent.path;
          if (path.endsWith('.mp3')) {
            songs.add(entity);
            songsFolder.add(entity.parent.path);
            List split = entity.path.split('/');
            String id = split.last.toString();
            String title = split.last.replaceAll('.mp3', '');
            String artist = split[split.length - 2];
            AudioModel audioModel =
                AudioModel(artist: artist, title: title, id: id, path: path);
            musicData.add(audioModel);
          }
        });
      } catch (e) {
        print('e: $e');
      }
    });
    musicData.sort((a, b) => a.id.compareTo(b.id));
    songs.sort((a, b) => a.path.compareTo(b.path));
    songsFolder.sort((a, b) => a.split('/').last.compareTo(b.split('/').last));
    // print(folders);
    // print(songs);
    print(songs.length);
    musicsFolder.value = songsFolder.toSet().toList();
    musics.value = songs;
    allMusicData = musicData;
    // songs.forEach((element) async {
    //   final metadata = await MetadataRetriever.fromFile(File(element.path));
    //   metadatas.add(metadata);
    //   print('${metadatas.length} == ${songs.length}');
    // });
    // metaData = metadatas;
    return metadatas.length == musics.length;
  }

  List<AudioModel> testFunc(List<String> musicFolder) {
    // print(musicFolder);
    return allMusicData
        .where((element) => musicFolder.contains(element.path))
        .toList();
  }
}

class AudioModel {
  final String artist;
  final String title;
  final String id;
  final String path;

  AudioModel({
    required this.artist,
    required this.title,
    required this.id,
    required this.path,
  });
}


//
// setChildren({
//   required String currentFile,
//   required List<String> filesData,
//   // required List<Metadata> metadatas,
// }) async {
//   // details.clear();
//   // List<FileSystemEntity> filesData = dir.listSync();
//   List<Map<String, dynamic>> newDetails = [];
//   int initIndex = 0;
//   List<AudioSource> children = [];
//   initIndex = filesData.indexOf(currentFile);
//
//   if (filesData.length > 50) {
//     List<String> split = currentFile.split('/');
//     String id = split.last.toString();
//     String title = split.last.replaceAll('.mp3', '');
//     String artist = split[split.length - 2];
//     Uint8List artPic = await getImageList();
//     Map<String, dynamic> data = {
//       'id': id,
//       'title': title,
//       'artist': artist,
//       'artPic': artPic,
//     };
//     details = [data];
//     Uri art =
//     // metadata.albumArt == null
//     //     ?
//     await getImageFileFromAssets();
//     await player.setAudioSource(AudioSource.file(
//       currentFile,
//       tag: MediaItem(
//         id: id,
//         title: title,
//         artist: artist,
//         artUri: art,
//       ),
//     ));
//     await play();
//     for (int i = 0; i <= filesData.length - 1; i++) {
//       print('i: $i');
//       String file = filesData[i];
//       // Metadata metadata = getMusicData(file);
//       // if (file.contains(currentFile)) {
//       //   initIndex = filesData.indexOf(file);
//       // }
//       List<String> split = file.split('/');
//       // String id = split;
//       // final metadata = await MetadataRetriever.fromFile(File(file));
//       // // print(
//       // //     'albumName: ${metadata.albumName}, ${metadata.trackName}, ${metadata.trackArtistNames}, ${metadata.albumArt}');
//       // String titleAr = metadata.trackArtistNames?[0] ?? split;
//
//       // String title = metadata.trackName ?? split;
//       String id = split.last.toString();
//       String title = split.last.replaceAll('.mp3', '');
//       String artist = split[split.length - 2];
//       Uint8List artPic = await getImageList();
//       Uri art =
//       // metadata.albumArt == null
//       //     ?
//       await getImageFileFromAssets();
//       //     : File.fromRawPath(metadata.albumArt!).uri;
//       Map<String, dynamic> data = {
//         'id': id,
//         'title': title,
//         'artist': artist,
//         'artPic': artPic,
//       };
//       newDetails.add(data);
//       children.add(
//         AudioSource.file(
//           file,
//           tag: MediaItem(
//             id: id,
//             title: title,
//             artist: artist,
//             artUri: art,
//           ),
//         ),
//       );
//     }
//     details = newDetails;
//     final playlist = ConcatenatingAudioSource(
//       // Start loading next item just before reaching it
//       useLazyPreparation: true,
//       // Customise the shuffle algorithm
//       shuffleOrder: DefaultShuffleOrder(),
//       // Specify the playlist items
//       children: children,
//     );
//     list = children;
//     await player.setAudioSource(playlist,
//         initialIndex: initIndex, initialPosition: Duration.zero);
//     player.setLoopMode(LoopMode.all);
//     await play();
//     checkPlaying(true);
//   } else {
//     for (int i = 0; i <= filesData.length - 1; i++) {
//       print('i: $i');
//       String file = filesData[i];
//       // Metadata metadata = getMusicData(file);
//       // if (file.contains(currentFile)) {
//       //   initIndex = filesData.indexOf(file);
//       // }
//       List<String> split = file.split('/');
//       // String id = split;
//       // final metadata = await MetadataRetriever.fromFile(File(file));
//       // // print(
//       // //     'albumName: ${metadata.albumName}, ${metadata.trackName}, ${metadata.trackArtistNames}, ${metadata.albumArt}');
//       // String titleAr = metadata.trackArtistNames?[0] ?? split;
//
//       // String title = metadata.trackName ?? split;
//       String id = split.last.toString();
//       String title = split.last.replaceAll('.mp3', '');
//       String artist = split[split.length - 2];
//       Uint8List artPic = await getImageList();
//       Uri art =
//       // metadata.albumArt == null
//       //     ?
//       await getImageFileFromAssets();
//       //     : File.fromRawPath(metadata.albumArt!).uri;
//       Map<String, dynamic> data = {
//         'id': id,
//         'title': title,
//         'artist': artist,
//         'artPic': artPic,
//       };
//       newDetails.add(data);
//       children.add(
//         AudioSource.file(
//           file,
//           tag: MediaItem(
//             id: id,
//             title: title,
//             artist: artist,
//             artUri: art,
//           ),
//         ),
//       );
//     }
//     details = newDetails;
//     final playlist = ConcatenatingAudioSource(
//       // Start loading next item just before reaching it
//       useLazyPreparation: true,
//       // Customise the shuffle algorithm
//       shuffleOrder: DefaultShuffleOrder(),
//       // Specify the playlist items
//       children: children,
//     );
//     list = children;
//     await player.setAudioSource(playlist,
//         initialIndex: initIndex, initialPosition: Duration.zero);
//     player.setLoopMode(LoopMode.all);
//     await play();
//     checkPlaying(true);
//   }
// }
