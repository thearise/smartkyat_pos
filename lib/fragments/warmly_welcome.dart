import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/add_shop_first.dart';
import 'package:smartkyat_pos/fragments/customers_fragment2.dart';
import 'package:smartkyat_pos/fragments/subs/forgot_password.dart';
import 'package:smartkyat_pos/fragments/welcome_fragment.dart';
import 'package:smartkyat_pos/pages2/first_launch_page.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';
import 'package:smartkyat_pos/pages2/homepage_off.dart';
import 'package:smartkyat_pos/src/app.dart';
import 'package:smartkyat_pos/src/screens/login.dart';
import 'package:smartkyat_pos/src/screens/verify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_theme.dart';
import 'add_new_shop_fragment.dart';
import 'add_shop_fragment.dart';
import 'choose_store_fragment.dart';
// import 'package:loader_overlay/loader_overlay.dart';

class WarmlyWelcome extends StatefulWidget {
  final double? gloBotPadd;
  const WarmlyWelcome({Key? key, this.gloBotPadd,}) : super(key: key);

  @override
  _WarmlyWelcomeState createState() => _WarmlyWelcomeState();
}

class _WarmlyWelcomeState extends State<WarmlyWelcome>
    with TickerProviderStateMixin<WarmlyWelcome>{

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
    getLangId().then((val) {
      debugPrint('ffirs ' + val.toString());
      lang = val;
      if(lang == 'english') {
        isEnglish = true;
      } else {
        isEnglish = false;
      }
    });

    if(Platform.isIOS)
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    if(Platform.isAndroid)
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white, // navigation bar color
          statusBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark// status bar color
      ));

    debugPrint('get off 0 ');
    getOffline().then((value) {
      debugPrint('get off ' + value.toString());
      if(value=='true') {
        Navigator.of(context).pushReplacement(FadeRoute(page: HomePageOff()),);
      } else if(value=='false') {
        Navigator.of(context).pushReplacement(FadeRoute(page: Welcome()),);
      }
    });

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) async {
      if (user == null) {
        debugPrint('User is currently signed out!');
        Future.delayed(const Duration(milliseconds: 1000), () {
          if(this.mounted) {
            setState(() {
              isLoading = false;
            });
          }
        });

        getStoreId().then((value) {
          debugPrint('Out ID -> ' + value.toString());
        });

        setStoreId('');

        WidgetsBinding.instance!.addPostFrameCallback((_) async {
          checkFirstSeen();
          // await Navigator.of(context).push(
          //     FadeRoute(page: FirstLaunchPage(),)
          // );

          // setState(() {
          //   debugPrint('setting state ' + lang.toString());
          // });

        });
      } else {
        bool usersInSys = false;
        await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: auth.currentUser!.email)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            usersInSys = true;
          });

          if(usersInSys) {
            getStoreId().then((value) {
              if(!auth.currentUser!.emailVerified) {
                Navigator.of(context).pushReplacement(FadeRoute(page: VerifyScreen()),);
              }
              else {
                isLoading = true;

                Future.delayed(const Duration(milliseconds: 1000), () async {

                  if(value.toString() != '' && value.toString() != 'idk') {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));

                    _getId().then((val) {
                      String deviceId = val!;
                      if(this.mounted) {
                        Navigator.of(context).pushReplacement(FadeRoute(page: HomePage(deviceId: deviceId)),);
                      }
                    });
                  } else {
                    bool shopExists = false;
                    FirebaseFirestore.instance
                        .collection('shops')
                        .where('users', arrayContains: auth.currentUser!.email.toString())
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                      querySnapshot.docs.forEach((doc) {
                        shopExists = true;
                      });
                      if(shopExists) {
                        if(this.mounted) {
                          Navigator.of(context).popUntil((_) => true);
                          Navigator.of(context).pushReplacement(FadeRoute(page: chooseStore()));
                        }
                      } else {
                        if(this.mounted) {
                          Navigator.of(context).pushReplacement(FadeRoute(page: AddShopFirst(isEnglish: isEnglish)));
                        }
                      }
                    });
                  }
                });
              }
            });
          } else {
            FirebaseFirestore.instance.collection('users').add({
              'user_id' : auth.currentUser!.uid.toString(),
              'name': auth.currentUser!.displayName.toString(),
              'email': auth.currentUser!.email.toString(),
              'plan_type' : 'basic',
            }).then((val) {
              getStoreId().then((value) {
                if(!auth.currentUser!.emailVerified) {
                  Navigator.of(context).pushReplacement(FadeRoute(page: VerifyScreen()),);
                }
                else {
                  isLoading = true;

                  Future.delayed(const Duration(milliseconds: 1000), () async {

                    if(value.toString() != '' && value.toString() != 'idk') {
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));

                      _getId().then((val) {
                        String deviceId = val!;
                        if(this.mounted) {
                          Navigator.of(context).pushReplacement(FadeRoute(page: HomePage(deviceId: deviceId)),);
                        }
                      });
                    } else {
                      bool shopExists = false;
                      FirebaseFirestore.instance
                          .collection('shops')
                          .where('users', arrayContains: auth.currentUser!.email.toString())
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          shopExists = true;
                        });
                        if(shopExists) {
                          if(this.mounted) {
                            Navigator.of(context).popUntil((_) => true);
                            Navigator.of(context).pushReplacement(FadeRoute(page: chooseStore()));
                          }
                        } else {
                          if(this.mounted) {
                            Navigator.of(context).pushReplacement(FadeRoute(page: AddShopFirst(isEnglish: isEnglish)));
                          }
                        }
                      });
                    }
                  });
                }
              });
            });
          }
        });
      }
    });

    _loginTabController = TabController(length: 2, vsync: this);
    _signupController = TabController(length: 2, vsync: this);
    _bottomTabBarCtl = TabController(length: 4, vsync: this);
    _bottomTabBarCtl.animateTo(1);



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

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            bottom: true,
            top: true,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 900? MediaQuery.of(context).size.width/4:0.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15, top: 23.0),
                              child: Container(
                                  child: Image.asset('assets/system/smartkyat.png', height: 63, width: 63,)
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.width > 900? 370 + 40 + (((MediaQuery.of(context).size.width/2) - 30) * (752/1496)) : 370 + 40 + ((MediaQuery.of(context).size.width - 30) * (752/1496)) ,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40.0, left: 0, right: 0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                      child: Container(
                                          child: Image.asset('assets/system/retialshop.png',)
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              await setOffline('true');
                                              Navigator.of(context).pushReplacement(FadeRoute(page: HomePageOff()),);
                                            },
                                            child: Container(
                                              height: 100,
                                              color: Colors.yellow,
                                              width: double.infinity,
                                              child: Text('Free offline use'),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushReplacement(FadeRoute(page: Welcome()),);
                                            },
                                            child: Container(
                                              height: 100,
                                              color: Colors.green,
                                              width: double.infinity,
                                              child: Text('Paid monthly online'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                                height: MediaQuery.of(context).viewInsets.bottom
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: isLoading,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                    child: CupertinoActivityIndicator(radius: 15,)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: overLoading,
            child: Container(
              color: Colors.white.withOpacity(0.4),
              child: Column(
                children: [
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
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