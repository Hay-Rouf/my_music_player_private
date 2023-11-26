import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

import 'constants.dart';
import 'models/database_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await MobileAds.instance.initialize();
  dir = Directory(par);
  await JustAudioBackground.init();
  parFolder = await getApplicationDocumentsDirectory();

  HiveSaver.init();
  await getImageAssetUri();
  await getSongs();
  runApp(const MyApp());
}
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
