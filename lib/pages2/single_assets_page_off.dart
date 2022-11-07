///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020-05-31 21:17
///
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ai_awesome_message/ai_awesome_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/loss_fragment.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
import 'package:smartkyat_pos/widgets2/method_list_view.dart';
import 'package:smartkyat_pos/widgets2/selected_assets_list_view.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'package:async/async.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show AssetEntity;

import '../app_theme.dart';
import '../constants/page_mixin.dart';
import '../constants/picker_method.dart';
// import 'package:dropdown_search/dropdown_search.dart';

class SingleAssetPage extends StatefulWidget {
  final _callback;
  final prodLoadingState;
  final endProdLoadingState;

  SingleAssetPage({required void toggleCoinCallback(), required this.isEnglish, required void toggleCoinCallback2(), required void toggleCoinCallback3()})
      : _callback = toggleCoinCallback,
        prodLoadingState = toggleCoinCallback2,
        endProdLoadingState = toggleCoinCallback3;
  final bool isEnglish;
  @override
  _SingleAssetPageState createState() => _SingleAssetPageState();
}

class _SingleAssetPageState extends State<SingleAssetPage> {
  final ValueNotifier<bool> isDisplayingDetail = ValueNotifier<bool>(true);
  List<AssetEntity> assets = <AssetEntity>[];

  var nameTECs = <TextEditingController>[];
  var ageTECs = <TextEditingController>[];
  var jobTECs = <TextEditingController>[];
  var priceTECs = <TextEditingController>[];
  var cards = <Padding>[];
  static List<String> prodFieldsValue = [];
  final _formKey = GlobalKey<FormState>();

  final pnameCtrl = TextEditingController();
  final bcodeCtrl = TextEditingController();
  final munitCtrl = TextEditingController();
  final mnameCtrl = TextEditingController();
  final msaleCtrl = TextEditingController();
  final mcostCtrl = TextEditingController();
  final bool allowDecimal = false;

  bool prodAdding = false;

  String? shopId;

  String textSetProductInfo = 'PRODUCT INFORMATION';
  String textSetProdName = 'Product name';
  String textSetBarcode = 'Barcode';
  String textSetMainUnitQty = 'MAIN UNIT INFORMATION';
  String textSetUnitQty = 'Unit quantity';
  String textSetUnitName = 'Unit name';
  String textSetBuyPrice = 'Buy price';
  String textSetSalePrice = 'Sale price';
  String textSetSub1UnitQty = '#1 SUB UNIT INFORMATION';
  String textSetSub2UnitQty = '#2 SUB UNIT INFORMATION';
  String textSetWarning = 'e.g, If this item were \"Cigarette 10 packs per 1 carton box\" then it could break down into \"10 / main carton box\".';
  String textSetWarning2 = 'e.g, If this item were \"20 cigarettes per 1 pack\" then it could break down into \"20 / #1 sub pack\".';
  String textSetRemove = 'REMOVE';
  String textSetUnitMain = 'Unit/main unit';
  String textSetSaveProd = 'Add product';
  String textSetMoreUnit = 'More unit?';
  String textSetUnitSub = 'Unit/sub1 unit';

  bool unitLimit = false;


  var deviceIdNum;

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
  String _getRegexString() =>
      r'[0-9]+[,.]{0,1}[0-9]*';

  String _getNum() =>
      r'[0-9]';

  String currencyUnit = 'MMK';

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }

  bool priceWarning = false;

  @override
  initState() {
    getStoreId().then((value) => shopId = value);

    getCurrency().then((value){
      setState(() {
        currencyUnit = value.toString();
      });
    });

    if(widget.isEnglish == true) {

      setState(() {
        textSetProductInfo = 'PRODUCT INFORMATION';
        textSetProdName = 'Product name';
        textSetBarcode = 'Barcode';
        textSetMainUnitQty = 'MAIN UNIT INFORMATION';
        textSetUnitQty = 'Unit quantity';
        textSetUnitName = 'Unit name';
        textSetBuyPrice = 'Buy price per unit';
        textSetSalePrice = 'Sale price per unit';
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
        textSetProductInfo = 'PRODUCT INFORMATION';
        // textSetProductInfo = 'ပစ္စည်း အချက်အလက်';
        textSetProdName = 'ပစ္စည်းအမည်';
        textSetBarcode = 'ဘားကုဒ်';
        textSetMainUnitQty = 'MAIN UNIT INFORMATION';
        // textSetMainUnitQty = 'အဓိကယူနစ် အချက်အလက်';
        textSetUnitQty = 'လက်ကျန် အရေအတွက်';
        textSetUnitName = 'ယူနစ်အမည်';
        textSetBuyPrice = 'တစ်ယူနစ် ဝယ်ဈေး';
        textSetSalePrice = 'တစ်ယူနစ် ရောင်းဈေး';
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


    getDeviceId().then((value) {
      deviceIdNum = value;
    });



    // if(msaleCtrl.text != '' && mcostCtrl.text != '') {
    mcostCtrl.addListener((){
      if(msaleCtrl.text != '' && mcostCtrl.text != '' && double.parse(msaleCtrl.text) > double.parse(mcostCtrl.text)) {
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

    msaleCtrl.addListener((){
      if(msaleCtrl.text != '' && mcostCtrl.text != '' && double.parse(msaleCtrl.text) > double.parse(mcostCtrl.text)) {
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
    //  }


    // debugPrint('Warning pya mal');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
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
                    //                 Container(
//                   height: 85,
//                   decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               color: AppTheme.skBorderColor, width: 2.0))),
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                         left: 15.0, right: 15.0, top: 20.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           width: 35,
//                           height: 35,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(5.0),
//                               ),
//                               color: Colors.grey.withOpacity(0.3)),
//                           child: IconButton(
//                             icon: Icon(
//                               Icons.close,
//                               size: 20,
//                               color: Colors.black,
//                             ),
//                             onPressed: () {
//                               if (pnameCtrl.text.length > 0 ||
//                                   mcostCtrl.text.length > 0 ||
//                                   msaleCtrl.text.length > 0 ||
//                                   munitCtrl.text.length > 0 ||
//                                   mnameCtrl.text.length > 0 ||
//                                   bcodeCtrl.text.length > 0) {
//                                 showOkCancelAlertDialog(
//                                   context: context,
//                                   title: 'Are you sure?',
//                                   message: 'You added data in some inputs.',
//                                   defaultType: OkCancelAlertDefaultType.cancel,
//                                 ).then((result) {
//                                   if (result == OkCancelResult.ok) {
//                                     Navigator.pop(context);
//                                   }
//                                 });
//                               } else {
//                                 Navigator.pop(context);
//                               }
//                             },
//                           ),
//                         ),
//                         Text(
//                           "Add new product",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 17,
//                               fontFamily: 'capsulesans',
//                               fontWeight: FontWeight.w600),
//                           textAlign: TextAlign.left,
//                         ),
//                         Container(
//                           width: 35,
//                           height: 35,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(5.0),
//                               ),
//                               color: AppTheme.themeColor),
//                           child: IconButton(
//                             icon: Icon(
//                               Icons.check,
//                               size: 20,
//                               color: Colors.white,
//                             ),
//                             onPressed: () async {
//                               prodFieldsValue = [];
//
//                               if (_formKey.currentState!.validate()) {
//                                 DateTime now = DateTime.now();
//                                 setState(() {
//                                   prodAdding = true;
//                                 });
//                                 debugPrint('validate ' + prodFieldsValue.toString());
//
//                                 List<PersonEntry> entries = [];
//
//                                 debugPrint('shit ' + entries.toString());
//
//                                 debugPrint('here ' + assets.length.toString());
//                                 photoUploadCount = 0;
//                                 var photoArray = ['', '', '', '', ''];
//
//                                 var prodExist = false;
//
//                                 var productId = await FirebaseFirestore.instance
//                                     .collection('shops')
//                                     .doc(shopId)
//                                     .collection('products');
//
//                                    // productId.where('prod_name', isEqualTo: prodFieldsValue[0]).get().then((QuerySnapshot
//                                    //          querySnapshot) async {
//                                    //    querySnapshot.docs.forEach((doc) {
//                                    //      prodExist = true;
//                                    //    });
//
//                                       // if (prodExist) {
//                                       //   debugPrint('product already');
//                                       //   var result = await showOkAlertDialog(
//                                       //     context: context,
//                                       //     title: 'Warning',
//                                       //     message: 'Product name already!',
//                                       //     okLabel: 'OK',
//                                       //   );
//                                       //   setState(() {
//                                       //     prodAdding = false;
//                                       //   });
//                                       // }
//                                       // else {
//                                       //   for (int i = 0;
//                                       //       i < assets.length;
//                                       //       i++) {
//                                       //     AssetEntity asset =
//                                       //         assets.elementAt(i);
//                                       //     asset.originFile.then((value) async {
//                                       //       addProduct(value!).then((value) {
//                                       //         photoArray[i] = value.toString();
//                                       //         photoUploaded(
//                                       //             assets.length, photoArray);
//                                       //       });
//                                       //     });
//                                       //   }
//
//                                         if (assets.length == 0) {
//                                           var subUnitFieldValue = [
//                                             '',
//                                             '',
//                                             '',
//                                             '',
//                                             '',
//                                             '',
//                                             '',
//                                             '',
//                                             '',
//                                             '',
//                                             '',
//                                             '',
//                                           ];
//                                           int j = -1;
//                                           for (int i = 0;
//                                               i < cards.length;
//                                               i++) {
//                                             subUnitFieldValue[++j] =
//                                                 nameTECs[i].text;
//                                             subUnitFieldValue[++j] =
//                                                 ageTECs[i].text;
//                                             subUnitFieldValue[++j] =
//                                                 jobTECs[i].text;
//                                             subUnitFieldValue[++j] =
//                                                 priceTECs[i].text;
//                                             // var name = nameTECs[i].text;
//                                             // var age = ageTECs[i].text;
//                                             // var job = jobTECs[i].text;
//                                             // entries.add(PersonEntry(name, age, job));
//                                           }
//                                           debugPrint('gg nothing' +
//                                               subUnitFieldValue.toString());
//
//
//                                               String sub1_buy;
//                                               String sub2_buy;
//                                               String sub3_buy;
//                                               String subExist;
//                                               double mainStock;
//                                               double sub1Stock;
//                                               double sub2Stock;
//                                               double sub3Stock;
//                                               String mTotal;
//
//                                               if( subUnitFieldValue[0] != ''){
//                                                 sub1_buy= (double.parse(prodFieldsValue[4])/double.parse(subUnitFieldValue[0])).toString();
//                                               } else
//                                               {
//                                                 sub1_buy = '0';
//                                               }
//                                               if( subUnitFieldValue[4] != ''){
//                                                 sub2_buy= (double.parse(sub1_buy)/double.parse(subUnitFieldValue[4])).toString();
//                                               } else
//                                               {
//                                                 sub2_buy = '0';
//                                               }
//
//                                               if( subUnitFieldValue[8] != ''){
//                                                 sub3_buy= (double.parse(sub2_buy)/double.parse(subUnitFieldValue[8])).toString();
//                                               } else
//                                               {
//                                                 sub3_buy = '0';
//                                               }
//
//                                               if (subUnitFieldValue[0] != '' && subUnitFieldValue[4] == '' && subUnitFieldValue[8] == ''){
//                                                 subExist = '1';
//                                               } else  if (subUnitFieldValue[0] != '' && subUnitFieldValue[4] != '' && subUnitFieldValue[8] == ''){
//                                                 subExist = '2';
//                                               } else  if (subUnitFieldValue[0] != '' && subUnitFieldValue[4] != '' && subUnitFieldValue[8] != ''){
//                                                 subExist = '3';
//                                               } else subExist ='0';
//
//                                               if( prodFieldsValue[2] != '') {
//                                                 mainStock=  double.parse(prodFieldsValue[2]);
//                                               mTotal = (mainStock * double.parse(prodFieldsValue[4])).toString();
//                                                } else { mainStock = 0;
//                                               mTotal = (mainStock * double.parse(prodFieldsValue[4])).toString();}
//
//                                               if( subUnitFieldValue[3] != '') {
//                                                 sub1Stock=  double.parse(subUnitFieldValue[3]);
//                                                 //sub1Total = (sub1Stock * double.parse(sub1_buy)).toString();
//                                               }
//                                               else {sub1Stock = 0;
//                                               //sub1Total = (sub1Stock * double.parse(sub1_buy)).toString();
//                                               }
//
//                                               if( subUnitFieldValue[7] != '') {
//                                                 sub2Stock=  double.parse(subUnitFieldValue[7]);
//                                                 //sub2Total = (sub2Stock * double.parse(sub2_buy)).toString();
//                                               }
//                                               else { sub2Stock = 0;
//                                               //sub2Total = (sub2Stock * double.parse(sub2_buy)).toString();
//                                               }
//
//                                               if( subUnitFieldValue[11] != '') {
//                                                 sub3Stock =  double.parse(subUnitFieldValue[11]);
//                                                 //sub3Total = (sub3Stock * double.parse(sub3_buy)).toString();
//                                               }
//                                               else {
//                                                 sub3Stock = 0;
//                                                 //sub3Total = (sub3Stock * double.parse(sub3_buy)).toString();
//                                               }
//
//                                               productId
//                                                   .where('prod_name',
//                                                       isEqualTo:
//                                                           prodFieldsValue[0])
//                                                   .get()
//                                                   .then((QuerySnapshot
//                                                       querySnapshot) async {
//                                                 querySnapshot.docs
//                                                     .forEach((doc) {
//                                                   prodExist = true;
//                                                 });
//
//                                                 if (prodExist) {
//                                                   debugPrint('product already');
//                                                   var result =
//                                                       await showOkAlertDialog(
//                                                     context: context,
//                                                     title: 'Warning',
//                                                     message:
//                                                         'Product name already!',
//                                                     okLabel: 'OK',
//                                                   );
//                                                 } else {
//                                                   CollectionReference shops = await FirebaseFirestore.instance.collection('shops').doc(
//                                                               shopId)
//                                                           .collection(
//                                                               'products');
//                                                   return shops.add({
//                                                     'prod_name':
//                                                         prodFieldsValue[0],
//                                                     'bar_code':
//                                                         prodFieldsValue[1],
//                                                     'unit_name':
//                                                         prodFieldsValue[3],
//                                                     'unit_sell':
//                                                         prodFieldsValue[5],
//                                                     'inStock1' : mainStock,
//                                                     'inStock2'  : sub1Stock,
//                                                     'inStock3' : sub2Stock,
//                                                     'inStock4' : sub3Stock,
//                                                       'buyPrice1' : prodFieldsValue[4],
//                                                       'buyPrice2' : sub1_buy,
//                                                       'buyPrice3' : sub2_buy,
//                                                        'buyPrice4' : sub3_buy,
//                                                     'sub1_link':
//                                                     subUnitFieldValue[0],
//                                                     'sub1_name':
//                                                         subUnitFieldValue[1],
//                                                     'sub1_sell':
//                                                         subUnitFieldValue[2],
//                                                     'sub2_link':
//                                                     subUnitFieldValue[4],
//                                                     'sub2_name':
//                                                         subUnitFieldValue[5],
//                                                     'sub2_sell':
//                                                         subUnitFieldValue[6],
//                                                     'sub3_link':
//                                                     subUnitFieldValue[8],
//                                                     'sub3_name':
//                                                         subUnitFieldValue[9],
//                                                     'sub3_sell':
//                                                         subUnitFieldValue[10],
//                                                     'sub_exist': subExist,
//                                                     'Loss1' : 0,
//                                                     'Loss2' : 0,
//                                                     'Loss3' : 0,
//                                                     'Loss4' : 0,
//                                                     'mTotal' : mTotal,
//                                                     'mainSellUnit' : 0,
//                                                     'sub1SellUnit' : 0,
//                                                     'sub2SellUnit' : 0,
//                                                     // 's1Total' : sub1Total,
//                                                     // 's2Total' : sub2Total,
//                                                     // 's3Total' : sub3Total,
//
//                                                     // 'unit_qtity': prodFieldsValue[2],
//                                                     // 'unit_name': prodFieldsValue[3],
//                                                     // 'buy_price': prodFieldsValue[4],
//                                                     // 'sale_price': prodFieldsValue[5],
//                                                     // 'sub1_unit': subUnitFieldValue[0],
//                                                     // 'sub1_name': subUnitFieldValue[1],
//                                                     // 'sub1_sale': subUnitFieldValue[2],
//                                                     // 'sub2_unit': subUnitFieldValue[3],
//                                                     // 'sub2_name': subUnitFieldValue[4],
//                                                     // 'sub2_sale': subUnitFieldValue[5],
//                                                     // 'sub3_unit': subUnitFieldValue[6],
//                                                     // 'sub3_name': subUnitFieldValue[7],
//                                                     // 'sub3_sale': subUnitFieldValue[8],
//                                                     'img_1': '',
//                                                     'img_2': '',
//                                                     'img_3': '',
//                                                     'img_4': '',
//                                                     'img_5': '',
//                                                   }).then((value) {
//                                                     debugPrint('product added');
//                                                     // setState(() {
//                                                     //   prodAdding = false;
//                                                     // });
//
//
//
//                                                     // FirebaseFirestore.instance
//                                                     //     .collection('space')
//                                                     //     .doc(
//                                                     //         '0NHIS0Jbn26wsgCzVBKT')
//                                                     //     .collection('shops')
//                                                     //     .doc(
//                                                     //         shopId)
//                                                     //     .collection('products')
//                                                     //     .doc(value.id)
//                                                     //     .collection('versions')
//                                                     //     .add({
//                                                     //   'date': zeroToTen(now.day
//                                                     //           .toString()) +
//                                                     //       zeroToTen(now.month
//                                                     //           .toString()) +
//                                                     //       zeroToTen(now.year
//                                                     //           .toString()),
//                                                     //   'unit_qtity':
//                                                     //       prodFieldsValue[2],
//                                                     //   'buy_price':
//                                                     //       prodFieldsValue[4],
//                                                     //   'type': 'main',
//                                                     // }).then((value) {
//                                                     //   debugPrint('product added 2');
//                                                     // });
//                                                     // debugPrint('sub1'+ prodFieldsValue[4]);
//                                                     // debugPrint('unit1'+ subUnitFieldValue[0]);
//                                                     // debugPrint('unit2'+ subUnitFieldValue[8]);
//                                                     // debugPrint('unit3'+ subUnitFieldValue[4]);
//                                                     // var sub1Buy=double.parse(prodFieldsValue[4]) / double.parse(subUnitFieldValue[0]);
//                                                     // var sub2Buy=double.parse(prodFieldsValue[4]) / double.parse(subUnitFieldValue[4]);
//                                                     // var sub3Buy=double.parse(prodFieldsValue[4]) / double.parse(subUnitFieldValue[8]);
//
//
//
//                                                     // FirebaseFirestore.instance
//                                                     //     .collection('space')
//                                                     //     .doc(
//                                                     //         '0NHIS0Jbn26wsgCzVBKT')
//                                                     //     .collection('shops')
//                                                     //     .doc(
//                                                     //         shopId)
//                                                     //     .collection('products')
//                                                     //     .doc(value.id)
//                                                     //     .collection('versions')
//                                                     //     .add({
//                                                     //   'date': zeroToTen(now.day
//                                                     //           .toString()) +
//                                                     //       zeroToTen(now.month
//                                                     //           .toString()) +
//                                                     //       zeroToTen(now.year
//                                                     //           .toString()),
//                                                     //   // 'unit_qtity':
//                                                     //   // prodFieldsValue[2] +
//                                                     //   // ' 0',
//                                                     //   // prodFieldsValue[4],
//                                                     //   // 'sale_price':
//                                                     //   // prodFieldsValue[5],
//                                                     //   'unit_qtity':
//                                                     //       subUnitFieldValue[3],
//                                                     //   'buy_price': sub1_buy,
//                                                     //   'type': 'sub1',
//                                                     // }).then((value) {
//                                                     //   debugPrint('product added 3');
//
//                                                     // });
//
//                                                     // FirebaseFirestore.instance
//                                                     //     .collection('space')
//                                                     //     .doc('0NHIS0Jbn26wsgCzVBKT')
//                                                     //     .collection('shops')
//                                                     //     .doc(shopId)
//                                                     //     .collection('products')
//                                                     //     .doc(value.id)
//                                                     //     .collection('versions')
//                                                     //     .add({
//                                                     //   'date': zeroToTen(now.day.toString()) + zeroToTen(now.month.toString()) + zeroToTen(now.year.toString()),
//                                                     //   'unit_qtity': subUnitFieldValue[7],
//                                                     //   'buy_price': sub2_buy,
//                                                     //   'type': 'sub2',
//                                                     // }).then((value) {
//                                                     //   debugPrint('product added 4');
//                                                     // });
//                                                       setState(() {
//                                                         prodAdding = false;
//                                                       });
//
//                                                       Navigator.pop(context);
//
//                                                       showFlash(
//                                                         context: context,
//                                                         duration:
//                                                             const Duration(
//                                                                 seconds: 2),
//                                                         persistent: true,
//                                                         builder:
//                                                             (_, controller) {
//                                                           return Flash(
//                                                             controller:
//                                                                 controller,
//                                                             backgroundColor:
//                                                                 Colors
//                                                                     .transparent,
//                                                             brightness:
//                                                                 Brightness
//                                                                     .light,
//                                                             // boxShadows: [BoxShadow(blurRadius: 4)],
//                                                             // barrierBlur: 3.0,
//                                                             // barrierColor: Colors.black38,
//                                                             barrierDismissible:
//                                                                 true,
//                                                             behavior:
//                                                                 FlashBehavior
//                                                                     .floating,
//                                                             position:
//                                                                 FlashPosition
//                                                                     .top,
//                                                             child: Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                           .only(
//                                                                       top:
//                                                                           80.0),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets
//                                                                         .only(
//                                                                     left: 15.0,
//                                                                     right:
//                                                                         15.0),
//                                                                 child:
//                                                                     Container(
//                                                                   decoration:
//                                                                       BoxDecoration(
//                                                                     borderRadius:
//                                                                         BorderRadius.circular(
//                                                                             10.0),
//                                                                     color: Colors
//                                                                         .green,
//                                                                   ),
//                                                                   child:
//                                                                       FlashBar(
//                                                                     title: Text(
//                                                                         'Title'),
//                                                                     content: Text(
//                                                                         'Hello world!'),
//                                                                     // showProgressIndicator: true,
//                                                                     primaryAction:
//                                                                         TextButton(
//                                                                       onPressed:
//                                                                           () =>
//                                                                               controller.dismiss(),
//                                                                       child: Text(
//                                                                           'DISMISS',
//                                                                           style:
//                                                                               TextStyle(color: Colors.amber)),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           );
//                                                         },
//                                                       );
//
//                                                     // FirebaseFirestore.instance.collection('space').doc(spaceDocId).collection('shops').doc(result2).collection('products').doc(value.id).collection('units')
//                                                     // .add({
//                                                     //   'prod_name': prodFieldsValue[0]
//                                                     // }).then((value) {
//                                                     //   debugPrint('product added 2');
//                                                     // });
//
//                                                     // Navigator.pop(context);
//                                                   });
//                                                 }
//                                               });
//                                         }
//                               }
//
// // debugPrint('here ' + nameController.text.toString());
// // Navigator.pop(context, entries);
//
// // if (_formKey.currentState!.validate()) {
// //   // If the form is valid, display a snackbar. In the real world,
// //   // you'd often call a server or save the information in a database.
// //   ScaffoldMessenger.of(context).showSnackBar(
// //     const SnackBar(content: Text('Processing Data')),
// //   );
// //   // debugPrint(prodFieldsValue);
// //
// //   CollectionReference spaces = FirebaseFirestore.instance.collection('space');
// //   var prodExist = false;
// //   var spaceDocId = '';
// //   FirebaseFirestore.instance
// //       .collection('space')
// //       .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
// //       .get()
// //       .then((QuerySnapshot querySnapshot) {
// //     querySnapshot.docs.forEach((doc) {
// //       spaceDocId = doc.id;
// //     });
// //
// //     debugPrint('space shi p thar');
// //     getStoreId().then((String result2) {
// //       debugPrint('store id ' + result2.toString());
// //
// //       FirebaseFirestore.instance
// //           .collection('space').doc(spaceDocId).collection('shops').doc(result2).collection('products')
// //           .where('prod_name', isEqualTo: prodFieldsValue[0])
// //           .get()
// //           .then((QuerySnapshot querySnapshot) async {
// //         querySnapshot.docs.forEach((doc) {
// //           prodExist = true;
// //         });
// //
// //         if(prodExist) {
// //           debugPrint('product already');
// //           var result = await showOkAlertDialog(
// //               context: context,
// //               title: 'Warning',
// //               message: 'Product name already!',
// //               okLabel: 'OK',
// //           );
// //
// //         } else {
// //           CollectionReference shops = FirebaseFirestore.instance.collection('space').doc(spaceDocId).collection('shops').doc(result2).collection('products');
// //           return shops
// //               .add({
// //             'prod_name': prodFieldsValue[0]
// //           })
// //               .then((value) {
// //             debugPrint('product added');
// //
// //             Navigator.pop(context);
// //           });
// //         }
// //       });
// //     });
// //   });
// // }
//                             },
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
// Row(
//   mainAxisAlignment: MainAxisAlignment.start,
//   children: [
//     Container(
//       padding: EdgeInsets.only(left: 15),
//       height: 130,
//       width: 150,
//       child: Image.network(
//         'http://www.hmofficesolutions.com/media/4252/royal-d.jpg',
//         fit: BoxFit.fill,
//       ),
//     ),
//     SizedBox(
//       width: 20,
//     ),
//     Container(
//       width: 200,
//       child: Expanded(
//           child: Text(
//             "Add images to show customers product details and features",
//             style: TextStyle(
//               color: Colors.amberAccent,
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//             ),
//           )),
//     ),
//   ],
// ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Container(
                                    height: assets.isNotEmpty ?  120 : 82,
                                    child: Column(
                                      children: [
                                        if (assets.isNotEmpty)
                                          GestureDetector(
                                            onTap: () {
                                              widget._callback();
                                              debugPrint('_waitUntilDone ' +
                                                  assets.length.toString());
                                            },
                                            child: SelectedAssetsListView(
                                              assets: assets,
                                              isDisplayingDetail:
                                              isDisplayingDetail,
                                              onResult: onResult,
                                              onRemoveAsset: removeAsset,
                                            ),
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Container(
                                          height: 65,
                                          child: TextFormField(
// The validator receives the text that the user has entered.
                                            controller: pnameCtrl,
                                            keyboardType: TextInputType.text,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(30),
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return ' This field is required. ';
                                              }
                                              if(value.length > 30 ) {
                                                return '  You have reached maximum no of characters.';
                                              }
                                              prodFieldsValue.add(value);
                                              return null;
                                            },
                                            style: TextStyle(height: 0.95, fontSize: 15/scaleFactor),
                                            decoration: InputDecoration(
                                              enabledBorder: const OutlineInputBorder(

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
                                              //suffixText: 'Required',
                                              errorStyle: TextStyle(
                                                  backgroundColor: Colors.white,
                                                  fontSize: 12/scaleFactor,
                                                  fontFamily: 'capsulesans',
                                                  height: 0.1
                                              ),
                                              suffixStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12/scaleFactor,
                                                fontFamily: 'capsulesans',
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
                                      // Container(
                                      //   alignment: Alignment.topLeft,
                                      //   padding: EdgeInsets.only(top: 20, left: 15),
                                      //   child: Text(
                                      //     "OTHER INFORMATION",
                                      //     style: TextStyle(
                                      //       fontWeight: FontWeight.bold,
                                      //       fontSize: 13,
                                      //       letterSpacing: 2,
                                      //       color: Colors.grey,
                                      //     ),
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Container(
                                          height: 65,
                                          child: TextFormField(
                                            controller: bcodeCtrl,
                                            // The validator receives the text that the user has entered.
                                            validator: (value) {
                                              if (value != null || value!.isNotEmpty) {
                                                prodFieldsValue.add(value);
                                              }
                                              return null;
                                            },
                                            style: TextStyle(height: 0.95, fontSize: 15/scaleFactor),
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
                                              suffixIcon: IconButton(
                                                icon: Image.asset('assets/system/barcode.png', height: 28,),
                                                onPressed: () async {
                                                  debugPrint("Barcode");
                                                  // var code = await Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //       builder: (context) =>
                                                  //           QRViewExample()),
                                                  // );

                                                  var code = await Navigator.of(context).push(
                                                    FadeRoute(page: QRViewExample()),
                                                  );
                                                  bcodeCtrl.text = code;
                                                  debugPrint('bar bar ' + code);
                                                },
                                              ),
                                              // suffixText: 'Optional',
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
                                              labelText: textSetBarcode,
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
                                      // Container(
                                      //   alignment: Alignment.topLeft,
                                      //   padding: EdgeInsets.only(top: 20, left: 15),
                                      //   child: Text(
                                      //     "MAIN UNIT QUANTITY",
                                      //     style: TextStyle(
                                      //       fontWeight: FontWeight.bold,
                                      //       fontSize: 13,
                                      //       letterSpacing: 2,
                                      //       color: Colors.grey,
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox(height: 15),
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //       color: Colors.white,
                                      //       border: Border(
                                      //         top: BorderSide(
                                      //             color:
                                      //             AppTheme.skBorderColor2,
                                      //             width: 1.0),
                                      //       )),
                                      //   width: double.infinity,
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 0, left: 15.0),
                                        child: Container(
                                          color: AppTheme.skBorderColor2,
                                          height: 1,
                                          width: MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15, bottom: 15.0),
                                        child: Text(textSetMainUnitQty, textScaleFactor: 1, style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,color: Colors.grey,
                                        ),
                                            strutStyle: StrutStyle(
                                              height: widget.isEnglish? 1.4: 1.6,
                                              forceStrutHeight: true,
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 65,
                                                child: TextFormField(
                                                  controller: munitCtrl,
                                                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter.allow(RegExp(_getNum())),  LengthLimitingTextInputFormatter(15),],
// The validator receives the text that the user has entered.
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return ' This field is required ';
                                                    }

                                                    prodFieldsValue.add(value);
                                                    return null;
                                                  },
                                                  style: TextStyle(height: 0.95, fontSize: 15/scaleFactor),
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

                                                    focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                        borderSide: const BorderSide(
                                                            color: AppTheme.themeColor,
                                                            width: 2.0),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(10.0))),
                                                    contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 15.0,
                                                        right: 15.0,
                                                        top: 18.0,
                                                        bottom: 18.0),
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
                                                    labelText: textSetUnitQty,
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
                                            ),
                                            SizedBox(width: 15),
                                            Container(
                                              height: 65,
                                              width: (MediaQuery.of(context).size.width - 30) * (1.41 / 4),
                                              child: TextFormField(
                                                controller: mnameCtrl,
                                                keyboardType: TextInputType.text,
                                                // The validator receives the text that the user has entered.
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return ' Required ';
                                                  }
                                                  prodFieldsValue.add(value);
                                                  return null;
                                                },
                                                style: TextStyle(height: 0.95, fontSize: 15/scaleFactor),
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

                                                  focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                      borderSide: const BorderSide(
                                                          color: AppTheme.themeColor,
                                                          width: 2.0),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10.0))),
                                                  contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 15.0,
                                                      right: 15.0,
                                                      top: 18.0,
                                                      bottom: 18.0),
                                                  // suffixText: 'Required',
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
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Container(
                                          height: 65,
                                          child: TextFormField(
                                            controller: msaleCtrl,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(RegExp(_getRegexString())),  LengthLimitingTextInputFormatter(15),],
// The validator receives the text that the user has entered.
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return ' This field is required ';
                                              }
                                              prodFieldsValue.add(value);
                                              return null;
                                            },
                                            style: TextStyle(height: 0.95, fontSize: 15/scaleFactor),
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
                                              suffixText: currencyUnit,
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
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Container(
                                          height: 65,
                                          child: Stack(
                                            children: [
                                              TextFormField(
                                                controller: mcostCtrl,
                                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.allow(RegExp(_getRegexString())),  LengthLimitingTextInputFormatter(15),],
// The validator receives the text that the user has entered.
                                                validator: (value) {
                                                  if (value == null || value.isEmpty) {
                                                    return ' This field is required ';
                                                  }
                                                  prodFieldsValue.add(value);
                                                  return null;
                                                },
                                                style: TextStyle(height: 0.95, fontSize: 15/scaleFactor),
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
                                                  suffixText: currencyUnit,
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
                                      Column(
                                        children: <Widget>[
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: cards.length,
                                            itemBuilder:
                                                (BuildContext context, int index) {
                                              return cards[index];
                                            },
                                          ),
                                          SizedBox(
                                            height: 15,
                                          )
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
                          SizedBox(height: 30,),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(
                                  color: Colors.grey
                                      .withOpacity(0.3),
                                  width: 1.0))

                      ),

                      height: 91,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
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
                                        if(cards.length == 0) {
                                          setState(() => cards.add(createCard(widget.isEnglish? 'main': 'အဓိက', widget.isEnglish)));
                                        } else if(cards.length == 1) {
                                          setState(() {
                                            cards.add(createCard(widget.isEnglish? '#1 sub ': '#1 အခွဲ', widget.isEnglish));
                                            unitLimit = true;
                                          });
                                        } else {
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
                                                  fontWeight: FontWeight.w500,
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
                                if(!unitLimit)
                                  SizedBox(
                                      width: 15.0
                                  ),
                                Expanded(
                                  child: ButtonTheme(
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
                                        prodFieldsValue = [];
                                        List <String> productExist = [];
                                        if (_formKey.currentState!.validate()) {
                                          DateTime now = DateTime.now();
                                          setState(() {
                                            widget.prodLoadingState();
                                            prodAdding = true;
                                          });
                                          openOverAllSubLoading();
                                          debugPrint('validate ' + prodFieldsValue.toString());

                                          List<PersonEntry> entries = [];

                                          debugPrint('shit ' + entries.toString());

                                          debugPrint('here ' + assets.length.toString());
                                          photoUploadCount = 0;
                                          var photoArray = ['', '', '', '', ''];

                                          var prodExist = false;

                                          if (assets.length == 0) {
                                            var subUnitFieldValue = ['', '', '', '', '', '', '', '', '', '', '', '',];
                                            int j = -1;
                                            for (int i = 0;
                                            i < cards.length;
                                            i++) {
                                              subUnitFieldValue[++j] =
                                                  nameTECs[i].text;
                                              subUnitFieldValue[++j] =
                                                  ageTECs[i].text;
                                              subUnitFieldValue[++j] =
                                                  jobTECs[i].text;
                                              subUnitFieldValue[++j] =
                                                  priceTECs[i].text;
// var name = nameTECs[i].text;
// var age = ageTECs[i].text;
// var job = jobTECs[i].text;
// entries.add(PersonEntry(name, age, job));
                                            }
                                            debugPrint('gg nothing' +
                                                subUnitFieldValue.toString());
                                            double sub1_buy;
                                            double sub2_buy;
                                            double sub3_buy;
                                            String subExist;
                                            double mainStock;
                                            double sub1Stock;
                                            double sub2Stock;
                                            double sub3Stock;
                                            String mTotal;


                                            if( subUnitFieldValue[0] != ''){
                                              sub1_buy= (double.parse(prodFieldsValue[4])/double.parse(subUnitFieldValue[0]));
                                            } else
                                            {
                                              sub1_buy = 0;
                                            }
                                            if( subUnitFieldValue[4] != ''){
                                              sub2_buy= (sub1_buy/double.parse(subUnitFieldValue[4]));
                                            } else
                                            {
                                              sub2_buy = 0;
                                            }

                                            double sub1Sell = 0;
                                            double sub2Sell = 0;

                                            if( subUnitFieldValue[0] != ''){
                                              sub1Sell= double.parse(subUnitFieldValue[2].toString());
                                            } else
                                            {
                                              sub1Sell = 0;
                                            }
                                            if( subUnitFieldValue[4] != ''){
                                              sub2Sell = double.parse(subUnitFieldValue[6].toString());
                                            } else
                                            {
                                              sub2Sell = 0;
                                            }



                                            if (subUnitFieldValue[0] != '' && subUnitFieldValue[4] == '' && subUnitFieldValue[8] == ''){
                                              subExist = '1';
                                            } else  if (subUnitFieldValue[0] != '' && subUnitFieldValue[4] != '' && subUnitFieldValue[8] == ''){
                                              subExist = '2';
                                            } else  if (subUnitFieldValue[0] != '' && subUnitFieldValue[4] != '' && subUnitFieldValue[8] != ''){
                                              subExist = '3';
                                            } else subExist ='0';

                                            if( prodFieldsValue[2] != '') {
                                              mainStock=  double.parse(prodFieldsValue[2]);
                                              mTotal = (mainStock * double.parse(prodFieldsValue[4])).toString();
                                            } else { mainStock = 0;
                                            mTotal = (mainStock * double.parse(prodFieldsValue[4])).toString();}

                                            if( subUnitFieldValue[3] != '') {
                                              sub1Stock=  double.parse(subUnitFieldValue[3]);
//sub1Total = (sub1Stock * double.parse(sub1_buy)).toString();
                                            }
                                            else {sub1Stock = 0;
//sub1Total = (sub1Stock * double.parse(sub1_buy)).toString();
                                            }

                                            if( subUnitFieldValue[7] != '') {
                                              sub2Stock=  double.parse(subUnitFieldValue[7]);
//sub2Total = (sub2Stock * double.parse(sub2_buy)).toString();
                                            }
                                            else { sub2Stock = 0;
//sub2Total = (sub2Stock * double.parse(sub2_buy)).toString();
                                            }

                                            if( subUnitFieldValue[11] != '') {
                                              sub3Stock =  double.parse(subUnitFieldValue[11]);
//sub3Total = (sub3Stock * double.parse(sub3_buy)).toString();
                                            }
                                            else {
                                              sub3Stock = 0;
//sub3Total = (sub3Stock * double.parse(sub3_buy)).toString();
                                            }

                                            // batch.set(
                                            //     prodsArr,
                                            //     {
                                            //       'prods': {
                                            //         '$deviceIdNum-' + prodsCnt.toString(): {
                                            //           'na': prodFieldsValue[0],
                                            //           'lm': 0,
                                            //           'l1': 0,
                                            //           'l2': 0,
                                            //           'ar': false,
                                            //           'co': prodFieldsValue[1],
                                            //           'im': mainStock,
                                            //           'i1': sub1Stock,
                                            //           'i2': sub2Stock,
                                            //           'bm': double.parse(prodFieldsValue[4].toString()),
                                            //           'b1': sub1_buy,
                                            //           'b2': sub2_buy,
                                            //           'sm': double.parse(prodFieldsValue[5].toString()),
                                            //           's1': sub1Sell,
                                            //           's2': sub2Sell,
                                            //           'c1': subUnitFieldValue[0].toString() == ''? 0:double.parse(subUnitFieldValue[0].toString()),
                                            //           'c2': subUnitFieldValue[4].toString() == ''? 0:double.parse(subUnitFieldValue[4].toString()),
                                            //           'nm': prodFieldsValue[3],
                                            //           'n1': subUnitFieldValue[1],
                                            //           'n2': subUnitFieldValue[5],
                                            //           'se': double.parse(subExist.toString()),
                                            //           // 'img_1': photoArray[0],
                                            //         }
                                            //       }
                                            //     },SetOptions(merge: true)
                                            // );


                                          }
                                          else {
                                            FirebaseFirestore.instance.collection('shops').doc(shopId).collection('collArr').doc('prodsArr')
                                                .get()
                                                .then((DocumentSnapshot documentSnapshot) async {
                                              if (documentSnapshot.exists) {
                                                documentSnapshot['prods'].forEach((key, value) {
                                                  if(value['na'] ==  prodFieldsValue[0].toString()) {
                                                    setState(() {
                                                      prodExist = true;
                                                    });

                                                  }

                                                  debugPrint('document print ' + productExist.toString());
                                                  debugPrint('document print ' + prodExist.toString());
                                                });     }

                                              //
                                              // });
                                              //
                                              //
                                              //
                                              // productId.where('prod_name',
                                              //     isEqualTo:
                                              //     prodFieldsValue[0])
                                              //     .get()
                                              //     .then((QuerySnapshot
                                              // querySnapshot) async {
                                              //   querySnapshot.docs
                                              //       .forEach((doc) {
                                              //     prodExist = true;
                                              //   });

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
                                                setState(() {
                                                  widget.endProdLoadingState();
                                                  prodAdding = false;
                                                });
                                                closeOverAllSubLoading();
                                              }
                                              else {
                                                for (int i = 0;
                                                i < assets.length;
                                                i++) {
                                                  AssetEntity asset =
                                                  assets.elementAt(i);
                                                  asset.originFile.then((value) async {
                                                    addProduct(value!).then((value) {
                                                      debugPrint('value check ' + value.toString());
                                                      if(value != 'error img upload') {
                                                        photoArray[i] = value.toString();
                                                        var subUnitFieldValue = ['', '', '', '', '', '', '', '', '', '', '', '',];
                                                        int j = -1;
                                                        for (int i = 0;
                                                        i < cards.length;
                                                        i++) {
                                                          subUnitFieldValue[++j] =
                                                              nameTECs[i].text;
                                                          subUnitFieldValue[++j] =
                                                              ageTECs[i].text;
                                                          subUnitFieldValue[++j] =
                                                              jobTECs[i].text;
                                                          subUnitFieldValue[++j] =
                                                              priceTECs[i].text;
// var name = nameTECs[i].text;
// var age = ageTECs[i].text;
// var job = jobTECs[i].text;
// entries.add(PersonEntry(name, age, job));
                                                        }
                                                        debugPrint('gg nothing' +
                                                            subUnitFieldValue.toString());


                                                        double sub1_buy;
                                                        double sub2_buy;
                                                        String subExist;
                                                        double mainStock;
                                                        double sub1Stock;
                                                        double sub2Stock;
                                                        double sub3Stock;
                                                        String mTotal;


                                                        if( subUnitFieldValue[0] != ''){
                                                          sub1_buy= (double.parse(prodFieldsValue[4])/double.parse(subUnitFieldValue[0]));
                                                        } else
                                                        {
                                                          sub1_buy = 0;
                                                        }
                                                        if( subUnitFieldValue[4] != ''){
                                                          sub2_buy= (sub1_buy/double.parse(subUnitFieldValue[4]));
                                                        } else
                                                        {
                                                          sub2_buy = 0;
                                                        }

                                                        double sub1Sell = 0;
                                                        double sub2Sell = 0;

                                                        if( subUnitFieldValue[0] != ''){
                                                          sub1Sell= double.parse(subUnitFieldValue[2].toString());
                                                        } else
                                                        {
                                                          sub1Sell = 0;
                                                        }
                                                        if( subUnitFieldValue[4] != ''){
                                                          sub2Sell = double.parse(subUnitFieldValue[6].toString());
                                                        } else
                                                        {
                                                          sub2Sell = 0;
                                                        }


                                                        if (subUnitFieldValue[0] != '' && subUnitFieldValue[4] == '' && subUnitFieldValue[8] == ''){
                                                          subExist = '1';
                                                        } else  if (subUnitFieldValue[0] != '' && subUnitFieldValue[4] != '' && subUnitFieldValue[8] == ''){
                                                          subExist = '2';
                                                        } else  if (subUnitFieldValue[0] != '' && subUnitFieldValue[4] != '' && subUnitFieldValue[8] != ''){
                                                          subExist = '3';
                                                        } else subExist ='0';

                                                        if( prodFieldsValue[2] != '') {
                                                          mainStock=  double.parse(prodFieldsValue[2]);
                                                          mTotal = (mainStock * double.parse(prodFieldsValue[4])).toString();
                                                        } else { mainStock = 0;
                                                        mTotal = (mainStock * double.parse(prodFieldsValue[4])).toString();}

                                                        if( subUnitFieldValue[3] != '') {
                                                          sub1Stock=  double.parse(subUnitFieldValue[3]);
//sub1Total = (sub1Stock * double.parse(sub1_buy)).toString();
                                                        }
                                                        else {sub1Stock = 0;
//sub1Total = (sub1Stock * double.parse(sub1_buy)).toString();
                                                        }

                                                        if( subUnitFieldValue[7] != '') {
                                                          sub2Stock=  double.parse(subUnitFieldValue[7]);
//sub2Total = (sub2Stock * double.parse(sub2_buy)).toString();
                                                        }
                                                        else { sub2Stock = 0;
//sub2Total = (sub2Stock * double.parse(sub2_buy)).toString();
                                                        }

                                                        if( subUnitFieldValue[11] != '') {
                                                          sub3Stock =  double.parse(subUnitFieldValue[11]);
                                                        }
                                                        else {
                                                          sub3Stock = 0;
                                                        }



                                                        DocumentReference prodsArr = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('collArr').doc('prodsArr');

                                                        FirebaseFirestore.instance.collection('shops').doc(shopId).collection('countColl').doc('prodsCnt')
                                                            .get()
                                                            .then((value) {
                                                          int prodsCnt = value.data()!['count'];

                                                          WriteBatch batch = FirebaseFirestore.instance.batch();

                                                          batch.set(
                                                              prodsArr,
                                                              {
                                                                'prods': {
                                                                  '$deviceIdNum-' + prodsCnt.toString(): {
                                                                    'na': prodFieldsValue[0],
                                                                    'lm': 0,
                                                                    'l1': 0,
                                                                    'l2': 0,
                                                                    'ar': false,
                                                                    'co': prodFieldsValue[1],
                                                                    'im': mainStock,
                                                                    'i1': sub1Stock,
                                                                    'i2': sub2Stock,
                                                                    'bm': double.parse(prodFieldsValue[4].toString()),
                                                                    'b1': sub1_buy,
                                                                    'b2': sub2_buy,
                                                                    'sm': double.parse(prodFieldsValue[5].toString()),
                                                                    's1': sub1Sell,
                                                                    's2': sub2Sell,
                                                                    'c1': subUnitFieldValue[0].toString() == ''? 0:double.parse(subUnitFieldValue[0].toString()),
                                                                    'c2': subUnitFieldValue[4].toString() == ''? 0:double.parse(subUnitFieldValue[4].toString()),
                                                                    'nm': prodFieldsValue[3],
                                                                    'n1': subUnitFieldValue[1],
                                                                    'n2': subUnitFieldValue[5],
                                                                    'se': double.parse(subExist.toString()),
                                                                    // 'img_1': photoArray[0],
                                                                  }
                                                                }
                                                              },SetOptions(merge: true)
                                                          );

                                                          batch.update(
                                                              FirebaseFirestore.instance.collection('shops').doc(shopId).collection('countColl').doc('prodsCnt'),
                                                              {'count': FieldValue.increment(1)}
                                                          );

                                                          batch.set(
                                                              FirebaseFirestore.instance.collection('shops').doc(shopId).collection('imgArr').doc('prodsArr'),
                                                              {
                                                                'prods': {
                                                                  '$deviceIdNum-' + prodsCnt.toString(): {
                                                                    'img': photoArray[0],
                                                                  }
                                                                }
                                                              },SetOptions(merge: true)
                                                          );

                                                          DocumentReference nonceRef = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('collArr').doc('nonce_doc').collection('nonce_col').doc();
                                                          batch.set(nonceRef, {
                                                            'time': FieldValue.serverTimestamp(),
                                                          });

                                                          try {
                                                            batch.commit();
                                                            Future.delayed(
                                                                const Duration(
                                                                    milliseconds: 3000), () {
                                                              setState(() {
                                                                prodAdding = false;
                                                                widget
                                                                    .endProdLoadingState();
                                                              });
                                                              closeOverAllSubLoading();
                                                              Navigator.pop(context);

                                                              smartKyatFlash(
                                                                  prodFieldsValue[0]
                                                                      .toString() +
                                                                      ' has been added successfully.',
                                                                  's');
                                                            });

                                                          } catch(error) {
                                                            Future.delayed(
                                                                const Duration(
                                                                    milliseconds: 3000), () {
                                                              setState(() {
                                                                prodAdding = false;
                                                                widget
                                                                    .endProdLoadingState();

                                                              });
                                                              Navigator.pop(context);
                                                              closeOverAllSubLoading();
                                                              smartKyatFlash(
                                                                  'An error occurred while adding new product. Please try again later.',
                                                                  's');
                                                            });

                                                          }


                                                          // FirebaseFirestore.instance.collection('shops').doc(shopId).collection('countColl').doc('prodsCnt')
                                                          //     .update(
                                                          //     {'count': FieldValue.increment(1)}
                                                          // ).then((value) => debugPrint('updated product count'));


                                                          // FirebaseFirestore.instance.collection('shops').doc(shopId).collection('imgArr').doc('prodsArr').set({
                                                          //   'prods': {
                                                          //     '$deviceIdNum-' + prodsCnt.toString(): {
                                                          //       'img': photoArray[0],
                                                          //     }
                                                          //   }
                                                          // },SetOptions(merge: true)).then((value) {
                                                          //   debugPrint('arrays added ' + '0-' + prodsCnt.toString());
                                                          // }).catchError((error) => debugPrint("Failed to update user: $error"));
                                                        });



                                                        // CollectionReference shops = await FirebaseFirestore.instance.collection('shops').doc(
                                                        //     shopId)
                                                        //     .collection(
                                                        //     'products');
                                                        // shops.add({
                                                        //   'prod_name':
                                                        //   prodFieldsValue[0],
                                                        //   'bar_code':
                                                        //   prodFieldsValue[1],
                                                        //   'unit_name':
                                                        //   prodFieldsValue[3],
                                                        //   'unit_sell':
                                                        //   prodFieldsValue[5],
                                                        //   'inStock1' : mainStock,
                                                        //   'inStock2'  : sub1Stock,
                                                        //   'inStock3' : sub2Stock,
                                                        //   'inStock4' : sub3Stock,
                                                        //   'buyPrice1' : prodFieldsValue[4],
                                                        //   'buyPrice2' : sub1_buy,
                                                        //   'buyPrice3' : sub2_buy,
                                                        //   'buyPrice4' : sub3_buy,
                                                        //   'sub1_link':
                                                        //   subUnitFieldValue[0],
                                                        //   'sub1_name':
                                                        //   subUnitFieldValue[1],
                                                        //   'sub1_sell':
                                                        //   subUnitFieldValue[2],
                                                        //   'sub2_link':
                                                        //   subUnitFieldValue[4],
                                                        //   'sub2_name':
                                                        //   subUnitFieldValue[5],
                                                        //   'sub2_sell':
                                                        //   subUnitFieldValue[6],
                                                        //   'sub3_link':
                                                        //   subUnitFieldValue[8],
                                                        //   'sub3_name':
                                                        //   subUnitFieldValue[9],
                                                        //   'sub3_sell':
                                                        //   subUnitFieldValue[10],
                                                        //   'sub_exist': subExist,
                                                        //   'Loss1' : 0,
                                                        //   'Loss2' : 0,
                                                        //   'Loss3' : 0,
                                                        //   'Loss4' : 0,
                                                        //   'mTotal' : mTotal,
                                                        //   'mainSellUnit' : 0,
                                                        //   'sub1SellUnit' : 0,
                                                        //   'sub2SellUnit' : 0,
                                                        //   'search_name' :  FieldValue.arrayUnion([]),
                                                        //   'img_1': photoArray[0],
                                                        //   'update_time' : DateTime.now(),
                                                        //   'search_name': textSplitFunction(prodFieldsValue[0].toString()),
                                                        // }).then((value) {
                                                        //   debugPrint('product added');
                                                        //   setState(() {
                                                        //     widget.endProdLoadingState();
                                                        //     prodAdding = false;
                                                        //   });
                                                        //   Navigator.pop(context);
                                                        //   smartKyatFlash( prodFieldsValue[0].toString() +' has been added successfully.', 's');
                                                        // });
                                                      } else {
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds: 3000), () {
                                                          setState(() {
                                                            prodAdding = false;
                                                            widget
                                                                .endProdLoadingState();

                                                          });
                                                          Navigator.pop(context);
                                                          closeOverAllSubLoading();
                                                          smartKyatFlash('Something went wrong while uploading image of ' + prodFieldsValue[0].toString() + '.', 'e');
                                                        });
                                                      }

                                                    });
                                                  });
                                                }



                                              }

                                            });

                                          }

                                        }
                                      },
                                      child: prodAdding == true ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                          child: CupertinoActivityIndicator(radius: 10,)) :
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0,
                                            right: 5.0,
                                            bottom: 3.0),
                                        child: Container(
                                            child: Text(
                                                textSetSaveProd, textScaleFactor: 1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing:-0.1
                                                ),
                                                strutStyle: StrutStyle(
                                                  height: widget.isEnglish? 1.4: 1.6,
                                                  forceStrutHeight: true,
                                                )

                                            )
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
                    )
                )
              ],
            ),
          ),
          // prodAdding
          //     ? Container(
          //         width: MediaQuery.of(context).size.width,
          //         height: MediaQuery.of(context).size.height,
          //         color: Colors.grey.withOpacity(0.5),
          //         child: Center(
          //             child: Theme(
          //                 data: ThemeData(
          //                     cupertinoOverrideTheme: CupertinoThemeData(
          //                         brightness: Brightness.light)),
          //                 child: CupertinoActivityIndicator(
          //                   radius: 20,
          //                 ))),
          //       )
          //     : Container(),
        ],
      ),
    );
    // return Column(
    //   children: <Widget>[
    //     if (assets.isNotEmpty)
    //       GestureDetector(
    //         onTap: () {
    //           widget._callback();
    //
    //           // _waitUntilDone();
    //           debugPrint('_waitUntilDone ' + assets.length.toString());
    //         },
    //         child: SelectedAssetsListView(
    //           assets: assets,
    //           isDisplayingDetail: isDisplayingDetail,
    //           onResult: onResult,
    //           onRemoveAsset: removeAsset,
    //         ),
    //       ),
    //     Expanded(
    //       child: MethodListView(
    //         pickMethods: [
    //           PickMethod.cameraAndStay(
    //             maxAssetsCount: 5,
    //           ),
    //         ],
    //         onSelectMethod: selectAssets,
    //       ),
    //     ),
    //   ],
    // );
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
          child: Text('i', textScaleFactor: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,)),
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

  int photoUploadCount = 0;

  zeroToTen(String string) {
    if (int.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
  }

  // photoUploaded(length, photoArray) {
  //   debugPrint('upload ' + photoUploadCount.toString());
  //   photoUploadCount++;
  //
  //   if (length == photoUploadCount) {
  //     debugPrint('all fking done' + photoArray.toString());
  //
  //     var subUnitFieldValue = ['', '', '', '', '', '', '', '', '', '', '', ''];
  //     int j = -1;
  //     for (int i = 0; i < cards.length; i++) {
  //       subUnitFieldValue[++j] = nameTECs[i].text;
  //       subUnitFieldValue[++j] = ageTECs[i].text;
  //       subUnitFieldValue[++j] = jobTECs[i].text;
  //       subUnitFieldValue[++j] =
  //           priceTECs[i].text; // var name = nameTECs[i].text;
  //       // var age = ageTECs[i].text;
  //       // var job = jobTECs[i].text;
  //       // entries.add(PersonEntry(name, age, job));
  //     }
  //     debugPrint('gg nothing' + subUnitFieldValue.toString());
  //     setState(() {
  //       prodAdding = true;
  //     });
  //
  //     CollectionReference spaces =
  //         FirebaseFirestore.instance.collection('space');
  //     var prodExist = false;
  //     var spaceDocId = '';
  //     FirebaseFirestore.instance
  //         .collection('space')
  //         .where('user_id', isEqualTo: 'aHHin46ulpdoxOGh6kav8EDE4xn2')
  //         .get()
  //         .then((QuerySnapshot querySnapshot) {
  //       querySnapshot.docs.forEach((doc) {
  //         spaceDocId = doc.id;
  //       });
  //
  //       debugPrint('space shi p thar');
  //       getStoreId().then((String result2) {
  //         debugPrint('store id ' + result2.toString());
  //
  //         FirebaseFirestore.instance
  //             .collection('space')
  //             .doc(spaceDocId)
  //             .collection('shops')
  //             .doc(result2)
  //             .collection('products')
  //             .where('prod_name', isEqualTo: prodFieldsValue[0])
  //             .get()
  //             .then((QuerySnapshot querySnapshot) async {
  //           querySnapshot.docs.forEach((doc) {
  //             prodExist = true;
  //           });
  //
  //           if (prodExist) {
  //             debugPrint('product already');
  //             var result = await showOkAlertDialog(
  //               context: context,
  //               title: 'Warning',
  //               message: 'Product name already!',
  //               okLabel: 'OK',
  //             );
  //           } else {
  //             CollectionReference shops = FirebaseFirestore.instance
  //                 .collection('space')
  //                 .doc(spaceDocId)
  //                 .collection('shops')
  //                 .doc(result2)
  //                 .collection('products');
  //             return shops.add({
  //               'prod_name': prodFieldsValue[0],
  //               'bar_code': prodFieldsValue[1],
  //               'unit_qtity': prodFieldsValue[2],
  //               'unit_name': prodFieldsValue[3],
  //               'buy_price': prodFieldsValue[4],
  //               'sale_price': prodFieldsValue[5],
  //               'sub1_unit': subUnitFieldValue[0],
  //               'sub1_name': subUnitFieldValue[1],
  //               'sub1_sale': subUnitFieldValue[2],
  //               'sub2_unit': subUnitFieldValue[3],
  //               'sub2_name': subUnitFieldValue[4],
  //               'sub2_sale': subUnitFieldValue[5],
  //               'sub3_unit': subUnitFieldValue[6],
  //               'sub3_name': subUnitFieldValue[7],
  //               'sub3_sale': subUnitFieldValue[8],
  //               'sub1_qtity': subUnitFieldValue[9],
  //               'sub2_qtity': subUnitFieldValue[10],
  //               'sub3_qtity': subUnitFieldValue[11],
  //               'img_1': photoArray[0],
  //               // 'img_2': photoArray[1],
  //               // 'img_3': photoArray[2],
  //               // 'img_4': photoArray[3],
  //               // 'img_5': photoArray[4],
  //             }).then((value) {
  //               debugPrint('product added');
  //               setState(() {
  //                 prodAdding = false;
  //               });
  //
  //               Navigator.pop(context);
  //
  //               // FirebaseFirestore.instance.collection('space').doc(spaceDocId).collection('shops').doc(result2).collection('products').doc(value.id).collection('units')
  //               // .add({
  //               //   'prod_name': prodFieldsValue[0]
  //               // }).then((value) {
  //               //   debugPrint('product added 2');
  //               // });
  //
  //               // Navigator.pop(context);
  //             });
  //           }
  //         });
  //       });
  //     });
  //
  //     // prodFieldsValue = [];
  //   }
  // }

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

  Padding createCard(unit, isEnglish) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    var nameController = TextEditingController();
    var ageController = TextEditingController();
    var jobController = TextEditingController();
    var priceController = TextEditingController();
    priceTECs.add(priceController);
    nameTECs.add(nameController);
    ageTECs.add(ageController);
    jobTECs.add(jobController);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
                    isEnglish?
                    "#${cards.length + 1} SUB UNIT INFORMATION":
                    "#${cards.length + 1} SUB UNIT INFORMATION",
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
                    setState(() {
                      cards.length--;
                      cards.remove(cards);
                      if(cards.length < 2) {
                        unitLimit = false;
                      }
                    });
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
                    ),
                  ),
                ),
                // child: IconButton(
                //   icon: Icon(
                //     Icons.close,
                //     size: 20,
                //     color: Colors.blue,
                //   ),
                //   onPressed: () {
                //     setState(() {
                //       cards.length--;
                //       cards.remove(cards);
                //     });
                //   },
                // ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 65,
                  child: TextFormField(
                    controller: nameController,
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
                    style: TextStyle(height: 0.95, fontSize: 15/scaleFactor),
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
                      // suffixText: 'Required',
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
                      labelText: isEnglish? 'Qty/ $unit unit': 'အရေတွက်/ $unitယူနစ်',
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
                width: (MediaQuery.of(context).size.width - 30) * (1.41 / 4),
                child: TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.text,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ' Required ';
                    }
                    // prodFieldsValue.add(value);
                    return null;
                  },
                  style: TextStyle(height: 0.95, fontSize: 15/scaleFactor ),
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
                    // suffixText: 'Required',
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
                  cards.length == 0 ?
                  textSetWarning: textSetWarning2,
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
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(_getNum())),  LengthLimitingTextInputFormatter(15),],
              // The validator receives the text that the user has entered.
              validator: (value) {
                // if (value == null || value.isEmpty) {
                //   return ' This field is required ';
                // }
                // prodFieldsValue.add(value);
                return null;
              },
              style: TextStyle(height: 0.95, fontSize: 15/scaleFactor),
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
              controller: jobController,
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
              style: TextStyle(height: 0.95, fontSize: 15/scaleFactor),
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
                suffixText: currencyUnit,
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
  addSubUnit() {
    return Scaffold(
      body: Stack(
          children: [
            SafeArea(
              top: true,
              bottom: true, child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    height: 85,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: AppTheme.skBorderColor, width: 2.0))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 15, right: 15),
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
                                Icons.arrow_back_ios_rounded,
                                size: 20,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Text(
                            textSetSaveProd, textScaleFactor: 1,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: 'capsulesans',
                                fontWeight: FontWeight.w600),
                            strutStyle: StrutStyle(
                              height: widget.isEnglish? 1.4: 1.6,
                              forceStrutHeight: true,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),),
                                color: AppTheme.themeColor),
                            child: IconButton(
                                icon: Icon(
                                  Icons.check,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                }),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
            ),
          ]
      ),
    );
  }

  Future<String> getStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));

    var index = prefs.getString('store');
    debugPrint(index);
    if (index == null) {
      return 'idk';
    } else {
      return index;
    }
  }

// pickMethods() {
//   return <PickMethod>[
//     // PickMethod.image(maxAssetsCount),
//     // PickMethod.video(maxAssetsCount),
//     // PickMethod.audio(maxAssetsCount),
//     // PickMethod.camera(
//     //   maxAssetsCount: maxAssetsCount,
//     //   handleResult: (BuildContext context, AssetEntity result) =>
//     //       Navigator.of(context).pop(<AssetEntity>[...assets, result]),
//     // ),
//
//     PickMethod.cameraAndStay(
//       maxAssetsCount: 5,
//     ),
//
//     // PickMethod.common(maxAssetsCount),
//     // PickMethod.threeItemsGrid(maxAssetsCount),
//     // PickMethod.customFilterOptions(maxAssetsCount),
//     // PickMethod.prependItem(maxAssetsCount),
//     // PickMethod(
//     //   icon: '🎭',
//     //   name: 'WeChat Moment',
//     //   description: 'Pick assets like the WeChat Moment pattern.',
//     //   method: (BuildContext context, List<AssetEntity> assets) {
//     //     return AssetPicker.pickAssets(
//     //       context,
//     //       maxAssets: maxAssetsCount,
//     //       specialPickerType: SpecialPickerType.wechatMoment,
//     //     );
//     //   },
//     // ),
//     // PickMethod.noPreview(maxAssetsCount),
//     // PickMethod.keepScrollOffset(
//     //   provider: () => keepScrollProvider,
//     //   delegate: () => keepScrollDelegate!,
//     //   onPermission: (PermissionState state) {
//     //     keepScrollDelegate ??= DefaultAssetPickerBuilderDelegate(
//     //       provider: keepScrollProvider,
//     //       initialPermission: state,
//     //       keepScrollOffset: true,
//     //     );
//     //   },
//     //   onLongPress: () {
//     //     keepScrollProvider.dispose();
//     //     keepScrollProvider = DefaultAssetPickerProvider();
//     //     keepScrollDelegate?.dispose();
//     //     keepScrollDelegate = null;
//     //     ScaffoldMessenger.of(context).showSnackBar(
//     //       const SnackBar(content: Text('Resources have been released')),
//     //     );
//     //   },
//     // ),
//     // PickMethod(
//     //   icon: '🎚',
//     //   name: 'Custom image preview thumb size',
//     //   description: 'You can reduce the thumb size to get faster load speed.',
//     //   method: (BuildContext context, List<AssetEntity> assets) {
//     //     return AssetPicker.pickAssets(
//     //       context,
//     //       maxAssets: maxAssetsCount,
//     //       selectedAssets: assets,
//     //       requestType: RequestType.image,
//     //       previewThumbSize: const <int>[150, 150],
//     //       gridThumbSize: 80,
//     //     );
//     //   },
//     // ),
//   ];
// }
}

class PersonEntry {
  final String name;
  final String age;
  final String studyJob;

  PersonEntry(this.name, this.age, this.studyJob);
  @override
  String toString() {
    return 'Person: name= $name, age= $age, study job= $studyJob';
  }
}

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(App());
// }
//
// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Home(),
//     );
//   }
// }
//
// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: RaisedButton(
//           child: Text('Add entries'),
//           onPressed: () async {
//             List<PersonEntry> persons = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => SOF(),
//               ),
//             );
//             if (persons != null) persons.forEach(print);
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class SOF extends StatefulWidget {
//   @override
//   _SOFState createState() => _SOFState();
// }
//
// class _SOFState extends State<SOF> {
//   var nameTECs = <TextEditingController>[];
//   var ageTECs = <TextEditingController>[];
//   var jobTECs = <TextEditingController>[];
//   var cards = <Card>[];
//
//   Card createCard() {
//     var nameController = TextEditingController();
//     var ageController = TextEditingController();
//     var jobController = TextEditingController();
//     nameTECs.add(nameController);
//     ageTECs.add(ageController);
//     jobTECs.add(jobController);
//     return Card(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Text('Person ${cards.length + 1}'),
//           TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Full Name')),
//           TextField(
//               controller: ageController,
//               decoration: InputDecoration(labelText: 'Age')),
//           TextField(
//               controller: jobController,
//               decoration: InputDecoration(labelText: 'Study/ job')),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     cards.add(createCard());
//   }
//
//   _onDone() {
//     List<PersonEntry> entries = [];
//     for (int i = 0; i < cards.length; i++) {
//       var name = nameTECs[i].text;
//       var age = ageTECs[i].text;
//       var job = jobTECs[i].text;
//       entries.add(PersonEntry(name, age, job));
//     }
//     Navigator.pop(context, entries);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               itemCount: cards.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return cards[index];
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: RaisedButton(
//               child: Text('add new'),
//               onPressed: () => setState(() => cards.add(createCard())),
//             ),
//           )
//         ],
//       ),
//       floatingActionButton:
//       FloatingActionButton(child: Icon(Icons.done), onPressed: _onDone),
//     );
//   }
// }
//
// class PersonEntry {
//   final String name;
//   final String age;
//   final String studyJob;
//
//   PersonEntry(this.name, this.age, this.studyJob);
//   @override
//   String toString() {
//     return 'Person: name= $name, age= $age, study job= $studyJob';
//   }
// }

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  @override
  bool get opaque => false;
  FadeRoute({required this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
    transitionDuration: Duration(milliseconds: 100),
    reverseTransitionDuration: Duration(milliseconds: 150),
  );
}