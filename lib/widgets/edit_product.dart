
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/constants/picker_method.dart';
import 'package:smartkyat_pos/fragments/subs/language_settings.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
import 'package:smartkyat_pos/widgets/qr_edit.dart';
import 'package:smartkyat_pos/widgets2/method_list_view.dart';
import 'package:smartkyat_pos/widgets2/selected_assets_list_view.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show AssetEntity;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import '../app_theme.dart';
import 'package:async/async.dart';

class EditProduct extends StatefulWidget {
  final _openCartBtn;
  const EditProduct({Key? key,
    required this.image, required this.shopId, required this.prodId, required this.prodName, required this.mainQty,  required this.mainName,
    required this.mainBuy, required this.mainSell, required this.barcode,  required this.sub1perUnit, required this.sub1UnitName,
    required this.sub1Qty, required this.sub1Sell, required this.sub2perUnit, required this.sub2UnitName,
    required this.sub2Qty, required this.sub2Sell, required this.subExist, required void openCartBtn()}) : _openCartBtn = openCartBtn,
        super(key: key);
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
  bool prodAdding = false;
 bool disableTouch = false;


  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

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

    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {

        });
      } else if(value=='english') {
        setState(() {

        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  int addSubUnit = 0;
  bool firstTime = true;
  double homeBotPadding = 0;
  @override
  Widget build(BuildContext context) {
    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
      firstTime = false;
    }
    return WillPopScope(
      onWillPop: () async {
        widget._openCartBtn();
        print('back key detected');
        return true;
      },
      child: Container(
        color: Colors.white,
        child: IgnorePointer(
          ignoring: disableTouch,
          child: SafeArea(
            top: true,
            bottom: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 81,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
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
                                    widget._openCartBtn();
                                    Navigator.pop(context);
                                  }),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                keyboardType: TextInputType.name,
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
                                keyboardType: TextInputType.text,
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
                                  suffixIcon: IconButton(
                                    icon: Image.asset('assets/system/barcode.png', height: 28,),
                                    onPressed: () async {
                                      print("Barcode");
                                      var code = await  Navigator.of(context).push(
                                          FadeRoute(page:
                                          QREditExample(prodName: widget.prodName,),
                                            )
                                        );
                                      barCodeCtrl.text = code;
                                      print('bar bar ' + code);
                                    },
                                  ),
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
                                      keyboardType: TextInputType.number,
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
                                      keyboardType: TextInputType.name,
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
                                keyboardType: TextInputType.number,
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
                                  suffixText: 'MMK',
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
                                keyboardType: TextInputType.number,
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
                                  suffixText: 'MMK',
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
                            (sub1perUnitCtrl.text != '' && sub1UnitNameCtrl.text != '' && sub1SellCtrl.text != '') && (sub2perUnitCtrl.text == '' && sub2UnitNameCtrl.text == '' &&  sub2SellCtrl.text == '')? createCard('1', 'main', sub1perUnitCtrl, sub1UnitNameCtrl, sub1QtyCtrl, sub1SellCtrl) :Container(),
                            sub1perUnitCtrl.text != '' && sub1UnitNameCtrl.text != '' && sub1SellCtrl.text != '' &&
                                sub2perUnitCtrl.text != '' && sub2UnitNameCtrl.text != '' && sub2SellCtrl.text != ''? Column(
                              children: [
                                createCard('1', 'main', sub1perUnitCtrl, sub1UnitNameCtrl, sub1QtyCtrl, sub1SellCtrl),
                                createCard('2', 'sub1', sub2perUnitCtrl, sub2UnitNameCtrl, sub2QtyCtrl, sub2SellCtrl),
                              ],
                            ) : Container(),

                            addSubUnit == 1 && subExist == '0'? createCard('1', 'main', sub1perUnitCtrl, sub1UnitNameCtrl, sub1QtyCtrl, sub1SellCtrl) : Container(),
                            addSubUnit == 1 && subExist == '1' ?  createCard('2', 'sub1', sub2perUnitCtrl, sub2UnitNameCtrl, sub2QtyCtrl, sub2SellCtrl) : Container(),
                            addSubUnit == 2 && subExist == '0' ?
                            Column(
                              children: [
                                createCard('1', 'main', sub1perUnitCtrl, sub1UnitNameCtrl, sub1QtyCtrl, sub1SellCtrl),
                                createCard('2', 'sub1', sub2perUnitCtrl, sub2UnitNameCtrl, sub2QtyCtrl, sub2SellCtrl),
                              ],
                            ) : Container(),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).viewInsets.bottom - 80 < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 141,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: homeBotPadding),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0, bottom: 15.0),
                        child:  ButtonTheme(
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
                                  prodAdding = true;
                                  disableTouch = true;
                                });
                                String subExistChange;
                                String sub1Buy;
                                String sub2Buy;
                                var prodExist = false;

                                CollectionReference productId = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');

                                if (sub1perUnitCtrl.text != '' && sub2perUnitCtrl.text == '') {
                                  subExistChange = '1';
                                  sub1Buy = (double.parse(mainBuyCtrl.text)/double.parse(sub1perUnitCtrl.text)).toString();
                                  sub2Buy = '0';
                                } else  if (sub1perUnitCtrl.text != '' && sub2perUnitCtrl.text != '') {
                                  subExistChange = '2';
                                  sub1Buy = (double.parse(mainBuyCtrl.text)/double.parse(sub1perUnitCtrl.text)).toString();
                                  sub2Buy = (double.parse(sub1Buy)/double.parse(sub2perUnitCtrl.text)).toString();
                                } else {
                                  subExistChange ='0';
                                  sub1Buy = '0';
                                  sub2Buy = '0';
                                }
                                productId.where('prod_name', isEqualTo: prodNameCtrl.text).get().then((QuerySnapshot
                                querySnapshot) async {
                                  querySnapshot.docs
                                      .forEach((doc) {
                                    prodExist = true;
                                  });

                                  if ( prodExist == true && prodNameCtrl.text != widget.prodName ) {
                                    print('product already');
                                    var result =
                                    await showOkAlertDialog(
                                      context: context,
                                      title: 'Warning',
                                      message:
                                      'Product name already!',
                                      okLabel: 'OK',
                                    );
                                    setState(() {
                                      disableTouch = false;
                                      prodAdding = false;
                                    });
                                  } else {
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
                                      }).then((value) {
                                      }).catchError((error) => print("Failed to update: $error"));

                                      Future.delayed(const Duration(milliseconds: 2000), () {
                                        setState(() {
                                          prodAdding = false;
                                          disableTouch = false;
                                        });
                                        Navigator.pop(context);
                                        widget._openCartBtn();
                                        smartKyatFlash(prodNameCtrl.text + ' is successfully updated.', 's');
                                      });

                                      // });
                                    } else {
                                      for (int i = 0;
                                      i < assets.length;
                                      i++)
                                      {
                                        AssetEntity asset = assets.elementAt(i);
                                        asset.originFile.then((value) async {
                                          addProduct(value!, photoArray).then((value) {
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
                                            }).then((value){ Navigator.pop(context);
                                            widget._openCartBtn();
                                            setState(() {
                                              prodAdding = false;
                                              disableTouch = false;
                                            });
                                            Navigator.pop(context);
                                            smartKyatFlash(prodNameCtrl.text + ' is successfully updated.', 's');
                                            }).catchError((error) => print("Failed to update: $error"));
                                          }
                                          );
                                        });
                                      }
                                    }  } });} },
                            child: prodAdding == true ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                child: CupertinoActivityIndicator(radius: 10,)) : Padding(
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future addProduct(File imageFile, String rm_image) async {
    print('RM path ' + rm_image.toString());
// ignore: deprecated_member_use
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("https://riftplus.me/smartkyat_pos/api/images_reup.php");
    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: Path.basename(imageFile.path));

    request.files.add(multipartFile);
    request.fields['rm_image'] = rm_image;
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
                      keyboardType: TextInputType.number,
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
                        //suffixText: 'Required',
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
                      keyboardType: TextInputType.name,
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
                        //suffixText: 'Required',
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
                  keyboardType: TextInputType.number,
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
                    // suffixText: 'MMK',
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
                  keyboardType: TextInputType.number,
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
}
