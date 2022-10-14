import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/add_new_shop_fragment.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/fragments/welcome_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';

import '../../app_theme.dart';
// import 'package:smartkyat_pos/src/screens/home.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  // final JiggleController jiggleCtl = JiggleController();

  late Timer _timer;
  int _start = 60;

  startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    print('initstate verify');
    // jiggleCtl.toggle();

    startTimer();
    user = auth.currentUser!;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });


    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 60.0, bottom: 60),
                        child: Container(
                            child: Image.asset('assets/system/smartkyat.png', height: 70, width: 70,)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 15.0, bottom: 15.0),
                        child: Text(
                          'Waiting your verification...',textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 70.0, bottom: 90.0),
                        child: Text(
                          'We have sent an email to ' + auth.currentUser!.email.toString() + ' so that you can activate your account.',
                          textScaleFactor: 1, textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setStoreId('');
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(FadeRoute(page: Welcome()),);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, top: 15.0, bottom: 15.0),
                          child: Text(
                            'Terminate to change user',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width,
                        splashColor: Colors.transparent,
                        height: 50,
                        child: FlatButton(
                          color: AppTheme.buttonColor2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: AppTheme.buttonColor2,
                            ),
                          ),
                          onPressed: () async {
                            if(_start == 0) {
                              user.sendEmailVerification();
                              setState(() {
                                _start = 60;
                              });
                              startTimer();
                            } else debugPrint('wait nay tl');
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0,
                                right: 5.0,
                                bottom: 3.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 90.0),
                                  child: Container(
                                    child: Text(
                                      'Resend email',
                                      textAlign: TextAlign.center,
                                      style: _start == 0 ?  TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing:-0.1
                                      ) : TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing:-0.1,
                                          color: Colors.black.withOpacity(0.3)
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  child: Text(
                                    _start == 0 ? '' : '($_start)' + ' s',
                                    textAlign: TextAlign.center,
                                    style:  TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing:-0.1,
                                      color: Colors.black.withOpacity(0.3)
                                    )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('After clicking the link or button in the email, you will be automatically directed to dashboard.',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  waitingTime() {
    Future.delayed(const Duration(milliseconds: 1000), () {

    });
  }

  setStoreId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));

    prefs.setString('store', id);
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      user.getIdToken(true);
      timer.cancel();
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => HomePage()));
      bool shopExists = false;
      await FirebaseFirestore.instance
          .collection('shops')
          .where('users', arrayContains: auth.currentUser!.email.toString())
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          shopExists = true;
        });

        if(shopExists) {
          Navigator.of(context).pushReplacement(FadeRoute(page: chooseStore()));
        } else Navigator.of(context).pushReplacement(FadeRoute(page: AddNewShop()));

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
