import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fragments/home_fragment.dart';
import 'package:smartkyat_pos/fragments/welcome_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page3.dart';

import '../../app_theme.dart';
import 'loading2.dart';
// import 'package:smartkyat_pos/src/screens/home.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  final JiggleController jiggleCtl = JiggleController();

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
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoadingScreen2()));
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
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
