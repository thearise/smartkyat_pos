import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/customers_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';

import '../app_theme.dart';

class FillProduct extends StatefulWidget {
  final _callback;
  final _callback3;
  const FillProduct(
      {Key? key,
        required this.idString, required this.unitName, required this.shopId, required this.price,
        required void toggleCoinCallback(String str), required this.unit,
        required void toggleCoinCallback3(String str), required this.prodName, required this.image, required this.stock, required this.link, required this.subExist,
      }) : _callback = toggleCoinCallback,
        _callback3 = toggleCoinCallback3;
  final String idString;
  final String unitName;
  final String shopId;
  final String price;
  final String prodName;
  final String image;
  final String unit;
  final String stock;
  final String link;
  final String subExist;

  @override
  _FillProductState createState() => _FillProductState();
}

class _FillProductState extends State<FillProduct> {
  var nameTECs = <TextEditingController>[];
  var ageTECs = <TextEditingController>[];
  var jobTECs = <TextEditingController>[];
  var cards = <Padding>[];
  static List<String> prodFieldsValue = [];
  final _formKey = GlobalKey<FormState>();


  final munitCtrl = TextEditingController();

  final msaleCtrl = TextEditingController();
  bool prodAdding = false;

  String _getRegexString() =>
      r'[0-9]+[,.]{0,1}[0-9]*';

  String _getNum() =>
      r'[0-9]';

  String currencyUnit = 'MMK';
  String textSetRefill = 'Refill to inventory';
  String textSetMainQty = 'PRICING & INVENTORY';
  String textSetUnitQty = 'Unit quantity';
  String textSetBuyPrice = 'Buy Price';
  String textSetAddBuy = 'Add to Buy Cart';

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }

  bool isEnglish = true;

  @override
  initState() {

    munitCtrl.text = '1';
    msaleCtrl.text = widget.price;

    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          isEnglish = false;
          textSetRefill = 'ပစ္စည်း ပြန်ဖြည့်ရန်';
          textSetMainQty = 'PRICING & INVENTORY';
          textSetUnitQty = 'အရေအတွက်';
          textSetBuyPrice = 'ဝယ်ဈေး';
          textSetAddBuy = 'အဝယ်စာရင်းသို့ ';

        });
      }
      else if(value=='english') {
        setState(() {
          isEnglish = true;
          textSetRefill = 'Refill to inventory';
          textSetMainQty = 'PRICING & INVENTORY';
          textSetUnitQty = 'Unit quantity';
          textSetBuyPrice = 'Buy Price';
          textSetAddBuy = 'Add to Buy Cart';

        });
      }
    });

    getCurrency().then((value){
      if(value == 'US Dollar (USD)') {
        setState(() {
          currencyUnit = 'USD';
        });
      }
      else if(value == 'Myanmar Kyat (MMK)') {
        setState(() {
          currencyUnit = 'MMK';
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    munitCtrl.clear();
    msaleCtrl.clear();
    super.dispose();
  }


  bool firstTime = true;
  double homeBotPadding = 0;
  @override
  Widget build(BuildContext context) {
    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
      firstTime = false;
    }
    return Container(
        color: Colors.white,
        child: SafeArea(
          top: true,
          bottom: false,
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
                  padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0,),
                  child: Row(
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
                      Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.prodName,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis
                                  // height: 1.5
                                ),
                                strutStyle: StrutStyle(
                                  height: 1.4,
                                  // fontSize:,
                                  forceStrutHeight: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 0.0),
                                child: Text(
                                    textSetRefill,
                                    maxLines: 1,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.ellipsis,
                                      // height: 1.3
                                    ),
                                    strutStyle: StrutStyle(
                                      height: isEnglish? 1.4: 1.6,
                                      forceStrutHeight: true,
                                    )
                                ),
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Form(
                      key: _formKey,
                      child:  Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(top: 15, left: 15, right: 15.0),
                                  child: Text(
                                      textSetMainQty,
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14, color: Colors.grey,
                                          height: 0.9
                                      ),
                                      strutStyle: StrutStyle(
                                        height: isEnglish? 1.4: 1.6,
                                        forceStrutHeight: true,
                                      )
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0, top: 14),
                                child: Icon(widget.unitName == 'unit_name'? SmartKyat_POS.prodm: widget.unitName == 'sub1_name'? SmartKyat_POS.prods1: SmartKyat_POS.prods2, size: 16, color: Colors.grey),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 45),
                            child: Row(
                              children: [
                                Container(
                                  width:  MediaQuery.of(context).size.width > 900 ? ((MediaQuery.of(context).size.width * (2 / 3.5))  - 30) : MediaQuery.of(context).size.width - 30,
                                  child: TextFormField(
                                    controller: munitCtrl,
                                    keyboardType: TextInputType.numberWithOptions(decimal: false),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp(_getNum())),],
// The validator receives the text that the user has entered.
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      prodFieldsValue.add(value);
                                      return null;
                                    },
                                    style: TextStyle(
                                      height: 0.95,
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
                                      suffixText: widget.unit,
                                      suffixStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontFamily: 'capsulesans',
                                          height: 0.8
                                      ),
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
                                      labelText: textSetUnitQty,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
//filled: true
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                )
//                                         Container(
//                                           width: MediaQuery.of(context).size.width > 900 ? ((MediaQuery.of(context).size.width * (2 / 3.5))  - 30) * (2.41 / 4) : (MediaQuery.of(context).size.width - 30) * (2.41 / 4),
//                                           child: TextFormField(
//                                             controller: munitCtrl,
//                                             keyboardType: TextInputType.numberWithOptions(decimal: false),
//                                             inputFormatters: <TextInputFormatter>[
//                                               FilteringTextInputFormatter.allow(RegExp(_getNum())),],
// // The validator receives the text that the user has entered.
//                                             validator: (value) {
//                                               if (value == null ||
//                                                   value.isEmpty) {
//                                                 return 'This field is required';
//                                               }
//                                               prodFieldsValue.add(value);
//                                               return null;
//                                             },
//                                             style: TextStyle(
//                                               height: 0.95,
//                                             ),
//                                             decoration: InputDecoration(
//                                               enabledBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                                   borderSide: const BorderSide(
//                                                       color: AppTheme.skBorderColor,
//                                                       width: 2.0),
//                                                   borderRadius: BorderRadius.all(
//                                                       Radius.circular(10.0))),
//
//                                               focusedBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                                   borderSide: const BorderSide(
//                                                       color: AppTheme.themeColor,
//                                                       width: 2.0),
//                                                   borderRadius: BorderRadius.all(
//                                                       Radius.circular(10.0))),
//                                               contentPadding: const EdgeInsets.only(
//                                                   left: 15.0,
//                                                   right: 15.0,
//                                                   top: 20.0,
//                                                   bottom: 20.0),
//                                               //suffixText: 'Required',
//                                               suffixStyle: TextStyle(
//                                                 color: Colors.grey,
//                                                 fontSize: 12,
//                                                 fontFamily: 'capsulesans',
//                                               ),
//                                               errorStyle: TextStyle(
//                                                   backgroundColor: Colors.white,
//                                                   fontSize: 12,
//                                                   fontFamily: 'capsulesans',
//                                                   height: 0.1
//                                               ),
//                                               labelStyle: TextStyle(
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.black,
//                                               ),
// // errorText: 'Error message',
//                                               labelText: 'Unit Quantity',
//                                               floatingLabelBehavior:
//                                               FloatingLabelBehavior.auto,
// //filled: true
//                                               border: OutlineInputBorder(
//                                                 borderRadius: BorderRadius.circular(10),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Spacer(),
//                                         Container(
//                                           width:  MediaQuery.of(context).size.width > 900 ? ((MediaQuery.of(context).size.width * (2 / 3.5))  -
//                                                   30) *
//                                               (1.41 / 4) : (MediaQuery.of(context).size.width -
//                                               30) *
//                                               (1.41 / 4),
//                                           child: Text(
//                                             mainName,
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 118),
                            child: TextFormField(
                              controller: msaleCtrl,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'This field is required';
                                }
                                prodFieldsValue.add(value);
                                return null;
                              },
                              style: TextStyle(
                                height: 0.95,
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
                                suffixText: '$currencyUnit',
                                suffixStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: 'capsulesans',
                                ),
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
                                labelText: textSetBuyPrice,
                                floatingLabelBehavior:
                                FloatingLabelBehavior.auto,
//filled: true
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 195),
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
                          //        if (_formKey.currentState!.validate()) {
                          //         widget._callback3(widget.idString +
                          //             '^' +
                          //             msaleCtrl.text +
                          //             '^' +
                          //             munitCtrl.text +
                          //             '^' +
                          //             'Phyo' +
                          //
                          //             '^'+ widget.unitname + '^' + '1'.toString());
                          //         print(widget.idString +
                          //             '^' +
                          //             msaleCtrl.text +
                          //             '^' +
                          //             munitCtrl.text +
                          //             '^' +
                          //             'Phyo' +
                          //
                          //             '^'+ widget.unitname + '^' + '1'.toString());
                          //         Navigator.pop(context);
                          //       } },
                          //       child: Padding(
                          //         padding: const EdgeInsets.only(
                          //             left: 5.0,
                          //             right: 5.0,
                          //             bottom: 2.0),
                          //         child: Container(
                          //           child: Text(
                          //             'Add to Buy Cart',
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
                          // )
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width > 900 ? homeBotPadding + 20: homeBotPadding),
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
                            if (_formKey.currentState!.validate()) {
                              widget._callback3(widget.idString +
                                  '^' +
                                  msaleCtrl.text +
                                  '^' +
                                  munitCtrl.text +
                                  '^' +
                                  'Phyo' +

                                  '^'+ widget.unitName + '^' + '1' + '^' + widget.prodName + '^' + widget.unit + '^' + widget.image + '^'+ widget.stock + '^' + widget.link + '^' + widget.subExist);
                              print(widget.idString +
                                  '^' +
                                  msaleCtrl.text +
                                  '^' +
                                  munitCtrl.text +
                                  '^' +
                                  'Phyo' +

                                  '^'+ widget.unitName + '^' + '1'.toString());
                              Navigator.pop(context);
                            } },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0,
                                right: 5.0,
                                bottom: 2.0),
                            child: Container(
                              child: Text(
                                  textSetAddBuy,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing:-0.1
                                  ),
                                  strutStyle: StrutStyle(
                                    height: isEnglish? 1.4: 1.6,
                                    forceStrutHeight: true,
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
              ),
            ],
          ),

        ));
  }

  zeroToTen(String string) {
    if (int.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
  }

  String buySubCheck(String unitName) {
    if(unitName == 'unit_name') {
      return '1';
    } else if(unitName == 'sub1_name') {
      return '2';
    } else if(unitName == 'sub2_name') {
      return '3';
    } else {
      return '1';
    }
  }
}
