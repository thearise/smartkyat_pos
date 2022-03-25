import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/welcome_fragment.dart';
import 'package:smartkyat_pos/pages2/first_launch_page.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';
import 'package:smartkyat_pos/src/screens/loading.dart';

import '../app_theme.dart';
import 'add_shop_fragment.dart';


class chooseStore extends StatefulWidget {
  const chooseStore({Key? key}) : super(key: key);



  @override
  chooseStoreState createState() => chooseStoreState();
}

class chooseStoreState extends State<chooseStore> {

  var _result;
  var _shop ;
  bool firstTime = true;
  final auth = FirebaseAuth.instance;

  bool loadingState = false;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {

      print('_seen');
    } else {
      print('_notSeen');
      Navigator.of(context).push(
          FadeRoute(page: FirstLaunchPage(),)
      );
      await prefs.setBool('seen', true);
    }
  }

  @override
  initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      checkFirstSeen();
    });
    // jiggleCtl.toggle();
    // user = auth.currentUser!;
    print('UID -> ' + auth.currentUser!.uid.toString());
    // user.sendEmailVerification();

    // timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   checkEmailVerified();
    // });
    super.initState();
    // Future.delayed(const Duration(milliseconds: 1000), () {
    //   FirebaseAuth.instance
    //       .authStateChanges()
    //       .listen((User? user) {
    //     if (user == null) {
    //       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoadingScreen()));
    //       // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Welcome()));
    //       print('User is currently signed out!');
    //     } else {
    //       print('User is signed in!');
    //     }
    //   });
    // });

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
            padding: EdgeInsets.only(
                top: 25, left: 15, right: 15),
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          bottom: true,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 900? MediaQuery.of(context).size.width/4:0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 23.0),
                        child: Container(
                            child: Image.asset('assets/system/smartkyat.png', height: 63, width: 63,)
                        ),
                      ),
                    ),
                    SizedBox(height: 26.5,),
                    Text('REGISTERED SHOPS', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 14, letterSpacing: 2,
                      color: Colors.grey,),),
                    SizedBox(height: 13,),
                    Expanded(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('shops')
                              .where('users', arrayContains: auth.currentUser == null? '' : auth.currentUser!.email.toString())
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            // print('CAGAIN ' + auth.currentUser!.email.toString());
                            if(snapshot.hasData) {
                              print('CAGAIN ' + auth.currentUser!.email.toString());
                              var index = 0;
                              return ListView(
                                // physics: NeverScrollableScrollPhysics(),
                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                  index++;
                                  print('owerner ' + data['owner_id'] + ' -> ' + auth.currentUser!.uid.toString());
                                  if(index == 1 && firstTime) {
                                    _result = document.id.toString();
                                    _shop= data['shop_name'];
                                  }
                                  firstTime = false;
                                  return  Container(
                                    height: 54,
                                    margin: EdgeInsets.only(bottom: 17),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    child: RadioListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.only(top: 1, bottom: 0, left: 5, right: 15),
                                        // title: Text(data['shop_name'], overflow: TextOverflow.ellipsis, style: TextStyle(height: 1.1, fontSize: 17, fontWeight: FontWeight.w500, ),),
                                        title: Container(
                                          // color: Colors.blue,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0.0),
                                            child: Row(
                                              children: [

                                                Expanded(child: Transform.translate(
                                                  offset: Offset(-12, 0),
                                                  child: Container(
                                                    child: Text(data['shop_name'], overflow: TextOverflow.ellipsis, style: TextStyle(height: 1.1, fontSize: 17, fontWeight: FontWeight.w500, ),),
                                                  ),
                                                ),),
                                                data['owner_id'].toString() == auth.currentUser!.uid.toString()?
                                                Container(
                                                  height: 23,
                                                  width: 55,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(6.0),
                                                      ),
                                                      color: AppTheme.badgeBgSuccess),
                                                  child: Text('Owner', style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 12,
                                                      color: Colors.white
                                                  ),),
                                                ):
                                                Container(
                                                  height: 23,
                                                  width: 55,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(6.0),
                                                      ),
                                                      color: AppTheme.badgeBgSecond),
                                                  child: Text('Staff', style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 12,
                                                      color: Colors.white
                                                  ),),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        activeColor: AppTheme.themeColor,
                                        value: document.id.toString(),
                                        groupValue: _result,
                                        onChanged: (value) {
                                          setState(() {
                                            _result = value;
                                            _shop= data['shop_name'];
                                            print(_result);
                                          });
                                        }
                                    ),
                                  );
                                }
                                ).toList(),
                              );
                            }
                            return Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                child: CupertinoActivityIndicator(radius: 15,));
                          }
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(width: 15),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                try {
                                  final result = await InternetAddress.lookup('google.com');
                                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                    await FirebaseFirestore.instance.collection('users')
                                        .where('user_id' ,isEqualTo: auth.currentUser!.uid)
                                        .limit(1)
                                        .get()
                                        .then((QuerySnapshot querySnapshot) async {
                                      Map<String, dynamic> userData = querySnapshot.docs[0].data()! as Map<String, dynamic>;
                                      await FirebaseFirestore.instance.collection('shops')
                                          .where('owner_id' ,isEqualTo: auth.currentUser!.uid)
                                          .get()
                                          .then((QuerySnapshot querySnapshot) async {
                                        int shopCount = querySnapshot.docs.length;
                                        if(userData['plan_type'] == 'basic' && shopCount >= 5) {
                                          showOkAlertDialog(
                                              context: context,
                                              title: 'Maximum shops reached',
                                              message: 'Maximum number of shops has been created. Please contact to our customer service to upgrade your account.'
                                          ).then((result) async {
                                          });
                                          setState(() {
                                            loadingState = false;
                                          });
                                        } else if(userData['plan_type'] == 'medium' && shopCount >= 10) {
                                          showOkAlertDialog(
                                              context: context,
                                              title: 'Maximum shops reached',
                                              message: 'Maximum number of shops has been created. Please contact to our customer service to upgrade your account.'
                                          ).then((result) async {
                                          });
                                          setState(() {
                                            loadingState = false;
                                          });
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddShop()),
                                          );
                                        }
                                      });
                                    });
                                  }
                                } on SocketException catch (_) {
                                  setState(() {
                                    smartKyatFlash('Internet connection is required to take this action.', 'w');
                                  });
                                }
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => AddShop()),);
                              },
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Create new shop',
                                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 15),
                                      strutStyle: StrutStyle(
                                        height: 1.2,
                                        // fontSize:,
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.add_circle_rounded,
                                      color: Colors.blue,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                        ],
                      ),
                    ),
                    // ButtonTheme(
                    //   minWidth: MediaQuery.of(context).size.width,
                    //   splashColor: Colors.transparent,
                    //   height: 50,
                    //   child: FlatButton(
                    //     color: AppTheme.buttonColor2,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius:
                    //       BorderRadius.circular(10.0),
                    //       side: BorderSide(
                    //         color: AppTheme.buttonColor2,
                    //       ),
                    //     ),
                    //     onPressed: () async {
                    //       Navigator.push(context, MaterialPageRoute(builder: (context) => AddShop()),);
                    //     },
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(
                    //           left: 5.0,
                    //           right: 5.0,
                    //           bottom: 3.0),
                    //       child: Container(
                    //         child: Text(
                    //           'Create new shop',
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //               fontSize: 18,
                    //               fontWeight: FontWeight.w600,
                    //               letterSpacing:-0.1
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 10,),
                    RichText(
                      strutStyle: StrutStyle(
                        height: 1,
                        // fontSize:,
                        forceStrutHeight: true,
                      ),
                      text: new TextSpan(
                        children: [
                          new TextSpan(
                            text: 'Set up some information about your shop later in shop settings.',
                            style: new TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, bottom: 40.0),
                      child: Row(
                        children: [
                          ButtonTheme(
                            // minWidth: MediaQuery.of(context).size.width/3 - 22.5,
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
                              onPressed: ()  async {
                                await FirebaseAuth.instance.signOut();
                                setStoreId('');
                                Navigator.of(context).pushReplacement(
                                  FadeRoute(page: Welcome()),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    bottom: 3.0),
                                child: Container(
                                  child: Text(
                                    'Logout',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        height: 1.3,
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 1.3,
                                      // fontSize:,
                                      forceStrutHeight: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: ButtonTheme(
                              // minWidth: double.infinity,
                              // minWidth: (MediaQuery.of(context).size.width * 2/3.1) - 22.5,
                              splashColor: Colors.transparent,
                              height: 50,
                              child: FlatButton(
                                color: AppTheme.themeColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    color: AppTheme.themeColor,
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    loadingState = true;
                                  });
                                  try {
                                    final result = await InternetAddress.lookup('google.com');
                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                      _getId().then((value1) async {
                                        print('IDD ' + value1.toString());
                                        await FirebaseFirestore.instance.collection('shops').doc(_result).update({
                                          'devices': FieldValue.arrayUnion([value1.toString()]),
                                        }).then((value3) async {
                                          print('got it 1');
                                          await FirebaseFirestore.instance.collection('shops').doc(_result)
                                          // .where('date', isGreaterThanOrEqualTo: todayToYearStart(now))
                                              .get().then((value2) async {
                                            print('got it 2');
                                            var isPro = value2.data()!['is_pro'];
                                            String shopName = value2.data()!['shop_name'];
                                            Timestamp isProStart = isPro['start'];
                                            Timestamp isProEnd = isPro['end'];

                                            DateTime startDate = isProStart.toDate();
                                            DateTime endDate = isProEnd.toDate();

                                            DateTime nowCheck = DateTime.now();

                                            if(!(startDate.isBefore(nowCheck) && endDate.isAfter(nowCheck))) {
                                              Future.delayed(const Duration(milliseconds: 500), () {
                                                smartKyatFlash('$shopName shop pro version ended', 'e');
                                                setState(() {
                                                  loadingState = false;
                                                });
                                              });
                                            } else {
                                              print('got it 3');
                                              await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users')
                                                  .where('email', isEqualTo: auth.currentUser!.email)
                                                  .get()
                                                  .then((QuerySnapshot querySnapshot) async {
                                                print('got it 4');
                                                print('shit ' + querySnapshot.docs[0].id.toString());
                                                await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users').doc(querySnapshot.docs[0].id).update({
                                                  // 'device0': FieldValue.arrayUnion([await _getId()]),
                                                  'device0': await _getId(),
                                                }).then((value3) async {
                                                  print('done');
                                                });
                                                // if(querySnapshot.docs[0]['devices'].length != 2) {
                                                //
                                                // }
                                              });

                                              // await FirebaseFirestore.instance.collection('shops').doc(_result).collection('users')
                                              //   .where('email', isEqualTo: auth.currentUser!.email)
                                              //   .get()
                                              //   .then((QuerySnapshot querySnapshot) {
                                              //   print('shit ' + querySnapshot.docs[0]['devices'].toString());
                                              // });
                                              setStoreId(_result);
                                              List devicesList = value2.data()!['devices'];
                                              int? deviceIdNum;
                                              for(int i = 0; i < devicesList.length; i++) {
                                                if(devicesList[i] == value1.toString()) {
                                                  print('DV LIST ' + devicesList[i].toString());
                                                  setState(() {
                                                    deviceIdNum = i;
                                                    print('DV LIST 2 ' + deviceIdNum.toString());
                                                  });
                                                }
                                              }
                                              setDeviceId(deviceIdNum.toString()).then((value) {
                                                // Navigator.of(context).pushReplacement(FadeRoute(page: HomePage()));
                                                _getId().then((val) {
                                                  String deviceId = val!;
                                                  Navigator.of(context).pushReplacement(FadeRoute(page: HomePage(deviceId: deviceId)),);
                                                });
                                              });
                                            }
                                          });
                                        });
                                      });
                                    }
                                  } on SocketException catch (_) {
                                    smartKyatFlash('Internet connection is required to take this action.', 'w');
                                    setState(() {
                                      loadingState = false;
                                    });
                                  }
                                },
                                child:  loadingState? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                    child: CupertinoActivityIndicator(radius: 10,)) : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0,
                                      right: 5.0,
                                      bottom: 3.0),
                                  child: Container(
                                    child: Text(
                                      'Go to dashboard',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          height: 1.3,
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black
                                      ),
                                      strutStyle: StrutStyle(
                                        height: 1.3,
                                        // fontSize:,
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 50.0, bottom: 40.0),
                    //   child: ButtonTheme(
                    //     minWidth: MediaQuery.of(context).size.width,
                    //     splashColor: Colors.transparent,
                    //     height: 50,
                    //     child: FlatButton(
                    //       color: AppTheme.themeColor,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius:
                    //         BorderRadius.circular(10.0),
                    //         side: BorderSide(
                    //           color: AppTheme.themeColor,
                    //         ),
                    //       ),
                    //       onPressed: () async {
                    //         try {
                    //           final result = await InternetAddress.lookup('google.com');
                    //           if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    //             setState(() {
                    //               loadingState = true;
                    //             });
                    //             setStoreId(_result);
                    //             _getId().then((value1) async {
                    //               print('IDD ' + value1.toString());
                    //               await FirebaseFirestore.instance.collection('shops').doc(_result).update({
                    //                 'devices': FieldValue.arrayUnion([value1.toString()]),
                    //               }).then((value3) async {
                    //                 print('done');
                    //                 await FirebaseFirestore.instance.collection('shops').doc(_result)
                    //                 // .where('date', isGreaterThanOrEqualTo: todayToYearStart(now))
                    //                     .get().then((value2) async {
                    //                   List devicesList = value2.data()!['devices'];
                    //                   int? deviceIdNum;
                    //                   for(int i = 0; i < devicesList.length; i++) {
                    //                     if(devicesList[i] == value1.toString()) {
                    //                       print('DV LIST ' + devicesList[i].toString());
                    //                       setState(() {
                    //                         deviceIdNum = i;
                    //                         print('DV LIST 2 ' + deviceIdNum.toString());
                    //                       });
                    //                     }
                    //                   }
                    //                   setDeviceId(deviceIdNum.toString()).then((value) {
                    //                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                    //                   });
                    //                 });
                    //               });
                    //             });
                    //           }
                    //         } on SocketException catch (_) {
                    //             smartKyatFlash('Internet connection is required to take this action.', 'w');
                    //         }
                    //       },
                    //       child:  loadingState? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                    //           child: CupertinoActivityIndicator(radius: 10,)) : Padding(
                    //         padding: const EdgeInsets.only(
                    //             left: 5.0,
                    //             right: 5.0,
                    //             bottom: 3.0),
                    //         child: Container(
                    //           child: Text(
                    //             // 'Switch as $_shop',
                    //             'Go to dashboard',
                    //             textAlign: TextAlign.center,
                    //             style: TextStyle(
                    //                 fontSize: 18,
                    //                 fontWeight: FontWeight.w600,
                    //                 letterSpacing:-0.1
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //
                    // ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  setStoreId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setString('store', id);
  }

  getStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('store');
  }

  setDeviceId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setString('device', id);
  }

  getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('device');
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
