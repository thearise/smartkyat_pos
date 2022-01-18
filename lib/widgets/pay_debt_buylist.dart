import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../app_theme.dart';

class PayDebtBuyList extends StatefulWidget {
  const PayDebtBuyList({Key? key, required this.documentId, required this.debt, required this.shopId, required this.data, required this.docId}) : super(key: key);
  final String debt;
  final String data;
  final String docId;
  final String shopId;
  final String documentId;
  @override
  _PayDebtBuyListState createState() => _PayDebtBuyListState();
}

class _PayDebtBuyListState extends State<PayDebtBuyList> {
  double paidAmount = 0;
  double refund = 0;
  double debtAmount =0;
  TextEditingController _textFieldController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _textFieldController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
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
      });       });

    super.initState();
  }

  bool disableTouch = false;
  bool loadingState = false;
  bool firstTime = true;
  double homeBotPadding = 0;
  @override
  Widget build(BuildContext context) {
    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
      firstTime = false;
    }
    // bottomNavigationBar: Padding(
    //   padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
    //   child: Container(
    //     color: Colors.white,
    //     child: Padding(
    //       padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0, bottom: 15.0),
    //       child: ButtonTheme(
    //         minWidth: MediaQuery.of(context).size.width,
    //         splashColor: Colors.transparent,
    //         height: 50,
    //         child: FlatButton(
    //           color: AppTheme.themeColor,
    //           shape: RoundedRectangleBorder(
    //             borderRadius:
    //             BorderRadius.circular(10.0),
    //             side: BorderSide(
    //               color: AppTheme.themeColor,
    //             ),
    //           ),
    //           onPressed: () async {
    //             if (_formKey.currentState!.validate()) {
    //               String dataRm = widget.data.split('^')[0] +
    //                   '^' +
    //                   widget.data.split('^')[1] +
    //                   '^' +
    //                   widget.data.split('^')[2] +
    //                   '^' +
    //                   widget.data.split('^')[3].split('&')[1] +
    //                   '^' +
    //                   widget.data.split('^')[4] + '^' + widget.data.split('^')[5] + '^' + widget.data.split('^')[6];
    //               String data = widget.data.split('^')[0] +
    //                   '^' +
    //                   widget.data.split('^')[1] +
    //                   '^' +
    //                   widget.data.split('^')[2] +
    //                   '^' +
    //                   widget.data.split('^')[3].split('&')[1] +
    //                   '^' +
    //                   widget.data.split('^')[4] + '^' + debtAmount.toString() + '^' + widget.data.split('^')[6];
    //
    //               CollectionReference dailyOrders = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders');
    //               CollectionReference order = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('order');
    //               CollectionReference customerDebt = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('customers');
    //
    //               dailyOrders.doc(widget.documentId).update({
    //                 'daily_order':
    //                 FieldValue.arrayRemove([dataRm])
    //               }).then((value) {print('array removed');})
    //                   .catchError((error) => print("Failed to update user: $error"));
    //
    //               dailyOrders.doc(widget.documentId).update({
    //                 'daily_order':
    //                 FieldValue.arrayUnion([data])
    //               }).then((value) { print('array updated');})
    //                   .catchError((error) => print("Failed to update user: $error"));
    //
    //               order.doc(
    //                   widget.docId)
    //                   .update({
    //                 'debt' : debtAmount
    //               })
    //                   .then((value) => print("User Updated"))
    //                   .catchError((error) => print("Failed to update user: $error"));
    //
    //               double debts = 0;
    //               if(debtAmount == 0.0) {
    //                 debts = 1;
    //               } else debts = 0;
    //               if( widget.data.split('^')[3].split('&')[1] !='name') {
    //                 customerDebt.doc(
    //                     widget.data.split('^')[3].split('&')[1])
    //                     .update({
    //                   'debtAmount' : FieldValue.increment( 0 - double.parse(paidAmount.toString())),
    //                   'debts' : FieldValue.increment( 0 - double.parse(debts.toString())),
    //                 })
    //                     .then((value) => print("User Updated"))
    //                     .catchError((error) => print("Failed to update user: $error"));}
    //
    //               _textFieldController.clear();
    //               Navigator.of(context).popUntil((route) => route.isFirst);
    //               smartKyatFlash('$debtAmount MMK is successfully paid to #' + widget.data.split('^')[1].toString(), 's');
    //             } },
    //           child: Padding(
    //             padding: const EdgeInsets.only(
    //                 left: 5.0,
    //                 right: 5.0,
    //                 bottom: 2.0),
    //             child: Container(
    //               child: Text(
    //                 'Done',
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                     fontSize: 18,
    //                     fontWeight: FontWeight.w600,
    //                     letterSpacing:-0.1
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // ),
    return Container(
      color:  Colors.white,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Column(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //       child: Container(
            //         height: 80,
            //         child:
            //         Row(
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.only(top: 0),
            //               child: Container(
            //                 width: 37,
            //                 height: 37,
            //                 decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.all(
            //                       Radius.circular(35.0),
            //                     ),
            //                     color: Colors.grey.withOpacity(0.3)),
            //                 child: Padding(
            //                   padding: const EdgeInsets.only(right: 3.0),
            //                   child: IconButton(
            //                       icon: Icon(
            //                         Icons.arrow_back_ios_rounded,
            //                         size: 17,
            //                         color: Colors.black,
            //                       ),
            //                       onPressed: () {
            //                         Navigator.pop(context);
            //                       }),
            //                 ),
            //               ),
            //             ),
            //             Spacer(),
            //             Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               // crossAxisAlignment: CrossAxisAlignment.end,
            //               children: [
            //                 Text('MMK ',
            //                   style: TextStyle(
            //                     fontSize: 13,
            //                     fontWeight: FontWeight.w500,
            //                     color: Colors.grey,
            //                   ),),
            //                 Text('#' +
            //                     'mainUnit',
            //                   style: TextStyle(
            //                     fontSize: 18,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 )
            //               ],
            //             ),
            //             Spacer(),
            //             Container(
            //               width: 37,
            //               height: 37,
            //               decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.all(
            //                     Radius.circular(35.0),
            //                   ),
            //                   color: Colors.grey.withOpacity(0.3)),
            //               child: Padding(
            //                 padding: const EdgeInsets.only(right: 3.0),
            //                 child: IconButton(
            //                     icon: Icon(
            //                       Icons.check,
            //                       size: 17,
            //                       color: Colors.black,
            //                     ),
            //                     onPressed: () async {
            //
            //                       String dataRm = widget.data.split('^')[0] +
            //                           '^' +
            //                           widget.data.split('^')[1] +
            //                           '^' +
            //                           widget.data.split('^')[2] +
            //                           '^' +
            //                           widget.data.split('^')[3].split('&')[1] +
            //                           '^' +
            //                           widget.data.split('^')[4] + '^' + widget.data.split('^')[5] + '^' + widget.data.split('^')[6];
            //                       String data = widget.data.split('^')[0] +
            //                           '^' +
            //                           widget.data.split('^')[1] +
            //                           '^' +
            //                           widget.data.split('^')[2] +
            //                           '^' +
            //                           widget.data.split('^')[3].split('&')[1] +
            //                           '^' +
            //                           widget.data.split('^')[4] + '^' + debtAmount.toString() + '^' + widget.data.split('^')[6];
            //
            //                       CollectionReference dailyOrders = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrders');
            //                       CollectionReference order = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrder');
            //                       CollectionReference customerDebt = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('merchants');
            //
            //                       dailyOrders.doc(widget.documentId).update({
            //                         'daily_order':
            //                         FieldValue.arrayRemove([dataRm])
            //                       }).then((value) {print('array removed');})
            //                           .catchError((error) => print("Failed to update user: $error"));
            //
            //                       dailyOrders.doc(widget.documentId).update({
            //                         'daily_order':
            //                         FieldValue.arrayUnion([data])
            //                       }).then((value) { print('array updated');})
            //                           .catchError((error) => print("Failed to update user: $error"));
            //
            //                       order.doc(
            //                           widget.docId)
            //                           .update({
            //                         'debt' : debtAmount
            //                       })
            //                           .then((value) => print("User Updated"))
            //                           .catchError((error) => print("Failed to update user: $error"));
            //
            //                       double debts = 0;
            //                       if(debtAmount == 0.0) {
            //                         debts = 1;
            //                       } else debts = 0;
            //                       if( widget.data.split('^')[3].split('&')[1] !='name') {
            //                         customerDebt.doc(
            //                             widget.data.split('^')[3].split('&')[1])
            //                             .update({
            //                           'debtAmount' : FieldValue.increment( 0 - double.parse(paidAmount.toString())),
            //                           'debts' : FieldValue.increment( 0 - double.parse(debts.toString())),
            //                         })
            //                             .then((value) => print("User Updated"))
            //                             .catchError((error) => print("Failed to update user: $error"));}
            //
            //                       _textFieldController.clear();
            //                       Navigator.of(context).popUntil((route) => route.isFirst);
            //                     }),
            //               ),
            //             ),
            //           ],
            //         ),
            //
            //       ),
            //     ),
            //     Container(
            //       height: 1,
            //       decoration: BoxDecoration(
            //           border: Border(
            //               bottom: BorderSide(
            //                   color: Colors.grey.withOpacity(0.3),
            //                   width: 1.0))),
            //     ),
            //   ],
            // ),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('MMK ' + widget.data.split('^')[2].toString(),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                // color: Colors.grey,
                              ),),
                            Text('#' +
                                widget.data.split('^')[1].toString() + ' - ' + widget.data.split('^')[3].split('&')[0].toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                        //           }).then((value) {print('array removed');})
                        //               .catchError((error) => print("Failed to update user: $error"));
                        //
                        //           dailyOrders.doc(widget.documentId).update({
                        //             'daily_order':
                        //             FieldValue.arrayUnion([data])
                        //           }).then((value) { print('array updated');})
                        //               .catchError((error) => print("Failed to update user: $error"));
                        //
                        //           order.doc(
                        //               widget.docId)
                        //               .update({
                        //             'debt' : debtAmount
                        //           })
                        //               .then((value) => print("User Updated"))
                        //               .catchError((error) => print("Failed to update user: $error"));
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
                        //               .then((value) => print("User Updated"))
                        //               .catchError((error) => print("Failed to update user: $error"));}
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
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                  Text('Debt Remaining - MMK', style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  )),
                                  SizedBox(height: 3),
                                  Text( debtAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: TextStyle(
                                    fontSize: 23, fontWeight: FontWeight.w500,
                                  )),
                                ],
                              )),
                          SizedBox(height: 15),
                          Text('CASH RECEIVED', style: TextStyle(
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
                              suffixText: 'MMK',
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
                              labelText: 'other amount',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              //filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.number,
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
                          SizedBox(height: 20,),
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
                                  color: Colors.grey.withOpacity(0.85),
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
                                child: Text( 'MMK ' +
                                    widget.debt.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
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
                            setState(() {
                              loadingState = true;
                              disableTouch =true;
                            });
                            String dataRm = widget.data.split('^')[0] +
                                '^' +
                                widget.data.split('^')[1] +
                                '^' +
                                widget.data.split('^')[2] +
                                '^' +
                                widget.data.split('^')[3].split('&')[1] +
                                '^' +
                                widget.data.split('^')[4] + '^' + widget.data.split('^')[5] + '^' + widget.data.split('^')[6];
                            String data = widget.data.split('^')[0] +
                                '^' +
                                widget.data.split('^')[1] +
                                '^' +
                                widget.data.split('^')[2] +
                                '^' +
                                widget.data.split('^')[3].split('&')[1] +
                                '^' +
                                widget.data.split('^')[4] + '^' + debtAmount.toString() + '^' + widget.data.split('^')[6];

                            CollectionReference dailyOrders = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrders');
                            CollectionReference order = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrder');
                            CollectionReference customerDebt = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('merchants');

                            dailyOrders.doc(widget.documentId).update({
                              'daily_order':
                              FieldValue.arrayRemove([dataRm])
                            }).then((value) {print('array removed');})
                                .catchError((error) => print("Failed to update user: $error"));

                            dailyOrders.doc(widget.documentId).update({
                              'daily_order':
                              FieldValue.arrayUnion([data])
                            }).then((value) { print('array updated');})
                                .catchError((error) => print("Failed to update user: $error"));

                            order.doc(
                                widget.docId)
                                .update({
                              'debt' : debtAmount
                            })
                                .then((value) => print("User Updated"))
                                .catchError((error) => print("Failed to update user: $error"));

                            double debts = 0;
                            if(debtAmount == 0.0) {
                              debts = 1;
                            } else debts = 0;
                            if( widget.data.split('^')[3].split('&')[1] !='name') {
                              customerDebt.doc(
                                  widget.data.split('^')[3].split('&')[1])
                                  .update({
                                'debtAmount' : FieldValue.increment( 0 - double.parse(paidAmount.toString())),
                                'debts' : FieldValue.increment( 0 - double.parse(debts.toString())),
                              })
                                  .then((value) => print("User Updated"))
                                  .catchError((error) => print("Failed to update user: $error"));}
                            Future.delayed(const Duration(milliseconds: 2000), () {
                              setState(() {
                                loadingState = false;
                                disableTouch = false;
                              });
                            });
                            _textFieldController.clear();
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            smartKyatFlash('MMK $debtAmount is successfully paid to #' + widget.data.split('^')[1].toString(), 's');
                          }
                        },
                        child: loadingState == true ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                            child: CupertinoActivityIndicator(radius: 10,)) :
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 5.0,
                              right: 5.0,
                              bottom: 2.0),
                          child: Container(
                            child: Text(
                              'Done',
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
    }

    else if(type == 'w') {
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
    }

    else if(type == 'e') {
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
    }

    else if(type == 'i') {
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
