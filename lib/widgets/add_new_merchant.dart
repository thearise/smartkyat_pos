import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fragments/customers_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';

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

  String? shopId;

  @override
  void initState() {
    HomePageState().getStoreId().then((value) => shopId = value);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SafeArea(
            top: true,
            bottom: true,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
// mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  //   child: Text('CUSTOMER INFORMATION', style: TextStyle(
                                  //     letterSpacing: 1.5,
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 14,color: Colors.grey,
                                  //   ),),
                                  // ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 15.0, left: 15.0,),
                                            child: Text('MERCHANT INFORMATION', style: TextStyle(
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,color: Colors.grey,
                                            ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0, top: 30),
                                            child: TextFormField(
// The validator receives the text that the user has entered.
                                              controller: mnameCtrl,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return ' This field is required ';
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
                                                        color: AppTheme.themeColor,
                                                        width: 2.0),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                contentPadding: const EdgeInsets.only(
                                                    left: 15.0,
                                                    right: 15.0,
                                                    top: 18.0,
                                                    bottom: 18.0),
                                                suffixText: 'Required',
                                                errorStyle: TextStyle(
                                                    backgroundColor: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily: 'capsulesans',
                                                    height: 0.1
                                                ),
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0, top: 101),
                                            child: TextFormField(
                                              controller: maddressCtrl,
// The validator receives the text that the user has entered.
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return ' This field is required ';
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
                                                        color: AppTheme.themeColor,
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0, top: 172),
                                            child: TextFormField(
// The validator receives the text that the user has entered.
                                              controller: mphoneCtrl,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return ' This field is required ';
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
                                                        color: AppTheme.themeColor,
                                                        width: 2.0),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                contentPadding: const EdgeInsets.only(
                                                    left: 15.0,
                                                    right: 15.0,
                                                    top: 18.0,
                                                    bottom: 18.0),
                                                suffixText: 'Required',
                                                errorStyle: TextStyle(
                                                    backgroundColor: Colors.white,
                                                    fontSize: 12,
                                                    fontFamily: 'capsulesans',
                                                    height: 0.1
                                                ),
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
                                                labelText: 'Phone number',
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
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 50,),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      height: 91,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20),
                        child: Column(
                          children: [
                            ButtonTheme(
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
                                  merchFieldsValue = [];
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      prodAdding = true;
                                    });

                                    bool exist = false;
                                    var merchants =  await FirebaseFirestore.instance
                                        .collection('shops')
                                        .doc(shopId)
                                        .collection('merchants');

                                    print(
                                        'validate ' + merchFieldsValue.toString());
                                    // var spaceDocId = '';

                                    // await FirebaseFirestore.instance
                                    //     .collection('space')
                                    //     .where('user_id',
                                    //         isEqualTo: 'aHHin46ulpdoxOGh6kav8EDE4xn2')
                                    //     .get()
                                    //     .then((QuerySnapshot querySnapshot) {
                                    //   querySnapshot.docs.forEach((doc) {
                                    //     spaceDocId = doc.id;
                                    //   });
                                    //
                                    //   print('space shi p thar');
                                    //   getStoreId().then((String result2) async {
                                    //     print('store id ' + result2.toString());


                                    merchants.doc('name').get().then((DocumentSnapshot documentSnapshot) {
                                      if (documentSnapshot.exists) {
                                        exist = true;
                                        print('Document exists on the database');
                                      }
                                    });

                                    if(exist) {
                                      merchants.add({
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
                                    } else
                                    {
                                      merchants.doc('name').set({
                                        'merchant_name': 'Unknown',
                                        'debt': 0, }).then((value) {
                                        print('name created');
                                      });

                                      merchants.add({
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
                                      });}

                                    // });
                                    // });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0,
                                      right: 5.0,
                                      bottom: 3.0),
                                  child: Container(
                                    child: Text(
                                      'Add merchant',
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
                          ],
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
          prodAdding
              ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey.withOpacity(0.5),
            child: Center(
                child: Theme(
                    data: ThemeData(
                        cupertinoOverrideTheme: CupertinoThemeData(
                            brightness: Brightness.light)),
                    child: CupertinoActivityIndicator(
                      radius: 20,
                    ))),
          )
              : Container(),
        ],
      ),
    );
  }
}
