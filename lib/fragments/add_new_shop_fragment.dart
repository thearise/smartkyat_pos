import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';

import '../app_theme.dart';

class AddNewShop extends StatefulWidget {
  const AddNewShop({Key? key}) : super(key: key);

  @override
  _AddNewShopState createState() => _AddNewShopState();
}

class _AddNewShopState extends State<AddNewShop> {

  static List<String> shopFieldsValue = [];
  final _formKey = GlobalKey<FormState>();
  final _shopName = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool loadingState = false;

  bool _connectionStatus = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            setState(() {
              _connectionStatus = true;
            });
          }
        } on SocketException catch (_) {
          setState(() {
            _connectionStatus = false;
          });
        }
        break;
      default:
        setState(() {
          // _connectionStatus = 'Failed to get connectivity.')
          _connectionStatus = false;
        });
        break;
    }
  }

  @override
  initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 25.0),
                    child: Container(
                      child: Image.asset('assets/system/smartkyat.png', height: 68, width: 68,),
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.topLeft,
                  child: Text('SHOP REGISTRATION', style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15, letterSpacing: 2,
                    color: Colors.grey,),),
                ),
                Stack(
                  children: [
                    //SizedBox(height: 18,),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
//The validator receives the text that the user has entered.
                        controller: _shopName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          shopFieldsValue.add(value);
                          return null;
                        },
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
                          // suffixText: 'Required',
                          suffixStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: 'capsulesans',
                          ),
                          //errorText: wrongPassword,
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
                          labelText: 'Shop name',
                          floatingLabelBehavior:
                          FloatingLabelBehavior.auto,
//filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    //SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.only(top: 89.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
//The validator receives the text that the user has entered.
                        controller: _address,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          shopFieldsValue.add(value);
                          //prodFieldsValue.add(value);
                          return null;
                        },
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
                          // suffixText: 'Required',
                          suffixStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: 'capsulesans',
                          ),
                          //errorText: wrongPassword,
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
                          labelText: 'Shop address',
                          floatingLabelBehavior:
                          FloatingLabelBehavior.auto,
//filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    //SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.only(top: 160.0, bottom: 30.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
//The validator receives the text that the user has entered.
                        controller: _phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          shopFieldsValue.add(value);
                          //prodFieldsValue.add(value);
                          return null;
                        },
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
                          // suffixText: 'Required',
                          suffixStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: 'capsulesans',
                          ),
                          //errorText: wrongPassword,
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
                          labelText: 'Phone number',
                          floatingLabelBehavior:
                          FloatingLabelBehavior.auto,
//filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(height: 30,),
                  ],
                ),
                _connectionStatus ? ButtonTheme(
                  minWidth: (MediaQuery.of(context).size.width),
                  splashColor: Colors.transparent,
                  height: 53,
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

                      shopFieldsValue = [];

                      final User? user = auth.currentUser;
                      final uid = user!.uid;
                      final email = user.email;
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loadingState = true;
                        });
                        CollectionReference shops = await FirebaseFirestore.instance.collection('shops');

                        shops.add(
                            {
                              'owner_id' : uid.toString(),
                              'shop_name': shopFieldsValue[0],
                              'shop_address' : shopFieldsValue[1],
                              'shop_phone': shopFieldsValue[2],
                              'users': FieldValue.arrayUnion([email.toString()]),
                              'orders_length': 1000,
                              'buyOrders_length': 1000,
                            }
                        ).then((value) async {
                          shops.doc(value.id).collection('users').add({
                            'email': email.toString(),
                            'role' : 'owner',
                          }).catchError((error) => print("Failed to update user: $error"));
                          setStoreId(value.id.toString());
                          CollectionReference cusName = await FirebaseFirestore.instance.collection('shops').doc(value.id).collection('customers');
                          cusName.doc('name').set({
                            'customer_name': 'Unknown',
                            'customer_address': '-',
                            'customer_phone': '-',
                            'total_orders' : 0,
                            'debts' : 0,
                            'debtAmount' : 0,
                            'total_refunds' : 0,
                          }).then((value) {})
                              .catchError((error) => print("Failed to update user: $error"));

                          CollectionReference merchName = await FirebaseFirestore.instance.collection('shops').doc(value.id).collection('merchants');
                          merchName.doc('name').set({
                            'merchant_name': 'Unknown',
                            'merchant_address': '-',
                            'merchant_phone': '-',
                            'total_orders' : 0,
                            'debts' : 0,
                            'debtAmount' : 0,
                            'total_refunds' : 0,
                          }).then((value) {})
                              .catchError((error) => print("Failed to update user: $error"));

                          var resultPop = await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                          //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                          print('shop added');
                        });
                      }
                    },
                    child: loadingState? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                        child: CupertinoActivityIndicator(radius: 10,)) : Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0,
                          right: 5.0,
                          bottom: 2.0),
                      child: Container(
                        child: Text(
                          'Create shop',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ) :
                ButtonTheme(
                  minWidth: (MediaQuery.of(context).size.width),
                  splashColor: Colors.transparent,
                  height: 53,
                  child: FlatButton(
                    color: AppTheme.themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: AppTheme.themeColor,
                      ),
                    ),
                    onPressed: ()  {
                      smartKyatFlash('Internet connection is required to take this action.', 'w');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0,
                          right: 5.0,
                          bottom: 2.0),
                      child: Container(
                        child: Text(
                          'Create shop',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30,),
                Text('Set up some information about your shop later in shop settings.'),
                Spacer(),
                // Row(
                //   children: [
                //     Text('By singing up, you agree to our ',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.grey,
                //       ),),
                //     Text('Terms',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.blue,
                //       ),),
                //     Text(', ',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.grey,
                //       ),),
                //     Text('Privacy Policy',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.blue,
                //       ),),
                //     Text(', ',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.grey,
                //       ),),
                //   ],
                // ),
                // Row(
                //   children: [
                //     Text('and ',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.grey,
                //       ),),
                //     Text('Cookie Use',
                //       style: TextStyle(
                //         fontSize: 12.5,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.blue,
                //       ),),
                //   ],
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 20,bottom: 40.0),
                //   child: ButtonTheme(
                //     minWidth: MediaQuery.of(context).size.width,
                //     splashColor: Colors.transparent,
                //     height: 53,
                //     child: FlatButton(
                //   color: AppTheme.themeColor,
                //   shape: RoundedRectangleBorder(
                //     borderRadius:
                //     BorderRadius.circular(10.0),
                //     side: BorderSide(
                //       color: AppTheme.themeColor,
                //     ),
                //   ),
                //   onPressed: () {
                //
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //         left: 5.0,
                //         right: 5.0,
                //         bottom: 2.0),
                //     child: Container(
                //       child: Text(
                //        'Enter',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
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
}
