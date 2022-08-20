import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fragments/welcome_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';

import '../../app_theme.dart';
// import 'package:smartkyat_pos/src/screens/home.dart';

class LoadingScreen2 extends StatefulWidget {
  @override
  _LoadingScreenState2 createState() => _LoadingScreenState2();
}

class _LoadingScreenState2 extends State<LoadingScreen2> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  // final JiggleController jiggleCtl = JiggleController();

  @override
  void initState() {
    // jiggleCtl.toggle();
    // user = auth.currentUser!;
    // user.sendEmailVerification();

    // timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   checkEmailVerified();
    // });
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Welcome()));
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                    child: CupertinoActivityIndicator(radius: 13,)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => HomePage()));
      _getId().then((val) {
        String deviceId = val!;
        Navigator.of(context).pushReplacement(FadeRoute(page: HomePage(deviceId: deviceId)),);
      });
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
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
