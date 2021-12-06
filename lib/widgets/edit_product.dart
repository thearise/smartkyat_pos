
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/constants/picker_method.dart';
import 'package:smartkyat_pos/widgets2/method_list_view.dart';
import 'package:smartkyat_pos/widgets2/selected_assets_list_view.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show AssetEntity;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import '../app_theme.dart';
import 'package:async/async.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({Key? key,
    required this.image, required this.shopId, required this.prodId, required this.prodName, required this.mainQty,  required this.mainName,
    required this.mainBuy, required this.mainSell, required this.barcode,  required this.sub1perUnit, required this.sub1UnitName,
    required this.sub1Qty, required this.sub1Sell, required this.sub2perUnit, required this.sub2UnitName,
    required this.sub2Qty, required this.sub2Sell, required this.subExist,});
  final String shopId;
  final String prodId;
  final String prodName;
  final String barcode;
  final String mainQty;
  final String mainName;
  final String mainBuy;
  final String mainSell;
  final String sub1perUnit;
  final String sub1UnitName;
  final String sub1Qty;
  final String sub1Sell;
  final String sub2perUnit;
  final String sub2UnitName;
  final String sub2Qty;
  final String sub2Sell;
  final String subExist;
  final String image;


  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> isDisplayingDetail = ValueNotifier<bool>(true);
  List<AssetEntity> assets = <AssetEntity>[];
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
  String subExist= '';
  var photoArray = '';


  @override
 void initState() {
   prodNameCtrl.text = widget.prodName;
   barCodeCtrl.text = widget.barcode;
   mainQtyCtrl.text = widget.mainQty;
   mainUnitNameCtrl.text = widget.mainName;
   mainBuyCtrl.text = widget.mainBuy;
   mainSellCtrl.text = widget.mainSell;
   sub1perUnitCtrl.text = widget.sub1perUnit;
   sub1UnitNameCtrl.text = widget.sub1UnitName;
   sub1QtyCtrl.text = widget.sub1Qty;
   sub1SellCtrl.text = widget.sub1Sell;
   sub2perUnitCtrl.text = widget.sub2perUnit;
   sub2UnitNameCtrl.text = widget.sub2UnitName;
   sub2QtyCtrl.text = widget.sub2Qty;
   sub2SellCtrl.text = widget.sub2Sell;
   subExist = widget.subExist;
   photoArray = widget.image;
   super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
int addSubUnit = 0;
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
                                  widget.prodName,
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
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0),
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
                          child: Container(
                            height: assets.isNotEmpty ? 120 : 82,
                            child: Column(
                              children: [
                                if (assets.isNotEmpty)
                                  SelectedAssetsListView(
                                    assets: assets,
                                    isDisplayingDetail:
                                    isDisplayingDetail,
                                    onResult: onResult,
                                    onRemoveAsset: removeAsset,
                                  ),
                                Expanded(
                                  child: MethodListView(
                                    pickMethods: [
                                      PickMethod.cameraAndStay(
                                        maxAssetsCount: 1,
                                      ),
                                    ],
                                    onSelectMethod: selectAssets,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0),
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
                          padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0),
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
                              labelText: 'Barcode',
                              floatingLabelBehavior:
                              FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0),
                          child: Row(
                            children: [
                              Text(
                                'MAIN UNIT QUANTITY',
                                style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,color: Colors.grey,
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                 if(addSubUnit == 2 || subExist== '2') {
                                   setState(() {
                                     addSubUnit = 2;
                                   });
                                 } else { setState(() {
                                   addSubUnit++;
                                   //subExist = (int.parse(subExist) +1 ).toString();
                                 }); }

                                },
                                child: Text('SUB UNIT?', style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,color: Colors.blue,
                                ),),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0),
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
                          padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0),
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
                          padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0, bottom: 15.0),
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
                        (sub1perUnitCtrl.text != '' && sub1UnitNameCtrl.text != '' && sub1QtyCtrl.text != '0' && sub1SellCtrl.text != '') && (sub2perUnitCtrl.text == '' && sub2UnitNameCtrl.text == '' && sub2QtyCtrl.text == '0' && sub2SellCtrl.text == '')? createCard('1', 'main', sub1perUnitCtrl, sub1UnitNameCtrl, sub1QtyCtrl, sub1SellCtrl) :Container(),
                        sub1perUnitCtrl.text != '' && sub1UnitNameCtrl.text != '' && sub1QtyCtrl.text != '0' && sub1SellCtrl.text != '' &&
                        sub2perUnitCtrl.text != '' && sub2UnitNameCtrl.text != '' && sub2QtyCtrl.text != '0' && sub2SellCtrl.text != ''? Column(
                          children: [
                            createCard('1', 'main', sub1perUnitCtrl, sub1UnitNameCtrl, sub1QtyCtrl, sub1SellCtrl),
                            createCard('2', 'sub1', sub2perUnitCtrl, sub2UnitNameCtrl, sub2QtyCtrl, sub2SellCtrl),
                          ],
                        ) : Container(),
                        addSubUnit == 1 && subExist == '0'? createCard('1', 'main', sub1perUnitCtrl, sub1UnitNameCtrl, sub1QtyCtrl, sub1SellCtrl) : Container(),
                        addSubUnit == 1 && subExist == '1' ?  createCard('2', 'sub1', sub2perUnitCtrl, sub2UnitNameCtrl, sub2QtyCtrl, sub2SellCtrl) : Container(),
                        addSubUnit == 2 && subExist == '0' ?  Column(
                          children: [
                            createCard('1', 'main', sub1perUnitCtrl, sub1UnitNameCtrl, sub1QtyCtrl, sub1SellCtrl),
                            createCard('2', 'sub1', sub2perUnitCtrl, sub2UnitNameCtrl, sub2QtyCtrl, sub2SellCtrl),
                          ],
                        ) : Container(),
                        Padding(
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
                                  String subExistChange;
                                  String sub1Buy;
                                  String sub2Buy;
                                  var prodExist = false;

                                  CollectionReference productId = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');

                                  if (sub1perUnitCtrl.text != '' && sub2perUnitCtrl.text == ''){
                                    subExistChange = '1';
                                    sub1Buy = (double.parse(mainBuyCtrl.text)/double.parse(sub1perUnitCtrl.text)).toString();
                                    sub2Buy = '0';
                                  } else  if (sub1perUnitCtrl.text != '' && sub2perUnitCtrl.text != ''){
                                    subExistChange = '2';
                                    sub1Buy = (double.parse(mainBuyCtrl.text)/double.parse(sub1perUnitCtrl.text)).toString();
                                    sub2Buy = (double.parse(sub1Buy)/double.parse(sub2perUnitCtrl.text)).toString();
                                  } else {
                                    subExistChange ='0';
                                    sub1Buy = '0';
                                    sub2Buy = '0';
                                  }
                                  // productId.where('prod_name', isEqualTo: prodNameCtrl.text).get().then((QuerySnapshot
                                  // querySnapshot) async {
                                  //   querySnapshot.docs
                                  //       .forEach((doc) {
                                  //     prodExist = true1/;
                                  //   });
                                  //
                                  //   if (prodExist) {
                                  //     print('product already');
                                  //     var result =
                                  //     await showOkAlertDialog(
                                  //       context: context,
                                  //       title: 'Warning',
                                  //       message:
                                  //       'Product name already!',
                                  //       okLabel: 'OK',
                                  //     );
                                  //   } else {
                                  if (assets.length == 0) {
                                      productId.doc(widget.prodId).update({
                                        'prod_name' : prodNameCtrl.text,
                                        'bar_code' : barCodeCtrl.text,
                                        'inStock1' : int.parse(mainQtyCtrl.text.toString()),
                                        'unit_name' : mainUnitNameCtrl.text,
                                        'buyPrice1' : mainBuyCtrl.text,
                                        'unit_sell' : mainSellCtrl.text,
                                        'sub_exist' : subExistChange,
                                        'inStock2' : int.parse(sub1QtyCtrl.text.toString()),
                                        'sub1_link' : sub1perUnitCtrl.text,
                                        'sub1_name' : sub1UnitNameCtrl.text,
                                        'sub1_sell' : sub1SellCtrl.text,
                                        'inStock3' : int.parse(sub2QtyCtrl.text.toString()),
                                        'sub2_link' : sub2perUnitCtrl.text,
                                        'sub2_name' : sub2UnitNameCtrl.text,
                                        'sub2_sell' : sub2SellCtrl.text,
                                        'buyPrice2' : sub1Buy,
                                        'buyPrice3' : sub2Buy,
                                      }).then((value) => Navigator.pop(context)).catchError((error) => print("Failed to update: $error"));

                                // });
                                } else {
                                    for (int i = 0;
                                    i < assets.length;
                                    i++) {
                                      AssetEntity asset =
                                      assets.elementAt(i);
                                      asset.originFile.then((value) async {
                                        addProduct(value!).then((value) {
                                          photoArray = value.toString();
                                          productId.doc(widget.prodId).update({
                                            'prod_name' : prodNameCtrl.text,
                                            'bar_code' : barCodeCtrl.text,
                                            'inStock1' : int.parse(mainQtyCtrl.text.toString()),
                                            'unit_name' : mainUnitNameCtrl.text,
                                            'buyPrice1' : mainBuyCtrl.text,
                                            'unit_sell' : mainSellCtrl.text,
                                            'sub_exist' : subExistChange,
                                            'inStock2' : int.parse(sub1QtyCtrl.text.toString()),
                                            'sub1_link' : sub1perUnitCtrl.text,
                                            'sub1_name' : sub1UnitNameCtrl.text,
                                            'sub1_sell' : sub1SellCtrl.text,
                                            'inStock3' : int.parse(sub2QtyCtrl.text.toString()),
                                            'sub2_link' : sub2perUnitCtrl.text,
                                            'sub2_name' : sub2UnitNameCtrl.text,
                                            'sub2_sell' : sub2SellCtrl.text,
                                            'buyPrice2' : sub1Buy,
                                            'buyPrice3' : sub2Buy,
                                            'img_1' : photoArray.toString(),
                                          }).then((value) => Navigator.pop(context)).catchError((error) => print("Failed to update: $error"));
                                        }
                                        );
                                      });
                                    }

                                  } } },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    bottom: 2.0),
                                child: Container(
                                  child: Text(
                                    'Save Product',
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Future addProduct(File imageFile) async {
// ignore: deprecated_member_use
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("https://riftplus.me/smartkyat_pos/api/images_upload.php");
    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: Path.basename(imageFile.path));

    request.files.add(multipartFile);
    // request.fields['productname'] = controllerName.text;
    // request.fields['productprice'] = controllerPrice.text;
    // request.fields['producttype'] = controllerType.text;
    // request.fields['product_owner'] = globals.restaurantId;

    var respond = await request.send();
    final respStr = await respond.stream.bytesToString();
    if (respond.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
    print('her ' + respStr.toString());
    return respStr.toString();
  }

//   Future removeProduct(File imageFile) async {
// // ignore: deprecated_member_use
//     var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//     var length = await imageFile.length();
//     var uri = Uri.parse("https://riftplus.me/smartkyat_pos/api/images_upload.php");
//
//     var request = new http.MultipartRequest("POST", uri);
//
//     var multipartFile = new http.MultipartFile("image", stream, length,
//         filename: Path.basename(imageFile.path));
//
//     request.files.add(multipartFile);
//     // request.fields['productname'] = controllerName.text;
//     // request.fields['productprice'] = controllerPrice.text;
//     // request.fields['producttype'] = controllerType.text;
//     // request.fields['product_owner'] = globals.restaurantId;
//
//     var respond = await request.send();
//     final respStr = await respond.stream.bytesToString();
//     if (respond.statusCode == 200) {
//       print("Image Uploaded");
//     } else {
//       print("Upload Failed");
//     }
//     print('her ' + respStr.toString());
//     return respStr.toString();
//   }

   createCard(length, unit, controller1, controller2, controller3, controller4) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "#$length SUB UNIT QUANTITY",
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 0),
                child: GestureDetector(
                  onTap: () {
                    if(addSubUnit == 2) {
                    setState(() {
                      sub2perUnitCtrl.clear();
                      sub2QtyCtrl.text = '0';
                      sub2SellCtrl.clear();
                      sub2UnitNameCtrl.clear();
                      subExist = '0';
                      addSubUnit = 1;
                    });
                    } else if(addSubUnit == 0) {
                      if(subExist == '2') {
                      setState(() {
                        sub2perUnitCtrl.clear();
                        sub2QtyCtrl.text = '0';
                        sub2SellCtrl.clear();
                        sub2UnitNameCtrl.clear();
                        subExist = '1';
                        addSubUnit = 0;
                      });} else
                      if(subExist == '1') {
                        setState(() {
                          sub1perUnitCtrl.clear();
                          sub1QtyCtrl.text = '0';
                          sub1SellCtrl.clear();
                          sub1UnitNameCtrl.clear();
                          subExist = '0';
                          addSubUnit = 0;
                        });}
                    } else if(addSubUnit == 1){
                      if(subExist == '1') {
                      setState(() {
                        sub2perUnitCtrl.clear();
                        sub2QtyCtrl.text = '0';
                        sub2SellCtrl.clear();
                        sub2UnitNameCtrl.clear();
                        subExist = '1';
                        addSubUnit = 0;
                      });
                    }
                      if(subExist == '0') {
                        setState(() {
                          sub1perUnitCtrl.clear();
                          sub1QtyCtrl.text = '0';
                          sub1SellCtrl.clear();
                          sub1UnitNameCtrl.clear();
                          subExist = '0';
                          addSubUnit = 0;
                        });
                      }}
                  },
                  child: Text(
                    "REMOVE",
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Stack(
            children: [
              Row(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - 30) * (2.41 / 4),
                    child: TextFormField(
                      controller: controller1,
                      // The validator receives the text that the user has entered.
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
                        labelText: 'Units / $unit unit',
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
                    child: TextFormField(
                      controller: controller2,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ' Required ';
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
                        labelText: 'Unit name',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        //filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 71.0),
                child: TextFormField(
                  controller: controller3,
                  // The validator receives the text that the user has entered.
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
                    //suffixText: 'MMK',
                    // suffixStyle: TextStyle(
                    //   fontWeight: FontWeight.w500,
                    //   color: Colors.grey,
                    //   fontSize: 12,
                    //   //fontFamily: 'capsulesans',
                    // ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    errorStyle: TextStyle(
                        backgroundColor: Colors.white,
                        fontSize: 12,
                        fontFamily: 'capsulesans',
                        height: 0.1
                    ),
                    // errorText: 'Error message',
                    labelText: 'Unit Quantity',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 142.0, bottom: 13),
                child: TextFormField(
                  controller: controller4,
                  // The validator receives the text that the user has entered.
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
                    labelText: 'Sale price',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
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
    );
  }
  Future<void> selectAssets(PickMethod model) async {
    try {
      final List<AssetEntity>? result = await model.method(context, assets);
      print('ASSETS ' + result.toString());
      if (result != null) {
        assets = List<AssetEntity>.from(result);
        if (mounted) {
          setState(() {});
        }
      }
    } catch (error) {
      print('never reached');
    }


  }
  void removeAsset(int index) {
    assets.removeAt(index);
    if (assets.isEmpty) {
      isDisplayingDetail.value = true;
    }
    setState(() {});
  }
  void onResult(List<AssetEntity>? result) {
    if (result != null && result != assets) {
      assets = List<AssetEntity>.from(result);
      if (mounted) {
        setState(() {});
      }
    }
  }
}
