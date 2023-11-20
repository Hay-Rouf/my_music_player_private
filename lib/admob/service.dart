import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constants.dart';

class AdManager extends GetxController {
  // late final AppLifecycleReactor appLifecycleReactor;

  AppOpenAd? _appOpenAd;

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  //https://x.com/Assimalhakeem/status/1716392494210982048?s=20

  @override
  Future<void> onInit() async {
    // appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: AdManager());
    // appLifecycleReactor.listenToAppStateChanges();
    super.onInit();
  }

  // Future<void> loadAppOpenAd() async {
  //   AppOpenAd.load(
  //     adUnitId: AdUnits.appOpenTest,
  //     orientation: AppOpenAd.orientationPortrait,
  //     adLoadCallback: AppOpenAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         _appOpenAd = ad;
  //         ad.fullScreenContentCallback = const FullScreenContentCallback();
  //         ad.show();
  //       },
  //       onAdFailedToLoad: (error) {
  //         if (kDebugMode) {
  //           print('AppOpenAd failed to load: $error');
  //         }
  //       },
  //     ),
  //     request: const AdRequest(),
  //   );
  // }

  InterstitialAd? interstitialAd;

  Future<void> loadInterstitialAd() async {
    // await InterstitialAd.load(
    //     adUnitId: AdUnits.interstitial,
    //     request: const AdRequest(),
    //     adLoadCallback: InterstitialAdLoadCallback(
    //       onAdLoaded: (ad) async {
    //         ad.fullScreenContentCallback = FullScreenContentCallback(
    //             onAdShowedFullScreenContent: (ad) {},
    //             onAdImpression: (ad) {},
    //             onAdFailedToShowFullScreenContent: (ad, err) {
    //               ad.dispose();
    //             },
    //             onAdDismissedFullScreenContent: (ad) {
    //               ad.dispose();
    //             },
    //             onAdClicked: (ad) {});
    //
    //         debugPrint('$ad loaded.');
    //         interstitialAd = ad;
    //         await ad.show();
    //       },
    //       // Called when an ad request failed.
    //       onAdFailedToLoad: (LoadAdError error) {
    //         debugPrint('InterstitialAd failed to load: $error');
    //       },
    //     ));
  }

  Future<void> rewardedAd() async {
    // await RewardedAd.load(
    //     adUnitId: AdUnits.reward,
    //     request: const AdRequest(),
    //     rewardedAdLoadCallback: RewardedAdLoadCallback(
    //       onAdLoaded: (ad) async {
    //         ad.fullScreenContentCallback = FullScreenContentCallback(
    //             onAdShowedFullScreenContent: (ad) {},
    //             onAdImpression: (ad) {},
    //             onAdFailedToShowFullScreenContent: (ad, err) {
    //               ad.dispose();
    //             },
    //             onAdDismissedFullScreenContent: (ad) {
    //               ad.dispose();
    //             },
    //             onAdClicked: (ad) {});
    //
    //         debugPrint('$ad loaded.');
    //         await ad.show(
    //             onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {});
    //       },
    //       // Called when an ad request failed.
    //       onAdFailedToLoad: (LoadAdError error) {
    //         debugPrint('InterstitialAd failed to load: $error');
    //       },
    //     ));
  }

  @override
  void onClose() {
    _appOpenAd?.dispose();
    super.onClose();
  }
}

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  BannerAd? bannerAd;

  Future<void> loadBanner() async {
    await BannerAd(
      adUnitId: kDebugMode ? AdUnits.bannerTest : AdUnits.banner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          if (kDebugMode) {
            print(
                'Ad load failed (code=${error.code} message=${error.message})');
          }
        },
      ),
    ).load();
    setState(() {});
  }

  @override
  void initState() {
    loadBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return bannerAd == null
        ? const SizedBox.shrink()
        : ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: AdSize.banner.width.toDouble(),
              minHeight: AdSize.banner.height.toDouble(),
              maxWidth: AdSize.fullBanner.width.toDouble(),
              maxHeight: AdSize.fullBanner.height.toDouble(),
            ),
            child: AdWidget(ad: bannerAd!));
  }
}

// Future<void> showAppOpenIfAvailable() async {
//   if (kDebugMode) {
//     print(isAdAvailable);
//   }
//   if (!isAdAvailable) {
//     if (kDebugMode) {
//       print('Tried to show ad before available.');
//     }
//     _loadAppOpenAd();
//     return;
//   }
//   if (_isShowingAd) {
//     if (kDebugMode) {
//       print('Tried to show ad while already showing an ad.');
//     }
//     return;
//   }
//   // Set the fullScreenContentCallback and show the ad.
//   _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
//     onAdShowedFullScreenContent: (ad) {
//       // _isShowingAd = true;
//       if (kDebugMode) {
//         print('$ad onAdShowedFullScreenContent');
//       }
//     },
//     onAdFailedToShowFullScreenContent: (ad, error) {
//       if (kDebugMode) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');
//       }
//       _isShowingAd = false;
//       ad.dispose();
//       _appOpenAd = null;
//     },
//     onAdDismissedFullScreenContent: (ad) {
//       if (kDebugMode) {
//         print('$ad onAdDismissedFullScreenContent');
//       }
//       _isShowingAd = false;
//       ad.dispose();
//       _appOpenAd = null;
//       _loadAppOpenAd();
//     },
//   );
//   await _appOpenAd?.show();
// }

// class AppLifecycleReactor {
//   final AdManager appOpenAdManager;
//
//   AppLifecycleReactor({required this.appOpenAdManager});
//
//   void listenToAppStateChanges() {
//     AppStateEventNotifier.startListening();
//     AppStateEventNotifier.appStateStream
//         .forEach((state) => _onAppStateChanged(state));
//   }
//
//   void _onAppStateChanged(AppState appState) {
//     // Try to show an app open ad if the app is being resumed and
//     // we're not already showing an app open ad.
//     if (appState == AppState.foreground) {
//       appOpenAdManager.loadAppOpenAd();
//     }
//   }
// }

class NativeAdsWidget extends StatefulWidget {
  const NativeAdsWidget({Key? key, required this.widget}) : super(key: key);
  final Widget widget;

  @override
  State<NativeAdsWidget> createState() => NativeAdsWidgetState();
}

class NativeAdsWidgetState extends State<NativeAdsWidget> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  /// Loads a native ad.
  Future<void> loadAd() async {
    _nativeAd = NativeAd(
      adUnitId: kDebugMode ? AdUnits.nativeTest : AdUnits.native,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Dispose the ad here to free resources.
          debugPrint('$NativeAd failed to load: $error');
          setState(() {
            _nativeAdIsLoaded = false;
          });
          ad.dispose();
        },
      ),
      request: const AdRequest(),
      // Styling
      nativeTemplateStyle: NativeTemplateStyle(
        // Required: Choose a template.
        templateType: TemplateType.medium,
        // Optional: Customize the ad's style.
        mainBackgroundColor: Colors.transparent,
        cornerRadius: 10.0,
        // callToActionTextStyle: NativeTemplateTextStyle(
        //     textColor: Colors.cyan,
        //     backgroundColor: Colors.red,
        //     style: NativeTemplateFontStyle.monospace,
        //     size: 16.0),
        // primaryTextStyle: NativeTemplateTextStyle(
        //     textColor: Colors.red,
        //     backgroundColor: Colors.cyan,
        //     style: NativeTemplateFontStyle.italic,
        //     size: 16.0),
        // secondaryTextStyle: NativeTemplateTextStyle(
        //     textColor: Colors.green,
        //     backgroundColor: Colors.black,
        //     style: NativeTemplateFontStyle.bold,
        //     size: 16.0),
        // tertiaryTextStyle: NativeTemplateTextStyle(
        //     textColor: Colors.brown,
        //     backgroundColor: Colors.amber,
        //     style: NativeTemplateFontStyle.normal,
        //     size: 16.0),
      ),
    );
    await _nativeAd?.load();
  }

  @override
  void initState() {
    loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !_nativeAdIsLoaded
        ? widget.widget
        : ConstrainedBox(
            constraints: BoxConstraints(
              // minWidth: ,
              // minHeight: AdSize.banner.height.toDouble(),
              maxWidth: 320,
              maxHeight: 400,
            ),
            child: AdWidget(ad: _nativeAd!));
  }
}

AdManager adManager = Get.find<AdManager>();
