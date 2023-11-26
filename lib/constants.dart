import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/music_model.dart';

export '../controller/app_binding.dart';
export '../controller/app_controller.dart';
export '../screens/home_screen.dart';
export '../screens/player_screen.dart';
export '../widgets/home_ widget.dart';
export  '../screens/splash_screen.dart';
export  '../admob/service.dart';
export  '../admob/adunit.dart';
export '../screens/search_screen.dart';
export '../screens/folder_music_screen.dart';
export '../models/music_model.dart';

export 'constants.dart';
export 'main.dart';

const Color myBlue = Color(0xff1603c2);
const Color myWhite = Color(0xffdadfe8);
const Color myBlack = Color(0xff000000);
const Color myRed = Color(0xfff80202);
List<SongModel> songModels = <SongModel>[];

List<MusicModel> musicModels = <MusicModel>[];

setMusics(List<MusicModel> musics) {
  musicModels = musics;
  print('len: ${musics.length}, ${musicModels.length}');
}
Future<void> getSongs() async {
  songModels =  await OnAudioQuery().querySongs(
    sortType: SongSortType.TITLE,
    orderType: OrderType.ASC_OR_SMALLER,
    uriType: UriType.EXTERNAL,
    ignoreCase: true,
  );
  print('songModels.length: ${songModels.length}');
}
Future getImageAssetUri() async {
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
  appImage = await file.readAsBytes();
}

Future<String> getImageUri(Uint8List image,String id) async {
  // final byteData = await rootBundle.load(assetImage);
  // final buffer = byteData.buffer;
  Directory folder = await getApplicationDocumentsDirectory();
  var filePath = '${folder.path}/$id.jpg';
  File file = File(filePath);
  await file.create(recursive: true).whenComplete(() {
    file.writeAsBytesSync(image);
  });
  return file.path;
}

late Uint8List appImage;
late Directory dir;
late Directory parFolder;
String par = '/storage/emulated/0/';

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
int kAdIndex = 4;

int getDestinationItemIndex(int rawIndex) {
  if (rawIndex >= kAdIndex) {
    return rawIndex - 1;
  }
  return rawIndex;
}

String appName = 'Music Player';
String assetImage = 'app_icon.jpeg';

// Future getPermission() async {
//   await Permission.storage.request();
//   await Permission.manageExternalStorage.request();
// }
