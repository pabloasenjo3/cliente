import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'env.dart';

class AdManager {
  // TODO rename
  static BannerAd? _bannerAd;
  static InterstitialAd? _interstitialAd;

  static initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await MobileAds.instance.initialize();
    await _loadInterstitialAd();
  }

  static _loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: Env.interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});

          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          //TODO Handle this??
        },
      ),
    );
  }

  static loadBannerAd(double bannerAdWidth) async {
    final adSize = AdSize(
      width: bannerAdWidth.toInt(),
      height: 50,
    );

    _bannerAd = BannerAd(
      adUnitId: Env.bannerUnitId,
      request: const AdRequest(),
      size: adSize,
      listener: const BannerAdListener(),
    );

    await _bannerAd!.load();
  }

  static Widget getBannerAdWidget() {
    return AdWidget(ad: _bannerAd!);
  }

  static BannerAd? getBannerAd() {
    return _bannerAd;
  }

  static disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  static showInterstitialAd() {
    if (_interstitialAd == null) {
      _loadInterstitialAd().then((_) {
        _interstitialAd!.show();
        _loadInterstitialAd();
      });
    } else {
      _interstitialAd!.show();
      _loadInterstitialAd();
    }
  }
}
