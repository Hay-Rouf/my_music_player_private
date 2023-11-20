import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
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
            bottom: MediaQuery.of(context).size.height * .3,
            child:Center(
              child: CircularProgressIndicator(),
            )
          ),
        ],
      ),
    );
  }
}

class SplashController extends GetxController {
  final MainController mainController = MainController();

  @override
  onInit() async {
    // await getPermission();
    // await mainController.getAllMusics().whenComplete(() {
    //   Get.offNamed(HomeScreen.id);
    // });
    Future.delayed(const Duration(seconds: 5), () {
      Get.offNamed(HomeScreen.id);
    });
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
