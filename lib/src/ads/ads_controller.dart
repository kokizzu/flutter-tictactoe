import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tictactoe/flavors.dart';
import 'package:tictactoe/src/ads/preloaded_banner_ad.dart';

class AdsController {
  final MobileAds _instance;

  PreloadedBannerAd? _preloadedAd;

  AdsController(this._instance) : assert(platformSupportsAds);

  void dispose() {
    _preloadedAd?.dispose();
  }

  void initialize() async {
    await _instance.initialize();
  }

  /// Starts preloading an ad to be used later.
  ///
  /// The work doesn't start immediately so that calling this doesn't have
  /// adverse effects (jank) during start of a new screen.
  void preloadAd() {
    final adUnitId = defaultTargetPlatform == TargetPlatform.android
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
    _preloadedAd =
        PreloadedBannerAd(size: AdSize.mediumRectangle, adUnitId: adUnitId);

    // Wait a bit so that calling at start of a new screen doesn't have
    // adverse effects on performance.
    Future<void>.delayed(const Duration(seconds: 1)).then((_) {
      return _preloadedAd!.load();
    });
  }

  /// Allows caller to take ownership of a [PreloadedBannerAd].
  ///
  /// If this method returns a non-null value, then the caller is responsible
  /// for disposing of the loaded ad.
  PreloadedBannerAd? takePreloadedAd() {
    final ad = _preloadedAd;
    _preloadedAd = null;
    return ad;
  }
}
