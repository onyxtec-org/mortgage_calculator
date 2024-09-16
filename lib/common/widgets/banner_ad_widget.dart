import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  final String? adUnitId = Platform.isAndroid
      // Use this ad unit on Android...
      ? dotenv.env['ANDROID_AD_UNIT_ID']
      // ... or this one on iOS.
      : dotenv.env['iOS_AD_UNIT_ID'];

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    BannerAd(
      adUnitId: adUnitId ?? '', // Replace with your ad unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          // Optionally add a delay or retry mechanism here
          Future.delayed(const Duration(seconds: 5), () {
            _loadBannerAd();
          });
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAd == null
        ? const SizedBox()
        : Container(
            alignment: Alignment.center,
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
