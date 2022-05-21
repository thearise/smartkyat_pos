import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/widgets_small/top80_app_bar.dart';

import '../app_theme.dart';

class PayDebtItems extends StatefulWidget {

  const PayDebtItems({Key? key, required this.documentId, required this.debt, required this.shopId, required this.data, required this.docId,});

final String debt;
final String data;
final String docId;
final String shopId;
final String documentId;

  @override
  _PayDebtItemsState createState() => _PayDebtItemsState();
}

class _PayDebtItemsState extends State<PayDebtItems> {
  double paidAmount = 0;
  double refund = 0;
  double debtAmount =0;
  TextEditingController _textFieldController = TextEditingController();

  bool loadingState = false;
  bool disableTouch = false;

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  String _getRegexString() =>
      r'[0-9]+[,.]{0,1}[0-9]*';

  final _formKey = GlobalKey<FormState>();

  String currencyUnit = 'MMK';
  String textSetDebt = 'Debt Remaining';
  String textSetCashRec = 'CASH RECEIVED';
  String textSetCusPrice = 'Custom price';
  String textSetDone = 'Done';

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

  @override
  initState() {

    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetDebt = 'ကျန်ငွေ';
          textSetCashRec = 'လက်ခံရရှိငွေ';
          textSetCusPrice = 'စိတ်ကြိုက်ပမာဏ';
          textSetDone = 'ပြီးပြီ';
        });
      } else if(value=='english') {
        setState(() {
          textSetDebt = 'Debt Remaining';
          textSetCashRec = 'CASH RECEIVED';
          textSetCusPrice = 'Custom amount';
          textSetDone = 'Done';
        });
      }
    });

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
    debtAmount = double.parse(widget.debt.toString());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _textFieldController.addListener((){
      print("value: ${_textFieldController.text}");
      setState(() {
        _textFieldController.text != '' ? paidAmount = double.parse(_textFieldController.text) : paidAmount = 0;
        if((double.parse(widget.debt.toString()) - paidAmount).isNegative){
          debtAmount = 0;
        } else { debtAmount = (double.parse(widget.debt.toString()) - paidAmount);
        }
        if((paidAmount - double.parse(widget.debt.toString())).isNegative){
          refund = 0;
        } else { refund = (paidAmount - double.parse(widget.debt.toString()));
        }
      });
    });
    super.initState();
  }

  bool firstTime = true;
  double homeBotPadding = 0;
  @override
  Widget build(BuildContext context) {
    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
      firstTime = false;
    }

    return IgnorePointer(
      ignoring: disableTouch,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Top80AppBar('#' +
                      widget.data.split('^')[1].toString() + ' (' + widget.data.split('^')[3].split('&')[0].toString() + ')', '$currencyUnit ' + (double.parse(widget.data.split('^')[2]).toStringAsFixed(1)).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')),
                  Expanded(
                    child: Container(
                      child: ListView(
                        children: [
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                          border: Border.all(
                                              color: Colors.grey.withOpacity(0.2),
                                              width: 1.0),
                                          color: AppTheme.lightBgColor),
                                      height:  133,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('$textSetDebt - $currencyUnit',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            )
                                          ),
                                          SizedBox(height: 8),
                                          Text( debtAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 23, fontWeight: FontWeight.w500,
                                            )
                                          ),
                                        ],
                                      )),
                                  SizedBox(height: 15),
                                  Text(textSetCashRec, style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 2,
                                    color: Colors.grey,
                                  ),),
                                  SizedBox(height: 15),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return ' This field is required ';
                                      }
                                      // prodFieldsValue.add(value);
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderSide: const BorderSide(
                                              color: AppTheme.skBorderColor, width: 2.0),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),

                                      focusedBorder: const OutlineInputBorder(
                                        // width: 0.0 produces a thin "hairline" border
                                          borderSide: const BorderSide(
                                              color: AppTheme.themeColor, width: 2.0),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                      contentPadding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
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
                                      // errorText: 'Error message',
                                      labelText: textSetCusPrice,
                                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                                      //filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                    onChanged: (value) {
                                      setState(() {
                                        value != '' ? paidAmount = double.parse(value) : paidAmount = 0.0;
                                        if((double.parse(widget.debt.toString()) - paidAmount).isNegative){
                                          debtAmount = 0;
                                        } else { debtAmount = (double.parse(widget.debt.toString()) - paidAmount);
                                        }
                                        if((paidAmount - double.parse(widget.debt.toString())).isNegative){
                                          refund = 0;
                                        } else { refund = (paidAmount - double.parse(widget.debt.toString()));
                                        }
                                      });
                                    },
                                    controller: _textFieldController,
                                  ),
                                  SizedBox(height: 20),
                                  ButtonTheme(
                                    minWidth: double.infinity,
                                    //minWidth: 50,
                                    splashColor: AppTheme.buttonColor2,
                                    height: 50,
                                    child: FlatButton(
                                      color: AppTheme.buttonColor2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7.0),
                                        side: BorderSide(
                                          color: AppTheme.buttonColor2,
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _textFieldController
                                              .text =
                                              widget.debt
                                                  .toString();
                                          paidAmount = double.parse(widget.debt.toString());
                                          debtAmount = 0;
                                          refund = 0;
                                        });
                                      },
                                      child: Container(
                                        child: Text( '$currencyUnit ' +
                                            widget.debt.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //       SizedBox(height: 20),
                                  //       Text('(OR)', style: TextStyle(
                                  //         fontSize: 16, fontWeight: FontWeight.w500,
                                  //       )),
                                  //       SizedBox(height: 20),
                                  //       Text('Type other amount', style: TextStyle(
                                  //         fontSize: 16, fontWeight: FontWeight.w500,
                                  //       )),
                                  //       SizedBox(height: 20),
                                  // TextFormField(
                                  //   validator: (value) {
                                  //     if (value == null || value.isEmpty) {
                                  //       return ' This field is required ';
                                  //     }
                                  //     // prodFieldsValue.add(value);
                                  //     return null;
                                  //   },
                                  //   decoration: InputDecoration(
                                  //     enabledBorder: const OutlineInputBorder(
                                  //       // width: 0.0 produces a thin "hairline" border
                                  //         borderSide: const BorderSide(
                                  //             color: AppTheme.skBorderColor, width: 2.0),
                                  //         borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  //
                                  //     focusedBorder: const OutlineInputBorder(
                                  //       // width: 0.0 produces a thin "hairline" border
                                  //         borderSide: const BorderSide(
                                  //             color: AppTheme.themeColor, width: 2.0),
                                  //         borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  //     contentPadding: const EdgeInsets.only(
                                  //         left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                                  //     suffixText: '$currencyUnit',
                                  //     suffixStyle: TextStyle(
                                  //       color: Colors.grey,
                                  //       fontSize: 12,
                                  //       fontFamily: 'capsulesans',
                                  //     ),
                                  //     errorStyle: TextStyle(
                                  //         backgroundColor: Colors.white,
                                  //         fontSize: 12,
                                  //         fontFamily: 'capsulesans',
                                  //         height: 0.1
                                  //     ),
                                  //     labelStyle: TextStyle(
                                  //       fontWeight: FontWeight.w500,
                                  //       color: Colors.black,
                                  //     ),
                                  //     // errorText: 'Error message',
                                  //     labelText: 'other amount',
                                  //     floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  //     //filled: true,
                                  //     border: OutlineInputBorder(
                                  //       borderRadius: BorderRadius.circular(10),
                                  //     ),
                                  //   ),
                                  //   keyboardType: TextInputType.number,
                                  //   onChanged: (value) {
                                  //     setState(() {
                                  //       value != '' ? paidAmount = double.parse(value) : paidAmount = 0.0;
                                  //       if((double.parse(widget.debt.toString()) - paidAmount).isNegative){
                                  //         debtAmount = 0;
                                  //       } else { debtAmount = (double.parse(widget.debt.toString()) - paidAmount);
                                  //       }
                                  //       if((paidAmount - double.parse(widget.debt.toString())).isNegative){
                                  //         refund = 0;
                                  //       } else { refund = (paidAmount - double.parse(widget.debt.toString()));
                                  //       }
                                  //     });
                                  //   },
                                  //   controller: _textFieldController,
                                  // ),
                                  SizedBox(height: 20,),
                                  // Center(
                                  //   child: Text('Debt Remaining - ' + debtAmount.toString(), style: TextStyle(
                                  //     fontSize: 16, fontWeight: FontWeight.w500,
                                  //   )),
                                  // ),
                                ],
                              ),

                            ),
                          ),

                        ],
                      ),
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
                                  setState(() {
                                    loadingState = true;
                                    disableTouch = true;
                                  });

                                  String noCustomer = '';

                                  if(widget.data.split('^')[3].split('&')[0] == 'No customer') {
                                    noCustomer = 'name';
                                  } else {noCustomer = widget.data.split('^')[3].split('&')[0];}

                                  var refundId = '';
                                  print('textpaid ' + paidAmount.toString());

                                  String dataRm = widget.data.split('^')[0] +
                                      '^' +
                                      widget.data.split('^')[1] +
                                      '^' +
                                      widget.data.split('^')[2] +
                                      '^' +
                                      widget.data.split('^')[3].split('&')[1] + '<>' + noCustomer +
                                      '^' +
                                      widget.data.split('^')[4] + '^' + widget.data.split('^')[5] + '^' + widget.data.split('^')[6];
                                  String data = widget.data.split('^')[0] +
                                      '^' +
                                      widget.data.split('^')[1] +
                                      '^' +
                                      widget.data.split('^')[2] +
                                      '^' +
                                      widget.data.split('^')[3].split('&')[1] + '<>' + noCustomer +
                                      '^' +
                                      widget.data.split('^')[4] + '^' + debtAmount.toString() + '^' + widget.data.split('^')[6];
                                  bool deFilter = false;
                                  double debts = 0;
                                  if(debtAmount == 0.0) {
                                    deFilter = false;
                                    debts = 1;
                                  } else {
                                    deFilter = true;
                                    debts = 0;
                                  }


                                  batch = await updateDailyOrder(batch, widget.documentId, dataRm, data);

                                  print('detAmount' + debtAmount.toString());

                                  batch = await updateOrderDetail(batch, widget.docId, debtAmount, deFilter);
                                  double paidCus = paidAmount;
                                  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('cusArr')
                                      .get()
                                      .then((DocumentSnapshot documentSnapshot) async {
                                    if (documentSnapshot.exists) {
                                      documentSnapshot['cus'].forEach((key, value) async {
                                        if(value['na'].toString() ==  widget.data.split('^')[3].split('&')[0].toString()) {
                                          batch = await updateRefund(batch, widget.data.split('^')[3].split('&')[1], debts, paidCus);
                                        }
                                      });
                                    }
                                    if( widget.data.split('^')[3].split('&')[1] == 'name') {
                                      batch = await updateRefund(batch, widget.data.split('^')[3].split('&')[1], debts, paidCus);
                                    }

                                    batch = await updateMonthlyData(batch, widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6), widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6) +  widget.data.split('^')[0].substring(6,8) + 'debt_cust', paidCus);
                                    batch = await updateYearlyData(batch, widget.data.split('^')[0].substring(0,4),  widget.data.split('^')[0].substring(0,4) +   widget.data.split('^')[0].substring(4,6)  + 'debt_cust', paidCus);

                                    try {
                                      print('loading state ' + loadingState.toString());
                                      batch.commit();
                                      Future.delayed(const Duration(milliseconds: 2000), () {
                                        loadingState = false;
                                        disableTouch = false;

                                        _textFieldController.clear();
                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                        smartKyatFlash('$debtAmount $currencyUnit is successfully paid to #' + widget.data.split('^')[1].toString(), 's');
                                      });
                                    } catch(error) {
                                      smartKyatFlash('An error occurred while payment process. Please try again later.', 'e');
                                      setState(() {
                                        loadingState = false;
                                        disableTouch = false;
                                      });
                                    }

                                  });

                                } },
                              child: loadingState == true ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                  child: CupertinoActivityIndicator(radius: 10,)) :
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    bottom: 2.0),
                                child: Container(
                                  child: Text(
                                    textSetDone,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing:-0.1
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
                  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
                  ),
                ],
              ),

        ),
      ),
    );
  }

  // keyboardSize(){
  //   double height = 0.0;
  //   if(MediaQuery.of(context).size.width > 900) {
  //     height = 141;
  //   } else {height = 141;}
  //   return height;
  // }
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

  updateMonthlyData(WriteBatch batch, id, field1, double price1) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_monthly').doc(id);
    batch.set(documentReference, {
      field1.toString() : FieldValue.increment(0 - double.parse(price1.toString())),

    }, SetOptions(merge: true));
    return batch;
  }

  updateYearlyData(WriteBatch batch, id, field1, double price1) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_yearly').doc(id);
    batch.set(documentReference, {
      field1.toString() : FieldValue.increment(0 - double.parse(price1.toString())),
    }, SetOptions(merge: true));
    return batch;
  }

  updateDailyOrder(WriteBatch batch, id, orgData, updateData) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders').doc(id);

    batch.update(documentReference, {
      'daily_order' :  FieldValue.arrayRemove([orgData]),
    });

    batch.update(documentReference, {
      'daily_order': FieldValue.arrayUnion([updateData])
    });
    return batch;
  }

  updateOrderDetail(WriteBatch batch, id,  debt, deF) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('order').doc(id);
    batch.update(documentReference, {
      'debt' : debt,
      'debt_filter' : deF,
    });
    return batch;
  }

  updateRefund(WriteBatch batch, id, totalDes, changeDes) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('customers').doc(id);
    DocumentReference documentReference2 =FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('cusArr');
    if(id != 'name') {
      batch.update(documentReference2, {
        'cus.' + id +'.de': FieldValue.increment(0 - double.parse(totalDes.toString())),
        'cus.' + id +'.da': FieldValue.increment(0 - double.parse(changeDes.toString())),
      });
    } else {
    batch.update(documentReference, {
      'debts' : FieldValue.increment(0 - double.parse(totalDes.toString())),
      'debtAmount' : FieldValue.increment(0 - double.parse(changeDes.toString())),
    });
    }
    return batch;
  }
}