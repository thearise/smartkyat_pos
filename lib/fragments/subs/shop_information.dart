

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/constants/screens.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';
import 'package:smartkyat_pos/widgets/custom_flat_button.dart';

import '../../app_theme.dart';

class ShopInformation extends StatefulWidget {
  ShopInformation({
    required this.name, required this.address, required this.phone,
    Key? key,
  });
  final String name;
  final String address;
  final String phone;

  @override
  _ShopInformationState createState() => _ShopInformationState();
}

class _ShopInformationState extends State<ShopInformation>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ShopInformation>{
  @override
  bool get wantKeepAlive => true;
  var shopId;
  final _formKey = GlobalKey<FormState>();
  bool firstTime = true;

  final _shopName = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();

  String textSetEdit = 'Shop info';
  String textSetShopInfo = 'Edit shop information';
  String textSetInformation = 'SHOP INFORMATION';
  String textSetName = 'Shop name';
  String textSetAddress = 'Shop address';
  String textSetPhone = 'Phone';
  String textSetSave = 'Save and exit';


  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }
  bool isEnglish = true;
  @override
  initState() {

    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          isEnglish = false;
          textSetEdit = 'information';
          textSetShopInfo = 'ဆိုင်အချက်အလက် ပြင်ဆင်ရန်';
          textSetInformation = 'SHOP INFORMATION';
          textSetName = 'ဆိုင်အမည်';
          textSetAddress = 'ဆိုင်လိပ်စာ';
          textSetPhone = 'ဖုန်းနံပါတ်';
          textSetSave = 'ပြင်ဆင်မည်';
        });
      } else if(value=='english') {
        setState(() {
          isEnglish = true;
          textSetEdit = 'information';
          textSetShopInfo = 'Edit shop information';
          textSetInformation = 'SHOP INFORMATION';
          textSetName = 'Shop name';
          textSetAddress = 'Shop address';
          textSetPhone = 'Phone';
          textSetSave = 'Save and exit';
        });
      }
    });
    _shopName.text = widget.name;
    _address.text = widget.address;
    _phone.text = widget.phone;
    getStoreId().then((value) {
      setState(() {
        shopId = value.toString();
      });
    });
    super.initState();
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

  @override
  void dispose() {
    _shopName.dispose();
    _address.dispose();
    _phone.dispose();
    super.dispose();
  }
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
          top: true,
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 81,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.3),
                                        width: 1.0))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 22),
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
                                            textSetEdit,  textScaleFactor: 1,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 13,
                                              height: 1.5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            strutStyle: StrutStyle(
                                              height: 1.4,
                                              // fontSize:,
                                              forceStrutHeight: true,
                                            ),
                                          ),
                                          Text(
                                            textSetShopInfo,  textScaleFactor: 1,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 18,
                                              height: 1.3,
                                              fontWeight: FontWeight.w500,
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
                            child: Text(textSetInformation,  textScaleFactor: 1, style: TextStyle(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,color: Colors.grey,
                            ),),
                          ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
                                    child: TextFormField(
                                      //obscureText: _obscureText,
                                      controller: _shopName,
                                      //initialValue: sName,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return ' This field is required ';
                                        }
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
                                        //suffixText: 'Required' ,
                                        suffixStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12/scaleFactor,
                                          fontFamily: 'capsulesans',
                                        ),
                                        // errorText: wrongPassword,
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
                                        labelText: textSetName,
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
                                padding: const EdgeInsets.only(top: 20.0,left: 15, right: 15),
                                child: TextFormField(
                                  //obscureText: _obscureText,
                                  controller: _address,
                                 // initialValue: sAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return ' This field is required ';
                                    }
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
                                   // suffixText: 'Required' ,
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
                                    labelText: textSetAddress,
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
                                padding: const EdgeInsets.only(top: 20.0,left: 15, right: 15),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                //obscureText: _obscureText,
                                controller: _phone,
                                 // initialValue: sPhone,
                                validator: (value) {
                                if (value == null || value.isEmpty) {
                                return ' This field is required ';
                                }
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
                                //suffixText: 'Required' ,
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
                                labelText: textSetPhone,
                                floatingLabelBehavior:
                                FloatingLabelBehavior.auto,
//filled: true,
                                border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                ),
                                ),
                                ),
                                ),
                                ],
                              ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: homeBotPadding),
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0, right: 15.0, left:15.0, bottom: 15.0),
                                  child:  ButtonTheme(
                                    minWidth: MediaQuery.of(context).size.width,
                                    splashColor: Colors.transparent,
                                    height: 50,
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

                                        CollectionReference shops = await FirebaseFirestore.instance.collection('shops');
                                        if (_formKey.currentState!.validate()) {
                                          try {
                                            final result = await InternetAddress.lookup('google.com');
                                            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                              setState(() {
                                                loadingState = true;
                                                disableTouch = true;
                                              });
                                              openOverAllSubLoading();
                                              shops.doc(shopId).update({
                                                'shop_name': _shopName.text,
                                                'shop_address': _address.text,
                                                'shop_phone': _phone.text,
                                              }).then((value) {
                                                Future.delayed(const Duration(milliseconds: 2000), () {
                                                  setState(() {
                                                    loadingState = false;
                                                    disableTouch = false;
                                                  });
                                                  closeOverAllSubLoading();
                                                  Navigator.pop(context);
                                                  smartKyatFMod(context, 'You have successfully updated your shop info.', 's');
                                                });

                                              });
                                              }
                                          } on SocketException catch (_) {
                                            smartKyatFMod(context, isEnglish? 'Internet connection is required to take this action.': 'ဒီလုပ်ဆောင်ချက်ကို လုပ်ဆောင်ရန် အင်တာနက်လိုပါသည်။', 'w');
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
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          //   child: ButtonTheme(
                          //     minWidth: MediaQuery.of(context).size.width,
                          //     splashColor: Colors.transparent,
                          //     height: 50,
                          //     child: CustomFlatButton(
                          //       color: AppTheme.themeColor,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius:
                          //         BorderRadius.circular(10.0),
                          //         side: BorderSide(
                          //           color: AppTheme.themeColor,
                          //         ),
                          //       ),
                          //       onPressed: () async {
                          //         if (_formKey.currentState!.validate()) {
                          //
                          //         }
                          //       },
                          //       child: Padding(
                          //         padding: const EdgeInsets.only(
                          //             left: 5.0,
                          //             right: 5.0,
                          //             bottom: 2.0),
                          //         child: Container(
                          //           child: Text(
                          //             'Save and exit',
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 fontSize: 18,
                          //                 fontWeight: FontWeight.w500,
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
                    // Container(
                    //   color: Colors.blue,
                    //   height: MediaQuery.of(context).viewInsets.bottom - 80 < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 141,
                    // ),
                  ],
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Padding(
              //     padding: EdgeInsets.only(bottom: homeBotPadding),
              //     child: Container(
              //       color: Colors.white,
              //       child: Padding(
              //         padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0, bottom: 15.0),
              //         child:  ButtonTheme(
              //           minWidth: MediaQuery.of(context).size.width,
              //           splashColor: Colors.transparent,
              //           height: 50,
              //           child: CustomFlatButton(
              //             color: AppTheme.themeColor,
              //             shape: RoundedRectangleBorder(
              //               borderRadius:
              //               BorderRadius.circular(10.0),
              //               side: BorderSide(
              //                 color: AppTheme.themeColor,
              //               ),
              //             ),
              //             onPressed: () async {
              //                 CollectionReference shops = await FirebaseFirestore.instance.collection('shops');
              //                 if (_formKey.currentState!.validate()) {
              //
              //                       setState(() {
              //                         loadingState = true;
              //                       });
              //                       shops.doc(shopId).update({
              //                         'shop_name': _shopName.text,
              //                         'shop_address': _address.text,
              //                         'shop_phone': _phone.text,
              //                       }).then((value) {
              //
              //                           loadingState = false;
              //
              //                       });
              //                       Navigator.pop(context);
              //                       smartKyatFlash('You have successfully updated your shop info.', 's');
              //                 }
              //             },
              //             child: loadingState == true ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
              //                 child: CupertinoActivityIndicator(radius: 10,)) : Padding(
              //               padding: const EdgeInsets.only(
              //                   left: 5.0,
              //                   right: 5.0,
              //                   bottom: 2.0),
              //               child: Container(
              //                 child: Text(
              //                   'Save and exit',
              //                   textAlign: TextAlign.center,
              //                   style: TextStyle(
              //                       fontSize: 18,
              //                       fontWeight: FontWeight.w500,
              //                       letterSpacing:-0.1
              //                   ),
              //                 ),
              //               ),
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