import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/customers_fragment2.dart';
import 'package:smartkyat_pos/fragments/subs/forgot_password.dart';
import 'package:smartkyat_pos/pages2/first_launch_page.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';
import 'package:smartkyat_pos/src/app.dart';
import 'package:smartkyat_pos/src/screens/login.dart';
import 'package:smartkyat_pos/src/screens/verify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_theme.dart';
import '../fragments/welcome_fragment.dart';

class EndOfProService extends StatefulWidget {
  const EndOfProService({
    Key? key,
    required this.shopId,
  }) : super(key: key);

  final String shopId;

  @override
  _EndOfProServiceState createState() => _EndOfProServiceState();
}

class _EndOfProServiceState extends State<EndOfProService>
    with TickerProviderStateMixin<EndOfProService>{

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
  bool loadingState = false;

  var shopSnapshot;

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
  }

  @override
  initState() {
    setStoreId('');
    shopSnapshot =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).snapshots();
    if(Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // navigation bar color
        statusBarColor: Colors.white, // status bar color
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  zeroToTen(String string) {
    if (double.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
  }

  convertToDate(String input) {
    switch (input) {
      case '01':
        return 'January';
        break;
      case '02':
        return 'February';
        break;
      case '03':
        return 'March';
        break;
      case '04':
        return 'April';
        break;
      case '05':
        return 'May';
        break;
      case '06':
        return 'June';
        break;
      case '07':
        return 'July';
        break;
      case '08':
        return 'August';
        break;
      case '09':
        return 'September';
        break;
      case '10':
        return 'October';
        break;
      case '11':
        return 'November';
        break;
      case '12':
        return 'December';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        top: true,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(18.0),
                //   topRight: Radius.circular(18.0),
                // ),
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    // color: Colors.yellow,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.all(
                            //   Radius.circular(15.0),
                            // ),
                            color: Colors.white,
                          ),
                          height: (MediaQuery.of(context).size.height - 50)/ 2,
                        ),
                        Container(
                          color: Color(0xFFF2F1F6),
                          height: (MediaQuery.of(context).size.height - 50)/ 2,
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  // topLeft: Radius.circular(15.0),
                                  // topRight: Radius.circular(15.0),
                                ),
                                color: Colors.white,
                              ),
                              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                stream:  shopSnapshot,
                                builder: (context, snapshot) {
                                  if(snapshot.hasData) {
                                    var output = snapshot.data != null? snapshot.data!.data(): null;
                                    var isPro = output?['is_pro'];
                                    Timestamp isProStart = isPro['start'];
                                    Timestamp isProEnd = isPro['end'];

                                    DateTime start = isProStart.toDate();
                                    DateTime end = isProEnd.toDate();
                                    return Column(
                                        children: [
                                          SizedBox(height: 15),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 40),
                                                  Center(
                                                    child: Text(
                                                      'Your pro version has ended',textScaleFactor: 1, style: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 26,
                                                        letterSpacing: -0.4
                                                    ),
                                                      strutStyle: StrutStyle(
                                                        height: 2.2,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 20.0),
                                                    child: Text('Your last updated (at ' + start.day.toString() + ' ' + convertToDate(zeroToTen(start.month.toString())) + ' ' + start.year.toString() + ') plan ended at '  + end.day.toString() + ' ' + convertToDate(zeroToTen(end.month.toString())) + ' ' + end.year.toString() +  '.',
                                                      textScaleFactor: 1, style: TextStyle( fontSize: 14),
                                                      strutStyle: StrutStyle(
                                                        height: 1.2,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15, right: 15, top: 20.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0),
                                                  ),
                                                  color: Color(0xFFF5F5F5),
                                                  border: Border.all(
                                                      color: Colors.grey.withOpacity(0.2),
                                                      width: 1.0),
                                                ),
                                                width: MediaQuery.of(context).size.width,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 20.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(height: 18),
                                                      Text('1 month pro version', textScaleFactor: 1, style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 18,
                                                          letterSpacing: -0.3
                                                      ),
                                                        strutStyle: StrutStyle(
                                                          height: 1.5,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text('15,000 Kyats /month', textScaleFactor: 1, style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                          letterSpacing: -0.3
                                                      ),
                                                        strutStyle: StrutStyle(
                                                          height: 1.2,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                      SizedBox(height: 22),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15, right: 15, top: 15.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(15.0),
                                                    ),
                                                    gradient: LinearGradient(
                                                        colors: [Color(0xFFFFE18A), Color(0xFFC2FC1D)],
                                                        begin: Alignment(-1.0, -2.0),
                                                        end: Alignment(1.0, 2.0),
                                                        tileMode: TileMode.clamp)),
                                                width: MediaQuery.of(context).size.width,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 20.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(height: 18),
                                                      Text('3 month pro version (save 20%)', textScaleFactor: 1, style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 18,
                                                          letterSpacing: -0.3
                                                      ),
                                                        strutStyle: StrutStyle(
                                                          height: 1.5,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text('12,000 Kyats /month', textScaleFactor: 1, style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                          letterSpacing: -0.3
                                                      ),
                                                        strutStyle: StrutStyle(
                                                          height: 1.2,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                      SizedBox(height: 22),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15, right: 15, top: 15.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(15.0),
                                                    ),
                                                    gradient: LinearGradient(
                                                        colors: [Color(0xFFDBFF76), Color(0xFF9FFFD1)],
                                                        begin: Alignment(-1.0, -2.0),
                                                        end: Alignment(1.0, 2.0),
                                                        tileMode: TileMode.clamp)),
                                                width: MediaQuery.of(context).size.width,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 20.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(height: 18),
                                                      Text('5 month pro version (save 30%)', textScaleFactor: 1, style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 18,
                                                          letterSpacing: -0.3
                                                      ),
                                                        strutStyle: StrutStyle(
                                                          height: 1.5,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text('10,500 Kyats /month', textScaleFactor: 1, style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                          letterSpacing: -0.3
                                                      ),
                                                        strutStyle: StrutStyle(
                                                          height: 1.2,
                                                          // fontSize:,
                                                          forceStrutHeight: true,
                                                        ),
                                                      ),
                                                      SizedBox(height: 22),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                          SizedBox(height: 20),
                                        ]
                                    );
                                  }
                                  return Container();
                                }
                              ),
                            ),
                            Container(
                              color: Color(0xFFF2F1F6),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0),
                                        ),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey.withOpacity(0.2),
                                            width: 1.0),
                                      ),
                                      child: ListTile(
                                        leading: Padding(
                                          padding: const EdgeInsets.only(left:3.0, top: 3.0),
                                          child: Image(image: AssetImage('assets/system/call_now.png'), width: 28,),
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Text('Contact us via phone', textScaleFactor: 1, style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              letterSpacing: -0.3
                                          ),
                                            strutStyle: StrutStyle(
                                              height: 1.5,
                                              // fontSize:,
                                              forceStrutHeight: true,
                                            ),
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 6),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          width: 1.0))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 10.0),
                                                child: Text('You can contact us now to purchase above plans.', style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15, color: Colors.black,
                                                ), textScaleFactor: 1,
                                                  strutStyle: StrutStyle(
                                                    height: 1.35,
                                                    // fontSize:,
                                                    forceStrutHeight: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text('Call now', style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17, color: Colors.blue,
                                            ), textScaleFactor: 1,
                                              strutStyle: StrutStyle(
                                                height: 1.3,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),

                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0),
                                        ),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey.withOpacity(0.2),
                                            width: 1.0),
                                      ),
                                      child: ListTile(
                                        leading: Padding(
                                          padding: const EdgeInsets.only(left:3.0, top: 3.0),
                                          child: Image(image: AssetImage('assets/system/messenger.png'), width: 28,),
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Text('Via messenger', style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              letterSpacing: -0.3
                                          ), textScaleFactor: 1,
                                            strutStyle: StrutStyle(
                                              height: 1.5,
                                              // fontSize:,
                                              forceStrutHeight: true,
                                            ),
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 6),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          width: 1.0))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 10.0),
                                                child: Text('You can contact us now to purchase above plans (delay response).', style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15, color: Colors.black,
                                                ), textScaleFactor: 1,
                                                  strutStyle: StrutStyle(
                                                    height: 1.35,
                                                    // fontSize:,
                                                    forceStrutHeight: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text('Messenger', style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17, color: Colors.blue,
                                            ), textScaleFactor: 1,
                                              strutStyle: StrutStyle(
                                                height: 1.3,
                                                // fontSize:,
                                                forceStrutHeight: true,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      color: Colors.white,
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Expanded(
                            child: Container(),
                          ),
                          GestureDetector(
                            onTap: () {
                              setStoreId('');
                              Navigator.of(context).pushReplacement(FadeRoute(page: Welcome()),);
                            },
                            child: Row(
                              children: [
                                Text('Switch shop',
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 15),
                                  strutStyle: StrutStyle(
                                    height: 1.2,
                                    // fontSize:,
                                    forceStrutHeight: true,
                                  ), textScaleFactor: 1,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: SizedBox(width: 14),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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
