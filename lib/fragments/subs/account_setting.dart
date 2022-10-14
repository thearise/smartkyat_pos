import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_theme.dart';
import 'change_password.dart';

class AccountSetting extends StatefulWidget {
  AccountSetting({
    required this.email, required this.name, required this.id,
    Key? key,
  });
  final String email;
  final String name;
  final String id;

  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {

  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final _accountName = TextEditingController();

  String textSetAccountSetting = 'Account setting';
  String textSetAccountName = 'Account name';
  String textSetInfo = 'Your account name will also be used for registering staff from other stores.';
  String textSetSave = 'Save and exit';
  String textSetEmailChange = 'You can\'t change email address by yourside. If you are sure want to change it, you need to contact us.';
  String textSetAuth = 'Authentication';
  String textSetChangePw = 'Change password';

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }


  @override
  void initState() {
    _accountName.text = widget.name;

    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetAccountSetting = 'Account setting';
          textSetAccountName = 'နာမည်';
          textSetInfo = 'သင့်အကောင့်အမည်ကို အခြားစတိုးဆိုင်များမှ ဝန်ထမ်းများကို စာရင်းသွင်းရန်အတွက်လည်း အသုံးပြုမည်ဖြစ်သည်။';
          textSetSave = 'သိမ်းမည်';
          textSetEmailChange = 'သင့်ဘက်မှ အီးမေးလ်လိပ်စာကို ပြောင်း၍မရပါ။ ပြောင်းလဲလိုပါက ကျွန်ုပ်တို့ထံ ဆက်သွယ်ရန် လိုအပ်ပါသည်။';
          textSetAuth = 'Authentication';
          textSetChangePw = 'စကားဝှက်ပြောင်းရန်';
        });
      } else if(value=='english') {
        setState(() {
          textSetAccountSetting = 'Account setting';
          textSetAccountName = 'Account name';
          textSetInfo = 'Your account name will also be used for registering staff from other stores.';
          textSetSave = 'Save and exit';
          textSetEmailChange = 'You can\'t change email address by yourside. If you are sure want to change it, you need to contact us.';
          textSetAuth = 'Authentication';
          textSetChangePw = 'Change password';
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _accountName.dispose();
    super.dispose();
  }

  late BuildContext dialogContext;

  openOverAllSubLoading() {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.4),
      context: context,
      builder: (context) {
        dialogContext = context;
        return Container();
      },
    );
  }

  closeOverAllSubLoading() {
    Navigator.pop(dialogContext);
  }

  bool firstTime = true;
  double homeBotPadding = 0;
  bool loadingState = false;
  bool disableTouch = false;
  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
      firstTime = false;
    }
    return Container(
      color: Colors.white,
      child: IgnorePointer(
        ignoring: disableTouch,
        child: SafeArea(
          bottom: true,
          top: true,
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 80,
                          child:
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
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
                              Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 15.5,
                                  ),
                                  Text('Information', textScaleFactor: 1,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5
                                      // color: Colors.grey,
                                    ),),
                                  Text(textSetAccountSetting,  textScaleFactor: 1,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        height: 1.3
                                    ),
                                    strutStyle: StrutStyle(
                                      height: 1.7,
                                      // fontSize:,
                                      forceStrutHeight: true,
                                    ),
                                  )
                                ],
                              ),
                              // Container(
                              //   width: 37,
                              //   height: 37,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(35.0),
                              //       ),
                              //       color: Colors.grey.withOpacity(0.3)),
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(right: 3.0),
                              //     child: IconButton(
                              //         icon: Icon(
                              //           Icons.check,
                              //           size: 17,
                              //           color: Colors.black,
                              //         ),
                              //         onPressed: () async {
                              //           String dataRm = widget.data.split('^')[0] +
                              //               '^' +
                              //               widget.data.split('^')[1] +
                              //               '^' +
                              //               widget.data.split('^')[2] +
                              //               '^' +
                              //               widget.data.split('^')[3].split('&')[1] +
                              //               '^' +
                              //               widget.data.split('^')[4] + '^' + widget.data.split('^')[5] + '^' + widget.data.split('^')[6];
                              //           String data = widget.data.split('^')[0] +
                              //               '^' +
                              //               widget.data.split('^')[1] +
                              //               '^' +
                              //               widget.data.split('^')[2] +
                              //               '^' +
                              //               widget.data.split('^')[3].split('&')[1] +
                              //               '^' +
                              //               widget.data.split('^')[4] + '^' + debtAmount.toString() + '^' + widget.data.split('^')[6];
                              //
                              //           CollectionReference dailyOrders = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders');
                              //           CollectionReference order = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('order');
                              //           CollectionReference customerDebt = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('customers');
                              //
                              //           dailyOrders.doc(widget.documentId).update({
                              //             'daily_order':
                              //             FieldValue.arrayRemove([dataRm])
                              //           }).then((value) {debugPrint('array removed');})
                              //               .catchError((error) => debugPrint("Failed to update user: $error"));
                              //
                              //           dailyOrders.doc(widget.documentId).update({
                              //             'daily_order':
                              //             FieldValue.arrayUnion([data])
                              //           }).then((value) { debugPrint('array updated');})
                              //               .catchError((error) => debugPrint("Failed to update user: $error"));
                              //
                              //           order.doc(
                              //               widget.docId)
                              //               .update({
                              //             'debt' : debtAmount
                              //           })
                              //               .then((value) => debugPrint("User Updated"))
                              //               .catchError((error) => debugPrint("Failed to update user: $error"));
                              //
                              //           double debts = 0;
                              //           if(debtAmount == 0.0) {
                              //             debts = 1;
                              //           } else debts = 0;
                              //           if( widget.data.split('^')[3].split('&')[1] !='name') {
                              //           customerDebt.doc(
                              //               widget.data.split('^')[3].split('&')[1])
                              //               .update({
                              //             'debtAmount' : FieldValue.increment( 0 - double.parse(paidAmount.toString())),
                              //             'debts' : FieldValue.increment( 0 - double.parse(debts.toString())),
                              //           })
                              //               .then((value) => debugPrint("User Updated"))
                              //               .catchError((error) => debugPrint("Failed to update user: $error"));}
                              //
                              //           _textFieldController.clear();
                              //           Navigator.of(context).popUntil((route) => route.isFirst);
                              //         }),
                              //   ),
                              // ),
                            ],
                          ),

                        ),
                      ),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1.0))),
                      ),
                    ],
                  ),
                  // Container(
                  //   height: 80,
                  //   decoration: BoxDecoration(
                  //       border: Border(
                  //           bottom: BorderSide(
                  //               color: Colors.grey.withOpacity(0.3),
                  //               width: 1.0))),
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 18.0, right: 15.0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.only(top: 16),
                  //           child: Container(
                  //             width: 37,
                  //             height: 37,
                  //             decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.all(
                  //                   Radius.circular(35.0),
                  //                 ),
                  //                 color: Colors.grey.withOpacity(0.3)),
                  //             child: Padding(
                  //               padding: const EdgeInsets.only(right: 3.0),
                  //               child: IconButton(
                  //                   icon: Icon(
                  //                     Icons.arrow_back_ios_rounded,
                  //                     size: 17,
                  //                     color: Colors.black,
                  //                   ),
                  //                   onPressed: () {
                  //                     Navigator.pop(context);
                  //                   }),
                  //             ),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(top: 16.0),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.start,
                  //               crossAxisAlignment: CrossAxisAlignment.end,
                  //               children: [
                  //                 Row(
                  //                   mainAxisAlignment: MainAxisAlignment.end,
                  //                   crossAxisAlignment: CrossAxisAlignment.end,
                  //                   children: [
                  //                     Text(
                  //                       'Information',
                  //                       textAlign: TextAlign.right,
                  //                       style: TextStyle(
                  //                         fontSize: 13,
                  //                         fontWeight: FontWeight.w500,color: Colors.grey,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 Text(
                  //                   'Account settings',
                  //                   textAlign: TextAlign.right,
                  //                   style: TextStyle(
                  //                     fontSize: 20,
                  //                     fontWeight: FontWeight.w500,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                                Expanded(
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                                        child: Text('INFORMATION',  textScaleFactor: 1, style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14, color: Colors.grey,
                                        ),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                                        child: TextFormField(
                                          keyboardType: TextInputType.name,
                                          controller: _accountName,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return ' This field is required ';
                                            }
                                            return null;
                                          },
                                          style: TextStyle(
                                            height: 0.95,
                                            fontSize: 15 / scaleFactor,
                                          ),
                                          decoration: InputDecoration(
                                            enabledBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                borderSide: const BorderSide(
                                                    color: AppTheme.skBorderColor,
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),

                                            focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                borderSide: const BorderSide(
                                                    color: AppTheme.themeColor,
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            contentPadding: const EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                top: 20.0,
                                                bottom: 20.0),
                                            //suffixText: 'Required',
                                            suffixStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12 / scaleFactor,
                                              fontFamily: 'capsulesans',
                                            ),
                                            // errorText: wrongPassword,
                                            errorStyle: TextStyle(
                                                backgroundColor: Colors.white,
                                                fontSize: 12 / scaleFactor,
                                                fontFamily: 'capsulesans',
                                                height: 0.1
                                            ),
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
// errorText: 'Error message',
                                            labelText: textSetAccountName,
                                            floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
//filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                        // child: Text('Choose the text box to customize your account name, and can save it.'),
                                        child: RichText(
                                          strutStyle: StrutStyle(
                                            height: 1,
                                            // fontSize:,
                                            forceStrutHeight: true,
                                          ),
                                          text: new TextSpan(
                                            children: [
                                              new TextSpan(
                                                text: textSetInfo,
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
                                      ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 20.0),
//                                   child: TextFormField(
//                                     //obscureText: _obscureText,
//                                     controller: _email,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return ' This field is required ';
//                                       }
//                                       return null;
//                                     },
//                                     style: TextStyle(
//                                       height: 0.95,
//                                     ),
//                                     decoration: InputDecoration(
//                                       enabledBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                           borderSide: const BorderSide(
//                                               color: AppTheme.skBorderColor,
//                                               width: 2.0),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10.0))),
//
//                                       focusedBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                           borderSide: const BorderSide(
//                                               color: AppTheme.themeColor,
//                                               width: 2.0),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10.0))),
//                                       contentPadding: const EdgeInsets.only(
//                                           left: 15.0,
//                                           right: 15.0,
//                                           top: 20.0,
//                                           bottom: 20.0),
//                                       suffixText: 'Required',
//                                       suffixStyle: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 12,
//                                         fontFamily: 'capsulesans',
//                                       ),
//                                       //errorText: wrongPassword,
//                                       errorStyle: TextStyle(
//                                           backgroundColor: Colors.white,
//                                           fontSize: 12,
//                                           fontFamily: 'capsulesans',
//                                           height: 0.1
//                                       ),
//                                       labelStyle: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.black,
//                                       ),
// // errorText: 'Error message',
//                                       labelText: 'Email address',
//                                       floatingLabelBehavior:
//                                       FloatingLabelBehavior.auto,
// //filled: true,
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                   ),
                                      SizedBox(height: 20,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                        child: ButtonTheme(
                                          minWidth: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
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
                                              CollectionReference accountName = await FirebaseFirestore.instance.collection('users');
                                              if (_formKey.currentState!.validate()) {
                                                try {
                                                  final result = await InternetAddress.lookup('google.com');
                                                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                    setState(() {
                                                      loadingState = true;
                                                      disableTouch = true;
                                                    });
                                                    openOverAllSubLoading();
                                                    accountName.doc(widget.id).update({
                                                      'name': _accountName.text,
                                                    }).then((value) {
                                                      Future.delayed(const Duration(milliseconds: 1000), () {
                                                        setState(() {
                                                          loadingState = false;
                                                          disableTouch = false;
                                                        });
                                                        closeOverAllSubLoading();
                                                        Navigator.pop(context);
                                                        smartKyatFMod(context, 'You have successfully changed your account name.', 's');
                                                      });

                                                      });

                                                  }
                                                } on SocketException catch (_) {
                                                  smartKyatFMod(context, 'Internet connection is required to take this action.', 'w');
                                                }
                                              }
                                            },
                                            child: loadingState == true ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                child: CupertinoActivityIndicator(radius: 10,)) : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0,
                                                  right: 5.0,
                                                  bottom: 2.0),
                                              child: Container(
                                                child: Text(
                                                textSetSave,  textScaleFactor: 1,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      height: 1.3,
                                                      fontSize: 17.5,
                                                      fontWeight: FontWeight.w500,
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
                                      SizedBox(height: 20,),
                                      Container(
                                        height: 1,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    width: 1.0))),
                                      ),
                                      SizedBox(height: 15,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                        child: Text('EMAIL ADDRESS',  textScaleFactor: 1, style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14, color: Colors.grey,
                                        ),),
                                      ),
                                      SizedBox(height: 15,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                        child: Container(
                                          height: 50,
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10.0),
                                            color: AppTheme.lightBgColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                            child: Text(
                                              widget.email.toString(),  textScaleFactor: 1, style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.0,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                        // child: Text('Choose the text box to customize your account name, and can save it.'),
                                        child: RichText(
                                          strutStyle: StrutStyle(
                                            height: 1,
                                            // fontSize:,
                                            forceStrutHeight: true,
                                          ),
                                          text: new TextSpan(
                                            children: [
                                              new TextSpan(
                                                text: textSetEmailChange,
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
                                      ),
                                      SizedBox(height: 20.0,),
                                      Container(
                                        height: 1,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    width: 1.0))),
                                      ),
                                      SizedBox(height: 15),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                        child: Text('PASSWORD',  textScaleFactor: 1, style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14, color: Colors.grey,
                                        ),),
                                      ),
                                      GestureDetector(
                                        onTap : () async {
                                          try {
                                            final result = await InternetAddress.lookup('google.com');
                                            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => ChangePassword()),
                                              );
                                            }
                                          } on SocketException catch (_) {
                                            smartKyatFMod(context, 'Internet connection is required to take this action.', 'w');
                                          }

                                        },
                                        child: eachTile(textSetAuth, textSetChangePw ),
                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ),
                  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
                  ),

                ]
            ),
          ),
        ),
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

  Widget eachTile(String leftTxt, String rightTxt) {
    return Container(
      color: Colors.white,
      height: 72,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0, left: 15, right: 15),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 3),
              child: Text(leftTxt,  textScaleFactor: 1,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500,),
                  strutStyle: StrutStyle(
                    height: 2,
                    forceStrutHeight: true,
                  )
              ),
            ),
            // Spacer(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Container(
                  // color: Colors.yellow,
                  // width: MediaQuery.of(context).size.width/6,
                    child: Text(
                        rightTxt,  textScaleFactor: 1,
                        textAlign: TextAlign.right,overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.grey,),
                        strutStyle: StrutStyle(
                          height: 2,
                          forceStrutHeight: true,
                        )
                    )
                ),
              ),
            ),
            SizedBox(width: 8,),
            Icon(
              Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
