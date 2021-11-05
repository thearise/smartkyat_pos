import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fragments/customers_fragment.dart';

import '../app_theme.dart';

class AddMerchant extends StatefulWidget {
  const AddMerchant({Key? key}) : super(key: key);

  @override
  _AddMerchantState createState() => _AddMerchantState();
}

class _AddMerchantState extends State<AddMerchant> {
  final mnameCtrl = TextEditingController();
  final maddressCtrl = TextEditingController();
  final mphoneCtrl = TextEditingController();
  static List<String> merchFieldsValue = [];
  final _formKey = GlobalKey<FormState>();
  bool prodAdding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                height: 75,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: AppTheme.skBorderColor, width: 2.0))),
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
                              if (mnameCtrl.text.length > 0) {
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
                            }),
                      ),
                      Text(
                        "Add Merchant",
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
                            onPressed: () {
                              merchFieldsValue = [];
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  prodAdding = true;
                                });
                                print(
                                    'validate ' + merchFieldsValue.toString());
                                var spaceDocId = '';

                                FirebaseFirestore.instance
                                    .collection('space')
                                    .where('user_id',
                                        isEqualTo: 'aHHin46ulpdoxOGh6kav8EDE4xn2')
                                    .get()
                                    .then((QuerySnapshot querySnapshot) {
                                  querySnapshot.docs.forEach((doc) {
                                    spaceDocId = doc.id;
                                  });

                                  print('space shi p thar');
                                  getStoreId().then((String result2) {
                                    print('store id ' + result2.toString());

                                    FirebaseFirestore.instance
                                        .collection('space')
                                        .doc('0NHIS0Jbn26wsgCzVBKT')
                                        .collection('shops')
                                        .doc('PucvhZDuUz3XlkTgzcjb')
                                        .collection('merchants')
                                        .add({
                                      'merchant_name': merchFieldsValue[0],
                                      'merchant_address': merchFieldsValue[1],
                                      'merchant_phone': merchFieldsValue[2],
                                    }).then((value) {
                                      print('product added 2');

                                      setState(() {
                                        prodAdding = false;
                                      });

                                      Navigator.pop(context);

                                      showFlash(
                                        context: context,
                                        duration: const Duration(seconds: 2),
                                        persistent: true,
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
                                                  top: 80.0),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0, right: 15.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: Colors.green,
                                                  ),
                                                  child: FlashBar(
                                                    title: Text('Title'),
                                                    content:
                                                        Text('Hello world!'),
                                                    // showProgressIndicator: true,
                                                    primaryAction: TextButton(
                                                      onPressed: () =>
                                                          controller.dismiss(),
                                                      child: Text('DISMISS',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .amber)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    });

                                    // FirebaseFirestore.instance.collection('space').doc(spaceDocId).collection('shops').doc(result2).collection('products').doc(value.id).collection('units')
                                    // .add({
                                    //   'prod_name': prodFieldsValue[0]
                                    // }).then((value) {
                                    //   print('product added 2');
                                    // });

                                    // Navigator.pop(context);
                                  });
                                });
                              }
                            }),
                      )
                    ],
                  ),
                )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                  child: ListView(
                children: [
                  Container(
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
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "MERCHANT NAME",
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
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: mnameCtrl,
// The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                merchFieldsValue.add(value);
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
                                labelText: 'Name',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
//filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "ADDRESS",
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
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: maddressCtrl,
// The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                merchFieldsValue.add(value);
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
                                labelText: 'Address',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
//filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "PHONE NUMBER",
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
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: mphoneCtrl,
// The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                merchFieldsValue.add(value);
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
                                labelText: 'Phone Number',
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
                    ),
                  ),
                ],
              )),
            ))
          ],
        ),
      ),
    );
  }
}
