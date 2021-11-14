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
        body: SafeArea(
      top: true,
      bottom: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 75,
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: AppTheme.skBorderColor, width: 2.0))),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        color: Colors.grey.withOpacity(0.3)),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 20,
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
                  Text(
                    "Fill Product",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'capsulesans',
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        color: AppTheme.skThemeColor2),
                    child: IconButton(
                        icon: Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () async {
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
                        }),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView(
                children: [
                  Container(
// height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                      color: Colors.white,
                    ),

                    child: Form(
                      key: _formKey,
                      child: StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
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
                              // var Sub1Name = output1?['sub1_name'];
                              // var Sub2Name = output1?['sub2_name'];
                              // var Sub3Name = output1?['sub3_name'];
                        return Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(top: 20, left: 15),
                                    child: Text(
                                      prodName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.5,
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(top: 20, left: 15),
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
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30) *
                                              (2.41 / 4),
                                          // child: TextField(
                                          //     controller: nameController,
                                          //     decoration: InputDecoration(labelText: 'Full Name')
                                          // ),
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
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                      borderSide:
                                                          const BorderSide(
                                                              color: AppTheme
                                                                  .skBorderColor,
                                                              width: 2.0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),

                                              focusedBorder:
                                                  const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                      borderSide:
                                                          const BorderSide(
                                                              color: AppTheme
                                                                  .skThemeColor2,
                                                              width: 2.0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 15.0,
                                                      right: 15.0,
                                                      top: 18.0,
                                                      bottom: 18.0),
                                              suffixText: 'Required',
                                              suffixStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontFamily: 'capsulesans',
                                              ),
                                              labelStyle: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
// errorText: 'Error message',
                                              labelText: 'Unit quantity',
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.auto,
//filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: TextFormField(
                                      controller: msaleCtrl,
// The validator receives the text that the user has entered.
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field is required';
                                        }
                                        prodFieldsValue.add(value);
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
                                                color: AppTheme.skThemeColor2,
                                                width: 2.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        contentPadding: const EdgeInsets.only(
                                            left: 15.0,
                                            right: 15.0,
                                            top: 18.0,
                                            bottom: 18.0),
                                        suffixText: 'MMK',
                                        suffixStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 12,
//fontFamily: 'capsulesans',
                                        ),
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
// errorText: 'Error message',
                                        labelText: 'Buy price',
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
//filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 15.0, right: 15.0),
//                                     child: TextFormField(
//                                       controller: mcostCtrl,
// // The validator receives the text that the user has entered.
//                                       validator: (value) {
//                                         if (value == null || value.isEmpty) {
//                                           return 'This field is required';
//                                         }
//                                         prodFieldsValue.add(value);
//                                         return null;
//                                       },
//                                       decoration: InputDecoration(
//                                         enabledBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                             borderSide: const BorderSide(
//                                                 color: AppTheme.skBorderColor,
//                                                 width: 2.0),
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(10.0))),
//
//                                         focusedBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                             borderSide: const BorderSide(
//                                                 color: AppTheme.skThemeColor2,
//                                                 width: 2.0),
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(10.0))),
//                                         contentPadding: const EdgeInsets.only(
//                                             left: 15.0,
//                                             right: 15.0,
//                                             top: 18.0,
//                                             bottom: 18.0),
//                                         suffixText: 'MMK',
//                                         suffixStyle: TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.grey,
//                                           fontSize: 12,
// //fontFamily: 'capsulesans',
//                                         ),
//                                         labelStyle: TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.black,
//                                         ),
// // errorText: 'Error message',
//                                         labelText: 'Sale price',
//                                         floatingLabelBehavior:
//                                             FloatingLabelBehavior.auto,
// //filled: true,
//                                         border: OutlineInputBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              );
                            }
                            return Container();
                          }),
                    ),
                  ),
                ],
              ),
            ),
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

  Padding createCard(subUnitname) {
    var nameController = TextEditingController();
    var ageController = TextEditingController();
    var jobController = TextEditingController();
    nameTECs.add(nameController);
    ageTECs.add(ageController);
    jobTECs.add(jobController);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  "#${cards.length + 1} SUB UNIT QUANTITY",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 2,
                    color: Colors.grey,
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(top: 15),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      cards.length--;
                      cards.remove(cards);
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Container(
                width: (MediaQuery.of(context).size.width - 30) * (2.41 / 4),
                // child: TextField(
                //     controller: nameController,
                //     decoration: InputDecoration(labelText: 'Full Name')
                // ),
                child: TextFormField(
                  controller: nameController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
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
                            color: AppTheme.skThemeColor2, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    contentPadding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                    suffixText: 'Required',
                    suffixStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'capsulesans',
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    // errorText: 'Error message',
                    labelText: 'Units / main unit',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: (MediaQuery.of(context).size.width - 30) * (1.41 / 4),
                child: Text(
                  subUnitname,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          TextFormField(
            controller: jobController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
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
                      color: AppTheme.skThemeColor2, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              contentPadding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
              suffixText: 'MMK',
              suffixStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 12,
                //fontFamily: 'capsulesans',
              ),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              // errorText: 'Error message',
              labelText: 'Sale price',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              //filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
