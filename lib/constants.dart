import 'dart:ui';

import 'package:permission_handler/permission_handler.dart';

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

export 'constants.dart';
export 'main.dart';

const Color myBlue = Color(0xff1603c2);
const Color myWhite = Color(0xffdadfe8);
const Color myBlack = Color(0xff000000);
const Color myRed = Color(0xfff80202);

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

Future getPermission() async {
  await Permission.storage.request();
  await Permission.manageExternalStorage.request();
}
