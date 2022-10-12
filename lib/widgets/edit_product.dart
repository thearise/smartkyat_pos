
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/constants/picker_method.dart';
import 'package:smartkyat_pos/fragments/subs/language_settings.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';
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
  const EditProduct({Key? key, required this.isEnglish,
    required this.image, required this.shopId, required this.fromSearch,required this.prodId, required this.prodName, required this.mainQty,  required this.mainName,
    required this.mainBuy, required this.mainSell, required this.barcode,  required this.sub1perUnit, required this.sub1UnitName,
    required this.sub1Qty, required this.sub1Sell, required this.sub2perUnit, required this.sub2UnitName,
    required this.sub2Qty, required this.sub2Sell, required this.subExist, }) :
        super(key: key);
  final String shopId;
  final String prodId;
  final String prodName;
  final String barcode;
  final double mainQty;
  final String mainName;
  final double mainBuy;
  final double mainSell;
  final double sub1perUnit;
  final String sub1UnitName;
  final double sub1Qty;
  final double sub1Sell;
  final double sub2perUnit;
  final String sub2UnitName;
  final double sub2Qty;
  final double sub2Sell;
  final double subExist;
  final String image;
  final bool fromSearch;
  final bool isEnglish;

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
  double subExist = 0;
  var photoArray = '';
  bool prodAdding = false;
  bool disableTouch = false;

  String textSetEdit = 'Edit product';
  String textSetProductInfo = 'PRODUCT INFORMATION';
  String textSetProdName = 'Product name';
  String textSetBarcode = 'Barcode';
  String textSetMainUnitQty = 'MAIN UNIT QUANTITY';
  String textSetUnitQty = 'Unit quantity';
  String textSetUnitName = 'Unit name';
  String textSetBuyPrice = 'Buy price';
  String textSetSalePrice = 'Sale price';
  String textSetSub1UnitQty = '#1 SUB UNIT QUANTITY';
  String textSetSub2UnitQty = '#2 SUB UNIT QUANTITY';
  String textSetWarning = 'E.g, If this item were \"Cigarette 10 packs per 1 carton box\" then it could break down into \"10 / main carton box\".';
  String textSetWarning2 = 'E.g, If this item were \"20 cigarettes per 1 pack\" then it could break down into \"20 / #1 sub pack\".';
  String textSetRemove = 'REMOVE';
  String textSetUnitMain = 'Unit/main unit';
  String textSetSaveProd = 'Save';
  String textSetMoreUnit = 'More unit?';
  String textSetUnitSub = 'Unit/sub1 unit';

  bool unitLimit = false;

  bool priceWarning = false;



  String _getRegexString() =>
      r'[0-9]+[,.]{0,1}[0-9]*';

  String _getNum() =>
      r'[0-9]';


  String currencyUnit = 'MMK';

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }

  late BuildContext dialogContext;

  openOverAllSubLoading() {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.4),
      context: context,
      builder: (context) {
        dialogContext = context;
        return Container();
      },
    );
  }

  closeOverAllSubLoading() {
    Navigator.pop(dialogContext);
  }


  @override
  initState() {

    mainBuyCtrl.addListener((){
      if(mainBuyCtrl.text != '' && mainSellCtrl.text != '' && double.parse(mainBuyCtrl.text) > double.parse(mainSellCtrl.text)) {
        setState(() {
          priceWarning = true;
        });
        // if (_formKey.currentState!.validate()) {
        //   debugPrint('lee lar');
        // }
        debugPrint('Warning pya mal');
      } else {
        setState(() {
          priceWarning = false;
        });
        debugPrint('Warning ma pya bu');}
    });

    mainSellCtrl.addListener((){
      if(mainSellCtrl.text != '' && mainBuyCtrl.text != '' && double.parse(mainBuyCtrl.text) > double.parse(mainSellCtrl.text)) {
        setState(() {
          priceWarning = true;
        });
        debugPrint('Warning pya mal');
      } else {
        setState(() {
          priceWarning = false;
        });
        debugPrint('Warning ma pya bu');}
    });

    getCurrency().then((value){
      if(value == 'US Dollar (USD)') {
        setState(() {
          currencyUnit = 'USD';
        });
      } else if(value == 'Myanmar Kyat (MMK)') {
        setState(() {
          currencyUnit = 'MMK';
        });
      }
    });
    prodNameCtrl.text = widget.prodName;
    barCodeCtrl.text = widget.barcode;
    mainQtyCtrl.text = double.parse(widget.mainQty.toString()).round().toString();
    mainUnitNameCtrl.text = widget.mainName;
    mainBuyCtrl.text = widget.mainBuy.toString();
    mainSellCtrl.text = widget.mainSell.toString();
    sub1perUnitCtrl.text = widget.sub1perUnit.toString();
    sub1UnitNameCtrl.text = widget.sub1UnitName;
    sub1QtyCtrl.text = double.parse(widget.sub1Qty.toString()).round().toString();
    sub1SellCtrl.text = widget.sub1Sell.toString();
    sub2perUnitCtrl.text = widget.sub2perUnit.toString();
    sub2UnitNameCtrl.text = widget.sub2UnitName;
    sub2QtyCtrl.text = double.parse(widget.sub2Qty.toString()).round().toString();
    sub2SellCtrl.text = widget.sub2Sell.toString();
    subExist = widget.subExist;
    photoArray = widget.image;

    // debugPrint('photo check ' + widget.sub1UnitName.toString() + widget.subExist.toString());

    if(widget.isEnglish == true) {

      setState(() {
        textSetEdit = 'Edit product';
        textSetProductInfo = 'PRODUCT INFORMATION';
        textSetProdName = 'Product name';
        textSetBarcode = 'Barcode';
        textSetMainUnitQty = 'MAIN UNIT INFORMATION';
        textSetUnitQty = 'Unit quantity';
        textSetUnitName = 'Unit name';
        textSetBuyPrice = 'Buy price';
        textSetSalePrice = 'Sale price';
        textSetSub1UnitQty = '#1 SUB UNIT INFORMATION';
        textSetSub2UnitQty = '#2 SUB UNIT INFORMATION';
        textSetWarning = 'e.g, If this item were \"Cigarette 10 packs per 1 carton box\" then it could break down into \"10 / main carton box\".';
        textSetWarning2 = 'e.g, If this item were \"20 cigarettes per 1 pack\" then it could break down into \"20 / #1 sub pack\".';
        textSetRemove = 'REMOVE';
        textSetUnitMain = 'Qty/ main unit';
        textSetSaveProd = 'Add product';
        textSetMoreUnit = 'More unit?';
        textSetUnitSub = 'Unit/#1 unit';
      });
    } else {
      setState(() {
        textSetEdit = 'ပစ္စည်း ပြင်ဆင်ခြင်း';
        textSetProductInfo = 'PRODUCT INFORMATION';
        // textSetProductInfo = 'ပစ္စည်း အချက်အလက်';
        textSetProdName = 'ပစ္စည်းအမည်';
        textSetBarcode = 'ဘားကုဒ်';
        textSetMainUnitQty = 'MAIN UNIT INFORMATION';
        // textSetMainUnitQty = 'အဓိကယူနစ် အချက်အလက်';
        textSetUnitQty = 'အရေအတွက်';
        textSetUnitName = 'ယူနစ်အမည်';
        textSetBuyPrice = 'ဝယ်ဈေး';
        textSetSalePrice = 'ရောင်းဈေး';
        textSetSub1UnitQty = '#1 ယူနစ် အချက်အလက်';
        textSetSub2UnitQty = '#2 ယူနစ် အချက်အလက်';
        textSetWarning = 'e.g, If this item were \"Cigarette 10 packs per 1 carton box\" then it could break down into \"10 / main carton box\".';
        textSetWarning2 = 'e.g, If this item were \"20 cigarettes per 1 pack\" then it could break down into \"20 / #1 sub pack\".';
        textSetRemove = 'ပယ်ဖျက်မည်';
        textSetUnitMain = 'အရေတွက်/ အဓိကယူနစ်';
        textSetSaveProd = 'သိမ်းဆည်းမည်';
        textSetMoreUnit = 'ယူနစ်?';
        textSetUnitSub = 'အရေတွက်/ #1ယူနစ်';
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  textSplitFunction(String text) {
    List example = text.runes.map((rune) => new String.fromCharCode(rune)).toList();
    List result = [];
    String intResult = '';
    int i = 0;
    for(int j =0; j<example.length; j++) {
      for(i = j ; i<example.length; i++) {
        intResult = intResult + example[i].toString();
        result.add(intResult.toLowerCase());
      }
      intResult = '';
    }
    return result;
  }


  int addSubUnit = 0;
  bool firstTime = true;
  double homeBotPadding = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 900
        ? MediaQuery.of(context).size.width * (2 / 3.5)
        : MediaQuery.of(context).size.width;
    // homeBotPadding = MediaQuery.of(context).padding.bottom;
    debugPrint('homebotpad ' + homeBotPadding.toString());
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
      firstTime = false;
    }
    return Container(
      color: Colors.white,
      child: IgnorePointer(
        ignoring: disableTouch,
        child: SafeArea(
          top: true,
          bottom: false,
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
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                textSetEdit, textScaleFactor: 1,
                                maxLines: 1,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis
                                  // height: 1.5
                                ),
                                strutStyle: StrutStyle(
                                  height: 1.4,
                                  // fontSize:,
                                  forceStrutHeight: true,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 0.0),
                              child: Text(
                                widget.prodName, textScaleFactor: 1,
                                maxLines: 1,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                  // height: 1.3
                                ),
                                strutStyle: StrutStyle(
                                  height: 1.7,
                                  // fontSize:,
                                  forceStrutHeight: true,
                                ),
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
                                textSetProductInfo, textScaleFactor: 1,
                                style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,color: Colors.grey,
                                ),
                                strutStyle: StrutStyle(
                                  height: widget.isEnglish? 1.4: 1.6,
                                  forceStrutHeight: true,
                                )
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
                                      isEnglish: widget.isEnglish,
                                      pickMethods: [
                                        PickMethod.cameraAndStay(
                                          maxAssetsCount: 1, lang: widget.isEnglish? 'en': 'mm',
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
                            child: Container(
                              height: 69,
                              child: TextFormField(
                                controller: prodNameCtrl,
                                keyboardType: TextInputType.text,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(30),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return ' This field is required ';
                                  }
                                  if(value.length > 30 ) {
                                    return '  You have reached maximum no of characters.';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  height: 0.95,
                                  fontSize: 15 / scaleFactor,
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
                                    fontSize: 12/scaleFactor,
                                    fontFamily: 'capsulesans',
                                  ),
                                  // errorText: wrongPassword,
                                  errorStyle: TextStyle(
                                      backgroundColor: Colors.white,
                                      fontSize: 12/scaleFactor,
                                      fontFamily: 'capsulesans',
                                      height: 0.1
                                  ),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
// errorText: 'Error message',
                                  labelText: textSetProdName,
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
//filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0, right: 15.0, left:15.0),
                            child: Container(
                              height: 69,
                              child: TextFormField(
                                controller: barCodeCtrl,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  return null;
                                },
                                style: TextStyle(
                                  height: 0.95,
                                  fontSize: 15 / scaleFactor,
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
                                      debugPrint("Barcode");
                                      var code = await  Navigator.of(context).push(
                                          FadeRoute(page:
                                          QREditExample(prodName: widget.prodName, isEnglish: widget.isEnglish),
                                          )
                                      );
                                      barCodeCtrl.text = code;
                                      debugPrint('bar bar ' + code);
                                    },
                                  ),
                                  suffixStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12/scaleFactor,
                                    fontFamily: 'capsulesans',
                                  ),
                                  // errorText: wrongPassword,
                                  errorStyle: TextStyle(
                                      backgroundColor: Colors.white,
                                      fontSize: 12/scaleFactor,
                                      fontFamily: 'capsulesans',
                                      height: 0.1
                                  ),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  labelText: textSetBarcode,
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0, left: 15.0),
                            child: Container(
                              color: AppTheme.skBorderColor2,
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0),
                            child: Text(
                                textSetMainUnitQty, textScaleFactor: 1,
                                style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,color: Colors.grey,
                                ),
                                strutStyle: StrutStyle(
                                  height: widget.isEnglish? 1.4: 1.6,
                                  forceStrutHeight: true,
                                )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 69,
                                    child: TextFormField(
                                      controller: mainQtyCtrl,
                                      keyboardType: TextInputType.numberWithOptions(decimal: false),

                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(_getNum())),
                                        LengthLimitingTextInputFormatter(15),
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return ' This field is required ';
                                        }
                                        return null;
                                      },
                                      style: TextStyle(
                                        height: 0.95,
                                        fontSize: 15 / scaleFactor,
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
                                          fontSize: 12/scaleFactor,
                                          fontFamily: 'capsulesans',
                                        ),
                                        // errorText: wrongPassword,
                                        errorStyle: TextStyle(
                                            backgroundColor: Colors.white,
                                            fontSize: 12/scaleFactor,
                                            fontFamily: 'capsulesans',
                                            height: 0.1
                                        ),
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
// errorText: 'Error message',
                                        labelText: textSetUnitQty,
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
//filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Container(
                                  height: 69,
                                  width: (width - 30) * (1.41 / 4),
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
                                      fontSize: 15 / scaleFactor,
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
                                        fontSize: 12/scaleFactor,
                                        fontFamily: 'capsulesans',
                                      ),
                                      // errorText: wrongPassword,
                                      errorStyle: TextStyle(
                                          backgroundColor: Colors.white,
                                          fontSize: 12/scaleFactor,
                                          fontFamily: 'capsulesans',
                                          height: 0.1
                                      ),
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
// errorText: 'Error message',
                                      labelText: textSetUnitName,
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
                            padding: const EdgeInsets.only(top: 0.0, right: 15.0, left:15.0),
                            child: Container(
                              height: 69,
                              child: TextFormField(
                                controller: mainBuyCtrl,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: <TextInputFormatter>[  LengthLimitingTextInputFormatter(15),
                                  FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return ' This field is required ';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                  height: 0.95,
                                  fontSize: 15 / scaleFactor,
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
                                  suffixText: '$currencyUnit',
                                  suffixStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12/scaleFactor,
                                    fontFamily: 'capsulesans',
                                  ),
                                  // errorText: wrongPassword,
                                  errorStyle: TextStyle(
                                      backgroundColor: Colors.white,
                                      fontSize: 12/scaleFactor,
                                      fontFamily: 'capsulesans',
                                      height: 0.1
                                  ),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
// errorText: 'Error message',
                                  labelText: textSetBuyPrice,
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
//filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0, right: 15.0, left:15.0, bottom: 0.0),
                            child: Container(
                              height: 69,
                              child: Stack(
                                children: [
                                  TextFormField(
                                    controller: mainSellCtrl,
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp(_getRegexString())),  LengthLimitingTextInputFormatter(15),],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return ' This field is required ';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                      height: 0.95,
                                      fontSize: 15 / scaleFactor,
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
                                      suffixText: '$currencyUnit',
                                      suffixStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12/scaleFactor,
                                        fontFamily: 'capsulesans',
                                      ),
                                      // errorText: wrongPassword,
                                      errorStyle: TextStyle(
                                          backgroundColor: Colors.white,
                                          fontSize: 12/scaleFactor,
                                          fontFamily: 'capsulesans',
                                          height: 0.1
                                      ),
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
// errorText: 'Error message',
                                      labelText: textSetSalePrice,
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
//filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  priceWarning ? Padding(
                                    padding: const EdgeInsets.only(left: 15.0, top: 43, right: 15),
                                    child: Container(
                                      height: 69,
                                      color: Colors.white,
                                      //height: 20,
                                      child: Text(' Price warning ', textScaleFactor: 1,
                                        style: TextStyle(
                                          color: Colors.amber, fontSize: 12, fontWeight: FontWeight.w500,
                                        ),),
                                    ),
                                  ) : Container(),
                                ],
                              ),
                            ),
                          ),
                          (sub1UnitNameCtrl.text != '') && (sub2UnitNameCtrl.text == '') && subExist == 1 || (sub1UnitNameCtrl.text != '') && (sub2UnitNameCtrl.text != '') && subExist == 1 ? createCard('1', widget.isEnglish? 'main': 'အဓိက', sub1perUnitCtrl, sub1UnitNameCtrl, sub1QtyCtrl, sub1SellCtrl, textSetWarning) : Container(),
                          (sub1UnitNameCtrl.text != '') && (sub2UnitNameCtrl.text != '' )  && subExist == 2 ? Column(
                            children: [
                              createCard('1', widget.isEnglish? 'main': 'အဓိက', sub1perUnitCtrl, sub1UnitNameCtrl, sub1QtyCtrl, sub1SellCtrl, textSetWarning),
                              createCard('2', widget.isEnglish? '#1 sub ': '#1 အခွဲ', sub2perUnitCtrl, sub2UnitNameCtrl, sub2QtyCtrl, sub2SellCtrl, textSetWarning2),
                            ],
                          ) : Container(),

                          addSubUnit == 1 && subExist == 0? createCard('1', widget.isEnglish? 'main': 'အဓိက', sub1perUnitCtrl, sub1UnitNameCtrl, sub1QtyCtrl, sub1SellCtrl, textSetWarning) : Container(),
                          addSubUnit == 1 && subExist == 1 ?  createCard('2', widget.isEnglish? '#1 sub ': '#1 အခွဲ', sub2perUnitCtrl, sub2UnitNameCtrl, sub2QtyCtrl, sub2SellCtrl, textSetWarning2) : Container(),
                          addSubUnit == 2 && subExist == 0 ?
                          Column(
                            children: [
                              createCard('1', widget.isEnglish? 'main': 'အဓိက', sub1perUnitCtrl, sub1UnitNameCtrl, sub1QtyCtrl, sub1SellCtrl, textSetWarning),
                              createCard('2', widget.isEnglish? '#1 sub ': '#1 အခွဲ', sub2perUnitCtrl, sub2UnitNameCtrl, sub2QtyCtrl, sub2SellCtrl, textSetWarning2),
                            ],
                          ) : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  // padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width > 900 ? homeBotPadding + 20: homeBotPadding),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width > 900 ? 0 + 20: homeBotPadding),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0, bottom: 15.0),
                      child:  Column(
                        children: [
                          Row(
                            children: [
                              if(subExist != 2)
                                if(!unitLimit)
                                  ButtonTheme(
                                    splashColor: Colors.transparent,
                                    height: 50,
                                    child: FlatButton(
                                      color: AppTheme.buttonColor2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      onPressed: () async {
                                        if(addSubUnit == 2 || subExist == 2) {
                                          setState(() {
                                            unitLimit = true;
                                            addSubUnit = 2;
                                          });
                                        } else {
                                          setState(() {
                                            addSubUnit++;
                                          });
                                        }

                                        if(addSubUnit == 1 &&  subExist== 1 || addSubUnit == 2  &&  subExist== 0) {
                                          setState(() {
                                            unitLimit = true;
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                            bottom: 3.0),
                                        child: Container(
                                          child: Text(
                                              textSetMoreUnit, textScaleFactor: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing:-0.1
                                              ),
                                              strutStyle: StrutStyle(
                                                height: widget.isEnglish? 1.4: 1.6,
                                                forceStrutHeight: true,
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              if(subExist != 2)
                                if(!unitLimit)
                                  SizedBox(
                                      width: 15.0
                                  ),
                              Expanded(
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
                                          prodAdding = true;
                                          disableTouch = true;
                                        });
                                        openOverAllSubLoading();
                                        String subExistChange;
                                        String sub1Buy;
                                        String sub2Buy;
                                        List <String> productExist = [];
                                        var prodExist = false;

                                        CollectionReference productId = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');

                                        if (double.parse(sub1perUnitCtrl.text) != 0 && double.parse(sub2perUnitCtrl.text) == 0.0) {
                                          subExistChange = '1';
                                          sub1Buy = (double.parse(mainBuyCtrl.text)/double.parse(sub1perUnitCtrl.text)).toString();
                                          sub2Buy = '0';
                                        } else  if (double.parse(sub1perUnitCtrl.text) != 0 && double.parse(sub2perUnitCtrl.text) != 0) {
                                          subExistChange = '2';
                                          sub1Buy = (double.parse(mainBuyCtrl.text)/double.parse(sub1perUnitCtrl.text)).toString();
                                          sub2Buy = (double.parse(sub1Buy)/double.parse(sub2perUnitCtrl.text)).toString();
                                        } else {
                                          subExistChange ='0';
                                          sub1Buy = '0';
                                          sub2Buy = '0';
                                        }
                                        debugPrint('whatting 0 ?' + subExistChange + ' ' + sub2perUnitCtrl.text);


                                        FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr')
                                            .get()
                                            .then((DocumentSnapshot documentSnapshot) async {
                                          debugPrint('whatting? 2');
                                          if (documentSnapshot.exists) {
                                            debugPrint('whatting? 3');
                                            // documentSnapshot['prods'].forEach((key, value) {
                                            //
                                            //   productExist.add( value['na'].toString());
                                            //
                                            // });

                                            documentSnapshot['prods'].forEach((key, value) async {
                                              if(value['na'] ==  prodNameCtrl.text && key.toString() != widget.prodId) {
                                                // setState(() {
                                                prodExist = true;
                                                // });

                                                debugPrint('document print no image ' + productExist.toString());
                                                debugPrint('document print no image ' + prodExist.toString());
                                              }
                                              debugPrint('val ' + value['na'].toString());

                                            });

                                            // for(int i = 0; i < documentSnapshot['prods'].length; i++) {
                                            //   // debugPrint('whatting 5?');*-**
                                            //   var eachMap = documentSnapshot['prods'].entries.elementAt(i);
                                            //   if(eachMap.value['na'] == prodNameCtrl.text) {
                                            //     prodExist = true;
                                            //     break;
                                            //   }
                                            //   // if(eachMap.key == widget.prodId) {
                                            //   //   continue;
                                            //   // } else {
                                            //   //   productExist.add(eachMap.value['na']);
                                            //   // }
                                            // }

                                            // for(int i=0; i < productExist.length; i++) {
                                            //   if(productExist[i].toString() ==  prodNameCtrl.text) {
                                            //     prodExist = true;
                                            //   }
                                            // }

                                            // debugPrint('document print ' + productExist.toString());
                                            debugPrint('document print ' + prodExist.toString());
                                          }

                                          if (prodExist) {
                                            debugPrint('product already');
                                            var result =
                                            await showOkAlertDialog(
                                              context: context,
                                              title: 'Warning',
                                              message:
                                              'Product name already!',
                                              okLabel: 'OK',
                                            );
                                            closeOverAllSubLoading();
                                            setState(() {
                                              disableTouch = false;
                                              prodAdding = false;
                                            });
                                          }
                                          else {
                                            if(assets.length == 0) {
                                              debugPrint('printedhere');
                                              DocumentReference prodsArr = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr');

                                              WriteBatch batch = FirebaseFirestore.instance.batch();

                                              // data edit start
                                              // FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr').set({
                                              //   'prods': {
                                              //     widget.prodId: {
                                              //       'na': prodNameCtrl.text,
                                              //       'co': barCodeCtrl.text,
                                              //       'im': double.parse(mainQtyCtrl.text.toString()),
                                              //       'i1': double.parse(sub1QtyCtrl.text.toString()),
                                              //       'i2': double.parse(sub2QtyCtrl.text.toString()),
                                              //       'bm': double.parse(mainBuyCtrl.text),
                                              //       'b1': sub1Buy,
                                              //       'b2': sub2Buy,
                                              //       'sm': double.parse(mainSellCtrl.text),
                                              //       's1': double.parse(sub1SellCtrl.text),
                                              //       's2': double.parse(sub2SellCtrl.text),
                                              //       'c1': sub1perUnitCtrl.text == ''? 0:double.parse(sub1perUnitCtrl.text),
                                              //       'c2': sub2perUnitCtrl.text == ''? 0:double.parse(sub2perUnitCtrl.text),
                                              //       'nm': mainUnitNameCtrl.text,
                                              //       'n1': sub1UnitNameCtrl.text,
                                              //       'n2': sub2UnitNameCtrl.text,
                                              //       'se': double.parse(subExistChange),
                                              //     }
                                              //   }
                                              //
                                              // },SetOptions(merge: true)).then((value) {
                                              // }).catchError((error) => debugPrint("Failed to update user: $error"));
                                              // data edit end

                                              batch.set(
                                                  prodsArr,
                                                  {
                                                    'prods': {
                                                      widget.prodId: {
                                                        'na': prodNameCtrl.text,
                                                        'co': barCodeCtrl.text,
                                                        'im': double.parse(mainQtyCtrl.text.toString()),
                                                        'i1': double.parse(sub1QtyCtrl.text.toString()),
                                                        'i2': double.parse(sub2QtyCtrl.text.toString()),
                                                        'bm': double.parse(mainBuyCtrl.text),
                                                        'b1': double.parse(sub1Buy),
                                                        'b2': double.parse(sub2Buy),
                                                        'sm': double.parse(mainSellCtrl.text),
                                                        's1': double.parse(sub1SellCtrl.text),
                                                        's2': double.parse(sub2SellCtrl.text),
                                                        'c1': sub1perUnitCtrl.text == ''? 0:double.parse(sub1perUnitCtrl.text),
                                                        'c2': sub2perUnitCtrl.text == ''? 0:double.parse(sub2perUnitCtrl.text),
                                                        'nm': mainUnitNameCtrl.text,
                                                        'n1': sub1UnitNameCtrl.text,
                                                        'n2': sub2UnitNameCtrl.text,
                                                        'se': double.parse(subExistChange),
                                                      }
                                                    }
                                                  },SetOptions(merge: true)
                                              );

                                              try {
                                                batch.commit();
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 3000), () {
                                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                                  smartKyatFlash(prodNameCtrl.text + ' is successfully updated.', 's');
                                                  closeOverAllSubLoading();
                                                  setState(() {
                                                    disableTouch = false;
                                                    prodAdding = false;
                                                  });
                                                });

                                              } catch(error) {
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 3000), () {
                                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                                  smartKyatFlash('An error occurred while editing a product. Please try again later.', 'e');
                                                  closeOverAllSubLoading();
                                                  setState(() {
                                                    disableTouch = false;
                                                    prodAdding = false;
                                                  });
                                                });

                                              }

                                              debugPrint('arrays added ' + '0-'.toString());

                                            } else {
                                              try {
                                                final resultInt = await InternetAddress.lookup('google.com');
                                                if (resultInt.isNotEmpty && resultInt[0].rawAddress.isNotEmpty) {
                                                  for (int i = 0; i < assets.length; i++) {
                                                    AssetEntity asset = assets.elementAt(i);
                                                    asset.originFile.then((value) async {
                                                      if(widget.image == '') {
                                                        addProduct(value!).then((val) async {
                                                          debugPrint('debug vlaue ' + val.toString());
                                                          if(val != 'error img upload') {

                                                            DocumentReference prodsArr = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr');

                                                            WriteBatch batch = FirebaseFirestore.instance.batch();

                                                            batch.set(
                                                                prodsArr,
                                                                {
                                                                  'prods': {
                                                                    widget.prodId: {
                                                                      'na': prodNameCtrl.text,
                                                                      'co': barCodeCtrl.text,
                                                                      'im': double.parse(mainQtyCtrl.text.toString()),
                                                                      'i1': double.parse(sub1QtyCtrl.text.toString()),
                                                                      'i2': double.parse(sub2QtyCtrl.text.toString()),
                                                                      'bm': double.parse(mainBuyCtrl.text),
                                                                      'b1': double.parse(sub1Buy),
                                                                      'b2': double.parse(sub2Buy),
                                                                      'sm': double.parse(mainSellCtrl.text),
                                                                      's1': double.parse(sub1SellCtrl.text),
                                                                      's2': double.parse(sub2SellCtrl.text),
                                                                      'c1': sub1perUnitCtrl.text == ''? 0:double.parse(sub1perUnitCtrl.text),
                                                                      'c2': sub2perUnitCtrl.text == ''? 0:double.parse(sub2perUnitCtrl.text),
                                                                      'nm': mainUnitNameCtrl.text,
                                                                      'n1': sub1UnitNameCtrl.text,
                                                                      'n2': sub2UnitNameCtrl.text,
                                                                      'se': double.parse(subExistChange),
                                                                    }
                                                                  }
                                                                },SetOptions(merge: true)
                                                            );

                                                            batch.set(
                                                                FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('imgArr').doc('prodsArr'),
                                                                {
                                                                  'prods': {
                                                                    widget.prodId: {
                                                                      'img': val.toString()
                                                                    }
                                                                  }
                                                                },SetOptions(merge: true)
                                                            );

                                                            try {
                                                              batch.commit();
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds: 3000), () {
                                                                Navigator.of(context).popUntil((route) => route.isFirst);
                                                                smartKyatFlash(prodNameCtrl.text + ' is successfully updated.', 's');
                                                                closeOverAllSubLoading();
                                                                setState(() {
                                                                  disableTouch = false;
                                                                  prodAdding = false;
                                                                });
                                                              });

                                                            } catch(error) {
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds: 3000), () {
                                                                Navigator.of(context).popUntil((route) => route.isFirst);
                                                                smartKyatFlash('An error occurred while editing a product. Please try again later.', 'e');
                                                                closeOverAllSubLoading();
                                                                setState(() {
                                                                  disableTouch = false;
                                                                  prodAdding = false;
                                                                });
                                                              });
                                                            }
                                                          }
                                                        });
                                                      } else {
                                                        addProductRe(value!, photoArray).then((val) async {
                                                          if(val != 'error img upload') {
                                                            DocumentReference prodsArr = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr');

                                                            WriteBatch batch = FirebaseFirestore.instance.batch();

                                                            batch.set(
                                                                prodsArr,
                                                                {
                                                                  'prods': {
                                                                    widget.prodId: {
                                                                      'na': prodNameCtrl.text,
                                                                      'co': barCodeCtrl.text,
                                                                      'im': double.parse(mainQtyCtrl.text.toString()),
                                                                      'i1': double.parse(sub1QtyCtrl.text.toString()),
                                                                      'i2': double.parse(sub2QtyCtrl.text.toString()),
                                                                      'bm': double.parse(mainBuyCtrl.text),
                                                                      'b1': double.parse(sub1Buy),
                                                                      'b2': double.parse(sub2Buy),
                                                                      'sm': double.parse(mainSellCtrl.text),
                                                                      's1': double.parse(sub1SellCtrl.text),
                                                                      's2': double.parse(sub2SellCtrl.text),
                                                                      'c1': sub1perUnitCtrl.text == ''? 0:double.parse(sub1perUnitCtrl.text),
                                                                      'c2': sub2perUnitCtrl.text == ''? 0:double.parse(sub2perUnitCtrl.text),
                                                                      'nm': mainUnitNameCtrl.text,
                                                                      'n1': sub1UnitNameCtrl.text,
                                                                      'n2': sub2UnitNameCtrl.text,
                                                                      'se': double.parse(subExistChange),
                                                                    }
                                                                  }
                                                                },SetOptions(merge: true)
                                                            );

                                                            batch.set(
                                                                FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('imgArr').doc('prodsArr'),
                                                                {
                                                                  'prods': {
                                                                    widget.prodId: {
                                                                      'img': val.toString()
                                                                    }
                                                                  }
                                                                },SetOptions(merge: true)
                                                            );

                                                            try {
                                                              batch.commit();
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds: 3000), () {
                                                                Navigator.of(context).popUntil((route) => route.isFirst);
                                                                smartKyatFlash(prodNameCtrl.text + ' is successfully updated.', 's');
                                                                closeOverAllSubLoading();
                                                                setState(() {
                                                                  disableTouch = false;
                                                                  prodAdding = false;
                                                                });
                                                              });

                                                            } catch(error) {
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds: 3000), () {
                                                                Navigator.of(context).popUntil((route) => route.isFirst);
                                                                smartKyatFlash('An error occurred while editing a product. Please try again later.', 'e');
                                                                closeOverAllSubLoading();
                                                                setState(() {
                                                                  disableTouch = false;
                                                                  prodAdding = false;
                                                                });
                                                              });
                                                            }
                                                          }

                                                        });
                                                      }

                                                    });
                                                  }
                                                }
                                              } on SocketException catch (_) {
                                                smartKyatFMod(context,'Internet connection is required to take this action.', 'w');
                                                closeOverAllSubLoading();
                                                setState(() {
                                                  disableTouch = false;
                                                  prodAdding = false;
                                                });
                                              }
                                            }


                                          }
                                        });
                                        FocusScope.of(context).unfocus();

                                        // productId.where('prod_name', isEqualTo: prodNameCtrl.text).get().then((QuerySnapshot
                                        // querySnapshot) async {
                                        //   querySnapshot.docs
                                        //       .forEach((doc) {
                                        //     prodExist = true;
                                        //   });
                                        //
                                        //   if ( prodExist == true && prodNameCtrl.text != widget.prodName ) {
                                        //     debugPrint('product already');
                                        //     var result =
                                        //     await showOkAlertDialog(
                                        //       context: context,
                                        //       title: 'Warning',
                                        //       message:
                                        //       'Product name already!',
                                        //       okLabel: 'OK',
                                        //     );
                                        //     setState(() {
                                        //       disableTouch = false;
                                        //       prodAdding = false;
                                        //     });
                                        //   } else {
                                        //     if (assets.length == 0) {
                                        //       FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr').update({
                                        //         'prods': {
                                        //           widget.prodId: {
                                        //             'na': prodNameCtrl.text,
                                        //             'co': barCodeCtrl.text,
                                        //             'im': double.parse(mainQtyCtrl.text.toString()),
                                        //             'i1': double.parse(sub1QtyCtrl.text.toString()),
                                        //             'i2': double.parse(sub2QtyCtrl.text.toString()),
                                        //             'bm': double.parse(mainBuyCtrl.text),
                                        //             'sm': double.parse(mainSellCtrl.text),
                                        //             's1': double.parse(sub1SellCtrl.text),
                                        //             's2': double.parse(sub2SellCtrl.text),
                                        //             'c1': sub1perUnitCtrl.text == ''? 0:double.parse(sub1perUnitCtrl.text),
                                        //             'c2': sub2perUnitCtrl.text == ''? 0:double.parse(sub2perUnitCtrl.text),
                                        //             'nm': mainUnitNameCtrl.text,
                                        //             'n1': sub1UnitNameCtrl.text,
                                        //             'n2': sub2UnitNameCtrl.text,
                                        //             'se': double.parse(subExist.toString()),
                                        //           }
                                        //         }
                                        //       }).then((value) {
                                        //         debugPrint('arrays added ' + '0-'.toString());
                                        //       }).catchError((error) => debugPrint("Failed to update user: $error"));
                                        //
                                        //
                                        //       productId.doc(widget.prodId).update({
                                        //         'prod_name' : prodNameCtrl.text,
                                        //         'bar_code' : barCodeCtrl.text,
                                        //         'inStock1' : double.parse(mainQtyCtrl.text.toString()),
                                        //         'unit_name' : mainUnitNameCtrl.text,
                                        //         'buyPrice1' : mainBuyCtrl.text,
                                        //         'unit_sell' : mainSellCtrl.text,
                                        //         'sub_exist' : subExistChange,
                                        //         'inStock2' : double.parse(sub1QtyCtrl.text.toString()),
                                        //         'sub1_link' : sub1perUnitCtrl.text,
                                        //         'sub1_name' : sub1UnitNameCtrl.text,
                                        //         'sub1_sell' : sub1SellCtrl.text,
                                        //         'inStock3' : double.parse(sub2QtyCtrl.text.toString()),
                                        //         'sub2_link' : sub2perUnitCtrl.text,
                                        //         'sub2_name' : sub2UnitNameCtrl.text,
                                        //         'sub2_sell' : sub2SellCtrl.text,
                                        //         'buyPrice2' : sub1Buy,
                                        //         'buyPrice3' : sub2Buy,
                                        //         'update_time' : DateTime.now(),
                                        //         'search_name': textSplitFunction(prodNameCtrl.text.toString()),
                                        //       }).then((value) {
                                        //       }).catchError((error) => debugPrint("Failed to update: $error"));
                                        //
                                        //       Future.delayed(const Duration(milliseconds: 2000), () {
                                        //         setState(() {
                                        //           prodAdding = false;
                                        //           disableTouch = false;
                                        //         });
                                        //         Navigator.pop(context);
                                        //         smartKyatFlash(prodNameCtrl.text + ' is successfully updated.', 's');
                                        //       });
                                        //
                                        //       // });
                                        //     } else {
                                        //       for (int i = 0;
                                        //       i < assets.length;
                                        //       i++)
                                        //       {
                                        //         AssetEntity asset = assets.elementAt(i);
                                        //         asset.originFile.then((value) async {
                                        //           addProduct(value!, photoArray).then((value) {
                                        //             photoArray = value.toString();
                                        //             productId.doc(widget.prodId).update({
                                        //               'prod_name' : prodNameCtrl.text,
                                        //               'bar_code' : barCodeCtrl.text,
                                        //               'inStock1' : double.parse(mainQtyCtrl.text.toString()),
                                        //               'unit_name' : mainUnitNameCtrl.text,
                                        //               'buyPrice1' : mainBuyCtrl.text,
                                        //               'unit_sell' : mainSellCtrl.text,
                                        //               'sub_exist' : subExistChange,
                                        //               'inStock2' : double.parse(sub1QtyCtrl.text.toString()),
                                        //               'sub1_link' : sub1perUnitCtrl.text,
                                        //               'sub1_name' : sub1UnitNameCtrl.text,
                                        //               'sub1_sell' : sub1SellCtrl.text,
                                        //               'inStock3' : double.parse(sub2QtyCtrl.text.toString()),
                                        //               'sub2_link' : sub2perUnitCtrl.text,
                                        //               'sub2_name' : sub2UnitNameCtrl.text,
                                        //               'sub2_sell' : sub2SellCtrl.text,
                                        //               'buyPrice2' : sub1Buy,
                                        //               'buyPrice3' : sub2Buy,
                                        //               'img_1' : photoArray.toString(),
                                        //               'update_time' : DateTime.now(),
                                        //               'search_name': textSplitFunction(prodNameCtrl.text.toString()),
                                        //             }).then((value){ Navigator.pop(context);
                                        //             setState(() {
                                        //               prodAdding = false;
                                        //               disableTouch = false;
                                        //             });
                                        //             Navigator.pop(context);
                                        //             smartKyatFlash(prodNameCtrl.text + ' is successfully updated.', 's');
                                        //             }).catchError((error) => debugPrint("Failed to update: $error"));
                                        //           }
                                        //           );
                                        //         });
                                        //       }
                                        //     }
                                        //   }
                                        // });
                                      }
                                    },
                                    child: prodAdding == true ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                        child: CupertinoActivityIndicator(radius: 10,)) : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0,
                                          right: 5.0,
                                          bottom: 2.0),
                                      child: Container(
                                        child: Text(
                                            textSetSaveProd, textScaleFactor: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                height: 1.3,
                                                fontSize: 17.5,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black
                                            ),
                                            strutStyle: StrutStyle(
                                              height: widget.isEnglish? 1.4: 1.6,
                                              forceStrutHeight: true,
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                // height: MediaQuery.of(context).viewInsets.bottom,
                // height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
                height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
              ),
              widget.fromSearch? SizedBox(height: 65): SizedBox(height: 0)
            ],
          ),
        ),
      ),
    );
  }

  Future addProduct(File imageFile) async {

// ignore: deprecated_member_use
    var stream =
    new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri =
    Uri.parse("https://smartkyatpos.com/api/images_upload.php");

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

    if(respond.statusCode == 200) {
      return respStr.toString();
    } else {
      return 'error img upload';
    }
  }

  Future addProductRe(File imageFile, String rm_image) async {
    debugPrint('RM path ' + rm_image.toString());
// ignore: deprecated_member_use
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("https://smartkyatpos.com/api/images_reup.php");
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
      debugPrint("Image Uploaded");
      return respStr.toString();
    } else {
      debugPrint("Upload Failed");
      return 'error img upload';
    }
    // debugPrint('her ' + respStr.toString());
    // return respStr.toString();
  }

//   Future removeProduct(File imageFile) async {
// // ignore: deprecated_member_use
//     var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//     var length = await imageFile.length();
//     var uri = Uri.parse("https://smartkyatpos.com/api/images_upload.php");
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
//       debugPrint("Image Uploaded");
//     } else {
//       debugPrint("Upload Failed");
//     }
//     debugPrint('her ' + respStr.toString());
//     return respStr.toString();
//   }

  createCard(length, unit, controller1, controller2, controller3, controller4, warning) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 15),
            child: Container(
              color: AppTheme.skBorderColor2,
              height: 1,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 0),
                  child: Text(
                    widget.isEnglish?
                    "#$length SUB UNIT INFORMATION":
                    "#$length SUB UNIT INFORMATION",
                    // "#${cards.length + 1} ယူနစ် အချက်အလက်",
                    textScaleFactor: 1,
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
                        unitLimit = false;
                        sub2perUnitCtrl.text = '0';
                        sub2QtyCtrl.text = '0';
                        sub2SellCtrl.text = '0';
                        sub2UnitNameCtrl.clear();
                        subExist = 0;
                        addSubUnit = 1;
                      });
                    } else if(addSubUnit == 0) {
                      if(subExist == 2) {
                        setState(() {
                          unitLimit = false;
                          sub2perUnitCtrl.text = '0';
                          sub2QtyCtrl.text = '0';
                          sub2SellCtrl.text = '0';
                          sub2UnitNameCtrl.clear();
                          subExist = 1;
                          addSubUnit = 0;
                        });} else
                      if(subExist == 1) {
                        setState(() {
                          unitLimit = false;
                          sub1perUnitCtrl.text = '0';
                          sub1QtyCtrl.text = '0';
                          sub1SellCtrl.text = '0';
                          sub1UnitNameCtrl.clear();
                          subExist = 0;
                          addSubUnit = 0;
                        });}
                    } else if(addSubUnit == 1){
                      if(subExist == 1) {
                        setState(() {
                          unitLimit = false;
                          sub2perUnitCtrl.text = '0';
                          sub2QtyCtrl.text = '0';
                          sub2SellCtrl.text = '0';
                          sub2UnitNameCtrl.clear();
                          subExist = 1;
                          addSubUnit = 0;
                        });
                      }
                      if(subExist == 0) {
                        setState(() {
                          unitLimit = false;
                          sub1perUnitCtrl.text = '0';
                          sub1QtyCtrl.text = '0';
                          sub1SellCtrl.text = '0';
                          sub1UnitNameCtrl.clear();
                          subExist = 0;
                          addSubUnit = 0;
                        });
                      }}
                  },
                  child: Text(
                      textSetRemove, textScaleFactor: 1,
                      style: TextStyle(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,color: Colors.blue,
                      ),
                      strutStyle: StrutStyle(
                        height: widget.isEnglish? 1.4: 1.6,
                        forceStrutHeight: true,
                      )
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 18,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 65,
                  width: MediaQuery.of(context).size.width > 900 ? ((MediaQuery.of(context).size.width * (2 / 3.5))  - 30) *
                      (2.6 / 4) - 8 : (MediaQuery.of(context).size.width -
                      30) *
                      (2.6 / 4) - 8,
                  child: TextFormField(
                    controller: controller1,
                    keyboardType: TextInputType.numberWithOptions(decimal: false),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(_getNum())),  LengthLimitingTextInputFormatter(15),],
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ' This field is required ';
                      }

                      if ((value.isNotEmpty || value != null) && double.parse(value.toString()) < 2) {
                        return ' Must be greater than 1 ';
                      }
                      // prodFieldsValue.add(value);
                      return null;
                    },
                    style: TextStyle(
                      height: 0.95,
                      fontSize: 15 / scaleFactor,
                    ),
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
                        fontSize: 12/scaleFactor,
                        fontFamily: 'capsulesans',
                      ),
                      errorStyle: TextStyle(
                          backgroundColor: Colors.white,
                          fontSize: 12/scaleFactor,
                          fontFamily: 'capsulesans',
                          height: 0.1
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      // errorText: 'Error message',
                      labelText: widget.isEnglish? 'Qty/ $unit unit': 'အရေတွက်/ $unitယူနစ်',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      //filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Container(
                height: 65,
                width: MediaQuery.of(context).size.width > 900 ? ((MediaQuery.of(context).size.width * (2 / 3.5))  -
                    30) *
                    (1.4 / 4) - 8 : (MediaQuery.of(context).size.width -
                    30) *
                    (1.4 / 4) - 8,
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
                  style: TextStyle(
                    height: 0.95,
                    fontSize: 15 / scaleFactor,
                  ),
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
                      fontSize: 12/scaleFactor,
                      fontFamily: 'capsulesans',
                    ),
                    errorStyle: TextStyle(
                        backgroundColor: Colors.white,
                        fontSize: 12/scaleFactor,
                        fontFamily: 'capsulesans',
                        height: 0.1
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    // errorText: 'Error message',
                    labelText: textSetUnitName,
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
          RichText(
            strutStyle: StrutStyle(
              height: 1,
              // fontSize:,
              forceStrutHeight: true,
            ),
            text: new TextSpan(
              children: [
                new TextSpan(
                  text:
                  warning,
                  style: new TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      overflow: TextOverflow.ellipsis
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 65,
            child: TextFormField(
              controller: controller3,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(_getNum())),  LengthLimitingTextInputFormatter(15),],
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ' This field is required ';
                }
                // prodFieldsValue.add(value);
                return null;
              },
              style: TextStyle(
                height: 0.95,
                fontSize: 15 / scaleFactor,
              ),
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
                // suffixText: '$currencyUnit',
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
                    fontSize: 12/scaleFactor,
                    fontFamily: 'capsulesans',
                    height: 0.1
                ),
                // errorText: 'Error message',
                labelText: textSetUnitQty,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                //filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Container(
            height: 65,
            child: TextFormField(
              controller: controller4,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(_getRegexString())),  LengthLimitingTextInputFormatter(15),],

              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ' This field is required ';
                }
                // prodFieldsValue.add(value);
                return null;
              },
              style: TextStyle(
                height: 0.95,
                fontSize: 15 / scaleFactor,
              ),
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
                suffixText: '$currencyUnit',
                suffixStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 12/scaleFactor,
                  //fontFamily: 'capsulesans',
                ),
                errorStyle: TextStyle(
                    backgroundColor: Colors.white,
                    fontSize: 12/scaleFactor,
                    fontFamily: 'capsulesans',
                    height: 0.1
                ),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                // errorText: 'Error message',
                labelText: textSetSalePrice,
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
    );
  }
  Future<void> selectAssets(PickMethod model) async {
    try {
      final List<AssetEntity>? result = await model.method(context, assets);
      debugPrint('ASSETS ' + result.toString());
      if (result != null) {
        assets = List<AssetEntity>.from(result);
        if (mounted) {
          setState(() {});
        }
      }
    } catch (error) {
      debugPrint('never reached');
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

  FlashController? _previousController;

  Future smartKyatFMod<T>(BuildContext context, String message, String type) async {
    if(_previousController != null) {
      if (_previousController!.isDisposed == false) _previousController!.dismiss();
    }

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
          child: Text('i', textScaleFactor: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    }

    _previousController = FlashController<T>(
      context,
      builder: (context, controller) {
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
                    child: Text(message, textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
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
        );
        // return Flash.dialog(
        //   controller: controller,
        //   alignment: const Alignment(0, 0.5),
        //   margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //   borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        //   backgroundColor: Colors.black87,
        //   child: DefaultTextStyle(
        //     style: const TextStyle(fontSize: 16.0, color: Colors.white),
        //     child: Padding(
        //       padding:
        //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //       child: Text(message),
        //     ),
        //   ),
        // );
      },
      duration: const Duration(milliseconds: 2500),
      persistent: true,
      transitionDuration: Duration(milliseconds: 300),
    );
    return _previousController!.show();
  }
}
