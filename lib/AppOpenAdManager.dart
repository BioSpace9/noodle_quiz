import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager implements AppOpenAdLoadCallback {
  AppOpenAd? _appOpenAd;
  bool _isAdLoaded = false;

  void loadAd() {
    AppOpenAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-2284509452520955/6311368304'
          : "ca-app-pub-2284509452520955/1155282539",
      request: AdRequest(),
      orientation: AppOpenAd.orientationPortrait,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdLoaded = true;
          _appOpenAd?.show();
        },
        onAdFailedToLoad: (error) {
          print('App open ad failed to load: $error');
        },
      ),
    );
  }

  void showAdIfLoaded() {
    if (_isAdLoaded) {
      _appOpenAd?.show();
    } else {
      loadAd();
    }
  }

  void onAppOpenAdLoaded(AppOpenAd ad) {
    _appOpenAd = ad;
    _isAdLoaded = true;
    showAdIfLoaded();
  }

  void onAppOpenAdFailedToLoad(LoadAdError error) {
    print('App open ad failed to load: $error');
  }

  @override
  void onAppOpenAdClosed() {
    _appOpenAd?.dispose();
    _isAdLoaded = false;
    loadAd();
  }

  void dispose() {
    _appOpenAd?.dispose();
  }

  @override
  // TODO: implement onAdFailedToLoad
  FullScreenAdLoadErrorCallback get onAdFailedToLoad => throw UnimplementedError();

  @override
  // TODO: implement onAdLoaded
  GenericAdEventCallback<AppOpenAd> get onAdLoaded => throw UnimplementedError();
}
