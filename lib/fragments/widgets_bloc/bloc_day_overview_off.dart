import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:countup/countup.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/add_shop_first.dart';
import 'package:smartkyat_pos/fragments/customers_fragment2.dart';
import 'package:smartkyat_pos/fragments/subs/forgot_password.dart';
import 'package:smartkyat_pos/fragments/welcome_fragment.dart';
import 'package:smartkyat_pos/main.dart';
import 'package:smartkyat_pos/models/order.dart';
import 'package:smartkyat_pos/pages2/first_launch_page.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';
import 'package:smartkyat_pos/pages2/homepage_off.dart';
import 'package:smartkyat_pos/src/app.dart';
import 'package:smartkyat_pos/src/screens/login.dart';
import 'package:smartkyat_pos/src/screens/verify.dart';
import 'package:smartkyat_pos/widgets/custom_flat_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme.dart';
import '../app_theme.dart';
// import 'package:loader_overlay/loader_overlay.dart';

class BlocDayOverviewOff extends StatefulWidget {
  final double? gloBotPadd;
  const BlocDayOverviewOff({Key? key, this.gloBotPadd,}) : super(key: key);

  @override
  _BlocDayOverviewOffState createState() => _BlocDayOverviewOffState();
}

class _BlocDayOverviewOffState extends State<BlocDayOverviewOff>
    with TickerProviderStateMixin<BlocDayOverviewOff>{

  late TabController _loginTabController;
  late TabController _signupController;
  late TabController _bottomTabBarCtl;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _emails = TextEditingController();
  final _passwords = TextEditingController();
  final _name = TextEditingController();
  final _confirm = TextEditingController();

  bool pressedCreate = false;
  bool _obscureText = true;
  bool _obscureText1 = true;
  String? wrongEmail;
  String? wrongPassword;
  String? weakPassword;
  String? emailExist;

  bool isLoading = true;
  bool overLoading = false;
  bool loadingState = false;

  String lang = 'english';

  bool isEnglish = true;
  String currencyUnit = 'MMK';

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {

    } else {
      Navigator.of(context).push(
          FadeRoute(page: FirstLaunchPage(),)
      );
      await prefs.setBool('seen', true);
    }
    getLangId().then((val) {
      debugPrint('ffirs ' + val.toString());
      lang = val;
      if(lang == 'english') {
        isEnglish = true;
      } else {
        isEnglish = false;
      }
    });
  }

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

  @override
  initState() {

    if(Platform.isIOS)
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    if(Platform.isAndroid)
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white, // navigation bar color
          statusBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark// status bar color
      ));

    super.initState();
  }

  Future<String> getStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));

    var index = prefs.getString('store');
    debugPrint(index);
    if (index == null) {
      return 'idk';
    } else {
      return index;
    }
  }

  setStoreId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));

    prefs.setString('store', id);
  }

  setOffline(String set) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));

    prefs.setString('offline', set);
  }

  Future<String> getOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var index = prefs.getString('offline');
    debugPrint(index.toString());
    if (index == null) {
      return 'notset';
    } else {
      return index.toString();
    }
  }

  @override
  void dispose() {
    _loginTabController.dispose();
    _signupController.dispose();
    _bottomTabBarCtl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  zeroToTen(String string) {
    if (int.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime pureToday = DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(today.day.toString()) + ' 23:59:59');

    // var overviewInfo = objectbox.getOverViewInfo('day', pureToday);
    // debugPrint('something ' + overviewInfo.toString());
    // double spTotalSales = overviewInfo['total'];

    double width = MediaQuery.of(context).size.width > 900
        ? MediaQuery.of(context).size.width * (2 / 3.5)
        : MediaQuery.of(context).size.width;
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Container(
      // height: MediaQuery.of(context).size.height-353,
      width: width,
      color: Colors.white,
      // child: Padding(
      //   padding: const EdgeInsets.only(left: 0.0, right: 0.0,),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       SizedBox(height: 10,),
      //       Container(
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.all(
      //             Radius.circular(10.0),
      //           ),
      //         ),
      //         child:  Column(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Padding(
      //               padding: const EdgeInsets.only(top: 0.0, bottom: 4.0, left: 15.0, right: 15.0),
      //               child: Text('textSetSaleSummary', textScaleFactor: 1,
      //                 style: TextStyle(
      //                   height: 0.9,
      //                   letterSpacing: 2,
      //                   fontWeight: FontWeight.bold,
      //                   fontSize: 14,color: Colors.grey,
      //                 ),),
      //             ),
      //             Row(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               children: [
      //                 Container(
      //                   width: width/2,
      //                   child: Padding(
      //                     padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Row(
      //                           children: [
      //                             animatedPrice(
      //                                 doubleRetri(NumberFormat.compactCurrency(
      //                                   decimalDigits: 2,
      //                                   symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
      //                                 ).format(spTotalSales)),
      //                                 GoogleFonts.lato(
      //                                     textStyle: TextStyle(
      //                                         letterSpacing: 1,
      //                                         fontSize: 26,
      //                                         fontWeight: FontWeight.w500,
      //                                         color: Colors.black
      //                                     )
      //                                 ),
      //                                 2
      //                             ),
      //                             Text(
      //                               lastSRetri(NumberFormat.compactCurrency(
      //                                 decimalDigits: 2,
      //                                 symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
      //                               ).format(spTotalSales))
      //                               ,
      //                               textScaleFactor: 1, textAlign: TextAlign.left,
      //                               style: GoogleFonts.lato(
      //                                   textStyle: TextStyle(
      //                                       letterSpacing: 1,
      //                                       fontSize: 26,
      //                                       fontWeight: FontWeight.w500,
      //                                       color: Colors.black
      //                                   )
      //                               ),
      //                             )
      //                           ],
      //                         ),
      //                         Text(
      //                           'textSetNetSales ($currencyUnit)',strutStyle: StrutStyle(
      //                             forceStrutHeight: true,
      //                             height: 1.2
      //                         ), textScaleFactor: 1,
      //                           style: TextStyle(
      //                               fontSize: 13, height: 1.2,
      //                               fontWeight: FontWeight.w500,
      //                               color: Colors.black.withOpacity(0.6)),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //                 Container(
      //                   width: width/2,
      //                   child: Padding(
      //                     padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Row(
      //                           children: [
      //                             animatedPrice(
      //                                 doubleRetri(NumberFormat.compactCurrency(
      //                                   decimalDigits: 2,
      //                                   symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
      //                                 ).format(100)),
      //                                 GoogleFonts.lato(
      //                                     textStyle: TextStyle(
      //                                         letterSpacing: 1,
      //                                         fontSize: 26,
      //                                         fontWeight: FontWeight.w500,
      //                                         color: Colors.black
      //                                     )
      //                                 ),
      //                                 2
      //                             ),
      //                             Text(
      //                               lastSRetri(NumberFormat.compactCurrency(
      //                                 decimalDigits: 2,
      //                                 symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
      //                               ).format(100))
      //                               ,
      //                               textScaleFactor: 1, textAlign: TextAlign.left,
      //                               style: GoogleFonts.lato(
      //                                   textStyle: TextStyle(
      //                                       letterSpacing: 1,
      //                                       fontSize: 26,
      //                                       fontWeight: FontWeight.w500,
      //                                       color: Colors.black
      //                                   )
      //                               ),
      //                             )
      //                           ],
      //                         ),
      //                         Text(
      //                           'textSetProfit ($currencyUnit)',strutStyle: StrutStyle(
      //                             forceStrutHeight: true,
      //                             height: 1.2
      //                         ), textScaleFactor: 1,
      //                           style: TextStyle(
      //                               fontSize: 13, height: 1.2,
      //                               fontWeight: FontWeight.w500,
      //                               color: Colors.black.withOpacity(0.6)),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 15.0),
      //               child: Container(
      //                 width: width,
      //                 decoration: BoxDecoration(
      //                     border: Border(
      //                         bottom: BorderSide(
      //                             color: Colors.grey
      //                                 .withOpacity(
      //                                 0.3),
      //                             width: 1.0)
      //                     )),
      //               ),
      //             ),
      //             Row(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               children: [
      //                 Container(
      //                   width: width/2,
      //                   child: Padding(
      //                     padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Row(
      //                           children: [
      //                             animatedPrice(
      //                                 doubleRetri(NumberFormat.compactCurrency(
      //                                   decimalDigits: 2,
      //                                   symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
      //                                 ).format(100)),
      //                                 GoogleFonts.lato(
      //                                     textStyle: TextStyle(
      //                                         letterSpacing: 1,
      //                                         fontSize: 26,
      //                                         fontWeight: FontWeight.w500,
      //                                         color: Colors.black
      //                                     )
      //                                 ),
      //                                 2
      //                             ),
      //                             Text(
      //                               lastSRetri(NumberFormat.compactCurrency(
      //                                 decimalDigits: 2,
      //                                 symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
      //                               ).format(100))
      //                               ,
      //                               textScaleFactor: 1, textAlign: TextAlign.left,
      //                               style: GoogleFonts.lato(
      //                                   textStyle: TextStyle(
      //                                       letterSpacing: 1,
      //                                       fontSize: 26,
      //                                       fontWeight: FontWeight.w500,
      //                                       color: Colors.black
      //                                   )
      //                               ),
      //                             )
      //                           ],
      //                         ),
      //                         Text(
      //                           'textSetStockCosts (' + currencyUnit +')',strutStyle: StrutStyle(
      //                             forceStrutHeight: true,
      //                             height: 1.2
      //                         ), textScaleFactor: 1,
      //                           style: TextStyle(
      //                               fontSize: 13, height: 1.2,
      //                               fontWeight: FontWeight.w500,
      //                               color: Colors.black.withOpacity(0.6)),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //                 Container(
      //                   width: width/2,
      //                   child: Padding(
      //                     padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Row(
      //                           children: [
      //                             animatedPrice(
      //                                 doubleRetri(NumberFormat.compactCurrency(
      //                                   decimalDigits: 2,
      //                                   symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
      //                                 ).format(100)),
      //                                 GoogleFonts.lato(
      //                                     textStyle: TextStyle(
      //                                         letterSpacing: 1,
      //                                         fontSize: 26,
      //                                         fontWeight: FontWeight.w500,
      //                                         color: Colors.black
      //                                     )
      //                                 ),
      //                                 2
      //                             ),
      //                             Text(
      //                               lastSRetri(NumberFormat.compactCurrency(
      //                                 decimalDigits: 2,
      //                                 symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
      //                               ).format(100))
      //                               ,
      //                               textScaleFactor: 1, textAlign: TextAlign.left,
      //                               style: GoogleFonts.lato(
      //                                   textStyle: TextStyle(
      //                                       letterSpacing: 1,
      //                                       fontSize: 26,
      //                                       fontWeight: FontWeight.w500,
      //                                       color: Colors.black
      //                                   )
      //                               ),
      //                             )
      //                           ],
      //                         ),
      //                         Text(
      //                           'textSetUnpaid ($currencyUnit)',strutStyle: StrutStyle(
      //                             forceStrutHeight: true,
      //                             height: 1.2
      //                         ), textScaleFactor: 1,
      //                           style: TextStyle(
      //                               fontSize: 13, height: 1.2,
      //                               fontWeight: FontWeight.w500,
      //                               color: Colors.black.withOpacity(0.6)),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 15.0),
      //               child: Container(
      //                 width: width,
      //                 decoration: BoxDecoration(
      //                     border: Border(
      //                         bottom: BorderSide(
      //                             color: Colors.grey
      //                                 .withOpacity(
      //                                 0.3),
      //                             width: 1.0)
      //                     )),
      //               ),
      //             ),
      //             Row(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               mainAxisAlignment: MainAxisAlignment.start,
      //               children: [
      //                 Container(
      //                   width: width/2,
      //                   child: Padding(
      //                     padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Row(
      //                           children: [
      //                             animatedPrice(
      //                                 doubleRetri(NumberFormat.compactCurrency(
      //                                   decimalDigits: 2,
      //                                   symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
      //                                 ).format(100)),
      //                                 GoogleFonts.lato(
      //                                     textStyle: TextStyle(
      //                                         letterSpacing: 1,
      //                                         fontSize: 26,
      //                                         fontWeight: FontWeight.w500,
      //                                         color: Colors.black
      //                                     )
      //                                 ),
      //                                 2
      //                             ),
      //                             Text(
      //                               lastSRetri(NumberFormat.compactCurrency(
      //                                 decimalDigits: 2,
      //                                 symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
      //                               ).format(100))
      //                               ,
      //                               textScaleFactor: 1, textAlign: TextAlign.left,
      //                               style: GoogleFonts.lato(
      //                                   textStyle: TextStyle(
      //                                       letterSpacing: 1,
      //                                       fontSize: 26,
      //                                       fontWeight: FontWeight.w500,
      //                                       color: Colors.black
      //                                   )
      //                               ),
      //                             )
      //                           ],
      //                         ),
      //                         Text(
      //                           'textSetRef ($currencyUnit)',strutStyle: StrutStyle(
      //                             forceStrutHeight: true,
      //                             height: 1.2
      //                         ), textScaleFactor: 1,
      //                           style: TextStyle(
      //                               fontSize: 13, height: 1.2,
      //                               fontWeight: FontWeight.w500,
      //                               color: Colors.black.withOpacity(0.6)),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //                 Container(
      //                   width: width/2,
      //                   child: Padding(
      //                     padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Row(
      //                           children: [
      //                             animatedPrice(
      //                                 doubleRetri(NumberFormat.compactCurrency(
      //                                   decimalDigits: 2,
      //                                   symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
      //                                 ).format(100)),
      //                                 GoogleFonts.lato(
      //                                     textStyle: TextStyle(
      //                                         letterSpacing: 1,
      //                                         fontSize: 26,
      //                                         fontWeight: FontWeight.w500,
      //                                         color: Colors.black
      //                                     )
      //                                 ),
      //                                 2
      //                             ),
      //                             Text(
      //                               lastSRetri(NumberFormat.compactCurrency(
      //                                 decimalDigits: 2,
      //                                 symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
      //                               ).format(100))
      //                               ,
      //                               textScaleFactor: 1, textAlign: TextAlign.left,
      //                               style: GoogleFonts.lato(
      //                                   textStyle: TextStyle(
      //                                       letterSpacing: 1,
      //                                       fontSize: 26,
      //                                       fontWeight: FontWeight.w500,
      //                                       color: Colors.black
      //                                   )
      //                               ),
      //                             )
      //                           ],
      //                         ),
      //                         Text(
      //                           'textSetLoss ($currencyUnit)',strutStyle: StrutStyle(
      //                             forceStrutHeight: true,
      //                             height: 1.2
      //                         ), textScaleFactor: 1,
      //                           style: TextStyle(
      //                               fontSize: 13, height: 1.2,
      //                               fontWeight: FontWeight.w500,
      //                               color: Colors.black.withOpacity(0.6)),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             // Padding(
      //             //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
      //             //   child: Container(
      //             //     width: width,
      //             //     decoration: BoxDecoration(
      //             //         border: Border(
      //             //             bottom: BorderSide(
      //             //                 color: Colors.grey
      //             //                     .withOpacity(
      //             //                     0.3),
      //             //                 width: 1.0)
      //             //         )),
      //             //   ),
      //             // ),
      //             // Row(
      //             //   children: [
      //             //     Container(
      //             //       width: width/2,
      //             //       child: Padding(
      //             //         padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 9, bottom: 14),
      //             //         child: Column(
      //             //           crossAxisAlignment: CrossAxisAlignment.start,
      //             //           children: [
      //             //             Row(
      //             //               children: [
      //             //                 Text(
      //             //                   '45',
      //             //                   textScaleFactor: 1, textAlign: TextAlign.left,
      //             //                   style: GoogleFonts.lato(
      //             //                       textStyle: TextStyle(
      //             //                           letterSpacing: 1,
      //             //                           fontSize: 26,
      //             //                           fontWeight: FontWeight.w500,
      //             //                           color: Colors.black
      //             //                       )
      //             //                   ),
      //             //                 ),
      //             //                 Padding(
      //             //                   padding: const EdgeInsets.only(left: 5.0, top: 13.0),
      //             //                   child: Text(
      //             //                     'M',strutStyle: StrutStyle(
      //             //                       forceStrutHeight: true,
      //             //                       height: 1.2
      //             //                   ),
      //             //                     style: TextStyle(
      //             //                         fontSize: 27, height: 1.2,
      //             //                         fontWeight: FontWeight.w500,
      //             //                         color: Colors.black),
      //             //                   ),
      //             //                 )
      //             //               ],
      //             //             ),
      //             //             Text(
      //             //               'Loss amount (MMK)',strutStyle: StrutStyle(
      //             //                 forceStrutHeight: true,
      //             //                 height: 1.2
      //             //             ),
      //             //               style: TextStyle(
      //             //                   fontSize: 13, height: 1.2,
      //             //                   fontWeight: FontWeight.w500,
      //             //                   color: Colors.black.withOpacity(0.6)),
      //             //             ),
      //             //           ],
      //             //         ),
      //             //       ),
      //             //     ),
      //             //
      //             //   ],
      //             // ),
      //             Padding(
      //               padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0, top: 4),
      //               child: ButtonTheme(
      //                 minWidth: width,
      //                 splashColor: Colors.transparent,
      //                 height: 50,
      //                 child: CustomFlatButton(
      //                   color: AppTheme.buttonColor2,
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius:
      //                     BorderRadius.circular(10.0),
      //                     side: BorderSide(
      //                       color: AppTheme.buttonColor2,
      //                     ),
      //                   ),
      //                   onPressed: () async {
      //                     // closeDrawerFrom();
      //                     // await Navigator.push(
      //                     //   context,
      //                     //   MaterialPageRoute(
      //                     //       builder: (
      //                     //           context) =>
      //                     //           HomeFragment(
      //                     //             shopId: widget.shopId, tab: cateScIndex, openDrawerBtn: widget._openDrawer, closeDrawerBtn: widget._closeDrawer, isEnglish: widget.isEnglish,
      //                     //           )),
      //                     // );
      //                     // openDrawerFrom();
      //                   },
      //                   child: Padding(
      //                     padding: const EdgeInsets.only(
      //                         left: 5.0,
      //                         right: 5.0,
      //                         bottom: 2.0),
      //                     child: Container(
      //                       child: Text(
      //                           'textSetMore', textScaleFactor: 1,
      //                           textAlign: TextAlign.center,
      //                           style: TextStyle(
      //                               fontSize: 18,
      //                               fontWeight: FontWeight.w500,
      //                               letterSpacing:-0.1
      //                           ),
      //                           strutStyle: StrutStyle(
      //                             height: 1.4,
      //                             forceStrutHeight: true,
      //                           )
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             Container(
      //               width: width,
      //               decoration: BoxDecoration(
      //                   border: Border(
      //                       bottom: BorderSide(
      //                           color: Colors.grey
      //                               .withOpacity(
      //                               0.3),
      //                           width: 1.0)
      //                   )),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0, bottom: 10.0),
      //               child: Text('textSetProdSale', textScaleFactor: 1,
      //                 style: TextStyle(
      //                   height: 0.9,
      //                   letterSpacing: 2,
      //                   fontWeight: FontWeight.bold,
      //                   fontSize: 14,color: Colors.grey,
      //                 ),),
      //             ),
      //             Column(
      //               children: [
      //                 Column(
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
      //                       child: Container(
      //                         height: 55,
      //                         child: Row(
      //                           children: [
      //                             Text('textSetTSales', textScaleFactor: 1, style:
      //                             TextStyle(
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.w500, color: Colors.black,
      //                             ),),
      //                             Spacer(),
      //                             animatedPrice(
      //                                 100,
      //                                 TextStyle(
      //                                   fontSize: 16,
      //                                   fontWeight: FontWeight.w500, color: Colors.black,
      //                                 ),
      //                                 0
      //                             ),
      //                             Text((' types'), textScaleFactor: 1, style:
      //                             TextStyle(
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.w500, color: Colors.black,
      //                             ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.only(left: 15.0),
      //                       child: Container(
      //                         decoration: BoxDecoration(
      //                             border: Border(
      //                                 bottom: BorderSide(
      //                                     color: Colors.grey
      //                                         .withOpacity(0.2),
      //                                     width: 1.0))),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //
      //
      //                 Column(
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
      //                       child: Container(
      //                         height: 55,
      //                         child: Row(
      //                           children: [
      //                             Text('textSetTLoss', textScaleFactor: 1, style:
      //                             TextStyle(
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.w500, color: Colors.black,
      //                             ),),
      //                             Spacer(),
      //                             animatedPrice(
      //                                 100,
      //                                 TextStyle(
      //                                   fontSize: 16,
      //                                   fontWeight: FontWeight.w500, color: Colors.black,
      //                                 ),
      //                                 0
      //                             ),
      //                             Text((' types'), textScaleFactor: 1, style:
      //                             TextStyle(
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.w500, color: Colors.black,
      //                             ),),
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.only(left: 15.0),
      //                       child: Container(
      //                         decoration: BoxDecoration(
      //                             border: Border(
      //                                 bottom: BorderSide(
      //                                     color: Colors.grey
      //                                         .withOpacity(0.2),
      //                                     width: 1.0))),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Column(
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
      //                       child: Container(
      //                         height: 55,
      //                         child: Row(
      //                           children: [
      //                             Text('textSetTRef', textScaleFactor: 1, style:
      //                             TextStyle(
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.w500, color: Colors.black,
      //                             ),),
      //                             Spacer(),
      //                             animatedPrice(
      //                                 100,
      //                                 TextStyle(
      //                                   fontSize: 16,
      //                                   fontWeight: FontWeight.w500, color: Colors.black,
      //                                 ),
      //                                 0
      //                             ),
      //                             Text((' types'), textScaleFactor: 1, style:
      //                             TextStyle(
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.w500, color: Colors.black,
      //                             ),),
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.only(left: 15.0),
      //                       child: Container(
      //                         decoration: BoxDecoration(
      //                             border: Border(
      //                                 bottom: BorderSide(
      //                                     color: Colors.grey
      //                                         .withOpacity(0.2),
      //                                     width: 1.0))),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Column(
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
      //                       child: Container(
      //                         height: 55,
      //                         child: Row(
      //                           children: [
      //                             Text('textSetSaleAmt', textScaleFactor: 1, style:
      //                             TextStyle(
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.w500, color: Colors.black,
      //                             ),),
      //                             Spacer(),
      //                             animatedPrice(
      //                                 100,
      //                                 TextStyle(
      //                                   fontSize: 16,
      //                                   fontWeight: FontWeight.w500, color: Colors.black,
      //                                 ),
      //                                 2
      //                             ),
      //                             Text(' ' +currencyUnit, textScaleFactor: 1, style:
      //                             TextStyle(
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.w500, color: Colors.black,
      //                             ),),
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.only(left: 15.0),
      //                       child: Container(
      //                         decoration: BoxDecoration(
      //                             border: Border(
      //                                 bottom: BorderSide(
      //                                     color: Colors.grey
      //                                         .withOpacity(0.2),
      //                                     width: 1.0))),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Column(
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
      //                       child: Container(
      //                         height: 55,
      //                         child: Row(
      //                           children: [
      //                             Text('textSetBuyAmt', textScaleFactor: 1, style:
      //                             TextStyle(
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.w500, color: Colors.black,
      //                             ),),
      //                             Spacer(),
      //                             animatedPrice(
      //                                 100,
      //                                 TextStyle(
      //                                   fontSize: 16,
      //                                   fontWeight: FontWeight.w500, color: Colors.black,
      //                                 ),
      //                                 2
      //                             ),
      //                             Text(' ' +currencyUnit, textScaleFactor: 1, style:
      //                             TextStyle(
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.w500, color: Colors.black,
      //                             ),),
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.only(left: 15.0),
      //                       child: Container(
      //                         decoration: BoxDecoration(
      //                             border: Border(
      //                                 bottom: BorderSide(
      //                                     color: Colors.grey
      //                                         .withOpacity(0.2),
      //                                     width: 1.0))),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Column(
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
      //                       child: Container(
      //                         height: 55,
      //                         child: Row(
      //                           children: [
      //                             Text('textSetDiscount', textScaleFactor: 1, style:
      //                             TextStyle(
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.w500, color: Colors.black,
      //                             ),),
      //                             Spacer(),
      //                             animatedPrice(
      //                                 100,
      //                                 TextStyle(
      //                                   fontSize: 16,
      //                                   fontWeight: FontWeight.w500, color: Colors.black,
      //                                 ),
      //                                 2
      //                             ),
      //                             Text(' ' +currencyUnit, textScaleFactor: 1, style:
      //                             TextStyle(
      //                               fontSize: 16,
      //                               fontWeight: FontWeight.w500, color: Colors.black,
      //                             ),),
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 // Column(
      //                 //   children: [
      //                 //     Padding(
      //                 //       padding: const EdgeInsets.symmetric(horizontal: 15.0),
      //                 //       child: Container(
      //                 //         height: 55,
      //                 //         child: Row(
      //                 //           children: [
      //                 //             Text('Total products', textScaleFactor: 1, style:
      //                 //             TextStyle(
      //                 //               fontSize: 16,
      //                 //               fontWeight: FontWeight.w500, color: Colors.black,
      //                 //             ),),
      //                 //             Spacer(),
      //                 //             Text('7,3454', textScaleFactor: 1, style:
      //                 //             TextStyle(
      //                 //               fontSize: 16,
      //                 //               fontWeight: FontWeight.w500, color: Colors.black,
      //                 //             ),),
      //                 //           ],
      //                 //         ),
      //                 //       ),
      //                 //     ),
      //                 //   ],
      //                 // ),
      //               ],
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 16.0, top: 10),
      //               child: ButtonTheme(
      //                 minWidth: width,
      //                 splashColor: Colors.transparent,
      //                 height: 50,
      //                 child: CustomFlatButton(
      //                   color: AppTheme.buttonColor2,
      //                   shape: RoundedRectangleBorder(
      //                     borderRadius:
      //                     BorderRadius.circular(10.0),
      //                     side: BorderSide(
      //                       color: AppTheme.buttonColor2,
      //                     ),
      //                   ),
      //                   onPressed: () async {
      //                     // closeDrawerFrom();
      //                     // await Navigator.push(
      //                     //   context,
      //                     //   MaterialPageRoute(
      //                     //       builder: (
      //                     //           context) =>
      //                     //           ProdSaleSumHome(
      //                     //             shopId: widget.shopId,  tab: cateScIndex,openDrawerBtn: widget._openDrawer, closeDrawerBtn: widget._closeDrawer, isEnglish: widget.isEnglish,
      //                     //           )),
      //                     // );
      //                     // openDrawerFrom();
      //                   },
      //                   child: Padding(
      //                     padding: const EdgeInsets.only(
      //                         left: 5.0,
      //                         right: 5.0,
      //                         bottom: 2.0),
      //                     child: Container(
      //                       child: Text(
      //                           'textSetMore', textScaleFactor: 1,
      //                           textAlign: TextAlign.center,
      //                           style: TextStyle(
      //                               fontSize: 18,
      //                               fontWeight: FontWeight.w500,
      //                               letterSpacing:-0.1
      //                           ),
      //                           strutStyle: StrutStyle(
      //                             height: 1.4,
      //                             forceStrutHeight: true,
      //                           )
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //
      //
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  FlashController? _previousController;

  Future smartKyatFMod<T>(BuildContext context, String message, String type) async {
    if(_previousController != null) {
      if (_previousController!.isDisposed == false) _previousController!.dismiss();
    }

    Widget widgetCon = Container();
    Color bdColor = Color(0xffffffff);
    Color bgColor = Color(0xffffffff);
    if(type == 's') {
      bdColor = Color(0xffB1D3B1);
      bgColor = Color(0xffCFEEE0);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff419373)),
        child: Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: Icon(
            Icons.check_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'w') {
      bdColor = Color(0xffF2E0BC);
      bgColor = Color(0xffFCF4E2);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffF5C04A)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 1.0),
          child: Text('!', textScaleFactor: 1, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    } else if(type == 'e') {
      bdColor = Color(0xffEAD2C8);
      bgColor = Color(0xffFAEEEC);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffE9625E)),
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Icon(
            Icons.close_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'i') {
      bdColor = Color(0xffBCCEEA);
      bgColor = Color(0xffE8EEF9);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff4788E2)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.5, top: 1.5),
          child: Text('i', textScaleFactor: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    }

    _previousController = FlashController<T>(
      context,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          // boxShadows: [BoxShadow(blurRadius: 4)],
          // barrierBlur: 3.0,
          // barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 93.0, left: 15, right: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: bgColor,
                border: Border.all(
                    color: bdColor,
                    width: 1.0
                ),
              ),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: widgetCon,
                ),
                minLeadingWidth: 15,
                horizontalTitleGap: 10,
                minVerticalPadding: 0,
                title: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 16.3),
                  child: Container(
                    child: Text(message, textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15, height: 1.2)),
                  ),
                ),
                // subtitle: Text('shit2'),
                // trailing: Text('GGG',
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //   ),),
              ),
            ),
          ),
        );
        // return Flash.dialog(
        //   controller: controller,
        //   alignment: const Alignment(0, 0.5),
        //   margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //   borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        //   backgroundColor: Colors.black87,
        //   child: DefaultTextStyle(
        //     style: const TextStyle(fontSize: 16.0, color: Colors.white),
        //     child: Padding(
        //       padding:
        //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //       child: Text(message),
        //     ),
        //   ),
        // );
      },
      duration: const Duration(milliseconds: 2500),
      persistent: true,
      transitionDuration: Duration(milliseconds: 300),
    );
    return _previousController!.show();
  }

  void smartKyatFlash(String text, String type) {
    Widget widgetCon = Container();
    Color bdColor = Color(0xffffffff);
    Color bgColor = Color(0xffffffff);
    if(type == 's') {
      bdColor = Color(0xffB1D3B1);
      bgColor = Color(0xffCFEEE0);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff419373)),
        child: Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: Icon(
            Icons.check_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'w') {
      bdColor = Color(0xffF2E0BC);
      bgColor = Color(0xffFCF4E2);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffF5C04A)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 1.0),
          child: Text('!', textScaleFactor: 1, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    } else if(type == 'e') {
      bdColor = Color(0xffEAD2C8);
      bgColor = Color(0xffFAEEEC);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffE9625E)),
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Icon(
            Icons.close_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'i') {
      bdColor = Color(0xffBCCEEA);
      bgColor = Color(0xffE8EEF9);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff4788E2)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.5, top: 1.5),
          child: Text('i', textScaleFactor: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    }
    showFlash(
      context: context,
      duration: const Duration(milliseconds: 2500),
      persistent: true,
      transitionDuration: Duration(milliseconds: 300),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          // boxShadows: [BoxShadow(blurRadius: 4)],
          // barrierBlur: 3.0,
          // barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 93.0, left: 15, right: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: bgColor,
                border: Border.all(
                    color: bdColor,
                    width: 1.0
                ),
              ),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: widgetCon,
                ),
                minLeadingWidth: 15,
                horizontalTitleGap: 10,
                minVerticalPadding: 0,
                title: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 16.3),
                  child: Container(
                    child: Text(text, textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15, height: 1.2)),
                  ),
                ),
                // subtitle: Text('shit2'),
                // trailing: Text('GGG',
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //   ),),
              ),
            ),
          ),
          // child: Padding(
          //   padding: const EdgeInsets.only(
          //       top: 93.0, left: 15, right: 15),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(10.0),
          //       ),
          //       color: bgColor,
          //       border: Border.all(
          //           color: bdColor,
          //           width: 1.0
          //       ),
          //     ),
          //     child: Padding(
          //         padding: const EdgeInsets.only(
          //             top: 15.0, left: 10, right: 10, bottom: 15),
          //         child: Row(
          //           children: [
          //             SizedBox(width: 5),
          //             widgetCon,
          //             SizedBox(width: 10),
          //             Padding(
          //               padding: const EdgeInsets.only(bottom: 2.5),
          //               child: Container(
          //                 child: Text(text, overflow: TextOverflow.visible, style: TextStyle(
          //                     fontWeight: FontWeight.w400, fontSize: 14.5)),
          //               ),
          //             )
          //           ],
          //         )
          //     ),
          //   ),
          // ),
        );
      },
    );
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  doubleRetri(String format) {
    if(format[format.length-1]!= 'K' && format[format.length-1]!= 'M' && format[format.length-1]!= 'B') {
      return double.parse(format);
    } else {
      return double.parse(format.substring(0, format.length-1));
    }
    // return format[format.length]
  }

  lastSRetri(String format) {
    if(format[format.length-1]!= 'K' && format[format.length-1]!= 'M' && format[format.length-1]!= 'B') {
      return '';
    } else {
      return format[format.length-1];
    }
  }

  animatedPrice(double price, style, precision) {
    double temp = 0;
    double total =  price;
    return Countup(
      precision: precision,
      begin: temp,
      end: total,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 500),
      separator: ',',
      style: style, textScaleFactor: 1,
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  @override
  bool get opaque => false;
  FadeRoute({required this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
    transitionDuration: Duration(milliseconds: 100),
    reverseTransitionDuration: Duration(milliseconds: 150),
  );
}