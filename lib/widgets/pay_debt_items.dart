import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';

class PayDebtItems extends StatefulWidget {
  const PayDebtItems({Key? key, required this.debt, required this.data, required this.docId}) : super(key: key);
final String debt;
final String data;
final String docId;
  @override
  _PayDebtItemsState createState() => _PayDebtItemsState();
}

class _PayDebtItemsState extends State<PayDebtItems> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                         // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('MMK ',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),),
                            Text('#' +
                                         'mainUnit',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                          ],
                        ),
                        Spacer(),
                        Container(
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
                                  Icons.check,
                                  size: 17,
                                  color: Colors.black,
                                ),
                                onPressed: () async {
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
                                  FirebaseFirestore.instance
                                      .collection('space')
                                      .doc('0NHIS0Jbn26wsgCzVBKT')
                                      .collection('shops')
                                      .doc('PucvhZDuUz3XlkTgzcjb')
                                      .collection('orders')
                                      .doc(widget.docId)
                                      .update({
                                    'daily_order':
                                    FieldValue.arrayRemove([dataRm])
                                  }).then((value) {
                                    print('array removed');

                                    FirebaseFirestore.instance
                                        .collection('space')
                                        .doc('0NHIS0Jbn26wsgCzVBKT')
                                        .collection('shops')
                                        .doc('PucvhZDuUz3XlkTgzcjb')
                                        .collection('orders')
                                        .doc(widget.docId)
                                        .update({
                                      'daily_order':
                                      FieldValue.arrayUnion([data])
                                    }).then((value) {
                                      print('array updated');  });
                                  });

                                  await FirebaseFirestore.instance.collection('space').doc(
                                      '0NHIS0Jbn26wsgCzVBKT').collection('shops').doc(
                                      'PucvhZDuUz3XlkTgzcjb').collection('orders').doc(
                                      widget.docId).collection('detail').doc(widget.data.split('^')[0])
                                      .update({
                                    'debt' : debtAmount
                                  })
                                      .then((value) => print("User Updated"))
                                      .catchError((error) => print("Failed to update user: $error"));

                                  await FirebaseFirestore.instance.collection('space').doc(
                                      '0NHIS0Jbn26wsgCzVBKT').collection('shops').doc(
                                      'PucvhZDuUz3XlkTgzcjb').collection('customers').doc(widget.data
                                      .split('^')[3]
                                      .split('&')[1]).collection('orders').doc(widget.data.split('^')[0])
                                      .update({
                                    'debt' : debtAmount
                                  })
                                      .then((value) => print("User Updated"))
                                      .catchError((error) => print("Failed to update user: $error"));
                                  _textFieldController.clear();
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
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
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
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
                      height:  100,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Total Debt Amount', style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          )),
                          SizedBox(height: 3),
                          Text('MMK ' + widget.debt.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.w500,
                          )),
                        ],
                      )),
                  SizedBox(height: 20),
                  Text('MMK: Amount received', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500,
                  )),
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
                  Text('(OR)', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500,
                  )),
                  SizedBox(height: 20),
                  Text('Type other amount', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500,
                  )),
                  SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                    borderSide: const BorderSide(
                        color: AppTheme.skBorderColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),

                focusedBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                    borderSide: const BorderSide(
                        color: AppTheme.skThemeColor2, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                contentPadding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                suffixText: 'MMK',
                suffixStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                // errorText: 'Error message',
                labelText: 'other  amount',
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
                  Center(
                    child: Text('Debt Remaining - ' + debtAmount.toString(), style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500,
                    )),
                  ),
                ],
              ),

            ),
          ],
        ),
      ),

    );
  }
}
