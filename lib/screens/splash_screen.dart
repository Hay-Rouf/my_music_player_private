import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_music_player/models/database_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../constants.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  static const String id = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhite,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                assetImage,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .35,
            child: Text(
              appName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
              bottom: MediaQuery.of(context).size.height * .25,
              child: Obx(() {
                return controller.current.value < 100
                    ? Column(children: [
                        CircularProgressIndicator(
                          value: controller.current.value <= 0.0
                              ? null
                              : controller.current.value / 100,
                        ),
                        Text('${controller.current.value.toInt()}%'),
                      ])
                    : FloatingActionButton(
                        onPressed: () async {
                          var data = await HiveSaver.checkMusic();
                          print('data: ${data.runtimeType}');
                        },
                        child: Text('check'),
                      );
              })),
        ],
      ),
    );
  }
}

class SplashController extends GetxController {
  final MainController mainController = MainController();
  RxDouble current = 0.0.obs;

  Future<List<MusicModel>> getMusicData() async {
    List<MusicModel> musicModels = [];
    for (SongModel element in songModels) {
      OnAudioQuery onAudioQuery = OnAudioQuery();
      Uint8List imageList =
          await onAudioQuery.queryArtwork(element.id, ArtworkType.AUDIO) ??
              appImage;
      String imageUri = await getImageUri(imageList, element.id.toString());
      final MusicModel musicModel = MusicModel.getData(
        songModel: element,
        imageList: imageList,
        imageUri: imageUri,
      );
      current.value =
          (songModels.indexOf(element) + 1) / songModels.length * 100;
      musicModels.add(musicModel);
      print('curr: $current');
    }
    HiveSaver.saveMusics(musicModels);
    setMusics(musicModels);
    Get.offNamed(HomeScreen.id);
    return musicModels;
  }

  @override
  onInit() async {
    // await getPermission();
    // await mainController.getAllMusics().whenComplete(() {
    //   Get.offNamed(HomeScreen.id);
    // });
    List<MusicModel>? musics = await HiveSaver.checkMusic();
    if (musics == null) {
      await getMusicData();
    } else {
      setMusics(musics);
      Get.offNamed(HomeScreen.id);
    }
    super.onInit();
  }

  @override
  Future<void> onClose() async {
    await adManager.loadInterstitialAd();
    super.onClose();
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
