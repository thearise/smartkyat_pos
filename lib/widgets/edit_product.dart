
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({Key? key,  required this.shopId, required this.prodId, required this.prodName, required this.mainQty,  required this.mainName,  required this.mainBuy, required this.mainSell, required this.barcode});
  final String shopId;
  final String prodId;
  final String prodName;
  final String barcode;
  final String mainQty;
  final String mainName;
  final String mainBuy;
  final String mainSell;


  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();

  final prodNameCtrl = TextEditingController();
  final barCodeCtrl = TextEditingController();
  final mainQtyCtrl = TextEditingController();
  final mainUnitNameCtrl = TextEditingController();
  final mainBuyCtrl = TextEditingController();
  final mainSellCtrl = TextEditingController();
  final sub1perUnitCtrl = TextEditingController();
  final sub1UnitNameCtrl = TextEditingController();
  final sub1QtyCtrl = TextEditingController();
  final sub1SellCtrl = TextEditingController();
  final sub2perUnitCtrl = TextEditingController();
  final sub2UnitNameCtrl = TextEditingController();
  final sub2QtyCtrl = TextEditingController();
  final sub2SellCtrl = TextEditingController();

 @override
 void initState() {
   prodNameCtrl.text = widget.prodName;
   barCodeCtrl.text = widget.barcode;
   mainQtyCtrl.text = widget.mainQty;
   mainUnitNameCtrl.text = widget.mainName;
   mainBuyCtrl.text = widget.mainBuy;
   mainSellCtrl.text = widget.mainSell;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                                  'MMK 1000',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Edit Product',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              'PRODUCT INFORMATION',
                              style: TextStyle(
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: TextFormField(
                              controller: prodNameCtrl,
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
                                labelText: 'Product Name',
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
                            padding: const EdgeInsets.only(top: 15.0),
                            child: TextFormField(
                              controller: barCodeCtrl,
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
                                labelText: 'Barcode',
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
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text(
                              'MAIN UNIT QUANTITY',
                              style: TextStyle(
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              children: [
                                Container(
                                  width:
                                  (MediaQuery.of(context).size.width - 30) * (2.41 / 4),
                                  child: TextFormField(
                                    controller: mainQtyCtrl,
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
                                      labelText: 'Unit quantity',
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
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
                                  child: TextFormField(
                                    controller: mainUnitNameCtrl,
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
                                      labelText: 'Unit name',
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
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: TextFormField(
                              controller: mainBuyCtrl,
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
                                labelText: 'Buy price',
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
                            padding: const EdgeInsets.only(top: 15.0),
                            child: TextFormField(
                              controller: mainSellCtrl,
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
                                labelText: 'Sale price',
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
                            padding: const EdgeInsets.only(top: 15.0),
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
                                    var prodExist = false;
                                    CollectionReference productId = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');

                                    productId.where('prod_name', isEqualTo: prodNameCtrl.text).get().then((QuerySnapshot
                                    querySnapshot) async {
                                      querySnapshot.docs
                                          .forEach((doc) {
                                        prodExist = true;
                                      });

                                      if (prodExist) {
                                        print('product already');
                                        var result =
                                        await showOkAlertDialog(
                                          context: context,
                                          title: 'Warning',
                                          message:
                                          'Product name already!',
                                          okLabel: 'OK',
                                        );
                                      } else {
                                        productId.doc(widget.prodId).update({
                                          'prod_name' : prodNameCtrl.text,
                                          'bar_code' : barCodeCtrl.text,
                                          'inStock1' : int.parse(mainQtyCtrl.text.toString()),
                                          'unit_name' : mainUnitNameCtrl.text,
                                          'buyPrice1' : mainBuyCtrl.text,
                                          'unit_sell' : mainSellCtrl.text,
                                        }).then((value) => Navigator.pop(context))
                                            .catchError((error) => print("Failed to update: $error"));
                                        
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
                                      'Save Loss Product',
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
                        ],
                      ),
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
