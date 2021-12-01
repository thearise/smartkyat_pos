import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fragments/customers_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page3.dart';

import '../app_theme.dart';

class FillProduct extends StatefulWidget {
  final _callback;
  final _callback3;
  const FillProduct(
      {Key? key,
      required this.idString, required this.unitname, required this.shopId,
      required void toggleCoinCallback(String str),
      required void toggleCoinCallback3(String str),})
      : _callback = toggleCoinCallback,
        _callback3 = toggleCoinCallback3;
  final String idString;
  final String unitname;
  final String shopId;

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

  final pnameCtrl = TextEditingController();
  final bcodeCtrl = TextEditingController();
  final munitCtrl = TextEditingController();
  final mnameCtrl = TextEditingController();
  final msaleCtrl = TextEditingController();
  final mcostCtrl = TextEditingController();
  bool prodAdding = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
      top: true,
      bottom: true,
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
          .collection('shops')
          .doc(widget.shopId)
          .collection('products')
          .doc(widget.idString)
          .snapshots(),
            builder: (BuildContext context, snapshot2) {
    if (snapshot2.hasData) {
    var output1 = snapshot2.data!.data();
    var prodName = output1?['prod_name'];
    var mainName = output1?[widget.unitname];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1.0))),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
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
                                if (msaleCtrl.text.length > 0 ||
                                    munitCtrl.text.length > 0) {
                                  showOkCancelAlertDialog(
                                    context: context,
                                    title: 'Are you sure?',
                                    message: 'You added data in some inputs.',
                                    defaultType: OkCancelAlertDefaultType.cancel,
                                  ).then((result) {
                                    if (result == OkCancelResult.ok) {
                                      Navigator.pop(context);
                                    }
                                  });
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                            ),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    prodName,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Refill Product',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
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
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(top: 15, left: 15, right: 15.0),
                                    child: Text(
                                      "MAIN UNIT QUANTITY",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        letterSpacing: 2,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0, top: 45),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: (MediaQuery.of(context).size.width - 30) * (2.41 / 4),
                                          child: TextFormField(
                                            controller: munitCtrl,
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
                                              suffixText: 'Required',
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
                                              labelText: 'Unit Quantity',
                                              floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
//filled: true
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30) *
                                              (1.41 / 4),
                                          child: Text(
                                            mainName,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0, top: 118),
                                    child: TextFormField(
                                      controller: msaleCtrl,
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
                                        labelText: 'Buy Price',
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
//filled: true
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 195),
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
                                              '-' +
                                              msaleCtrl.text +
                                              '-' +
                                              munitCtrl.text +
                                              '-' +
                                              'Phyo' +

                                              '-'+ widget.unitname +'-'+'1'.toString());
                                          print(widget.idString +
                                              '-' +
                                              msaleCtrl.text +
                                              '-' +
                                              munitCtrl.text +
                                              '-' +
                                              'Phyo' +

                                              '-'+ widget.unitname +'-'+'1'.toString());
                                          Navigator.pop(context);
                                        } },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0,
                                              right: 5.0,
                                              bottom: 2.0),
                                          child: Container(
                                            child: Text(
                                              'Add to Buy Cart',
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
                                  )
                                ],
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ); }
             return Container();
        }
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
}
