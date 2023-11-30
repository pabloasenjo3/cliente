import 'dart:developer' as developer;
import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/foundation.dart';
import 'package:quimify_client/internet/ads/env/env.dart';

class Ads {
  static final Ads _singleton = Ads._internal();

  factory Ads() => _singleton;

  Ads._internal();

  late String _bannerUnitId;
  late String _interstitialUnitId;

  int _interstitialAttempts = 0;

  // Constants:

  static const int _interstitialFreeAttempts = 3;


  // Initialize:

  initialize() {
    AppLovinMAX.initialize(Env.applovinMaxSdkKey);

    if (Platform.isAndroid) {
      _bannerUnitId = Env.androidBannerUnitId;
      _interstitialUnitId = Env.androidInterstitialUnitId;
    } else {
      _bannerUnitId = Env.iosBannerUnitId;
      _interstitialUnitId = Env.iosInterstitialUnitId;
    }

    _initializeInterstitial();
    _loadInterstitial();
  }

  // Private:

  _initializeInterstitial() => AppLovinMAX.setInterstitialListener(
        InterstitialListener(
          onAdLoadedCallback: (ad) {},
          onAdLoadFailedCallback: (id, error) => developer.log(error.message),
          onAdDisplayedCallback: (ad) {},
          onAdDisplayFailedCallback: (ad, error) {},
          onAdClickedCallback: (ad) {},
          onAdHiddenCallback: (ad) => _loadInterstitial(),
        ),
      );

  _loadInterstitial() => AppLovinMAX.loadInterstitial(_interstitialUnitId);

  // Public:

  MaxAdView banner(String placementName, bool visible, VoidCallback onLoaded) =>
      MaxAdView(
        placement: placementName,
        adUnitId: _bannerUnitId,
        adFormat: AdFormat.banner,
        visible: visible,
        listener: AdViewAdListener(
          onAdLoadedCallback: (ad) => onLoaded(),
          onAdLoadFailedCallback: (ad, error) => developer.log(error.message),
          onAdClickedCallback: (ad) {},
          onAdExpandedCallback: (ad) {},
          onAdCollapsedCallback: (ad) {},
        ),
      );

  showInterstitial() {
    _interstitialAttempts += 1;

    if (_interstitialAttempts > _interstitialFreeAttempts) {
      AppLovinMAX.isInterstitialReady(_interstitialUnitId).then((isReady) {
        if (isReady ?? false) {
          AppLovinMAX.showInterstitial(_interstitialUnitId);
        } else {
          _loadInterstitial();
        }
      });
    }
  }
}
