import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';

import '../app_theme.dart';

class LossProduct extends StatefulWidget {
  const LossProduct(
      {Key? key, required this.idString, required this.isEnglish, required this.prodID, required this.shopId, required this.price, required this.fromSearch});
  final String idString;
  final String prodID;
  final String shopId;
  final String price;
  final bool fromSearch;
  final bool isEnglish;

  @override
  _LossProductState createState() => _LossProductState();
}

final _formKey = GlobalKey<FormState>();

final lossAmount = TextEditingController();
final priceAmount = TextEditingController();

late int codeDialog =0;

var deviceIdNum;

getDeviceId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('device');
}

class _LossProductState extends State<LossProduct> {



  String _getRegexString() =>
      r'[0-9]+[,.]{0,1}[0-9]*';

  String _getNum() =>
      r'[0-9]';

  String currencyUnit = 'MMK';
  String textSetAddLoss = 'Add loss item';
  String textSetLossInventory = 'LOSS IN INVENTORY';
  String textSetLossQty = 'Loss quantity';
  String textSetBuyPrice = 'Buy price';
  String textSetSave = 'Save Loss Product';

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }

  @override
  initState() {
    lossAmount.text = '1';

      if(widget.isEnglish == true) {

        setState(() {
          textSetAddLoss = 'Add loss item';
          textSetLossInventory = 'LOSS IN INVENTORY';
          textSetLossQty = 'Loss quantity';
          textSetBuyPrice = 'Buy price';
          textSetSave = 'Save';
        });
      } else {
        setState(() {
          textSetAddLoss = 'ဆုံးရှုံးပစ္စည်းထည့်ရန်';
          textSetLossInventory = 'LOSS IN INVENTORY';
          textSetLossQty = 'အရေအတွက်';
          textSetBuyPrice = 'ဝယ်ဈေး';
          textSetSave = 'သိမ်းဆည်းမည်';
        });
      }

    getCurrency().then((value){
      if(value == 'US Dollar (USD)') {
        setState(() {
          currencyUnit = 'USD';
        });
      } else if(value == 'Myanmar Kyat (MMK)') {
        setState(() {
          currencyUnit = 'MMK';
        });
      }
    });
    priceAmount.text = widget.price.toString();
    // TODO: implement initState
    getDeviceId().then((value) {
      deviceIdNum = value;
    });
    super.initState();
  }

  @override
  void dispose() {
    lossAmount.clear();
    priceAmount.clear();
    super.dispose();
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
                                widget.prodID.split('^')[1].toString(), textScaleFactor: 1,
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
                              Text(
                                  textSetAddLoss, textScaleFactor: 1,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  strutStyle: StrutStyle(
                                    height: widget.isEnglish? 1.4: 1.6,
                                    forceStrutHeight: true,
                                  )
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
                                      textSetLossInventory, textScaleFactor: 1,
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14, color: Colors.grey,
                                          height: 0.9
                                      ),
                                      strutStyle: StrutStyle(
                                        height: widget.isEnglish? 1.4: 1.6,
                                        forceStrutHeight: true,
                                      )
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0, top: 14),
                                child: Icon(widget.prodID.split('^')[3] == 'unit_name'? SmartKyat_POS.prodm: widget.prodID.split('^')[3] == 'sub1_name'? SmartKyat_POS.prods1: SmartKyat_POS.prods2, size: 16, color: Colors.grey),
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
                                    controller: lossAmount,
                                    keyboardType: TextInputType.numberWithOptions(decimal: false),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp(_getNum())),],
// The validator receives the text that the user has entered.
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty) {
                                        return 'This field is required';
                                      }
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
                                      labelText: textSetLossQty,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
//filled: true
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                // Spacer(),
                                // Container(
                                //   width: MediaQuery.of(context).size.width > 900 ? ((MediaQuery.of(context).size.width * (2 / 3.5))  -
                                //       30) *
                                //       (1.41 / 4) : (MediaQuery.of(context).size.width -
                                //       30) *
                                //       (1.41 / 4),
                                //   child: Text(
                                //     mainName,
                                //     style: TextStyle(
                                //       fontSize: 16,
                                //       fontWeight: FontWeight.w500,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 118),
                            child: TextFormField(
                              controller: priceAmount,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
// The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'This field is required';
                                }
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

                              WriteBatch batch = FirebaseFirestore.instance.batch();
                              DateTime now = DateTime.now();

                              DocumentReference prodsArr = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('prodSaleData').doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()));
                              DocumentReference prodsMonthly = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('prodMthData').doc(now.year.toString() + zeroToTen(now.month.toString()));
                              DocumentReference prodsYearly = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('prodYearData').doc(now.year.toString());

                              showOkCancelAlertDialog(
                                context: context,
                                title: 'Confirmation alert',
                                message: 'Are you sure you want to add this product to loss products in inventory',
                                defaultType: OkCancelAlertDefaultType.cancel,
                              ).then((result) async {
                                if(result == OkCancelResult.ok) {
                                  if (widget.prodID.split('^')[3] == 'unit_name') {
                                    batch  = await decStockFromInv(batch, widget.prodID.split('^')[0], 'im', lossAmount.text.toString());
                                    batch  = await updateLoss(batch, widget.prodID.split('^')[0], 'lm', lossAmount.text.toString());

                                    batch.set(
                                        prodsArr,
                                        {
                                          'prods': {
                                            widget.prodID.split('^')[0].toString(): {
                                              'lm': FieldValue.increment(double.parse(lossAmount.text.toString())),

                                            }
                                          }
                                        },SetOptions(merge: true)
                                    );

                                    batch.set(
                                        prodsMonthly,
                                        {
                                          'prods': {
                                            widget.prodID.split('^')[0].toString(): {
                                              'lm': FieldValue.increment(double.parse(lossAmount.text.toString())),
                                            }
                                          }
                                        },SetOptions(merge: true)
                                    );

                                    batch.set(
                                        prodsYearly,
                                        {
                                          'prods': {
                                            widget.prodID.split('^')[0].toString(): {
                                              'lm': FieldValue.increment(double.parse(lossAmount.text.toString())),

                                            }
                                          }
                                        },SetOptions(merge: true)
                                    );
                                  }
                                  else if (widget.prodID.split('^')[3] == 'sub1_name') {
                                    batch = await sub1Execution(batch, widget.prodID.split('^')[4], widget.prodID.split('^')[5], widget.prodID.split('^')[0], lossAmount.text.toString());
                                    batch  = await updateLoss(batch, widget.prodID.split('^')[0], 'l1', lossAmount.text.toString());
                                    batch.set(
                                        prodsArr,
                                        {
                                          'prods': {
                                            widget.prodID.split('^')[0].toString(): {
                                              'l1': FieldValue.increment(double.parse(lossAmount.text.toString())),

                                            }
                                          }
                                        },SetOptions(merge: true)
                                    );

                                    batch.set(
                                        prodsMonthly,
                                        {
                                          'prods': {
                                            widget.prodID.split('^')[0].toString(): {
                                              'l1': FieldValue.increment(double.parse(lossAmount.text.toString())),
                                            }
                                          }
                                        },SetOptions(merge: true)
                                    );

                                    batch.set(
                                        prodsYearly,
                                        {
                                          'prods': {
                                            widget.prodID.split('^')[0].toString(): {
                                              'l1': FieldValue.increment(double.parse(lossAmount.text.toString())),

                                            }
                                          }
                                        },SetOptions(merge: true)
                                    );
                                  }
                                  else if (widget.prodID.split('^')[3] == 'sub2_name') {
                                    batch = await sub2Execution(batch, widget.prodID.split('^')[4], widget.prodID.split('^')[5], widget.prodID.split('^')[0], lossAmount.text.toString());
                                    batch  = await updateLoss(batch, widget.prodID.split('^')[0], 'l2', lossAmount.text.toString());
                                    batch.set(
                                        prodsArr,
                                        {
                                          'prods': {
                                            widget.prodID.split('^')[0].toString(): {
                                              'l2': FieldValue.increment(double.parse(lossAmount.text.toString())),

                                            }
                                          }
                                        },SetOptions(merge: true)
                                    );

                                    batch.set(
                                        prodsMonthly,
                                        {
                                          'prods': {
                                            widget.prodID.split('^')[0].toString(): {
                                              'l2': FieldValue.increment(double.parse(lossAmount.text.toString())),
                                            }
                                          }
                                        },SetOptions(merge: true)
                                    );

                                    batch.set(
                                        prodsYearly,
                                        {
                                          'prods': {
                                            widget.prodID.split('^')[0].toString(): {
                                              'l2': FieldValue.increment(double.parse(lossAmount.text.toString())),

                                            }
                                          }
                                        },SetOptions(merge: true)
                                    );
                                  }

                                  DateTime ordCntDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 12:00:00');
                                  double ttlLossAmount = 0.0;
                                  ttlLossAmount = double.parse(lossAmount.text.toString()) * double.parse(priceAmount.text.toString());
                                  batch = await updateMonthlyData(batch, now.year.toString() + zeroToTen(now.month.toString()),  now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'loss_cust', ttlLossAmount.toString(), ordCntDate);
                                  batch = await updateYearlyData(batch, now.year.toString(),  now.year.toString() +  zeroToTen(now.month.toString())  + 'loss_cust',  ttlLossAmount.toString(), ordCntDate);
                                  try {
                                    batch.commit();
                                    Navigator.pop(context);
                                    smartKyatFlash('Success', 's');
                                  } catch(error) {
                                    Navigator.pop(context);
                                    smartKyatFlash('Unknown error! Please try again later.', 'e');
                                  }
                                }
                              });

                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0,
                                right: 5.0,
                                bottom: 2.0),
                            child: Container(
                              child: Text(
                                  textSetSave, textScaleFactor: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing:-0.1
                                  ),
                                  strutStyle: StrutStyle(
                                    height: widget.isEnglish? 1.4: 1.6,
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
              widget.fromSearch?SizedBox(height: 65): SizedBox(height: 0)
            ],
          ),
        )
    );
  }
  // changeUnitName2Stock(String split) {
  //   if(split == 'main') {
  //     return 'inStock1';
  //   } else {
  //     return 'inStock' + (int.parse(split[3]) + 1).toString();
  //   }
  // }
  zeroToTen(String string) {
    if (int.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
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

  updateLossMonthly(WriteBatch batch, id, field, price) {

    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_monthly').doc(id);

    batch.update(documentReference, {
      field : FieldValue.increment(double.parse(price.toString())),

    });
    return batch;
  }

  updateMonthlyData(WriteBatch batch, id, field1, price1, now) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_monthly').doc(id);
    // batch.update(documentReference, {
    //   field1 : FieldValue.increment(double.parse(price1.toString())),
    //   field2 : FieldValue.increment(double.parse(price2.toString())),
    //
    // });
    batch.set(documentReference, {
      field1.toString() : FieldValue.increment(double.parse(price1.toString())),
      'date': now,
    },SetOptions(merge: true));
    return batch;
  }

  updateYearlyData(WriteBatch batch, id, field1, price1, now) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_yearly').doc(id);
    batch.set(documentReference, {
      field1.toString() : FieldValue.increment(double.parse(price1.toString())),
      'date': now,
    },SetOptions(merge: true));
    return batch;
  }

  updateLossYearly(WriteBatch batch, id, field, price) {

    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_yearly').doc(id);

    batch.update(documentReference, {
      field : FieldValue.increment(double.parse(price.toString())),

    });
    return batch;
  }


  updateLoss(WriteBatch batch, id, unit, num){

    DocumentReference documentReference =FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr');

    batch.update(documentReference, {'prods.$id.$unit': FieldValue.increment((double.parse(num.toString()))),});
    return batch;
  }

  decStockFromInv(WriteBatch batch, id, unit, num) {
    debugPrint('Double Check Sub1' + '$id.im');
    DocumentReference documentReference =FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr');

    batch.update(documentReference, {'prods.$id.$unit': FieldValue.increment(0- (double.parse(num.toString()))),});

    return batch;
  }

  incStockFromInv(WriteBatch batch, id, unit, num) {
    DocumentReference documentReference =FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr');

    batch.update(documentReference, {'prods.$id.$unit': FieldValue.increment((double.parse(num.toString()))),});
    return batch;
  }

  sub1Execution(WriteBatch batch, subStock, subLink, id, num,) {
    //var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(id).get();
    if(double.parse(subStock) > double.parse(num)) {
      batch = decStockFromInv(batch, id, 'i1', num);
    } else {
      batch = decStockFromInv(batch, id, 'im', ((double.parse(num)  - double.parse(subStock))/double.parse(subLink)).ceil());
      batch = incStockFromInv(batch, id, 'i1', ((double.parse(num)- double.parse(subStock).round()) % double.parse(subLink)) == 0? 0: (double.parse(subLink) - (double.parse(num)-double.parse(subStock).round()) % double.parse(subLink)));
      batch = decStockFromInv(batch, id, 'i1', subStock);
    }
    return batch;
  }

  sub2Execution(WriteBatch batch, subStock, subLink, id, num) {
    //var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(id).get();
    if(double.parse(subStock) > double.parse(num)) {
      batch = decStockFromInv(batch, id, 'i2', num);
    } else {
      batch =  incStockFromInv(batch, id, 'i2', ((double.parse(num)-double.parse(subStock).round()) % double.parse(subLink)) == 0? 0: (double.parse(subLink) - (double.parse(num)-double.parse(subStock).round()) % double.parse(subLink)));
      batch = decStockFromInv(batch, id, 'i2', subStock);
      batch = sub1Execution(batch, subStock, subLink, id, ((double.parse(num)  - double.parse(subStock))/double.parse(subLink)).ceil().toString(),);
    }

    return batch;
  }


// Future<void> decStockFromInv(id, unit, num) async {
//   CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');
//
//   // debugPrint('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));
//
//   users
//       .doc(id)
//       .update({changeUnitName2Stock(unit): FieldValue.increment(0 - (double.parse(num.toString())))})
//       .then((value) => debugPrint("User Updated"))
//       .catchError((error) => debugPrint("Failed to update user: $error"));
// }
//
// Future<void> incStockFromInv(id, unit, num) async {
//   CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');
//
//   // debugPrint('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));
//
//   users
//       .doc(id)
//       .update({changeUnitName2Stock(unit): FieldValue.increment(double.parse(num.toString()))})
//       .then((value) => debugPrint("User Updated"))
//       .catchError((error) => debugPrint("Failed to update user: $error"));
// }
//
// Future<void> sub1Execution(subStock, subLink, id, num) async {
//   var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(id).get();
//   if (docSnapshot10.exists) {
//     Map<String, dynamic>? data10 = docSnapshot10.data();
//     subStock[1] = double.parse((data10 ? ['inStock2']).toString());
//     if(subStock[1] > double.parse(num)) {
//       decStockFromInv(id, 'sub1', num);
//     } else {
//       decStockFromInv(id, 'main', ((int.parse(num)  - subStock[1])/int.parse(subLink[0])).ceil());
//       incStockFromInv(id, 'sub1', ((int.parse(num)-subStock[1].round()) % int.parse(subLink[0])) == 0? 0: (int.parse(subLink[0]) - (int.parse(num)-subStock[1].round()) % int.parse(subLink[0])));
//       decStockFromInv(id, 'sub1', subStock[1]);
//     }0
//   }
// }
//
// Future<void> sub2Execution(subStock, subLink, id, num) async {
//   var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(id).get();
//   if (docSnapshot10.exists) {
//     Map<String, dynamic>? data10 = docSnapshot10.data();
//     subStock[2] = double.parse((data10 ? ['inStock3']).toString());
//     if(subStock[2] > double.parse(num)) {
//       decStockFromInv(id, 'sub2', num);
//     } else {
//       await incStockFromInv(id, 'sub2', ((int.parse(num)-subStock[2].round()) % int.parse(subLink[1])) == 0? 0: (int.parse(subLink[1]) - (int.parse(num)-subStock[2].round()) % int.parse(subLink[1])));
//       await decStockFromInv(id, 'sub2', subStock[2]);
//       sub1Execution(subStock, subLink, id, ((int.parse(num)  - subStock[2])/int.parse(subLink[1])).ceil().toString());
//     }
//   }
// }
}