
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app_theme.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}


class _ChangePasswordState extends State<ChangePassword> {

bool _obscureText = true;
bool _obscureText1 = true;
  final _password = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  late bool checkCurrentPasswordValid = true;
  final auth = FirebaseAuth.instance;
  String? current;
  String? weak;
  String? incorrect;

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

  final _formKey = GlobalKey<FormState>();
bool firstTime = true;
double homeBotPadding = 0;
bool loadingState = false;
bool disableTouch = false;
@override
Widget build(BuildContext context) {

  if(firstTime) {
    homeBotPadding = MediaQuery.of(context).padding.bottom;
    firstTime = false;
  }
    return Container(
      color: Colors.white,
      child: IgnorePointer(
        ignoring: disableTouch,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.3),
                                width: 1.0))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Container(
                              width: 37,
                              height: 37,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(35.0),
                                  ),
                                  color: Colors.grey.withOpacity(0.3)),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 3.0),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      size: 17,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Information',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Account settings',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
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
                  Expanded(
                    child: ListView(
                      children: [
                        Form(
                          key: _formKey,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                                child: Text('CHANGE PASSWORD', style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14, color: Colors.grey,
                                ),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 45),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
//The validator receives the text that the user has entered.
                                  controller: _password,
                                  obscureText: _obscureText1,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      // return '';
                                      return ' This field is required ';
                                    }
                                    if (current != '') {
                                      return current;
                                    }
                                    return null;
                                  },
                                  style: TextStyle(
                                      height: 0.95
                                  ),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    enabledBorder:  OutlineInputBorder(
                                        borderSide:  BorderSide(
                                            color: AppTheme.skBorderColor,
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),

                                    focusedBorder:  OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                        borderSide:  BorderSide(
                                            color: AppTheme.themeColor,
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    // contentPadding: EdgeInsets.symmetric(vertical: 10), //Change this value to custom as you like
                                    // isDense: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 15.0,
                                        right: 15.0,
                                        top: 20,
                                        bottom: 20.0),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(bottom: 3.0),
                                      child: IconButton(
                                        icon: _obscureText1? Icon(Icons.remove_red_eye_outlined, size: 21,): Icon(Icons.remove_red_eye, size: 21,),
                                        //tooltip: 'Increase volume by 10',
                                        onPressed: () {
                                          setState(() {
                                            _toggle1();
                                          });
                                        },
                                      ),
                                    ),
                                    suffixStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontFamily: 'capsulesans',
                                    ),
                                    errorText: current,
                                    errorStyle: TextStyle(
                                        backgroundColor: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'capsulesans',
                                        height: 0.1
                                    ),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    labelText: 'Current Password',
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
//filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 117),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
//The validator receives the text that the user has entered.
                                  controller: _newPassword,
                                  obscureText: _obscureText,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      // return '';
                                      return ' This field is required ';
                                    }
                                    if (weak != '') {
                                      return weak;
                                    }
                                    // if (_newPassword.text == _password.text) {
                                    //   return ' Invalid Password';
                                    // }
                                    return null;
                                  },
                                  style: TextStyle(
                                      height: 0.95
                                  ),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    enabledBorder:  OutlineInputBorder(
                                        borderSide:  BorderSide(
                                            color: AppTheme.skBorderColor,
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),

                                    focusedBorder:  OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                        borderSide:  BorderSide(
                                            color: AppTheme.themeColor,
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    // contentPadding: EdgeInsets.symmetric(vertical: 10), //Change this value to custom as you like
                                    // isDense: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 15.0,
                                        right: 15.0,
                                        top: 20,
                                        bottom: 20.0),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(bottom: 3.0),
                                      child: IconButton(
                                        icon: _obscureText? Icon(Icons.remove_red_eye_outlined, size: 21,): Icon(Icons.remove_red_eye, size: 21,),
                                        //tooltip: 'Increase volume by 10',
                                        onPressed: () {
                                          setState(() {
                                            _toggle();
                                          });
                                        },
                                      ),
                                    ),
                                    suffixStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontFamily: 'capsulesans',
                                    ),
                                     errorText: weak,
                                    errorStyle: TextStyle(
                                        backgroundColor: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'capsulesans',
                                        height: 0.1
                                    ),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
// errorText: 'Error message',
                                    labelText: 'New Password',
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
//filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 189),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
//The validator receives the text that the user has entered.
                                  obscureText: _obscureText,
                                  controller: _confirmPassword,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      // return '';
                                      return ' This field is required ';
                                    }
                                    if (_newPassword.text != _confirmPassword.text) {
                                      return ' Passwords are not match ';
                                    }
                                    return null;
                                  },
                                  style: TextStyle(
                                      height: 0.95
                                  ),
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    enabledBorder:  OutlineInputBorder(
                                        borderSide:  BorderSide(
                                            color: AppTheme.skBorderColor,
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),

                                    focusedBorder:  OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                        borderSide:  BorderSide(
                                            color: AppTheme.themeColor,
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    // contentPadding: EdgeInsets.symmetric(vertical: 10), //Change this value to custom as you like
                                    // isDense: true,
                                    contentPadding: const EdgeInsets.only(
                                        left: 15.0,
                                        right: 15.0,
                                        top: 20,
                                        bottom: 20.0),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(bottom: 3.0),
                                      child: IconButton(
                                        icon: _obscureText? Icon(Icons.remove_red_eye_outlined, size: 21,): Icon(Icons.remove_red_eye, size: 21,),
                                        //tooltip: 'Increase volume by 10',
                                        onPressed: () {
                                          setState(() {
                                            _toggle();
                                          });
                                        },
                                      ),
                                    ),
                                    suffixStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontFamily: 'capsulesans',
                                    ),
                                    // errorText: wrongEmail,
                                    errorStyle: TextStyle(
                                        backgroundColor: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'capsulesans',
                                        height: 0.1
                                    ),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
// errorText: 'Error message',
                                    labelText: 'Confirm Password',
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
//filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 265),
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
                              //         current = null;
                              //         weak = null;
                              //         if (_formKey.currentState!.validate()) {
                              //           final user = FirebaseAuth.instance
                              //               .currentUser;
                              //           final cred = EmailAuthProvider.credential(
                              //               email: user!.email.toString(),
                              //               password: _password.text);
                              //
                              //           user.reauthenticateWithCredential(cred)
                              //               .then((value) {
                              //             user.updatePassword(_newPassword.text)
                              //                 .then((success) {
                              //                   Navigator.pop(context);
                              //               debugPrint('success changed');
                              //             }).catchError((error) {
                              //               setState(() {
                              //                 weak = ' Password must be 6 characters long';
                              //               });
                              //
                              //               debugPrint('error changed');
                              //             });
                              //           }).catchError((err) {
                              //             setState(() {
                              //               current = ' Invalid current password';
                              //             });
                              //
                              //             debugPrint('current password is wrong. ');
                              //           });
                              //         }
                              //       },
                              //       child: Padding(
                              //         padding: const EdgeInsets.only(
                              //             left: 5.0,
                              //             right: 5.0,
                              //             bottom: 3.0),
                              //         child: Container(
                              //           child: Text(
                              //             'Change Password',
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
                              // ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: homeBotPadding),
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0, bottom: 15.0),
                                child: ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width,
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
                                      current = null;
                                      weak = null;
                                      if (_formKey.currentState!.validate()) {
                                        try {
                                          final result = await InternetAddress.lookup('google.com');
                                          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                            setState(() {
                                              loadingState = true;
                                              disableTouch = true;
                                            });
                                            final user = FirebaseAuth.instance
                                                .currentUser;
                                            final cred = EmailAuthProvider.credential(
                                                email: user!.email.toString(),
                                                password: _password.text);

                                            user.reauthenticateWithCredential(cred)
                                                .then((value) {
                                              user.updatePassword(_newPassword.text)
                                                  .then((success) {
                                                setState(() {
                                                  loadingState = false;
                                                  disableTouch = false;
                                                });
                                                Navigator.pop(context);
                                                smartKyatFlash('You have successfully changed your password.', 's');
                                                debugPrint('success changed');
                                              }).catchError((error) {
                                                setState(() {
                                                  weak = ' Password must be 6 characters long';
                                                  disableTouch = false;
                                                  loadingState = false;
                                                });

                                                debugPrint('error changed');
                                              });
                                            }).catchError((err) {
                                              setState(() {
                                                current = ' Invalid current password';
                                                disableTouch = false;
                                                loadingState = false;
                                              });

                                              debugPrint('current password is wrong. ');
                                            });
                                          }
                                        } on SocketException catch (_) {
                                          smartKyatFlash('Internet connection is required to take this action.', 'w');
                                        }

                                      }
                                    },
                                    child:  loadingState == true ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                        child: CupertinoActivityIndicator(radius: 10,)) : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0,
                                          right: 5.0,
                                          bottom: 3.0),
                                      child: Container(
                                        child: Text(
                                          'Change password',
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Container(
                  //   color: Colors.white,
                  //   height: MediaQuery.of(context).viewInsets.bottom - 80 < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
        child: Text ('i', textScaleFactor: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,)),
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
}
