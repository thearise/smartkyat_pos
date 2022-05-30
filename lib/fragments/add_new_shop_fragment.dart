import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';

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

  String deviceId = '';


  @override
  initState() {
    _getId().then((val) {
      deviceId = val!;
    });
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

  bool firstTime = true;
  double homeBotPadding = 0;
  @override
  Widget build(BuildContext context) {

    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
      firstTime = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width > 900? MediaQuery.of(context).size.width/4:0.0),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
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
                              keyboardType: TextInputType.text,
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
                            padding: const EdgeInsets.only(top: 160.0, ),
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
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: ButtonTheme(
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
                                try {
                                  final result = await InternetAddress.lookup('google.com');
                                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                    shopFieldsValue = [];
                                    final User? user = auth.currentUser;
                                    final uid = user!.uid;
                                    final email = user.email;
                                    if (_formKey.currentState!.validate()) {
                                      WriteBatch batch = FirebaseFirestore.instance.batch();
                                      setState(() {
                                        loadingState = true;
                                      });
                                      CollectionReference shops = await FirebaseFirestore.instance.collection('shops');
                                      shops.add(
                                          {
                                            'owner_id' : uid.toString(),
                                            'shop_name': shopFieldsValue[0],
                                            'shop_address' : shopFieldsValue[1],
                                            'plan_type' : 'basic',
                                            'shop_phone': shopFieldsValue[2],
                                            'users': FieldValue.arrayUnion([email.toString()]),
                                            'orders_length': 1000,
                                            'buyOrders_length': 1000,
                                            'is_pro' :  {'start': DateTime.now(), 'end': DateTime.now().add(const Duration(days: 10))},
                                            'devices': [await _getId()],

                                          }
                                      ).then((value) async {
                                        shops.doc(value.id).collection('users').doc(email).set({
                                          'email': email.toString(),
                                          'role' : 'owner',
                                          'device0': await _getId()
                                        }).catchError((error) => debugPrint("Failed to update user: $error"));

                                        shops.doc(value.id).collection('users_ver').doc(uid).set({
                                          'email': email.toString(),
                                          'role' : 'owner',
                                          'device0': await _getId()
                                        }).catchError((error) => debugPrint("Failed to update user: $error"));
                                       // setStoreId(value.id.toString());

                                        addMapData(batch, value.id, 'imgArr', 'prodsArr', 'prods');

                                        addMapData(batch, value.id, 'collArr', 'prodsArr', 'prods');

                                        addMapData(batch, value.id, 'collArr', 'cusArr', 'cus');

                                        addMapData(batch, value.id, 'collArr', 'merArr', 'mer');

                                        addCountData(batch, value.id, 'prodsCnt', 0);

                                        addCountData(batch, value.id, 'cusCnt', 0);

                                        addCountData(batch, value.id, 'merCnt', 0);

                                        addCountData(batch, value.id, 'ordsCnt', 1000);

                                        addCountData(batch, value.id, 'buyOrdsCnt', 1000);

                                        addNoCus(batch, value.id);

                                        addNoMer(batch, value.id);

                                        try {
                                          FocusScope.of(context).unfocus();
                                          await batch.commit();
                                          setStoreId(value.id.toString());
                                          Future.delayed(const Duration(milliseconds: 1000), () async {
                                            var resultPop = await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage(deviceId: deviceId,)));
                                          });

                                          //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                                          debugPrint('shop added');
                                        } catch (error) {
                                          debugPrint('shop adding error');
                                          setState(() {
                                            loadingState = false;
                                          });
                                        }

                                        // CollectionReference imageArr = await FirebaseFirestore.instance.collection('shops').doc(value.id).collection('imgArr');
                                        // imageArr.doc('prodsArr').set({
                                        //   'prods' : {}
                                        // }).then((value) {})
                                        //     .catchError((error) => debugPrint("Failed to update user: $error"));
                                        //
                                        // CollectionReference collectionArr = await FirebaseFirestore.instance.collection('shops').doc(value.id).collection('collArr');
                                        // collectionArr.doc('cusArr').set({
                                        //   'cus' : {}
                                        // }).then((value) {})
                                        //     .catchError((error) => debugPrint("Failed to update user: $error"));
                                        //
                                        // collectionArr.doc('merArr').set({
                                        //   'mer' : {}
                                        // }).then((value) {})
                                        //     .catchError((error) => debugPrint("Failed to update user: $error"));
                                        //
                                        // collectionArr.doc('prodsArr').set({
                                        //   'prods' : {}
                                        // }).then((value) {})
                                        //     .catchError((error) => debugPrint("Failed to update user: $error"));
                                        //
                                        // CollectionReference countColl = await FirebaseFirestore.instance.collection('shops').doc(value.id).collection('countColl');
                                        // countColl.doc('prodsCnt').set({
                                        //   'count' : 0
                                        // }).then((value) {})
                                        //     .catchError((error) => debugPrint("Failed to update user: $error"));
                                        //
                                        // countColl.doc('cusCnt').set({
                                        //   'count' : 0
                                        // }).then((value) {})
                                        //     .catchError((error) => debugPrint("Failed to update user: $error"));
                                        //
                                        // countColl.doc('merCnt').set({
                                        //   'count' : 0
                                        // }).then((value) {})
                                        //     .catchError((error) => debugPrint("Failed to update user: $error"));
                                        //
                                        // countColl.doc('ordsCnt').set({
                                        //   'count' : 1000
                                        // }).then((value) {})
                                        //     .catchError((error) => debugPrint("Failed to update user: $error"));
                                        //
                                        // countColl.doc('buyOrdsCnt').set({
                                        //   'count' : 1000
                                        // }).then((value) {})
                                        //     .catchError((error) => debugPrint("Failed to update user: $error"));
                                        //
                                        // CollectionReference cusName = await FirebaseFirestore.instance.collection('shops').doc(value.id).collection('customers');
                                        // cusName.doc('name').set({
                                        //   'customer_name': 'No customer',
                                        //   'customer_address': 'unknown',
                                        //   'customer_phone': '',
                                        //   'total_orders' : 0,
                                        //   'debts' : 0,
                                        //   'debtAmount' : 0,
                                        //   'total_refunds' : 0,
                                        // }).then((value) {})
                                        //     .catchError((error) => debugPrint("Failed to update user: $error"));
                                        //
                                        // CollectionReference merchName = await FirebaseFirestore.instance.collection('shops').doc(value.id).collection('merchants');
                                        // merchName.doc('name').set({
                                        //   'merchant_name': 'No merchant',
                                        //   'merchant_address': 'unknown',
                                        //   'merchant_phone': '',
                                        //   'total_orders' : 0,
                                        //   'debts' : 0,
                                        //   'debtAmount' : 0,
                                        //   'total_refunds' : 0,
                                        // }).then((value) {})
                                        //     .catchError((error) => debugPrint("Failed to update user: $error"));


                                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                                       // debugPrint('shop added');
                                      });
                                    }
                                  }
                                } on SocketException catch (_) {
                                  setState(() {
                                    smartKyatFlash('Internet connection is required to take this action.', 'w');
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
                          ),
                        ),
                      ),
                          SizedBox(height: 20,),
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
                          SizedBox(height: 15,),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  addMapData(WriteBatch batch, newShopId ,collName, docId, mapName) {
    DocumentReference arStream =  FirebaseFirestore.instance.collection('shops').doc(newShopId).collection(collName).doc(docId);
    batch.set(arStream, { mapName.toString() : {}
    });
    return batch;
  }

  addCountData(WriteBatch batch, newShopId , docId, val) {
    DocumentReference arStream =  FirebaseFirestore.instance.collection('shops').doc(newShopId).collection('countColl').doc(docId);
    batch.set(arStream, { 'count' : val
    });
    return batch;
  }

  addNoCus(WriteBatch batch, newShopId) {
    DocumentReference arStream =  FirebaseFirestore.instance.collection('shops').doc(newShopId).collection('customers').doc('name');
    batch.set(arStream, {
      'customer_name': 'No customer',
      'customer_address': 'unknown',
      'customer_phone': '',
      'total_orders' : 0,
      'debts' : 0,
      'debtAmount' : 0,
      'total_refunds' : 0,
    });
    return batch;
  }

  addNoMer(WriteBatch batch, newShopId) {
    DocumentReference arStream =  FirebaseFirestore.instance.collection('shops').doc(newShopId).collection('merchants').doc('name');
    batch.set(arStream, {
      'merchant_name': 'No merchant',
      'merchant_address': 'unknown',
      'merchant_phone': '',
      'total_orders' : 0,
      'debts' : 0,
      'debtAmount' : 0,
      'total_refunds' : 0,
    });
    return batch;
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
