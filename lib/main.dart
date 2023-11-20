import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await MobileAds.instance.initialize();
  dir = Directory(par);
  await JustAudioBackground.init();
  await getImageFileFromAssets();
  parFolder = await getApplicationDocumentsDirectory();
  runApp(const MyApp());
}
Future getImageFileFromAssets() async {
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
  appImage = file.uri;
}
late Uri appImage;
late Directory dir;
late Directory parFolder;
String par = '/storage/emulated/0/';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Music Player',
      initialBinding: AppBinding(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: myBlue),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.id,
      // home: NativeAdsWidget(),
      getPages: [
        GetPage(
          name: HomeScreen.id,
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: PlayerScreen.id,
          page: () => const PlayerScreen(),
        ),
        GetPage(
          name: SplashScreen.id,
          page: () => const SplashScreen(),
          binding: SplashBinding(),
        ),
      ],
    );
  }
}
