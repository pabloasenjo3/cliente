import 'dart:developer' as developer;
import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/foundation.dart';
import 'package:quimify_client/internet/ads/env/env.dart';

class Ads {
  static final Ads _singleton = Ads._internal();

  factory Ads() => _singleton;

  Ads._internal();

  // Constants:

  static const int _interstitialPeriod = 2; // Minimum attempts before next one
  static const int _interstitialOffset = 3; // Minimum attempts before 1st one

  // Fields:

  late String _bannerUnitId;
  late String _interstitialUnitId;

  int _interstitialAttempts = _interstitialPeriod - _interstitialOffset;

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
    if (_interstitialAttempts++ < _interstitialPeriod) {
      return;
    }

    AppLovinMAX.isInterstitialReady(_interstitialUnitId).then((isReady) {
      if (isReady ?? false) {
        AppLovinMAX.showInterstitial(_interstitialUnitId);
        _interstitialAttempts = 0;
      } else {
        _loadInterstitial();
      }
    });
  }
}
