import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';
// import 'package:pinput/pin_put/pin_put_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/constants/screens.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';
import 'package:smartkyat_pos/widgets/custom_flat_button.dart';

import '../app_theme.dart';

class AddShop extends StatefulWidget {
  const AddShop({
    Key? key,
    required this.isEnglish,
  }) : super(key: key);

  final bool isEnglish;

  @override
  _AddShopState createState() => _AddShopState();
}



class _AddShopState extends State<AddShop> {



  static List<String> shopFieldsValue = [];
  final _formKey = GlobalKey<FormState>();
  final _shopName = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final _timezone = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool loadingState = false;
  bool disableTouch = false;

  String deviceId = '';

  @override
  initState() {
    DateTime time = DateTime.now();
    debugPrint('offseting ' + (time).toString());
    timezoneLists = [
      for(int i=0; i<allUTCs.length; i++)
        Text(allUTCs[i]['text'],  textScaleFactor: 1, style: TextStyle(fontSize: 16, height: 1.7),),
    ];
    for(int i=0; i<allUTCs.length; i++) {
      if(allUTCs[i]["offset"] == (time.timeZoneOffset.inMinutes/60)) {
        _timezone.text = allUTCs[i]["text"];
        offsetStore = allUTCs[i]["offset"].toDouble();
        _selectedItemIndex = i;
        break;
      }
    }

    _getId().then((val) {
      deviceId = val!;
    });
    super.initState();
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
        );
      },
    );
  }

  bool firstTime = true;
  double homeBotPadding = 0;
  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
      firstTime = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: IgnorePointer(
        ignoring: disableTouch,
        child: SafeArea(
          bottom: true,
          top: true,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        height: 81,
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
                                      Text(
                                        widget.isEnglish? 'Information': 'အချက်အလက်',  textScaleFactor: 1,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5
                                        ),
                                        strutStyle: StrutStyle(
                                          height: 1.4,
                                          // fontSize:,
                                          forceStrutHeight: true,
                                        ),
                                      ),
                                      Text(
                                        widget.isEnglish? 'Add new shop': 'ဆိုင်အသစ်ထည့်ရန်', textScaleFactor: 1,
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
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('SHOP INFORMATION', textScaleFactor: 1, style: TextStyle(
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,color: Colors.grey,
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Stack(
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
                                style: TextStyle(
                                  height: 0.95,
                                  fontSize: 15/scaleFactor,
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
                                  // suffixText: 'Required',
                                  suffixStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12/scaleFactor,
                                    fontFamily: 'capsulesans',
                                  ),
                                  //errorText: wrongPassword,
                                  errorStyle: TextStyle(
                                      backgroundColor: Colors.white,
                                      fontSize: 12/scaleFactor,
                                      fontFamily: 'capsulesans',
                                      height: 0.1
                                  ),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
// errorText: 'Error message',
                                  labelText: widget.isEnglish? 'Shop name': 'ဆိုင်အမည်',
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
                                style: TextStyle(
                                  height: 0.95, fontSize: 15/scaleFactor,
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
                                  // suffixText: 'Required',
                                  suffixStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12/scaleFactor,
                                    fontFamily: 'capsulesans',
                                  ),
                                  //errorText: wrongPassword,
                                  errorStyle: TextStyle(
                                      backgroundColor: Colors.white,
                                      fontSize: 12/scaleFactor,
                                      fontFamily: 'capsulesans',
                                      height: 0.1
                                  ),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
// errorText: 'Error message',
                                  labelText: widget.isEnglish? 'Shop address': 'ဆိုင်လိပ်စာ',
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
                              padding: const EdgeInsets.only(top: 160.0),
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
                                style: TextStyle(
                                  height: 0.95, fontSize: 15/scaleFactor,
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
                                  // suffixText: 'Required',
                                  suffixStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12/scaleFactor,
                                    fontFamily: 'capsulesans',
                                  ),
                                  //errorText: wrongPassword,
                                  errorStyle: TextStyle(
                                      backgroundColor: Colors.white,
                                      fontSize: 12/scaleFactor,
                                      fontFamily: 'capsulesans',
                                      height: 0.1
                                  ),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
// errorText: 'Error message',
                                  labelText: widget.isEnglish? 'Phone number': 'ဖုန်းနံပါတ်',
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
                            Padding(
                              padding: const EdgeInsets.only(top: 231.0),
                              child: Focus(
                                // onFocusChange: (focus) {
                                //   if(focus) {
                                //     _openTimeZonePicker(OneContext().context, context);
                                //     // FocusScope.of(context).unfocus();
                                //     // _timezone.clear();
                                //   }
                                // },
                                child: TextFormField(
                                  onTap: () {
                                    _openTimeZonePicker(OneContext().context, context);
                                  },
                                  readOnly: true,
                                  // keyboardType: TextInputType.number,
//The validator receives the text that the user has entered.
                                  controller: _timezone,
                                  // initialValue: 'Myanmar (UTC +6:30)',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    shopFieldsValue.add(value);
                                    //prodFieldsValue.add(value);
                                    return null;
                                  },
                                  style: TextStyle(
                                    height: 0.95, fontSize: 15/scaleFactor,
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
                                    // suffixText: 'Required',
                                    suffixStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12/scaleFactor,
                                      fontFamily: 'capsulesans',
                                    ),
                                    //errorText: wrongPassword,
                                    errorStyle: TextStyle(
                                        backgroundColor: Colors.white,
                                        fontSize: 12/scaleFactor,
                                        fontFamily: 'capsulesans',
                                        height: 0.1
                                    ),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
// errorText: 'Error message',
                                    labelText: widget.isEnglish? 'Time zone': 'အချိန်ဇုန်/ဒေသ',
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
//filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 14, top: 276.0),
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 1.0, right: 5.0),
                                  child: Text(
                                    widget.isEnglish? 'Time zone information can\'t be changed later.': 'အချိန်ဇုန်/ဒေသ သည်နောက်မှ ပြောင်းလဲမရနိုင်ပါ။',
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blue,
                                        fontSize: 11.4,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing:-0.1
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                          child: ButtonTheme(
                            minWidth: (MediaQuery.of(context).size.width),
                            splashColor: Colors.transparent,
                            height: 53,
                            child: CustomFlatButton(
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
                                    CollectionReference shops = await FirebaseFirestore.instance.collection('shops');
                                    final User? user = auth.currentUser;
                                    final uid = user!.uid;
                                    final email = user.email;

                                    FocusScope.of(context).unfocus();

                                    if (_formKey.currentState!.validate()) {
                                      openOverAllSubLoading();
                                        setState(() {
                                          loadingState = true;
                                          disableTouch = true;
                                        });

                                        WriteBatch batch = FirebaseFirestore.instance.batch();

                                        await FirebaseFirestore.instance.collection('users')
                                            .where('user_id' ,isEqualTo: user.uid)
                                            .limit(1)
                                            .get()
                                            .then((QuerySnapshot querySnapshot) async {
                                          Map<String, dynamic> userData = querySnapshot.docs[0].data()! as Map<String, dynamic>;
                                          await FirebaseFirestore.instance.collection('shops')
                                              .where('owner_id' ,isEqualTo: user.uid)
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
                                                disableTouch = false;
                                              });
                                              closeOverAllSubLoading();
                                            } else if(userData['plan_type'] == 'medium' && shopCount >= 10) {
                                              showOkAlertDialog(
                                                  context: context,
                                                  title: 'Maximum shops reached',
                                                  message: 'Maximum number of shops has been created. Please contact to our customer service to upgrade your account.'
                                              ).then((result) async {
                                              });
                                              setState(() {
                                                loadingState = false;
                                                disableTouch = false;
                                              });
                                              closeOverAllSubLoading();
                                            }
                                            else {
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
                                                    'timezone': offsetStore
                                                  }
                                              ).then((value) async {
                                                shops.doc(value.id).collection('users').doc(email).set({
                                                  'email': email.toString(),
                                                  'role' : 'owner',
                                                  'device0': await _getId()
                                                }).then((value) {

                                                })
                                                    .catchError((error) => debugPrint("Failed to update user: $error"));

                                                shops.doc(value.id).collection('users_ver').doc(uid).set({
                                                  'email': email.toString(),
                                                  'role' : 'owner',
                                                  'device0': await _getId()
                                                }).then((value) {})
                                                    .catchError((error) => debugPrint("Failed to update user: $error"));


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
                                                  await setDeviceId('0');
                                                  setStoreId(value.id.toString());
                                                  debugPrint('shop added');
                                                  Future.delayed(const Duration(milliseconds: 1000), () async {
                                                    setState(() {
                                                      loadingState = false;
                                                      disableTouch = false;
                                                    });
                                                    closeOverAllSubLoading();
                                                    var resultPop = await Navigator.of(context).pushReplacement(FadeRoute(page: HomePage(deviceId: deviceId,)));
                                                  });



                                                  //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));

                                                } catch (error) {
                                                  debugPrint('shop adding error');
                                                  await FirebaseFirestore.instance.collection('shops').doc(value.id).delete();
                                                  smartKyatFlash('Something went wrong while creating the shop', 'e');
                                                  setState(() {
                                                    loadingState = false;
                                                    disableTouch = false;
                                                  });
                                                  closeOverAllSubLoading();
                                                }
                                              });
                                            }
                                          });
                                        });







                                      }


                                  }
                                } on SocketException catch (_) {
                                  setState(() {
                                    smartKyatFlash(widget.isEnglish? 'Internet connection is required to take this action.': 'ဒီလုပ်ဆောင်ချက်ကို လုပ်ဆောင်ရန် အင်တာနက်လိုပါသည်။', 'w');
                                  });
                                }

                              },
                              child:  loadingState? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                  child: CupertinoActivityIndicator(radius: 10,)) : Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    bottom: 2.0),
                                child: Container(
                                  child: Text(
                                    widget.isEnglish? 'Create shop': 'ဆိုင်ထည့်ပါ', textScaleFactor: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing:-0.1
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
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
                                text: widget.isEnglish? 'Set up some information about your shop later in shop settings.': 'ဆိုင်နှင့်ပတ်သက်ပြီး အချက်အလက်အချို့ကို နောက်ပြီးပြန်လည် ပြင်ဆိုင်နိုင်ပါသည်။',
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
    );
  }

  List allUTCs = [
    {
      "value": "Dateline Standard Time",
      "abbr": "DST",
      "offset": -12,
      "isdst": false,
      "text": "(UTC-12:00) International Date Line West",
      "utc": [
        "Etc/GMT+12"
      ]
    },
    {
      "value": "UTC-11",
      "abbr": "U",
      "offset": -11,
      "isdst": false,
      "text": "(UTC-11:00) Coordinated Universal Time-11",
      "utc": [
        "Etc/GMT+11",
        "Pacific/Midway",
        "Pacific/Niue",
        "Pacific/Pago_Pago"
      ]
    },
    {
      "value": "Hawaiian Standard Time",
      "abbr": "HST",
      "offset": -10,
      "isdst": false,
      "text": "(UTC-10:00) Hawaii",
      "utc": [
        "Etc/GMT+10",
        "Pacific/Honolulu",
        "Pacific/Johnston",
        "Pacific/Rarotonga",
        "Pacific/Tahiti"
      ]
    },
    {
      "value": "Alaskan Standard Time",
      "abbr": "AKDT",
      "offset": -8,
      "isdst": true,
      "text": "(UTC-09:00) Alaska",
      "utc": [
        "America/Anchorage",
        "America/Juneau",
        "America/Nome",
        "America/Sitka",
        "America/Yakutat"
      ]
    },
    {
      "value": "Pacific Standard Time (Mexico)",
      "abbr": "PDT",
      "offset": -7,
      "isdst": true,
      "text": "(UTC-08:00) Baja California",
      "utc": [
        "America/Santa_Isabel"
      ]
    },
    {
      "value": "Pacific Daylight Time",
      "abbr": "PDT",
      "offset": -7,
      "isdst": true,
      "text": "(UTC-07:00) Pacific Daylight Time (US & Canada)",
      "utc": [
        "America/Los_Angeles",
        "America/Tijuana",
        "America/Vancouver"
      ]
    },
    {
      "value": "Pacific Standard Time",
      "abbr": "PST",
      "offset": -8,
      "isdst": false,
      "text": "(UTC-08:00) Pacific Standard Time (US & Canada)",
      "utc": [
        "America/Los_Angeles",
        "America/Tijuana",
        "America/Vancouver",
        "PST8PDT"
      ]
    },
    {
      "value": "US Mountain Standard Time",
      "abbr": "UMST",
      "offset": -7,
      "isdst": false,
      "text": "(UTC-07:00) Arizona",
      "utc": [
        "America/Creston",
        "America/Dawson",
        "America/Dawson_Creek",
        "America/Hermosillo",
        "America/Phoenix",
        "America/Whitehorse",
        "Etc/GMT+7"
      ]
    },
    {
      "value": "Mountain Standard Time (Mexico)",
      "abbr": "MDT",
      "offset": -6,
      "isdst": true,
      "text": "(UTC-07:00) Chihuahua, La Paz, Mazatlan",
      "utc": [
        "America/Chihuahua",
        "America/Mazatlan"
      ]
    },
    {
      "value": "Mountain Standard Time",
      "abbr": "MDT",
      "offset": -6,
      "isdst": true,
      "text": "(UTC-07:00) Mountain Time (US & Canada)",
      "utc": [
        "America/Boise",
        "America/Cambridge_Bay",
        "America/Denver",
        "America/Edmonton",
        "America/Inuvik",
        "America/Ojinaga",
        "America/Yellowknife",
        "MST7MDT"
      ]
    },
    {
      "value": "Central America Standard Time",
      "abbr": "CAST",
      "offset": -6,
      "isdst": false,
      "text": "(UTC-06:00) Central America",
      "utc": [
        "America/Belize",
        "America/Costa_Rica",
        "America/El_Salvador",
        "America/Guatemala",
        "America/Managua",
        "America/Tegucigalpa",
        "Etc/GMT+6",
        "Pacific/Galapagos"
      ]
    },
    {
      "value": "Central Standard Time",
      "abbr": "CDT",
      "offset": -5,
      "isdst": true,
      "text": "(UTC-06:00) Central Time (US & Canada)",
      "utc": [
        "America/Chicago",
        "America/Indiana/Knox",
        "America/Indiana/Tell_City",
        "America/Matamoros",
        "America/Menominee",
        "America/North_Dakota/Beulah",
        "America/North_Dakota/Center",
        "America/North_Dakota/New_Salem",
        "America/Rainy_River",
        "America/Rankin_Inlet",
        "America/Resolute",
        "America/Winnipeg",
        "CST6CDT"
      ]
    },
    {
      "value": "Central Standard Time (Mexico)",
      "abbr": "CDT",
      "offset": -5,
      "isdst": true,
      "text": "(UTC-06:00) Guadalajara, Mexico City, Monterrey",
      "utc": [
        "America/Bahia_Banderas",
        "America/Cancun",
        "America/Merida",
        "America/Mexico_City",
        "America/Monterrey"
      ]
    },
    {
      "value": "Canada Central Standard Time",
      "abbr": "CCST",
      "offset": -6,
      "isdst": false,
      "text": "(UTC-06:00) Saskatchewan",
      "utc": [
        "America/Regina",
        "America/Swift_Current"
      ]
    },
    {
      "value": "SA Pacific Standard Time",
      "abbr": "SPST",
      "offset": -5,
      "isdst": false,
      "text": "(UTC-05:00) Bogota, Lima, Quito",
      "utc": [
        "America/Bogota",
        "America/Cayman",
        "America/Coral_Harbour",
        "America/Eirunepe",
        "America/Guayaquil",
        "America/Jamaica",
        "America/Lima",
        "America/Panama",
        "America/Rio_Branco",
        "Etc/GMT+5"
      ]
    },
    {
      "value": "Eastern Standard Time",
      "abbr": "EST",
      "offset": -5,
      "isdst": false,
      "text": "(UTC-05:00) Eastern Time (US & Canada)",
      "utc": [
        "America/Detroit",
        "America/Havana",
        "America/Indiana/Petersburg",
        "America/Indiana/Vincennes",
        "America/Indiana/Winamac",
        "America/Iqaluit",
        "America/Kentucky/Monticello",
        "America/Louisville",
        "America/Montreal",
        "America/Nassau",
        "America/New_York",
        "America/Nipigon",
        "America/Pangnirtung",
        "America/Port-au-Prince",
        "America/Thunder_Bay",
        "America/Toronto"
      ]
    },
    {
      "value": "Eastern Daylight Time",
      "abbr": "EDT",
      "offset": -4,
      "isdst": true,
      "text": "(UTC-04:00) Eastern Daylight Time (US & Canada)",
      "utc": [
        "America/Detroit",
        "America/Havana",
        "America/Indiana/Petersburg",
        "America/Indiana/Vincennes",
        "America/Indiana/Winamac",
        "America/Iqaluit",
        "America/Kentucky/Monticello",
        "America/Louisville",
        "America/Montreal",
        "America/Nassau",
        "America/New_York",
        "America/Nipigon",
        "America/Pangnirtung",
        "America/Port-au-Prince",
        "America/Thunder_Bay",
        "America/Toronto"
      ]
    },
    {
      "value": "US Eastern Standard Time",
      "abbr": "UEDT",
      "offset": -5,
      "isdst": false,
      "text": "(UTC-05:00) Indiana (East)",
      "utc": [
        "America/Indiana/Marengo",
        "America/Indiana/Vevay",
        "America/Indianapolis"
      ]
    },
    {
      "value": "Venezuela Standard Time",
      "abbr": "VST",
      "offset": -4.5,
      "isdst": false,
      "text": "(UTC-04:30) Caracas",
      "utc": [
        "America/Caracas"
      ]
    },
    {
      "value": "Paraguay Standard Time",
      "abbr": "PYT",
      "offset": -4,
      "isdst": false,
      "text": "(UTC-04:00) Asuncion",
      "utc": [
        "America/Asuncion"
      ]
    },
    {
      "value": "Atlantic Standard Time",
      "abbr": "ADT",
      "offset": -3,
      "isdst": true,
      "text": "(UTC-04:00) Atlantic Time (Canada)",
      "utc": [
        "America/Glace_Bay",
        "America/Goose_Bay",
        "America/Halifax",
        "America/Moncton",
        "America/Thule",
        "Atlantic/Bermuda"
      ]
    },
    {
      "value": "Central Brazilian Standard Time",
      "abbr": "CBST",
      "offset": -4,
      "isdst": false,
      "text": "(UTC-04:00) Cuiaba",
      "utc": [
        "America/Campo_Grande",
        "America/Cuiaba"
      ]
    },
    {
      "value": "SA Western Standard Time",
      "abbr": "SWST",
      "offset": -4,
      "isdst": false,
      "text": "(UTC-04:00) Georgetown, La Paz, Manaus, San Juan",
      "utc": [
        "America/Anguilla",
        "America/Antigua",
        "America/Aruba",
        "America/Barbados",
        "America/Blanc-Sablon",
        "America/Boa_Vista",
        "America/Curacao",
        "America/Dominica",
        "America/Grand_Turk",
        "America/Grenada",
        "America/Guadeloupe",
        "America/Guyana",
        "America/Kralendijk",
        "America/La_Paz",
        "America/Lower_Princes",
        "America/Manaus",
        "America/Marigot",
        "America/Martinique",
        "America/Montserrat",
        "America/Port_of_Spain",
        "America/Porto_Velho",
        "America/Puerto_Rico",
        "America/Santo_Domingo",
        "America/St_Barthelemy",
        "America/St_Kitts",
        "America/St_Lucia",
        "America/St_Thomas",
        "America/St_Vincent",
        "America/Tortola",
        "Etc/GMT+4"
      ]
    },
    {
      "value": "Pacific SA Standard Time",
      "abbr": "PSST",
      "offset": -4,
      "isdst": false,
      "text": "(UTC-04:00) Santiago",
      "utc": [
        "America/Santiago",
        "Antarctica/Palmer"
      ]
    },
    {
      "value": "Newfoundland Standard Time",
      "abbr": "NDT",
      "offset": -2.5,
      "isdst": true,
      "text": "(UTC-03:30) Newfoundland",
      "utc": [
        "America/St_Johns"
      ]
    },
    {
      "value": "E. South America Standard Time",
      "abbr": "ESAST",
      "offset": -3,
      "isdst": false,
      "text": "(UTC-03:00) Brasilia",
      "utc": [
        "America/Sao_Paulo"
      ]
    },
    {
      "value": "Argentina Standard Time",
      "abbr": "AST",
      "offset": -3,
      "isdst": false,
      "text": "(UTC-03:00) Buenos Aires",
      "utc": [
        "America/Argentina/La_Rioja",
        "America/Argentina/Rio_Gallegos",
        "America/Argentina/Salta",
        "America/Argentina/San_Juan",
        "America/Argentina/San_Luis",
        "America/Argentina/Tucuman",
        "America/Argentina/Ushuaia",
        "America/Buenos_Aires",
        "America/Catamarca",
        "America/Cordoba",
        "America/Jujuy",
        "America/Mendoza"
      ]
    },
    {
      "value": "SA Eastern Standard Time",
      "abbr": "SEST",
      "offset": -3,
      "isdst": false,
      "text": "(UTC-03:00) Cayenne, Fortaleza",
      "utc": [
        "America/Araguaina",
        "America/Belem",
        "America/Cayenne",
        "America/Fortaleza",
        "America/Maceio",
        "America/Paramaribo",
        "America/Recife",
        "America/Santarem",
        "Antarctica/Rothera",
        "Atlantic/Stanley",
        "Etc/GMT+3"
      ]
    },
    {
      "value": "Greenland Standard Time",
      "abbr": "GDT",
      "offset": -3,
      "isdst": true,
      "text": "(UTC-03:00) Greenland",
      "utc": [
        "America/Godthab"
      ]
    },
    {
      "value": "Montevideo Standard Time",
      "abbr": "MST",
      "offset": -3,
      "isdst": false,
      "text": "(UTC-03:00) Montevideo",
      "utc": [
        "America/Montevideo"
      ]
    },
    {
      "value": "Bahia Standard Time",
      "abbr": "BST",
      "offset": -3,
      "isdst": false,
      "text": "(UTC-03:00) Salvador",
      "utc": [
        "America/Bahia"
      ]
    },
    {
      "value": "UTC-02",
      "abbr": "U",
      "offset": -2,
      "isdst": false,
      "text": "(UTC-02:00) Coordinated Universal Time-02",
      "utc": [
        "America/Noronha",
        "Atlantic/South_Georgia",
        "Etc/GMT+2"
      ]
    },
    {
      "value": "Mid-Atlantic Standard Time",
      "abbr": "MDT",
      "offset": -1,
      "isdst": true,
      "text": "(UTC-02:00) Mid-Atlantic - Old",
      "utc": []
    },
    {
      "value": "Azores Standard Time",
      "abbr": "ADT",
      "offset": 0,
      "isdst": true,
      "text": "(UTC-01:00) Azores",
      "utc": [
        "America/Scoresbysund",
        "Atlantic/Azores"
      ]
    },
    {
      "value": "Cape Verde Standard Time",
      "abbr": "CVST",
      "offset": -1,
      "isdst": false,
      "text": "(UTC-01:00) Cape Verde Is.",
      "utc": [
        "Atlantic/Cape_Verde",
        "Etc/GMT+1"
      ]
    },
    {
      "value": "Morocco Standard Time",
      "abbr": "MDT",
      "offset": 1,
      "isdst": true,
      "text": "(UTC) Casablanca",
      "utc": [
        "Africa/Casablanca",
        "Africa/El_Aaiun"
      ]
    },
    {
      "value": "UTC",
      "abbr": "UTC",
      "offset": 0,
      "isdst": false,
      "text": "(UTC) Coordinated Universal Time",
      "utc": [
        "America/Danmarkshavn",
        "Etc/GMT"
      ]
    },
    {
      "value": "GMT Standard Time",
      "abbr": "GMT",
      "offset": 0,
      "isdst": false,
      "text": "(UTC) Edinburgh, London",
      "utc": [
        "Europe/Isle_of_Man",
        "Europe/Guernsey",
        "Europe/Jersey",
        "Europe/London"
      ]
    },
    {
      "value": "British Summer Time",
      "abbr": "BST",
      "offset": 1,
      "isdst": true,
      "text": "(UTC+01:00) Edinburgh, London",
      "utc": [
        "Europe/Isle_of_Man",
        "Europe/Guernsey",
        "Europe/Jersey",
        "Europe/London"
      ]
    },
    {
      "value": "GMT Standard Time",
      "abbr": "GDT",
      "offset": 1,
      "isdst": true,
      "text": "(UTC) Dublin, Lisbon",
      "utc": [
        "Atlantic/Canary",
        "Atlantic/Faeroe",
        "Atlantic/Madeira",
        "Europe/Dublin",
        "Europe/Lisbon"
      ]
    },
    {
      "value": "Greenwich Standard Time",
      "abbr": "GST",
      "offset": 0,
      "isdst": false,
      "text": "(UTC) Monrovia, Reykjavik",
      "utc": [
        "Africa/Abidjan",
        "Africa/Accra",
        "Africa/Bamako",
        "Africa/Banjul",
        "Africa/Bissau",
        "Africa/Conakry",
        "Africa/Dakar",
        "Africa/Freetown",
        "Africa/Lome",
        "Africa/Monrovia",
        "Africa/Nouakchott",
        "Africa/Ouagadougou",
        "Africa/Sao_Tome",
        "Atlantic/Reykjavik",
        "Atlantic/St_Helena"
      ]
    },
    {
      "value": "W. Europe Standard Time",
      "abbr": "WEDT",
      "offset": 2,
      "isdst": true,
      "text": "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna",
      "utc": [
        "Arctic/Longyearbyen",
        "Europe/Amsterdam",
        "Europe/Andorra",
        "Europe/Berlin",
        "Europe/Busingen",
        "Europe/Gibraltar",
        "Europe/Luxembourg",
        "Europe/Malta",
        "Europe/Monaco",
        "Europe/Oslo",
        "Europe/Rome",
        "Europe/San_Marino",
        "Europe/Stockholm",
        "Europe/Vaduz",
        "Europe/Vatican",
        "Europe/Vienna",
        "Europe/Zurich"
      ]
    },
    {
      "value": "Central Europe Standard Time",
      "abbr": "CEDT",
      "offset": 2,
      "isdst": true,
      "text": "(UTC+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague",
      "utc": [
        "Europe/Belgrade",
        "Europe/Bratislava",
        "Europe/Budapest",
        "Europe/Ljubljana",
        "Europe/Podgorica",
        "Europe/Prague",
        "Europe/Tirane"
      ]
    },
    {
      "value": "Romance Standard Time",
      "abbr": "RDT",
      "offset": 2,
      "isdst": true,
      "text": "(UTC+01:00) Brussels, Copenhagen, Madrid, Paris",
      "utc": [
        "Africa/Ceuta",
        "Europe/Brussels",
        "Europe/Copenhagen",
        "Europe/Madrid",
        "Europe/Paris"
      ]
    },
    {
      "value": "Central European Standard Time",
      "abbr": "CEDT",
      "offset": 2,
      "isdst": true,
      "text": "(UTC+01:00) Sarajevo, Skopje, Warsaw, Zagreb",
      "utc": [
        "Europe/Sarajevo",
        "Europe/Skopje",
        "Europe/Warsaw",
        "Europe/Zagreb"
      ]
    },
    {
      "value": "W. Central Africa Standard Time",
      "abbr": "WCAST",
      "offset": 1,
      "isdst": false,
      "text": "(UTC+01:00) West Central Africa",
      "utc": [
        "Africa/Algiers",
        "Africa/Bangui",
        "Africa/Brazzaville",
        "Africa/Douala",
        "Africa/Kinshasa",
        "Africa/Lagos",
        "Africa/Libreville",
        "Africa/Luanda",
        "Africa/Malabo",
        "Africa/Ndjamena",
        "Africa/Niamey",
        "Africa/Porto-Novo",
        "Africa/Tunis",
        "Etc/GMT-1"
      ]
    },
    {
      "value": "Namibia Standard Time",
      "abbr": "NST",
      "offset": 1,
      "isdst": false,
      "text": "(UTC+01:00) Windhoek",
      "utc": [
        "Africa/Windhoek"
      ]
    },
    {
      "value": "GTB Standard Time",
      "abbr": "GDT",
      "offset": 3,
      "isdst": true,
      "text": "(UTC+02:00) Athens, Bucharest",
      "utc": [
        "Asia/Nicosia",
        "Europe/Athens",
        "Europe/Bucharest",
        "Europe/Chisinau"
      ]
    },
    {
      "value": "Middle East Standard Time",
      "abbr": "MEDT",
      "offset": 3,
      "isdst": true,
      "text": "(UTC+02:00) Beirut",
      "utc": [
        "Asia/Beirut"
      ]
    },
    {
      "value": "Egypt Standard Time",
      "abbr": "EST",
      "offset": 2,
      "isdst": false,
      "text": "(UTC+02:00) Cairo",
      "utc": [
        "Africa/Cairo"
      ]
    },
    {
      "value": "Syria Standard Time",
      "abbr": "SDT",
      "offset": 3,
      "isdst": true,
      "text": "(UTC+02:00) Damascus",
      "utc": [
        "Asia/Damascus"
      ]
    },
    {
      "value": "E. Europe Standard Time",
      "abbr": "EEDT",
      "offset": 3,
      "isdst": true,
      "text": "(UTC+02:00) E. Europe",
      "utc": [
        "Asia/Nicosia",
        "Europe/Athens",
        "Europe/Bucharest",
        "Europe/Chisinau",
        "Europe/Helsinki",
        "Europe/Kiev",
        "Europe/Mariehamn",
        "Europe/Nicosia",
        "Europe/Riga",
        "Europe/Sofia",
        "Europe/Tallinn",
        "Europe/Uzhgorod",
        "Europe/Vilnius",
        "Europe/Zaporozhye"

      ]
    },
    {
      "value": "South Africa Standard Time",
      "abbr": "SAST",
      "offset": 2,
      "isdst": false,
      "text": "(UTC+02:00) Harare, Pretoria",
      "utc": [
        "Africa/Blantyre",
        "Africa/Bujumbura",
        "Africa/Gaborone",
        "Africa/Harare",
        "Africa/Johannesburg",
        "Africa/Kigali",
        "Africa/Lubumbashi",
        "Africa/Lusaka",
        "Africa/Maputo",
        "Africa/Maseru",
        "Africa/Mbabane",
        "Etc/GMT-2"
      ]
    },
    {
      "value": "FLE Standard Time",
      "abbr": "FDT",
      "offset": 3,
      "isdst": true,
      "text": "(UTC+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius",
      "utc": [
        "Europe/Helsinki",
        "Europe/Kiev",
        "Europe/Mariehamn",
        "Europe/Riga",
        "Europe/Sofia",
        "Europe/Tallinn",
        "Europe/Uzhgorod",
        "Europe/Vilnius",
        "Europe/Zaporozhye"
      ]
    },
    {
      "value": "Turkey Standard Time",
      "abbr": "TDT",
      "offset": 3,
      "isdst": false,
      "text": "(UTC+03:00) Istanbul",
      "utc": [
        "Europe/Istanbul"
      ]
    },
    {
      "value": "Israel Standard Time",
      "abbr": "JDT",
      "offset": 3,
      "isdst": true,
      "text": "(UTC+02:00) Jerusalem",
      "utc": [
        "Asia/Jerusalem"
      ]
    },
    {
      "value": "Libya Standard Time",
      "abbr": "LST",
      "offset": 2,
      "isdst": false,
      "text": "(UTC+02:00) Tripoli",
      "utc": [
        "Africa/Tripoli"
      ]
    },
    {
      "value": "Jordan Standard Time",
      "abbr": "JST",
      "offset": 3,
      "isdst": false,
      "text": "(UTC+03:00) Amman",
      "utc": [
        "Asia/Amman"
      ]
    },
    {
      "value": "Arabic Standard Time",
      "abbr": "AST",
      "offset": 3,
      "isdst": false,
      "text": "(UTC+03:00) Baghdad",
      "utc": [
        "Asia/Baghdad"
      ]
    },
    {
      "value": "Kaliningrad Standard Time",
      "abbr": "KST",
      "offset": 3,
      "isdst": false,
      "text": "(UTC+02:00) Kaliningrad",
      "utc": [
        "Europe/Kaliningrad"
      ]
    },
    {
      "value": "Arab Standard Time",
      "abbr": "AST",
      "offset": 3,
      "isdst": false,
      "text": "(UTC+03:00) Kuwait, Riyadh",
      "utc": [
        "Asia/Aden",
        "Asia/Bahrain",
        "Asia/Kuwait",
        "Asia/Qatar",
        "Asia/Riyadh"
      ]
    },
    {
      "value": "E. Africa Standard Time",
      "abbr": "EAST",
      "offset": 3,
      "isdst": false,
      "text": "(UTC+03:00) Nairobi",
      "utc": [
        "Africa/Addis_Ababa",
        "Africa/Asmera",
        "Africa/Dar_es_Salaam",
        "Africa/Djibouti",
        "Africa/Juba",
        "Africa/Kampala",
        "Africa/Khartoum",
        "Africa/Mogadishu",
        "Africa/Nairobi",
        "Antarctica/Syowa",
        "Etc/GMT-3",
        "Indian/Antananarivo",
        "Indian/Comoro",
        "Indian/Mayotte"
      ]
    },
    {
      "value": "Moscow Standard Time",
      "abbr": "MSK",
      "offset": 3,
      "isdst": false,
      "text": "(UTC+03:00) Moscow, St. Petersburg, Volgograd, Minsk",
      "utc": [
        "Europe/Kirov",
        "Europe/Moscow",
        "Europe/Simferopol",
        "Europe/Volgograd",
        "Europe/Minsk"
      ]
    },
    {
      "value": "Samara Time",
      "abbr": "SAMT",
      "offset": 4,
      "isdst": false,
      "text": "(UTC+04:00) Samara, Ulyanovsk, Saratov",
      "utc": [
        "Europe/Astrakhan",
        "Europe/Samara",
        "Europe/Ulyanovsk"
      ]
    },
    {
      "value": "Iran Standard Time",
      "abbr": "IDT",
      "offset": 4.5,
      "isdst": true,
      "text": "(UTC+03:30) Tehran",
      "utc": [
        "Asia/Tehran"
      ]
    },
    {
      "value": "Arabian Standard Time",
      "abbr": "AST",
      "offset": 4,
      "isdst": false,
      "text": "(UTC+04:00) Abu Dhabi, Muscat",
      "utc": [
        "Asia/Dubai",
        "Asia/Muscat",
        "Etc/GMT-4"
      ]
    },
    {
      "value": "Azerbaijan Standard Time",
      "abbr": "ADT",
      "offset": 5,
      "isdst": true,
      "text": "(UTC+04:00) Baku",
      "utc": [
        "Asia/Baku"
      ]
    },
    {
      "value": "Mauritius Standard Time",
      "abbr": "MST",
      "offset": 4,
      "isdst": false,
      "text": "(UTC+04:00) Port Louis",
      "utc": [
        "Indian/Mahe",
        "Indian/Mauritius",
        "Indian/Reunion"
      ]
    },
    {
      "value": "Georgian Standard Time",
      "abbr": "GET",
      "offset": 4,
      "isdst": false,
      "text": "(UTC+04:00) Tbilisi",
      "utc": [
        "Asia/Tbilisi"
      ]
    },
    {
      "value": "Caucasus Standard Time",
      "abbr": "CST",
      "offset": 4,
      "isdst": false,
      "text": "(UTC+04:00) Yerevan",
      "utc": [
        "Asia/Yerevan"
      ]
    },
    {
      "value": "Afghanistan Standard Time",
      "abbr": "AST",
      "offset": 4.5,
      "isdst": false,
      "text": "(UTC+04:30) Kabul",
      "utc": [
        "Asia/Kabul"
      ]
    },
    {
      "value": "West Asia Standard Time",
      "abbr": "WAST",
      "offset": 5,
      "isdst": false,
      "text": "(UTC+05:00) Ashgabat, Tashkent",
      "utc": [
        "Antarctica/Mawson",
        "Asia/Aqtau",
        "Asia/Aqtobe",
        "Asia/Ashgabat",
        "Asia/Dushanbe",
        "Asia/Oral",
        "Asia/Samarkand",
        "Asia/Tashkent",
        "Etc/GMT-5",
        "Indian/Kerguelen",
        "Indian/Maldives"
      ]
    },
    {
      "value": "Yekaterinburg Time",
      "abbr": "YEKT",
      "offset": 5,
      "isdst": false,
      "text": "(UTC+05:00) Yekaterinburg",
      "utc": [
        "Asia/Yekaterinburg"
      ]
    },
    {
      "value": "Pakistan Standard Time",
      "abbr": "PKT",
      "offset": 5,
      "isdst": false,
      "text": "(UTC+05:00) Islamabad, Karachi",
      "utc": [
        "Asia/Karachi"
      ]
    },
    {
      "value": "India Standard Time",
      "abbr": "IST",
      "offset": 5.5,
      "isdst": false,
      "text": "(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi",
      "utc": [
        "Asia/Kolkata",
        "Asia/Calcutta"
      ]
    },
    {
      "value": "Sri Lanka Standard Time",
      "abbr": "SLST",
      "offset": 5.5,
      "isdst": false,
      "text": "(UTC+05:30) Sri Jayawardenepura",
      "utc": [
        "Asia/Colombo"
      ]
    },
    {
      "value": "Nepal Standard Time",
      "abbr": "NST",
      "offset": 5.75,
      "isdst": false,
      "text": "(UTC+05:45) Kathmandu",
      "utc": [
        "Asia/Kathmandu"
      ]
    },
    {
      "value": "Central Asia Standard Time",
      "abbr": "CAST",
      "offset": 6,
      "isdst": false,
      "text": "(UTC+06:00) Nur-Sultan (Astana)",
      "utc": [
        "Antarctica/Vostok",
        "Asia/Almaty",
        "Asia/Bishkek",
        "Asia/Qyzylorda",
        "Asia/Urumqi",
        "Etc/GMT-6",
        "Indian/Chagos"
      ]
    },
    {
      "value": "Bangladesh Standard Time",
      "abbr": "BST",
      "offset": 6,
      "isdst": false,
      "text": "(UTC+06:00) Dhaka",
      "utc": [
        "Asia/Dhaka",
        "Asia/Thimphu"
      ]
    },
    {
      "value": "Myanmar Standard Time",
      "abbr": "MST",
      "offset": 6.5,
      "isdst": false,
      "text": "(UTC+06:30) Yangon (Rangoon)",
      "utc": [
        "Asia/Rangoon",
        "Indian/Cocos"
      ]
    },
    {
      "value": "SE Asia Standard Time",
      "abbr": "SAST",
      "offset": 7,
      "isdst": false,
      "text": "(UTC+07:00) Bangkok, Hanoi, Jakarta",
      "utc": [
        "Antarctica/Davis",
        "Asia/Bangkok",
        "Asia/Hovd",
        "Asia/Jakarta",
        "Asia/Phnom_Penh",
        "Asia/Pontianak",
        "Asia/Saigon",
        "Asia/Vientiane",
        "Etc/GMT-7",
        "Indian/Christmas"
      ]
    },
    {
      "value": "N. Central Asia Standard Time",
      "abbr": "NCAST",
      "offset": 7,
      "isdst": false,
      "text": "(UTC+07:00) Novosibirsk",
      "utc": [
        "Asia/Novokuznetsk",
        "Asia/Novosibirsk",
        "Asia/Omsk"
      ]
    },
    {
      "value": "China Standard Time",
      "abbr": "CST",
      "offset": 8,
      "isdst": false,
      "text": "(UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi",
      "utc": [
        "Asia/Hong_Kong",
        "Asia/Macau",
        "Asia/Shanghai"
      ]
    },
    {
      "value": "North Asia Standard Time",
      "abbr": "NAST",
      "offset": 8,
      "isdst": false,
      "text": "(UTC+08:00) Krasnoyarsk",
      "utc": [
        "Asia/Krasnoyarsk"
      ]
    },
    {
      "value": "Singapore Standard Time",
      "abbr": "MPST",
      "offset": 8,
      "isdst": false,
      "text": "(UTC+08:00) Kuala Lumpur, Singapore",
      "utc": [
        "Asia/Brunei",
        "Asia/Kuala_Lumpur",
        "Asia/Kuching",
        "Asia/Makassar",
        "Asia/Manila",
        "Asia/Singapore",
        "Etc/GMT-8"
      ]
    },
    {
      "value": "W. Australia Standard Time",
      "abbr": "WAST",
      "offset": 8,
      "isdst": false,
      "text": "(UTC+08:00) Perth",
      "utc": [
        "Antarctica/Casey",
        "Australia/Perth"
      ]
    },
    {
      "value": "Taipei Standard Time",
      "abbr": "TST",
      "offset": 8,
      "isdst": false,
      "text": "(UTC+08:00) Taipei",
      "utc": [
        "Asia/Taipei"
      ]
    },
    {
      "value": "Ulaanbaatar Standard Time",
      "abbr": "UST",
      "offset": 8,
      "isdst": false,
      "text": "(UTC+08:00) Ulaanbaatar",
      "utc": [
        "Asia/Choibalsan",
        "Asia/Ulaanbaatar"
      ]
    },
    {
      "value": "North Asia East Standard Time",
      "abbr": "NAEST",
      "offset": 8,
      "isdst": false,
      "text": "(UTC+08:00) Irkutsk",
      "utc": [
        "Asia/Irkutsk"
      ]
    },
    {
      "value": "Japan Standard Time",
      "abbr": "JST",
      "offset": 9,
      "isdst": false,
      "text": "(UTC+09:00) Osaka, Sapporo, Tokyo",
      "utc": [
        "Asia/Dili",
        "Asia/Jayapura",
        "Asia/Tokyo",
        "Etc/GMT-9",
        "Pacific/Palau"
      ]
    },
    {
      "value": "Korea Standard Time",
      "abbr": "KST",
      "offset": 9,
      "isdst": false,
      "text": "(UTC+09:00) Seoul",
      "utc": [
        "Asia/Pyongyang",
        "Asia/Seoul"
      ]
    },
    {
      "value": "Cen. Australia Standard Time",
      "abbr": "CAST",
      "offset": 9.5,
      "isdst": false,
      "text": "(UTC+09:30) Adelaide",
      "utc": [
        "Australia/Adelaide",
        "Australia/Broken_Hill"
      ]
    },
    {
      "value": "AUS Central Standard Time",
      "abbr": "ACST",
      "offset": 9.5,
      "isdst": false,
      "text": "(UTC+09:30) Darwin",
      "utc": [
        "Australia/Darwin"
      ]
    },
    {
      "value": "E. Australia Standard Time",
      "abbr": "EAST",
      "offset": 10,
      "isdst": false,
      "text": "(UTC+10:00) Brisbane",
      "utc": [
        "Australia/Brisbane",
        "Australia/Lindeman"
      ]
    },
    {
      "value": "AUS Eastern Standard Time",
      "abbr": "AEST",
      "offset": 10,
      "isdst": false,
      "text": "(UTC+10:00) Canberra, Melbourne, Sydney",
      "utc": [
        "Australia/Melbourne",
        "Australia/Sydney"
      ]
    },
    {
      "value": "West Pacific Standard Time",
      "abbr": "WPST",
      "offset": 10,
      "isdst": false,
      "text": "(UTC+10:00) Guam, Port Moresby",
      "utc": [
        "Antarctica/DumontDUrville",
        "Etc/GMT-10",
        "Pacific/Guam",
        "Pacific/Port_Moresby",
        "Pacific/Saipan",
        "Pacific/Truk"
      ]
    },
    {
      "value": "Tasmania Standard Time",
      "abbr": "TST",
      "offset": 10,
      "isdst": false,
      "text": "(UTC+10:00) Hobart",
      "utc": [
        "Australia/Currie",
        "Australia/Hobart"
      ]
    },
    {
      "value": "Yakutsk Standard Time",
      "abbr": "YST",
      "offset": 9,
      "isdst": false,
      "text": "(UTC+09:00) Yakutsk",
      "utc": [
        "Asia/Chita",
        "Asia/Khandyga",
        "Asia/Yakutsk"
      ]
    },
    {
      "value": "Central Pacific Standard Time",
      "abbr": "CPST",
      "offset": 11,
      "isdst": false,
      "text": "(UTC+11:00) Solomon Is., New Caledonia",
      "utc": [
        "Antarctica/Macquarie",
        "Etc/GMT-11",
        "Pacific/Efate",
        "Pacific/Guadalcanal",
        "Pacific/Kosrae",
        "Pacific/Noumea",
        "Pacific/Ponape"
      ]
    },
    {
      "value": "Vladivostok Standard Time",
      "abbr": "VST",
      "offset": 11,
      "isdst": false,
      "text": "(UTC+11:00) Vladivostok",
      "utc": [
        "Asia/Sakhalin",
        "Asia/Ust-Nera",
        "Asia/Vladivostok"
      ]
    },
    {
      "value": "New Zealand Standard Time",
      "abbr": "NZST",
      "offset": 12,
      "isdst": false,
      "text": "(UTC+12:00) Auckland, Wellington",
      "utc": [
        "Antarctica/McMurdo",
        "Pacific/Auckland"
      ]
    },
    {
      "value": "UTC+12",
      "abbr": "U",
      "offset": 12,
      "isdst": false,
      "text": "(UTC+12:00) Coordinated Universal Time+12",
      "utc": [
        "Etc/GMT-12",
        "Pacific/Funafuti",
        "Pacific/Kwajalein",
        "Pacific/Majuro",
        "Pacific/Nauru",
        "Pacific/Tarawa",
        "Pacific/Wake",
        "Pacific/Wallis"
      ]
    },
    {
      "value": "Fiji Standard Time",
      "abbr": "FST",
      "offset": 12,
      "isdst": false,
      "text": "(UTC+12:00) Fiji",
      "utc": [
        "Pacific/Fiji"
      ]
    },
    {
      "value": "Magadan Standard Time",
      "abbr": "MST",
      "offset": 12,
      "isdst": false,
      "text": "(UTC+12:00) Magadan",
      "utc": [
        "Asia/Anadyr",
        "Asia/Kamchatka",
        "Asia/Magadan",
        "Asia/Srednekolymsk"
      ]
    },
    {
      "value": "Kamchatka Standard Time",
      "abbr": "KDT",
      "offset": 13,
      "isdst": true,
      "text": "(UTC+12:00) Petropavlovsk-Kamchatsky - Old",
      "utc": [
        "Asia/Kamchatka"
      ]
    },
    {
      "value": "Tonga Standard Time",
      "abbr": "TST",
      "offset": 13,
      "isdst": false,
      "text": "(UTC+13:00) Nuku'alofa",
      "utc": [
        "Etc/GMT-13",
        "Pacific/Enderbury",
        "Pacific/Fakaofo",
        "Pacific/Tongatapu"
      ]
    },
    {
      "value": "Samoa Standard Time",
      "abbr": "SST",
      "offset": 13,
      "isdst": false,
      "text": "(UTC+13:00) Samoa",
      "utc": [
        "Pacific/Apia"
      ]
    }
  ];

  List<Text>? timezoneLists = [];
  int _selectedItemIndex = 0;
  double offsetStore = -50;

  Future _openTimeZonePicker(context, thisContext) async {
    await BottomPicker(
      // displayButtonIcon: false,
      buttonText: '',
      displayButtonIcon: false,
      buttonSingleColor: Colors.grey,
      dismissable: true,
      items: timezoneLists,
      title: widget.isEnglish? 'Select timezone': 'အချိန်ဇုန်/ဒေသ ရွေးပါ',
      selectedItemIndex: _selectedItemIndex,
      buttonTextStyle: TextStyle(color: Colors.blue),
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      onSubmit: (index) {
        debugPrint('onSubmit');
      },
      onChange: (index) {
        debugPrint('onChange');
        setState(() {
          _selectedItemIndex = index;
          _timezone.text = allUTCs[_selectedItemIndex]['text'];
          offsetStore = allUTCs[_selectedItemIndex]['offset'].toDouble();
        });
      },
      onClose: (index) {
        // FocusScopeNode currentFocus = FocusScope.of(context);
        //
        // if (!currentFocus.hasPrimaryFocus) {
        //   currentFocus.unfocus();
        // }
        debugPrint('onClose');
        // _timezone.clear();
      },
    );

    // FocusScope.of(context).unfocus();

  }

  setDeviceId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setString('device', id);
  }

  addMapData(WriteBatch batch, newShopId ,collName, docId, mapName, ) {
    DocumentReference arStream =  FirebaseFirestore.instance.collection('shops').doc(newShopId).collection(collName).doc(docId);
    batch.set(arStream, { mapName.toString() : {}
    });
    return batch;
  }

  addCountData(WriteBatch batch, newShopId , docId, val, ) {
    DocumentReference arStream =  FirebaseFirestore.instance.collection('shops').doc(newShopId).collection('countColl').doc(docId);
    batch.set(arStream, { 'count' : val
    });
    return batch;
  }

  addNoCus(WriteBatch batch, newShopId, ) {
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

  addNoMer(WriteBatch batch, newShopId, ) {
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
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  someFunc() {
    FocusScope.of(context).unfocus();
  }
}
