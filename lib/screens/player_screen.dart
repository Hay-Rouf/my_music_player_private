import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../constants.dart';

class PlayerScreen extends GetView<MainController> {
  const PlayerScreen({Key? key}) : super(key: key);
  static const String id = '/playerScreen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const BannerWidget(),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: myWhite,
            ),
            onPressed: () {
              Get.back();
              adManager.loadInterstitialAd();
            },
          ),
          title: StreamBuilder(
              stream: controller.currentIndexStream,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  int index = snapshot.data!;
                  return Text(
                    controller.currentFolder[index].title,
                    style: const TextStyle(fontSize: 20, color: myWhite),
                  );
                }
                return const Center(
                    child: CircularProgressIndicator(
                  color: myBlue,
                ));
              }),
          centerTitle: true,
          //
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            StreamBuilder(
                stream: controller.currentIndexStream,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    int index = snapshot.data!;
                    return Image.asset(
                      assetImage,
                      height: MediaQuery.of(context).size.height * .45,
                      fit: BoxFit.cover,
                    );
                  }
                  return Image.asset(
                    assetImage,
                    height: MediaQuery.of(context).size.height * .45,
                    fit: BoxFit.cover,
                  );
                }),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(.4),
                  alignment: Alignment.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    child: NativeAdsWidget(
                      widget: Image.asset(
                        assetImage,
                        height: MediaQuery.of(context).size.height * .45,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // StreamBuilder(
                    //     stream: controller.currentIndexStream,
                    //     builder: (_, snapshot) {
                    //       if (snapshot.hasData) {
                    //         int index = snapshot.data!;
                    //         return Image.asset(
                    //           assetImage,
                    //           height: MediaQuery.of(context).size.height * .45,
                    //           fit: BoxFit.cover,
                    //         );
                    //       }
                    //       return Image.asset(
                    //         assetImage,
                    //         height: MediaQuery.of(context).size.height * .45,
                    //         fit: BoxFit.cover,
                    //       );
                    //     }),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder(
                      stream: controller.currentIndexStream,
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          int index = snapshot.data!;
                          return Text(
                            controller.currentFolder[index].artist,
                            style:
                                const TextStyle(fontSize: 20, color: myWhite),
                          );
                        }
                        return const Center(
                            child: CircularProgressIndicator(
                          color: myBlue,
                        ));
                      }),
                  const SizedBox(height: 10),
                  const SeekBar(),
                  const SizedBox(height: 10),
                  const PlayerTools(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeekBar extends GetView<MainController> {
  const SeekBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Duration? a;
    // Duration? b;
    double sliderValue = 0.0;
    return StreamBuilder<PositionData>(
        stream: controller.positionDataStream,
        builder: (context, snapshot) {
          final positionData = snapshot.data;
          Duration duration =
              positionData?.duration ?? controller.defaultDuration;
          Duration position = positionData?.position ?? Duration.zero;
          sliderValue = min(position.inMilliseconds.toDouble(),
              duration.inMilliseconds.toDouble());
          return Column(
            children: [
              SizedBox(
                height: 10,
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: myWhite,
                    trackHeight: 3,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 5),
                    thumbColor: myWhite,
                    inactiveTrackColor: myWhite.withOpacity(.2),
                  ),
                  child: Slider(
                    min: 0.0,
                    max: duration.inMilliseconds.toDouble(),
                    value: sliderValue,
                    onChanged: (value) {
                      controller
                          .seekAudio(Duration(milliseconds: value.round()));
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        controller.formatTime(
                            position < duration ? position : Duration.zero),
                        style: TextStyle(color: myWhite, fontSize: 10),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        controller.formatTime(duration),
                        textAlign: TextAlign.end,
                        style: TextStyle(color: myWhite, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}

class PlayerTools extends GetView<MainController> {
  const PlayerTools({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Obx(() {
        //   return IconButton(
        //     onPressed: constantsController.changeLoop,
        //     icon: repeatButton(constantsController.loop.value),
        //   );
        // }),
        GestureDetector(
          onTap: controller.changeLoop,
          child: StreamBuilder(
              stream: controller.loop.stream,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  Loop loopChecker = snapshot.data!;
                  switch (loopChecker) {
                    case Loop.all:
                      return Icon(
                        Icons.repeat,
                        color: myWhite,
                        size: iconSize,
                      );
                    case Loop.one:
                      return Icon(
                        Icons.repeat_one,
                        color: myWhite,
                        size: iconSize,
                      );
                    case Loop.off:
                      return Icon(
                        Icons.repeat_on_sharp,
                        color: myWhite,
                        size: iconSize,
                      );
                  }
                }
                return const Icon(
                  Icons.repeat,
                  color: myWhite,
                );
              }),
        ),
        IconButton(
            onPressed: controller.skipToPrevious,
            icon: Icon(
              Icons.skip_previous,
              size: iconSize,
              color: myWhite,
            )),
        StreamBuilder<PlayerState>(
          stream: controller.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                //padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: myWhite.withOpacity(.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const SpinKitRipple(
                  color: myWhite,
                ),
              );
            } else if (playing == false) {
              return InkWell(
                onTap: controller.play,
                child: CircleAvatar(
                  backgroundColor: myWhite.withOpacity(.3),
                  radius: iconSize * .8,
                  child: Icon(
                    Icons.play_arrow,
                    color: myWhite,
                    size: iconSize,
                  ),
                ),
              );
            } else if (processingState == ProcessingState.completed) {
              return InkWell(
                onTap: () => controller.seekAudio(Duration.zero),
                child: CircleAvatar(
                  backgroundColor: myWhite.withOpacity(.3),
                  radius: iconSize * .8,
                  child: Icon(
                    Icons.play_arrow,
                    size: iconSize,
                    color: myWhite,
                  ),
                ),
              );
            } else {
              return InkWell(
                onTap: controller.pause,
                child: CircleAvatar(
                  backgroundColor: myWhite.withOpacity(.3),
                  radius: iconSize * .8,
                  child: Icon(
                    Icons.pause,
                    size: iconSize,
                    color: myWhite,
                  ),
                ),
              );
            }
          },
        ),
        IconButton(
          onPressed: controller.skipToNext,
          icon: Icon(
            Icons.skip_next,
            size: iconSize,
            color: myWhite,
          ),
        ),
        StreamBuilder<double>(
          stream: controller.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(
              Icons.speed,
              color: myWhite,
              size: iconSize,
            ),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                // divisions: 10,
                min: 0.5,
                max: 1.5,
                value: controller.speed,
                stream: controller.speedStream,
                onChanged: controller.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required double min,
  required double max,
  String valueSuffix = '',
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// NativeAdWidget(
//   customWidget: Image.asset(
//     assetImage,
//     height: MediaQuery.of(context).size.height * .45,
//     fit: BoxFit.cover,
//   ),
// ),
// GetX<AdManager>(
//   initState: (_) {
//     _.controller?.loadNativeAds(AdUnits.NativeAdvanced);
//   },
//   builder: (logic) {
//     return adManager.nativeAd != null
//         ? ConstrainedBox(
//             constraints: const BoxConstraints(
//               minWidth: 320,
//               minHeight: 320,
//               maxWidth: 400,
//               maxHeight: 400,
//             ),
//             child: AdWidget(ad: adManager.nativeAd!.value),
//           )
//         : Image.asset(
//             assetImage,
//             height:
//                 MediaQuery.of(context).size.height * .45,
//             fit: BoxFit.cover,
//           );
//   },
// ),

// Obx(() {
//   // print(controller.player.currentIndex);
//   return Text(
//     controller.details[controller.player.currentIndex!]['title']!,
//     style: TextStyle(fontSize: 20, color: myWhite),
//   );
// }),
