import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class EditMerchant extends StatefulWidget {
  const EditMerchant({Key? key, required this.shopId, required this.merchId, required this.merchName, required this.merchAddress, required this.merchPhone});
  final String shopId;
  final String merchId;
  final String merchName;
  final String merchAddress;
  final String merchPhone;


  @override
  _EditMerchantState createState() => _EditMerchantState();
}

class _EditMerchantState extends State<EditMerchant> {

  final _formKey = GlobalKey<FormState>();
  final merchNameCtrl = TextEditingController();
  final merchAddressCtrl = TextEditingController();
  final merchPhoneCtrl = TextEditingController();

  @override
  void initState() {
    merchNameCtrl.text = widget.merchName;
    merchAddressCtrl.text = widget.merchAddress;
    merchPhoneCtrl.text = widget.merchPhone;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
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
                padding: const EdgeInsets.only(left: 18.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.merchName,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Edit Merchant',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0),
                          child: Text(
                            'MERCHANT INFORMATION',
                            style: TextStyle(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,color: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 45.0, right: 15.0, left:15.0),
                          child: TextFormField(
                            controller: merchNameCtrl,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' This field is required ';
                              }
                              return null;
                            },
                            style: TextStyle(
                              height: 0.95,
                            ),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                  borderSide: BorderSide(
                                      color: AppTheme.skBorderColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0))),

                              focusedBorder: OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                  borderSide: BorderSide(
                                      color: AppTheme.themeColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0))),
                              contentPadding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 20.0,
                                  bottom: 20.0),
                              //suffixText: 'Required',
                              suffixStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'capsulesans',
                              ),
                              // errorText: wrongPassword,
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
                          padding: const EdgeInsets.only(top: 117.0, right: 15.0, left:15.0),
                          child: TextFormField(
                            controller: merchAddressCtrl,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' This field is required ';
                              }
                              return null;
                            },
                            style: TextStyle(
                              height: 0.95,
                            ),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                  borderSide: BorderSide(
                                      color: AppTheme.skBorderColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0))),

                              focusedBorder: OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                  borderSide: BorderSide(
                                      color: AppTheme.themeColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0))),
                              contentPadding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 20.0,
                                  bottom: 20.0),
                              //suffixText: 'Required',
                              suffixStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'capsulesans',
                              ),
                              // errorText: wrongPassword,
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
                          padding: const EdgeInsets.only(top: 189.0, right: 15.0, left:15.0),
                          child: TextFormField(
                            controller: merchPhoneCtrl,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ' This field is required ';
                              }
                              return null;
                            },
                            style: TextStyle(
                              height: 0.95,
                            ),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                  borderSide: BorderSide(
                                      color: AppTheme.skBorderColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0))),

                              focusedBorder: OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                  borderSide: BorderSide(
                                      color: AppTheme.themeColor,
                                      width: 2.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0))),
                              contentPadding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 20.0,
                                  bottom: 20.0),
                              //suffixText: 'Required',
                              suffixStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'capsulesans',
                              ),
                              // errorText: wrongPassword,
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
                        Padding(
                          padding: const EdgeInsets.only(top: 261.0, right: 15.0, left:15.0),
                          child: ButtonTheme(
                            minWidth: MediaQuery
                                .of(context)
                                .size
                                .width,
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
                                CollectionReference customerLocate = await FirebaseFirestore.instance.collection('shops')
                                    .doc(widget.shopId)
                                    .collection('merchants');
                                if (_formKey.currentState!.validate()) {
                                  customerLocate.doc(widget.merchId).update({
                                    'merchant_name': merchNameCtrl.text,
                                    'merchant_address': merchAddressCtrl.text,
                                    'merchant_phone' : merchPhoneCtrl.text,
                                  });
                                }
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    bottom: 2.0),
                                child: Container(
                                  child: Text(
                                    'Save Merchant',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.1
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
