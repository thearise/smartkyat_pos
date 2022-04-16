import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';

import '../../app_theme.dart';
import '../app_theme.dart';
import 'ad_helper.dart';

class BannerFull extends StatefulWidget {
  const BannerFull({Key? key}) : super(key: key);

  @override
  _BannerFullState createState() => _BannerFullState();
}

class _BannerFullState extends State<BannerFull>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<BannerFull>{
  @override
  bool get wantKeepAlive => true;

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  initState() {
    _bannerAd = BannerAd(
      // Change Banner Size According to Ur Need
        size: AdSize.fullBanner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        }, onAdFailedToLoad: (ad, LoadAdError error) {
          print("Failed to Load A Banner Ad${error.message}");
          _isBannerAdReady = false;
          ad.dispose();
        }),
        request: AdRequest())
      ..load();
    // super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _bannerAd.size.height.toDouble(),
      width: _bannerAd.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd, key: UniqueKey()),
    );
  }



}



