import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/loss_fragment.dart';
import 'package:smartkyat_pos/fragments/subs/language_settings.dart';
import 'package:smartkyat_pos/main.dart';
import 'package:smartkyat_pos/models/product.dart';
import 'package:smartkyat_pos/pages2/home_page5.dart';
import 'package:smartkyat_pos/widgets/custom_flat_button.dart';
import 'package:smartkyat_pos/widgets/edit_product.dart';
import '../app_theme.dart';
import 'fill_product.dart';
import 'package:http/http.dart' as http;

class ProductDetailsView2 extends StatefulWidget {
  final _callback;
  final _callback3;
  final _closeCartBtn;
  final _openCartBtn;
  const ProductDetailsView2(
      {Key? key,
        required this.shopId,
        required this.idString,
        required this.prodName,
        required this.mainSell,
        required this.imgUrl,
        required this.mainName,
        required this.sub1Name,
        required this.sub2Name,
        required this.barcode,
        required this.sub1Price,
        required this.sub2Price,
        required this.sub1Unit,
        required this.sub2Unit,
        required this.subExist,
        required this.mainLoss,
        required this.sub1Loss,
        required this.sub2Loss,
        required this.mainQty,
        required this.sub1Qty,
        required this.sub2Qty,
        required this.buyPrice1,
        required this.buyPrice2,
        required this.buyPrice3,
        required this.fromSearch, required this.isEnglish,
        required void toggleCoinCallback(String str),
        required void toggleCoinCallback3(String str),
        required void openCartBtn(),
        required void closeCartBtn(),
      })
      : _callback = toggleCoinCallback,
        _callback3 = toggleCoinCallback3,
        _openCartBtn = openCartBtn,
        _closeCartBtn = closeCartBtn,
        super(key: key);

  final String idString;
  final String prodName;
  final String shopId;
  final double mainSell;
  final String imgUrl;
  final String mainName;
  final String sub1Name;
  final String sub2Name;
  final String barcode;
  final double sub1Price;
  final double sub2Price;
  final double sub1Unit;
  final double sub2Unit;
  final double subExist;
  final double mainLoss;
  final double sub1Loss;
  final double sub2Loss;
  final double mainQty;
  final double sub1Qty;
  final double sub2Qty;
  final double buyPrice1;
  final double buyPrice2;
  final double buyPrice3;
  final bool fromSearch;
  final bool isEnglish;


  @override
  ProductDetailsViewState2 createState() => ProductDetailsViewState2();
}

class ProductDetailsViewState2 extends State<ProductDetailsView2>  with
    TickerProviderStateMixin <ProductDetailsView2> {

  var deviceIdNum;
  final auth = FirebaseAuth.instance;

  bool isEnglish = true;

  var prodsSnap;

  addProduct2(data) {
    widget._callback(data);
  }

  naviDetPop() {
    debugPrint('clicked Popping ');
    Navigator.pop(context);
  }

  addProduct3(data) {
    widget._callback3(data);
  }

  getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('device');
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

  // routeLoss(res, buyPrice1, buyPrice2, buyPrice3) {
  //   Navigator.push(
  //     context, MaterialPageRoute( builder: (context) => LossProduct(idString: widget.idString, prodID: res, shopId: widget.shopId, price1: buyPrice1, price2: buyPrice2, price3: buyPrice3, openCartBtn: widget._openCartBtn,
  //   )
  //   ));
  // }

  // routeFill(res) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => FillProduct(
  //             idString: widget.idString,
  //             toggleCoinCallback: addProduct2,
  //             toggleCoinCallback3: addProduct3,
  //             unitname: res, shopId: widget.shopId,
  //           )));
  // }



  TextEditingController _textFieldController = TextEditingController();

  late int codeDialog =0;
  String prodID = '';


  late TabController _controller;
  int _sliding = 0;

  String textSetAddtoCart = 'Add to\nsale cart';
  String textSetRefill =  'Refill to\ninventory';
  String textSetAddLoss = 'Add\nLoss item';
  String textSetEdit = 'EDIT';
  String textSetMainUnit = 'UNIT ITEM (MAIN)';
  String textSetSub1 = 'UNIT ITEM (SUB 1)';
  String textSetSub2 = 'UNIT ITEM (SUB 2)';
  String textSetSalePrice = 'Sale price';
  String textSetInStock = 'In stock items';
  String textSetLoss = 'Loss items';
  String textSetBarcode = 'Barcode';
  String textSetOtherInfo = 'OTHER INFORMATION';
  String textSetTotalSale = 'Total items sold';
  String textSetBuyPrice = 'Buy price';
  String textSetLink1 = 'Items per Main Unit';
  String textSetLink2 = 'Items per Sub-1 Unit';
  String textSetArchive = 'ARCHIVE ITEM';
  String textSetRemoveItem = 'Remove this item';
  String textSetWarning = 'Once you remove it, there is no going back.';
  String textSetRemove = 'Remove';

  String currencyUnit = 'MMK';

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');

  }

  String prodName =  '';
  String mainName = '';
  String sub1Name = '';
  String sub2Name = '';
  String barcode = '';
  double mainPrice =  0;
  double sub1Price =  0;
  double sub2Price =  0;
  double sub1Unit =  0;
  double sub2Unit =  0;
  double subExist =  0;
  double mainLoss =  0;
  double sub1Loss =  0;
  double sub2Loss =  0;
  double mainQty =  0;
  double sub1Qty =  0;
  double sub2Qty =  0;
  double buyPrice1 =  0;
  double buyPrice2 =  0;
  double buyPrice3 =  0;
  String image = '';

  @override
  initState() {
    prodName = widget.prodName;
    mainName = widget.mainName;
    sub1Name = widget.sub1Name;
    sub2Name = widget.sub2Name;
    barcode = widget.barcode;
    mainPrice = widget.mainSell;
    sub1Price = widget.sub1Price;
    sub2Price = widget.sub2Price;
    sub1Unit = widget.sub1Unit;
    sub2Unit = widget.sub2Unit;
    subExist = widget.subExist;
    mainLoss = widget.mainLoss;
    sub1Loss = widget.sub1Loss;
    sub2Loss = widget.sub2Loss;
    mainQty = widget.mainQty;
    sub1Qty = widget.sub1Qty;
    sub2Qty = widget.sub2Qty;
    buyPrice1 = widget.buyPrice1;
    buyPrice2 = widget.buyPrice2;
    buyPrice3 = widget.buyPrice3;
    image = widget.imgUrl;

    getCurrency().then((value){
      setState(() {
        currencyUnit = value.toString();
      });
    });
    getDeviceId().then((value) {
      deviceIdNum = value;
    });
    _controller = new TabController(length: 3, vsync: this);
    _controller.addListener((){
      debugPrint('my index is'+ _controller.index.toString());
      if(_controller.index.toString()=='1') {
        setState(() {
          _sliding = 1;
        });
      } else if(_controller.index.toString()=='2') {
        setState(() {
          _sliding = 2;
        });
      } else {
        setState(() {
          _sliding = 0;
        });
      }
    });

    if(widget.isEnglish == true) {
      setState(() {
        isEnglish = true;
        textSetAddtoCart = 'Add to\nsale cart';
        textSetRefill =  'Refill to\ninventory';
        textSetAddLoss = 'Add\nLoss item';
        textSetEdit = 'EDIT';
        textSetMainUnit = 'UNIT ITEM (MAIN)';
        textSetSub1 = 'UNIT ITEM (SUB 1)';
        textSetSub2 = 'UNIT ITEM (SUB 2)';
        textSetSalePrice = 'Sale price';
        textSetInStock = 'In stock items';
        textSetLoss = 'Loss items';
        textSetBarcode = 'Barcode';
        textSetOtherInfo = 'OTHER INFORMATION';
        textSetTotalSale = 'Total items sold';
        textSetBuyPrice = 'Buy price';
        textSetLink1 = 'Items per Main Unit';
        textSetLink2 = 'Items per Sub-1 Unit';
        textSetArchive = 'ARCHIVE ITEM';
        textSetRemoveItem = 'Remove this item';
        textSetWarning = 'Once you remove it, there is no going back.';
        textSetRemove = 'Remove';
      });
    } else {
      setState(() {
        isEnglish = false;
        textSetAddtoCart = 'ရောင်းရန်\nစာရင်းထည့်';
        textSetRefill =  'ကုန်ပစ္စည်း\nပြန်ဖြည့်ရန်';
        textSetAddLoss = 'ဆုံးရှုံးပစ္စည်း\nထည့်ရန်';
        textSetEdit = 'ပြင်ဆင်ရန်';
        textSetMainUnit = 'UNIT ITEM (MAIN)';
        textSetSub1 = 'UNIT ITEM (SUB 1)';
        textSetSub2 = 'UNIT ITEM (SUB 2)';
        textSetSalePrice = 'ရောင်းဈေး';
        textSetInStock = 'လက်ကျန်ပစ္စည်း';
        textSetLoss = 'ဆုံးရှုံးပစ္စည်း';
        textSetBarcode = 'ဘားကုဒ်';
        textSetOtherInfo = 'OTHER INFORMATION';
        textSetTotalSale = 'ရောင်းပြီးပစ္စည်း';
        textSetBuyPrice = 'ဝယ်ဈေး';
        textSetLink1 = 'Items per Main Unit';
        textSetLink2 = 'Items per Sub-1 Unit';
        textSetArchive = 'ARCHIVE ITEM';
        textSetRemoveItem = 'ဤပစ္စည်းကို ဖယ်ရှားမည်';
        textSetWarning = 'တစ်ခါဖယ်ပြီးလျှင် နောက်ထပ်ပြန်ဖော်လို့ မရနိုင်ပါ';
        textSetRemove = 'ဖယ်ရှားမည်';
      });
    }

    super.initState();
  }
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  @override
  Widget build(BuildContext contextOver) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.end,
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
                                  currencyUnit + ' ' +mainPrice.toString(), textScaleFactor: 1,
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
                                  prodName, textScaleFactor: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
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
                // Expanded(
                //   child: StreamBuilder<Product?>(
                //     stream: objectbox.getProduct(int.parse(widget.idString)),
                //     builder: (context, snapshot) {
                //       print('snapshotting ' + snapshot.data.toString());
                //       if(snapshot.data!=null) {
                //         Product product = snapshot.data ?? Product(
                //           false, 1000,1000,1000,1000,1000, '', 1000,1000,1000,'','','','',1000,1000,1000,1000,1000,100,100,100,''
                //         );
                //         debugPrint('checking prod ' + product.na);
                //         prodName = product.na;
                //         mainName = product.nm;
                //         sub1Name = product.n1;
                //         sub2Name = product.n2;
                //         barcode = product.co;
                //         mainPrice = product.sm;
                //         sub1Price = product.s1;
                //         sub2Price = product.s2;
                //         sub1Unit = product.c1;
                //         sub2Unit = product.c2;
                //         subExist = product.se;
                //         mainLoss = 0;
                //         sub1Loss = 0;
                //         sub2Loss = 0;
                //         mainQty = product.im;
                //         sub1Qty = product.i1;
                //         sub2Qty = product.i2;
                //         buyPrice1 = product.b1;
                //         buyPrice2 = product.b2;
                //         buyPrice3 = product.bm;
                //         image = '';
                //         return CustomScrollView(
                //           slivers: <Widget>[
                //             SliverList(
                //               delegate: SliverChildListDelegate(
                //                 [
                //                   SizedBox(height: 15,),
                //                   Container(
                //                     height: 100,
                //                     child: ListView(
                //                       scrollDirection: Axis.horizontal,
                //                       children: [
                //                         Padding(
                //                           padding: const EdgeInsets.only(left: 15.0),
                //                           child: Stack(
                //                             children: [
                //                               ClipRRect(
                //                                   borderRadius:
                //                                   BorderRadius
                //                                       .circular(
                //                                       7.0),
                //                                   child: image != ""
                //                                       ? CachedNetworkImage(
                //                                     imageUrl:
                //                                     'https://smartkyatpos.com/api/uploads/' +
                //                                         image,
                //                                     width: 133,
                //                                     height: 100,
                //                                     progressIndicatorBuilder: (context, url, downloadProgress) =>
                //                                         Center(child: Container(
                //                                             height: 100,
                //                                             width: 130,
                //                                             color: Color(0xFFdca409)
                //                                         )),
                //                                     // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                //                                     errorWidget: (context, url, error) => Container(
                //                                         height: 100,
                //                                         width: 130,
                //                                         color: Color(0xFFdca409)
                //                                     ),
                //                                     fadeInDuration: Duration(milliseconds: 100),
                //                                     fadeOutDuration: Duration(milliseconds: 10),
                //                                     fadeInCurve: Curves.bounceIn,
                //                                     fit: BoxFit.cover,
                //                                   ): Container(
                //                                       height: 100,
                //                                       width: 130,
                //                                       // color: AppTheme.themeColor
                //                                       color: Color(0xFFdca409)
                //                                   )
                //                                 // : Image.asset('assets/system/default-product.png', height: 100, width: 130)
                //                               ),
                //                               ButtonTheme(
                //                                 minWidth: 133,
                //                                 height: 100,
                //                                 child: CustomFlatButton(
                //                                   // splashColor: Colors.black.withOpacity(0.2),
                //                                   color: Colors.white.withOpacity(0.78),
                //                                   shape: RoundedRectangleBorder(
                //                                     borderRadius: BorderRadius.circular(7.0),
                //                                     side: BorderSide(
                //                                       color: Colors.white.withOpacity(0.78),
                //                                     ),
                //                                   ),
                //                                   onPressed: () async {
                //                                     if (subExist == 0) {
                //                                       widget._callback( widget.idString + '^' + buyPrice1.toString() + '^' + mainPrice.toString() +
                //                                           '^unit_name^1^' + prodName + '^' + mainName + '^' + image +  '^' + '^',);
                //                                       debugPrint('result text ' + buyPrice1.toString());
                //                                     } else {
                //                                       final result =
                //                                       await showModalActionSheet<String>(
                //                                         context: context,
                //                                         title: 'This product has multiple sub items',
                //                                         actions: [
                //                                           SheetAction(
                //                                             icon: SmartKyat_POS.prodm,
                //                                             label: '1 ' + mainName,
                //                                             key: widget.idString +
                //                                                 '^' + buyPrice1.toString() +
                //                                                 '^' +
                //                                                 mainPrice.toString() +
                //                                                 '^unit_name^1^' + prodName + '^' +  mainName  + '^' + image +  '^' + '^',
                //                                           ),
                //                                           if (sub1Price != 0)
                //                                             SheetAction(
                //                                               icon: SmartKyat_POS.prods1,
                //                                               label: '1 ' + sub1Name,
                //                                               key: widget.idString +
                //                                                   '^' + buyPrice2.toString() +
                //                                                   '^' +
                //                                                   sub1Price.toString() +
                //                                                   '^sub1_name^1^' + prodName + '^' + sub1Name.toString()  + '^' + image + '^' +  sub1Qty.toString()  + '^' + sub1Unit.toString(),
                //                                             ),
                //                                           if (sub2Price != 0)
                //                                             SheetAction(
                //                                               icon: SmartKyat_POS.prods2,
                //                                               label: '1 ' + sub2Name,
                //                                               key: widget.idString +
                //                                                   '^' + buyPrice3.toString() +
                //                                                   '^' +
                //                                                   sub2Price.toString() +
                //                                                   '^sub2_name^1^' + prodName + '^' + sub2Name.toString()  + '^' + image + '^' +  sub2Qty.toString()  + '^' + sub2Unit.toString(),
                //                                             ),
                //                                         ],
                //                                       );
                //                                       widget._callback(result.toString());
                //                                       debugPrint('resut text ' + result.toString());
                //                                     }
                //                                     if(mainQty - 1 <= 0) {smartKyatFMod(context, 'Low Stock', 'w');}
                //                                   },
                //                                   child: Container(
                //                                     width: 100,
                //                                     height: 100,
                //                                     child: Stack(
                //                                       children: [
                //                                         Positioned(
                //                                           left: 0,
                //                                           top: 15,
                //                                           child: Icon(SmartKyat_POS.order,
                //                                             size: 20,
                //                                           ),
                //                                         ),
                //                                         Positioned(
                //                                           left: 0,
                //                                           bottom: 15,
                //                                           child: Text(
                //                                               textSetAddtoCart, textScaleFactor: 1, overflow: TextOverflow.ellipsis,
                //                                               style: TextStyle(
                //                                                 fontWeight: FontWeight.w500,
                //                                                 fontSize: 16,
                //                                               ),
                //                                               strutStyle: StrutStyle(
                //                                                 height: isEnglish? 1.4: 1.6,
                //                                                 forceStrutHeight: true,
                //                                               )
                //                                           ),
                //                                         ),
                //                                       ],
                //                                     ),
                //                                   ),
                //                                 ),
                //                               ),
                //                             ],
                //                           ),
                //                         ),
                //                         SizedBox(width: 10),
                //                         ButtonTheme(
                //                           minWidth: 133,
                //                           //minWidth: 50,
                //                           splashColor: Colors.transparent,
                //                           height: 100,
                //                           child: CustomFlatButton(
                //                             color: AppTheme.buttonColor2,
                //                             shape: RoundedRectangleBorder(
                //                               borderRadius: BorderRadius.circular(7.0),
                //                               side: BorderSide(
                //                                 color: AppTheme.buttonColor2,
                //                               ),
                //                             ),
                //                             onPressed: () async {
                //                               if (subExist == 0) {
                //                                 widget._closeCartBtn();
                //                                 await Navigator.push(
                //                                     context,
                //                                     MaterialPageRoute(
                //                                         builder: (context) => FillProduct(isEnglish : widget.isEnglish,
                //                                           fromSearch: widget.fromSearch,
                //                                           idString: widget.idString,
                //                                           toggleCoinCallback: addProduct2,
                //                                           toggleCoinCallback3: addProduct3,
                //                                           unitName: 'unit_name', shopId: widget.shopId, price: buyPrice1.toString(), prodName: prodName, image: image, unit: mainName, stock: sub1Unit.toString(), link: sub2Unit.toString(), subExist : subExist.toString(), qty: mainQty.toString(),
                //                                         )));
                //                                 widget._openCartBtn();
                //                               } else {
                //                                 final result =
                //                                 await showModalActionSheet<String>(
                //                                   context: context,
                //                                   title: 'This product has multiple sub items',
                //                                   actions: [
                //                                     SheetAction(
                //                                         icon: SmartKyat_POS.prodm,
                //                                         label: '1 ' + mainName,
                //                                         key: 'unit_name'),
                //                                     if (sub1Price != 0)
                //                                       SheetAction(
                //                                           icon: SmartKyat_POS.prods1,
                //                                           label: '1 ' + sub1Name,
                //                                           key: 'sub1_name'),
                //                                     if (sub2Price != 0)
                //                                       SheetAction(
                //                                           icon: SmartKyat_POS.prods2,
                //                                           label: '1 ' + sub2Name,
                //                                           key: 'sub2_name'),
                //                                   ],
                //                                 );
                //                                 if (result != null) {
                //                                   widget._closeCartBtn();
                //                                   if(result == 'sub1_name') {
                //                                     await Navigator.push(
                //                                         context,
                //                                         MaterialPageRoute(
                //                                             builder: (context) => FillProduct(isEnglish : widget.isEnglish,
                //                                               fromSearch: widget.fromSearch,
                //                                               idString: widget.idString,
                //                                               toggleCoinCallback: addProduct2,
                //                                               toggleCoinCallback3: addProduct3,
                //                                               unitName: result, shopId: widget.shopId, price: buyPrice2.toString(), prodName: prodName, image: image, unit: sub1Name, stock: sub1Unit.toString(), link: sub2Unit.toString(), subExist : subExist.toString(),qty: sub1Qty.toString(),
                //                                             )));
                //                                   } else if (result == 'sub2_name') {
                //                                     await Navigator.push(
                //                                         context,
                //                                         MaterialPageRoute(
                //                                             builder: (context) => FillProduct(isEnglish : widget.isEnglish,
                //                                               fromSearch: widget.fromSearch,
                //                                               idString: widget.idString,
                //                                               toggleCoinCallback: addProduct2,
                //                                               toggleCoinCallback3: addProduct3,
                //                                               unitName: result, shopId: widget.shopId, price: buyPrice3.toString(), prodName: prodName, image: image, unit: sub2Name,stock: sub1Unit.toString(), link: sub2Unit.toString(), subExist : subExist.toString(), qty: sub1Qty.toString(),
                //                                             )));
                //                                   } else {
                //                                     await Navigator.push(
                //                                         context,
                //                                         MaterialPageRoute(
                //                                             builder: (context) => FillProduct(
                //                                               fromSearch: widget.fromSearch,isEnglish : widget.isEnglish,
                //                                               idString: widget.idString,
                //                                               toggleCoinCallback: addProduct2,
                //                                               toggleCoinCallback3: addProduct3,
                //                                               unitName: result, shopId: widget.shopId, price: buyPrice1.toString(), prodName: prodName, image: image, unit: mainName,stock: sub1Unit.toString(), link: sub2Unit.toString(), subExist : subExist.toString(), qty: mainQty.toString(),
                //                                             )));
                //                                   }
                //                                   widget._openCartBtn();
                //                                 }
                //                               }
                //
                //                             },
                //                             child: Container(
                //                               width: 100,
                //                               height: 100,
                //                               child: Stack(
                //                                 children: [
                //                                   Positioned(
                //                                     top: 17,
                //                                     left: 0,
                //                                     child: Icon(
                //                                       SmartKyat_POS.product,
                //                                       size: 18,
                //                                     ),
                //                                   ),
                //                                   Positioned(
                //                                     bottom: 15,
                //                                     left: 0,
                //                                     child: Text(
                //                                         textSetRefill, textScaleFactor: 1, overflow: TextOverflow.ellipsis,
                //                                         style: TextStyle(
                //                                           fontWeight: FontWeight.w500,
                //                                           fontSize: 16,
                //                                         ),
                //                                         strutStyle: StrutStyle(
                //                                           height: isEnglish? 1.4: 1.6,
                //                                           forceStrutHeight: true,
                //                                         )
                //                                     ),
                //                                   ),
                //                                 ],
                //                               ),
                //                             ),
                //                           ),
                //                         ),
                //                         SizedBox(width: 11.5),
                //                         Padding(
                //                           padding: const EdgeInsets.only(right: 15.0),
                //                           child: ButtonTheme(
                //                             minWidth: 130,
                //                             splashColor: Colors.transparent,
                //                             height: 100,
                //                             child: CustomFlatButton(
                //                               color: AppTheme.clearColor,
                //                               shape: RoundedRectangleBorder(
                //                                 borderRadius: BorderRadius.circular(7.0),
                //                                 side: BorderSide(
                //                                   color: AppTheme.clearColor,
                //                                 ),
                //                               ),
                //                               onPressed: () async {
                //                                 if (subExist == 0) {
                //                                   widget._closeCartBtn();
                //                                   await Navigator.push(
                //                                       context, MaterialPageRoute( builder: (context) => LossProduct(fromSearch: widget.fromSearch, idString: widget.idString, prodID: widget.idString + '^' + prodName + '^' + mainName.toString() +
                //                                       '^unit_name' + '^' + mainQty.toString() + '^', shopId: widget.shopId, price: buyPrice1.toString(), isEnglish: widget.isEnglish,
                //                                   )
                //                                   ));
                //                                   widget._openCartBtn();
                //                                 } else {
                //                                   final result =
                //                                   await showModalActionSheet<String>(
                //                                     context: context,
                //                                     title: 'This product has multiple sub items',
                //                                     actions: [
                //                                       SheetAction(
                //                                         icon: SmartKyat_POS.prodm,
                //                                         label: '1 ' + mainName,
                //                                         key:  widget.idString + '^' + prodName + '^' + mainName.toString() +
                //                                             '^unit_name' + '^' + mainQty.toString() + '^',
                //                                       ),
                //                                       if (sub1Price != 0)
                //                                         SheetAction(
                //                                           icon: SmartKyat_POS.prods1,
                //                                           label: '1 ' + sub1Name,
                //                                           key:  widget.idString + '^' + prodName + '^' + sub1Name.toString() +
                //                                               '^sub1_name' + '^' + sub1Qty.toString() + '^' + sub1Unit.toString(),
                //                                         ),
                //                                       if (sub2Price != 0)
                //                                         SheetAction(
                //                                           icon: SmartKyat_POS.prods2,
                //                                           label: '1 ' + sub2Name,
                //                                           key:  widget.idString + '^' + prodName + '^' + sub2Name.toString() +
                //                                               '^sub2_name' + '^' + sub2Qty.toString() + '^' + sub2Unit.toString(),
                //                                         ),
                //                                     ],
                //                                   );
                //                                   if (result != null) {
                //                                     widget._closeCartBtn();
                //                                     if(result.split('^')[3] == 'sub1_name') {
                //                                       await Navigator.push(
                //                                           context, MaterialPageRoute( builder: (context) => LossProduct(isEnglish: widget.isEnglish, idString: widget.idString, prodID: result, shopId: widget.shopId, price: buyPrice2.toString(), fromSearch: widget.fromSearch,
                //                                       )
                //                                       ));
                //                                     } else if(result.split('^')[3] == 'sub2_name') {
                //                                       await Navigator.push(
                //                                           context, MaterialPageRoute( builder: (context) => LossProduct(isEnglish: widget.isEnglish, idString: widget.idString, prodID: result, shopId: widget.shopId, price: buyPrice3.toString(), fromSearch: widget.fromSearch,
                //                                       )
                //                                       ));
                //                                     } else {
                //                                       await Navigator.push(
                //                                           context, MaterialPageRoute( builder: (context) => LossProduct(isEnglish: widget.isEnglish, idString: widget.idString, prodID: result, shopId: widget.shopId, price: buyPrice1.toString(), fromSearch: widget.fromSearch,
                //                                       )
                //                                       ));
                //                                     }
                //                                     widget._openCartBtn();
                //                                   }
                //                                 }
                //                               },
                //                               child: Container(
                //                                 width: 100,
                //                                 height: 100,
                //                                 child: Stack(
                //                                   children: [
                //                                     Positioned(
                //                                       top: 15,
                //                                       left: 0,
                //                                       child: Icon(
                //                                         Icons.delete,
                //                                         size: 22,
                //                                       ),
                //                                     ),
                //                                     Positioned(
                //                                       bottom: 15,
                //                                       left: 0,
                //                                       child: Text(
                //                                           textSetAddLoss, textScaleFactor: 1, overflow: TextOverflow.ellipsis,
                //                                           style: TextStyle(
                //                                             fontWeight: FontWeight.w500,
                //                                             fontSize: 16,
                //                                           ),
                //                                           strutStyle: StrutStyle(
                //                                             height: isEnglish? 1.4: 1.6,
                //                                             forceStrutHeight: true,
                //                                           )
                //                                       ),
                //                                     ),
                //                                   ],
                //                                 ),
                //                               ),
                //                             ),
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                   SizedBox(height: 5)
                //                 ],
                //               ),
                //             ),
                //             SliverPersistentHeader(
                //               pinned: true,
                //               delegate: _SliverAppBarDelegate(
                //                   minHeight: 56.0,
                //                   maxHeight: 56.0,
                //                   child: Container(
                //                     color: Colors.white,
                //                     child: Padding(
                //                       padding: const EdgeInsets.only(left: 15, right: 0.0, top: 12.0, bottom: 12.0),
                //                       child: Row(
                //                         children: [
                //                           Row(
                //                             children: [
                //                               CustomFlatButton(
                //                                 padding: EdgeInsets.only(left: 0, right: 0),
                //                                 color: AppTheme.secButtonColor,
                //                                 shape: RoundedRectangleBorder(
                //                                   borderRadius: BorderRadius.circular(8.0),
                //                                   side: BorderSide(
                //                                     color: AppTheme.skBorderColor2,
                //                                   ),
                //                                 ),
                //                                 onPressed: () async {
                //                                   widget._closeCartBtn();
                //                                   var result = await Navigator.push(
                //                                       context,
                //                                       MaterialPageRoute(
                //                                           builder: (context) => EditProduct(image: image, shopId: widget.shopId, prodId: widget.idString, prodName: prodName, mainQty: double.parse(mainQty.toString()), mainName: mainName, mainBuy: double.parse(buyPrice1.toString()), mainSell: double.parse(mainPrice.toString()), barcode: barcode, sub1perUnit: double.parse(sub1Unit.toString()), sub1UnitName: sub1Name, sub1Qty: double.parse(sub1Qty.toString()), sub1Sell: double.parse(sub1Price.toString()), sub2perUnit: double.parse(sub2Unit.toString()), sub2UnitName: sub2Name, isEnglish : widget.isEnglish, sub2Qty: double.parse(sub2Qty.toString()), sub2Sell: double.parse(sub2Price.toString()), fromSearch: widget.fromSearch, subExist : double.parse(subExist.toString()))));
                //                                   widget._openCartBtn();
                //                                   debugPrint('result check ' + result.toString());
                //                                 },
                //                                 child: Padding(
                //                                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //                                   child: Row(
                //                                     // mainAxisAlignment: Main,
                //                                     children: [
                //                                       Padding(
                //                                         padding: const EdgeInsets.only(right: 6.0),
                //                                         child: Icon(
                //                                           Icons.edit_rounded,
                //                                           size: 17,
                //                                         ),
                //                                       ),
                //                                       Text(
                //                                         widget.isEnglish? 'Edit item': 'ပြင်ဆင်ရန်', textScaleFactor: 1,
                //                                         textAlign: TextAlign.center,
                //                                         style: TextStyle(
                //                                             fontSize: 14,
                //                                             fontWeight: FontWeight.w500,
                //                                             color: Colors.black),
                //                                       ),
                //                                     ],
                //                                   ),
                //                                 ),
                //                               ),
                //                               SizedBox(width: 12),
                //                               Container(
                //                                 color: Colors.grey.withOpacity(0.2),
                //                                 width: 1.5,
                //                                 height: 30,
                //                               )
                //                             ],
                //                           ),
                //                           Expanded(
                //                             child: ListView(
                //                               scrollDirection: Axis.horizontal,
                //                               children: [
                //                                 SizedBox(width: 10),
                //                                 CustomFlatButton(
                //                                   // minWidth: 0,
                //                                   padding: EdgeInsets.only(left: 8, right: 12),
                //                                   color: _sliding == 0 ? AppTheme.secButtonColor:Colors.white,
                //                                   shape: RoundedRectangleBorder(
                //                                     borderRadius: BorderRadius.circular(50.0),
                //                                     side: BorderSide(
                //                                       color: AppTheme.skBorderColor2,
                //                                     ),
                //                                   ),
                //                                   onPressed: () {
                //                                     _controller.animateTo(0);
                //                                   },
                //                                   child:Container(
                //                                     child: Row(
                //                                       children: [
                //                                         Icon(SmartKyat_POS.prodm, size: 20, color: Colors.grey),
                //                                         SizedBox(width: 4),
                //                                         Text(
                //                                           mainName, textScaleFactor: 1,
                //                                           textAlign: TextAlign.center,
                //                                           style: TextStyle(
                //                                               fontSize: 14,
                //                                               fontWeight: FontWeight.w500,
                //                                               color: Colors.black),
                //                                         ),
                //                                       ],
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 sub1Name != '' ? SizedBox(width: 10): Container(),
                //                                 sub1Name != '' ? CustomFlatButton(
                //                                   // minWidth: 0,
                //                                   padding: EdgeInsets.only(left: 8, right: 12),
                //                                   color: _sliding == 1 ? AppTheme.secButtonColor:Colors.white,
                //                                   shape: RoundedRectangleBorder(
                //                                     borderRadius: BorderRadius.circular(20.0),
                //                                     side: BorderSide(
                //                                       color: AppTheme.skBorderColor2,
                //                                     ),
                //                                   ),
                //                                   onPressed: () {
                //                                     _controller.animateTo(1);
                //                                   },
                //                                   child:Container(
                //                                     child: Row(
                //                                       children: [
                //                                         Icon(SmartKyat_POS.prods1, size: 20, color: Colors.grey),
                //                                         SizedBox(width: 4),
                //                                         Text(
                //                                           sub1Name, textScaleFactor: 1,
                //                                           textAlign: TextAlign.center,
                //                                           style: TextStyle(
                //                                               fontSize: 14,
                //                                               fontWeight: FontWeight.w500,
                //                                               color: Colors.black),
                //                                         ),
                //                                       ],
                //                                     ),
                //                                   ),
                //                                 ) : Container(),
                //                                 sub2Name != '' ? SizedBox(width: 10): Container(),
                //                                 sub2Name != '' ? CustomFlatButton(
                //                                   // minWidth: 0,
                //                                   padding: EdgeInsets.only(left: 8, right: 12),
                //                                   color: _sliding == 2 ? AppTheme.secButtonColor:Colors.white,
                //                                   shape: RoundedRectangleBorder(
                //                                     borderRadius: BorderRadius.circular(20.0),
                //                                     side: BorderSide(
                //                                       color: AppTheme.skBorderColor2,
                //                                     ),
                //                                   ),
                //                                   onPressed: () {
                //                                     _controller.animateTo(2);
                //                                   },
                //                                   child:Container(
                //                                     child: Row(
                //                                       children: [
                //                                         Icon(SmartKyat_POS.prods2, size: 20, color: Colors.grey),
                //                                         SizedBox(width: 4),
                //                                         Text(
                //                                           sub2Name, textScaleFactor: 1,
                //                                           textAlign: TextAlign.center,
                //                                           style: TextStyle(
                //                                               fontSize: 14,
                //                                               fontWeight: FontWeight.w500,
                //                                               color: Colors.black),
                //                                         ),
                //                                       ],
                //                                     ),
                //                                   ),
                //                                 ) : Container(),
                //                                 SizedBox(width: 15),
                //                               ],
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   )
                //               ),
                //             ),
                //             SliverList(
                //               delegate: SliverChildListDelegate(
                //                 [
                //                   Padding(
                //                     padding: const EdgeInsets.only(top: 5.0),
                //                     child: Container(
                //                       height: 310,
                //                       child: TabBarView(
                //                         controller: _controller,
                //                         physics: NeverScrollableScrollPhysics(),
                //                         children: [
                //                           Padding(
                //                             padding: const EdgeInsets.symmetric(horizontal: 15.0),
                //                             child: Column(
                //                               crossAxisAlignment: CrossAxisAlignment.start,
                //                               children: [
                //                                 Text(
                //                                   textSetMainUnit, textScaleFactor: 1,
                //                                   style: TextStyle(
                //                                     fontWeight: FontWeight.bold,
                //                                     fontSize: 14,
                //                                     letterSpacing: 2,
                //                                     color: Colors.grey,
                //                                   ),
                //                                 ),
                //                                 SizedBox(height: 15,),
                //                                 Container(
                //                                   height:  275,
                //                                   decoration: BoxDecoration(
                //                                     borderRadius: BorderRadius.circular(20.0),
                //                                     color: AppTheme.lightBgColor,
                //                                   ),
                //                                   child: Padding(
                //                                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                //                                     child: Column(
                //                                       crossAxisAlignment: CrossAxisAlignment.start,
                //                                       children: [
                //                                         Container(
                //                                           height: 55,
                //                                           decoration: BoxDecoration(border: Border(bottom: BorderSide(
                //                                               color: Colors.grey
                //                                                   .withOpacity(0.2),
                //                                               width: 1.0))),
                //                                           child: Row(
                //                                             children: [
                //                                               Text(textSetBuyPrice, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                               ),),
                //                                               Spacer(),
                //                                               Text('$currencyUnit ' + buyPrice1.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),),
                //                                             ],
                //                                           ),
                //                                         ),
                //                                         Container(
                //                                           height: 55,
                //                                           decoration: BoxDecoration(border: Border(bottom: BorderSide(
                //                                               color: Colors.grey
                //                                                   .withOpacity(0.2),
                //                                               width: 1.0))),
                //                                           child: Row(
                //                                             children: [
                //                                               Text(textSetSalePrice, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                               ),),
                //                                               Spacer(),
                //                                               Text('$currencyUnit ' + mainPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),),
                //                                             ],
                //                                           ),
                //                                         ),
                //                                         Container(
                //                                           height: 55,
                //                                           decoration: BoxDecoration(
                //                                               border: Border(
                //                                                   bottom: BorderSide(
                //                                                       color: Colors.grey
                //                                                           .withOpacity(0.2),
                //                                                       width: 1.0))),
                //                                           child: Row(
                //                                             children: [
                //                                               Text(textSetInStock, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                               ),),
                //                                               Spacer(),
                //                                               Text(mainQty.round().toString() + ' ' + mainName, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),),
                //                                             ],
                //                                           ),
                //                                         ),
                //                                         Container(
                //                                           height: 55,
                //                                           decoration: BoxDecoration(
                //                                               border: Border(
                //                                                   bottom: BorderSide(
                //                                                       color: Colors.grey
                //                                                           .withOpacity(0.2),
                //                                                       width: 1.0))),
                //                                           child: Row(
                //                                             children: [
                //                                               Text(textSetLoss, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                               ),),
                //                                               Spacer(),
                //                                               Text(mainLoss.round().toString() + ' ' + mainName, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),),
                //
                //                                             ],
                //                                           ),
                //                                         ),
                //                                         Container(
                //                                           height: 55,
                //                                           child: Row(
                //                                             children: [
                //                                               Text(textSetBarcode, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                               ),),
                //                                               Spacer(),
                //                                               Text(barcode, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),),
                //                                             ],
                //                                           ),
                //                                         ),
                //                                       ],
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 // SizedBox(height: 20),
                //                                 // Container(
                //                                 //   height: 1,
                //                                 //   decoration: BoxDecoration(border: Border(bottom: BorderSide(
                //                                 //       color: Colors.grey
                //                                 //           .withOpacity(0.4),
                //                                 //       width: 1.0))),),
                //                                 // SizedBox(height: 20),
                //                                 // Text(
                //                                 //   textSetOtherInfo,
                //                                 //   style: TextStyle(
                //                                 //     fontWeight: FontWeight.bold,
                //                                 //     fontSize: 14,
                //                                 //     letterSpacing: 2,
                //                                 //     color: Colors.grey,
                //                                 //   ),
                //                                 // ),
                //                                 // SizedBox(height: 15,),
                //                                 // Container(
                //                                 //   height: 220,
                //                                 //   decoration: BoxDecoration(
                //                                 //     borderRadius: BorderRadius.circular(20.0),
                //                                 //     color: AppTheme.lightBgColor,
                //                                 //   ),
                //                                 //   child: Padding(
                //                                 //     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                //                                 //     child: Column(
                //                                 //       crossAxisAlignment: CrossAxisAlignment.start,
                //                                 //       children: [
                //                                 //         Container(
                //                                 //           height: 55,
                //                                 //           decoration: BoxDecoration(
                //                                 //               border: Border(
                //                                 //                   bottom: BorderSide(
                //                                 //                       color: Colors.grey
                //                                 //                           .withOpacity(0.2),
                //                                 //                       width: 1.0))),
                //                                 //           child: Row(
                //                                 //             children: [
                //                                 //               Text(textSetTotalSale, style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //               ),),
                //                                 //               Spacer(),
                //                                 //               Text(totalSale.round().toString() + ' $mainName', style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //                 color: Colors.grey,
                //                                 //               ),),
                //                                 //             ],
                //                                 //           ),
                //                                 //         ),
                //                                 //         Container(
                //                                 //           height: 55,
                //                                 //           decoration: BoxDecoration(
                //                                 //               border: Border(
                //                                 //                   bottom: BorderSide(
                //                                 //                       color: Colors.grey
                //                                 //                           .withOpacity(0.2),
                //                                 //                       width: 1.0))),
                //                                 //           child: Row(
                //                                 //             children: [
                //                                 //               Text(textSetInStock, style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //               ),),
                //                                 //               Spacer(),
                //                                 //               Text('124 Far', style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //                 color: Colors.grey,
                //                                 //               ),),
                //                                 //             ],
                //                                 //           ),
                //                                 //         ),
                //                                 //         Container(
                //                                 //           height: 55,
                //                                 //           decoration: BoxDecoration(
                //                                 //               border: Border(
                //                                 //                   bottom: BorderSide(
                //                                 //                       color: Colors.grey
                //                                 //                           .withOpacity(0.2),
                //                                 //                       width: 1.0))),
                //                                 //           child: Row(
                //                                 //             children: [
                //                                 //               Text(textSetLoss, style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //               ),),
                //                                 //               Spacer(),
                //                                 //               Text('5 Far', style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //                 color: Colors.grey,
                //                                 //               ),),
                //                                 //             ],
                //                                 //           ),
                //                                 //         ),
                //                                 //         Container(
                //                                 //           height: 55,
                //                                 //           child: Row(
                //                                 //             children: [
                //                                 //               Text(textSetBarcode, style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //               ),),
                //                                 //               Spacer(),
                //                                 //               Text('3kro46456218', style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //                 color: Colors.grey,
                //                                 //               ),),
                //                                 //             ],
                //                                 //           ),
                //                                 //         ),
                //                                 //       ],
                //                                 //     ),
                //                                 //   ),
                //                                 // ),
                //                               ],
                //                             ),
                //                           ),
                //                           sub1Name != '' ? Padding(
                //                             padding: const EdgeInsets.symmetric(horizontal: 15.0),
                //                             child: Column(
                //                               crossAxisAlignment: CrossAxisAlignment.start,
                //                               children: [
                //                                 Text(
                //                                   textSetSub1, textScaleFactor: 1,
                //                                   style: TextStyle(
                //                                     fontWeight: FontWeight.bold,
                //                                     fontSize: 14,
                //                                     letterSpacing: 2,
                //                                     color: Colors.grey,
                //                                   ),
                //                                 ),
                //                                 SizedBox(height: 15,),
                //                                 Container(
                //                                   height:  275,
                //                                   decoration: BoxDecoration(
                //                                     borderRadius: BorderRadius.circular(20.0),
                //                                     color: AppTheme.lightBgColor,
                //                                   ),
                //                                   child: Padding(
                //                                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                //                                     child: Column(
                //                                       crossAxisAlignment: CrossAxisAlignment.start,
                //                                       children: [
                //                                         Container(
                //                                           height: 55,
                //                                           decoration: BoxDecoration(border: Border(bottom: BorderSide(
                //                                               color: Colors.grey
                //                                                   .withOpacity(0.2),
                //                                               width: 1.0))),
                //                                           child: Row(
                //                                             children: [
                //                                               Text(textSetBuyPrice, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                               ),),
                //                                               Spacer(),
                //                                               Text('$currencyUnit ' + buyPrice2.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),),
                //                                             ],
                //                                           ),
                //                                         ),
                //                                         Container(
                //                                           height: 55,
                //                                           decoration: BoxDecoration(border: Border(bottom: BorderSide(
                //                                               color: Colors.grey
                //                                                   .withOpacity(0.2),
                //                                               width: 1.0))),
                //                                           child: Row(
                //                                             children: [
                //                                               Text(textSetSalePrice, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                               ),),
                //                                               Spacer(),
                //                                               Text('$currencyUnit ' + sub1Price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),),
                //                                             ],
                //                                           ),
                //                                         ),
                //                                         Container(
                //                                           height: 55,
                //                                           decoration: BoxDecoration(
                //                                               border: Border(
                //                                                   bottom: BorderSide(
                //                                                       color: Colors.grey
                //                                                           .withOpacity(0.2),
                //                                                       width: 1.0))),
                //                                           child: Row(
                //                                             children: [
                //                                               Text(textSetInStock, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                               ),),
                //                                               Spacer(),
                //                                               Text( sub1Qty.round().toString() + ' ' + sub1Name, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),),
                //                                             ],
                //                                           ),
                //                                         ),
                //                                         Container(
                //                                           height: 55,
                //                                           decoration: BoxDecoration(
                //                                               border: Border(
                //                                                   bottom: BorderSide(
                //                                                       color: Colors.grey
                //                                                           .withOpacity(0.2),
                //                                                       width: 1.0))),
                //                                           child: Row(
                //                                             children: [
                //                                               Text(textSetLoss,textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                               ),),
                //                                               Spacer(),
                //                                               Text(sub1Loss.round().toString() + ' ' + sub1Name, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),),
                //                                             ],
                //                                           ),
                //                                         ),
                //                                         Container(
                //                                           height: 55,
                //                                           child: Row(
                //                                             children: [
                //                                               Text(
                //                                                 textSetLink1, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                               ),),
                //                                               Spacer(),
                //                                               Text(sub1Unit.toString() + ' ' + sub1Name.toString(),textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),),
                //                                             ],
                //                                           ),
                //                                         ),
                //                                       ],
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 // SizedBox(height: 20),
                //                                 // Container(
                //                                 //   height: 1,
                //                                 //   decoration: BoxDecoration(border: Border(bottom: BorderSide(
                //                                 //       color: Colors.grey
                //                                 //           .withOpacity(0.2),
                //                                 //       width: 1.0))),),
                //                                 // SizedBox(height: 20),
                //                                 // Text(
                //                                 //   textSetOtherInfo,
                //                                 //   style: TextStyle(
                //                                 //     fontWeight: FontWeight.bold,
                //                                 //     fontSize: 14,
                //                                 //     letterSpacing: 2,
                //                                 //     color: Colors.grey,
                //                                 //   ),
                //                                 // ),
                //                                 // SizedBox(height: 15,),
                //                                 // Container(
                //                                 //   height: 220,
                //                                 //   decoration: BoxDecoration(
                //                                 //     borderRadius: BorderRadius.circular(20.0),
                //                                 //     color: AppTheme.lightBgColor,
                //                                 //   ),
                //                                 //   child: Padding(
                //                                 //     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                //                                 //     child: Column(
                //                                 //       crossAxisAlignment: CrossAxisAlignment.start,
                //                                 //       children: [
                //                                 //         Container(
                //                                 //           height: 55,
                //                                 //           decoration: BoxDecoration(
                //                                 //               border: Border(
                //                                 //                   bottom: BorderSide(
                //                                 //                       color: Colors.grey
                //                                 //                           .withOpacity(0.2),
                //                                 //                       width: 1.0))),
                //                                 //           child: Row(
                //                                 //             children: [
                //                                 //               Text(textSetTotalSale, style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //               ),),
                //                                 //               Spacer(),
                //                                 //               Text(totalSale2.round().toString() + ' $sub1Name', style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //                 color: Colors.grey,
                //                                 //               ),),
                //                                 //             ],
                //                                 //           ),
                //                                 //         ),
                //                                 //         Container(
                //                                 //           height: 55,
                //                                 //           decoration: BoxDecoration(
                //                                 //               border: Border(
                //                                 //                   bottom: BorderSide(
                //                                 //                       color: Colors.grey
                //                                 //                           .withOpacity(0.2),
                //                                 //                       width: 1.0))),
                //                                 //           child: Row(
                //                                 //             children: [
                //                                 //               Text(textSetInStock, style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //               ),),
                //                                 //               Spacer(),
                //                                 //               Text('124 Far', style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //                 color: Colors.grey,
                //                                 //               ),),
                //                                 //             ],
                //                                 //           ),
                //                                 //         ),
                //                                 //         Container(
                //                                 //           height: 55,
                //                                 //           decoration: BoxDecoration(
                //                                 //               border: Border(
                //                                 //                   bottom: BorderSide(
                //                                 //                       color: Colors.grey
                //                                 //                           .withOpacity(0.2),
                //                                 //                       width: 1.0))),
                //                                 //           child: Row(
                //                                 //             children: [
                //                                 //               Text(textSetLoss, style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //               ),),
                //                                 //               Spacer(),
                //                                 //               Text('5 Far', style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //                 color: Colors.grey,
                //                                 //               ),),
                //                                 //             ],
                //                                 //           ),
                //                                 //         ),
                //                                 //         Container(
                //                                 //           height: 55,
                //                                 //           child: Row(
                //                                 //             children: [
                //                                 //               Text(textSetBarcode, style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //               ),),
                //                                 //               Spacer(),
                //                                 //               Text('3kro46456218', style:
                //                                 //               TextStyle(
                //                                 //                 fontSize: 15,
                //                                 //                 fontWeight: FontWeight.w500,
                //                                 //                 color: Colors.grey,
                //                                 //               ),),
                //                                 //             ],
                //                                 //           ),
                //                                 //         ),
                //                                 //       ],
                //                                 //     ),
                //                                 //   ),
                //                                 // ),
                //                               ],
                //                             ),
                //                           ) : Container(),
                //                           sub2Name != '' ? Padding(
                //                             padding: const EdgeInsets.symmetric(horizontal: 15.0),
                //                             child: Column(
                //                               crossAxisAlignment: CrossAxisAlignment.start,
                //                               children: [
                //                                 Text(
                //                                   textSetSub2, textScaleFactor: 1,
                //                                   style: TextStyle(
                //                                     fontWeight: FontWeight.bold,
                //                                     fontSize: 14,
                //                                     letterSpacing: 2,
                //                                     color: Colors.grey,
                //                                   ),
                //                                 ),
                //                                 SizedBox(height: 15,),
                //                                 Container(
                //                                   height:  275,
                //                                   decoration: BoxDecoration(
                //                                     borderRadius: BorderRadius.circular(15.0),
                //                                     color: AppTheme.lightBgColor,
                //                                   ),
                //                                   child: Padding(
                //                                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                //                                     child: Column(
                //                                       crossAxisAlignment: CrossAxisAlignment.start,
                //                                       children: [
                //                                         Container(
                //                                           height: 55,
                //                                           decoration: BoxDecoration(border: Border(bottom: BorderSide(
                //                                               color: Colors.grey
                //                                                   .withOpacity(0.2),
                //                                               width: 1.0))),
                //                                           child: Row(
                //                                             children: [
                //                                               Text(textSetBuyPrice, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                               ),),
                //                                               Spacer(),
                //                                               Text('$currencyUnit ' + buyPrice3.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),),
                //                                             ],
                //                                           ),
                //                                         ),
                //                                         Container(
                //                                           height: 55,
                //                                           decoration: BoxDecoration(border: Border(bottom: BorderSide(
                //                                               color: Colors.grey
                //                                                   .withOpacity(0.2),
                //                                               width: 1.0))),
                //                                           child: Row(
                //                                             children: [
                //                                               Text(textSetSalePrice, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                               ),),
                //                                               Spacer(),
                //                                               Text('$currencyUnit ' + sub2Price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),),
                //                                             ],
                //                                           ),
                //                                         ),
                //                                         Container(
                //                                           height: 55,
                //                                           decoration: BoxDecoration(
                //                                               border: Border(
                //                                                   bottom: BorderSide(
                //                                                       color: Colors.grey
                //                                                           .withOpacity(0.2),
                //                                                       width: 1.0))),
                //                                           child: Row(
                //                                             children: [
                //                                               Text(textSetInStock, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                               ),),
                //                                               Spacer(),
                //                                               Text(sub2Qty.round().toString() + ' ' + sub2Name, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),),
                //                                             ],
                //                                           ),
                //                                         ),
                //                                         Container(
                //                                           height: 55,
                //                                           decoration: BoxDecoration(
                //                                               border: Border(
                //                                                   bottom: BorderSide(
                //                                                       color: Colors.grey
                //                                                           .withOpacity(0.2),
                //                                                       width: 1.0))),
                //                                           child: Row(
                //                                             children: [Text(textSetLoss, textScaleFactor: 1,
                //                                               style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,),),
                //                                               Spacer(),
                //                                               Text(sub2Loss.round().toString() + ' ' + sub2Name, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),)
                //                                             ],
                //                                           ),
                //                                         ),
                //                                         Container(
                //                                           height: 55,
                //                                           child: Row(
                //                                             children: [
                //                                               Text(textSetLink2, textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                               ),),
                //                                               Spacer(),
                //                                               Text(sub2Unit.toString() + ' ' +sub2Name.toString(), textScaleFactor: 1, style:
                //                                               TextStyle(
                //                                                 fontSize: 15,
                //                                                 fontWeight: FontWeight.w500,
                //                                                 color: Colors.grey,
                //                                               ),),
                //                                             ],
                //                                           ),
                //                                         ),
                //                                       ],
                //                                     ),
                //                                   ),
                //                                 ),
                //                               ],
                //                             ),
                //                           ) : Container(),
                //                         ],
                //                       ),
                //                     ),
                //                   ),
                //                   SizedBox(height: 15,),
                //                   Container(
                //                     decoration: BoxDecoration(
                //                         border: Border(
                //                             bottom: BorderSide(
                //                                 color: AppTheme.skBorderColor2,
                //                                 width: 0.5)
                //                         )),
                //                     height: 1,
                //                   ),
                //                   Column(
                //                     crossAxisAlignment: CrossAxisAlignment.stretch,
                //                     children: [
                //                       SizedBox(height: 15,),
                //                       Padding(
                //                         padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                //                         child: Text(
                //                           textSetArchive, textScaleFactor: 1,
                //                           style: TextStyle(
                //                             fontWeight: FontWeight.bold,
                //                             fontSize: 14,
                //                             letterSpacing: 2,
                //                             color: Colors.grey,
                //                           ),
                //                         ),
                //                       ),
                //                       SizedBox(height: 13,),
                //                       Padding(
                //                         padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                //                         child: Container(
                //                           decoration: BoxDecoration(
                //                             borderRadius: BorderRadius.circular(15.0),
                //                             color: AppTheme.lightBgColor,
                //                           ),
                //                           child: Padding(
                //                             padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
                //                             child: Container(
                //                               // color: Colors.yellow,
                //                               child: ListTile(
                //                                 // leading: Padding(
                //                                 //   padding: const EdgeInsets.only(top: 2.0),
                //                                 //   child: Text('jsidfaj'),
                //                                 // ),
                //                                 minLeadingWidth: 15,
                //                                 horizontalTitleGap: 10,
                //                                 minVerticalPadding: 0,
                //                                 title: Container(
                //                                   child: Padding(
                //                                     padding: const EdgeInsets.only(bottom: 8.0),
                //                                     child: Text(textSetRemoveItem, textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
                //                                         fontWeight: FontWeight.w500, fontSize: 16, height: 1.2)),
                //                                   ),
                //                                 ),
                //                                 subtitle: Padding(
                //                                   padding: const EdgeInsets.only(bottom: 8.0),
                //                                   child: Text(textSetWarning, textScaleFactor: 1, style: TextStyle(height: 1.2)),
                //                                 ),
                //                                 trailing: Container(
                //                                   height: 33,
                //                                   child: CustomFlatButton(
                //                                     padding: EdgeInsets.only(left: 0, right: 0),
                //                                     color: AppTheme.badgeBgDanger2,
                //                                     shape: RoundedRectangleBorder(
                //                                       borderRadius: BorderRadius.circular(10.0),
                //                                     ),
                //                                     onPressed: () async {
                //                                       DocumentReference product = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr');
                //                                       DocumentReference productImg = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('imgArr').doc('prodsArr');
                //
                //                                       showOkCancelAlertDialog(
                //                                         context: context,
                //                                         title: 'Are you sure you want to remove this product?',
                //                                         message: 'This action cannot go back later.',
                //                                         defaultType: OkCancelAlertDefaultType.cancel,
                //                                       ).then((result) async {
                //                                         if(result == OkCancelResult.ok) {
                //                                           debugPrint('widgeturl' + widget.imgUrl);
                //                                           if(widget.imgUrl != null && widget.imgUrl != '') {
                //                                             try {
                //                                               final resultInt = await InternetAddress.lookup('google.com');
                //                                               if (resultInt.isNotEmpty && resultInt[0].rawAddress.isNotEmpty) {
                //                                                 removeImgServer(widget.imgUrl).then((value) async {
                //                                                   debugPrint('val lue' + value.toString());
                //                                                   if(value == 200) {
                //                                                     debugPrint('all set');
                //                                                     smartKyatFlash(prodName.toString() + ' is successfully removed.', 's');
                //
                //                                                     product.update({
                //                                                       'prods.' + widget.idString: FieldValue.delete()
                //                                                     }).then((value) async {
                //                                                     }).catchError((error) => debugPrint("Failed to update:  0 $error"));
                //
                //                                                     productImg.update({
                //                                                       'prods.' + widget.idString: FieldValue.delete()
                //                                                     }).then((value) {
                //                                                     }).catchError((error) => debugPrint("Failed to update: 1 $error"));
                //
                //                                                     Navigator.pop(contextOver);
                //                                                   }
                //                                                 });
                //                                               }
                //                                             } on SocketException catch (_) {
                //                                               smartKyatFMod(context,widget.isEnglish? 'Internet connection is required if this product has image.': 'ဒီပစ္စည်းတွင် ပုံထည့်ထားပါက အင်တာနက်ရှိရန် လိုအပ်ပါသည်။', 'w');
                //                                             }
                //                                           } else {
                //                                             debugPrint('all set no img');
                //                                             smartKyatFlash(prodName.toString() + ' is successfully removed.', 's');
                //
                //                                             product.update({
                //                                               'prods.' + widget.idString: FieldValue.delete()
                //                                             }).then((value) async {
                //                                             }).catchError((error) => debugPrint("Failed to update:  0 $error"));
                //
                //                                             productImg.update({
                //                                               'prods.' + widget.idString: FieldValue.delete()
                //                                             }).then((value) {
                //                                             }).catchError((error) => debugPrint("Failed to update: 1 $error"));
                //
                //                                             Navigator.pop(contextOver);
                //                                           }
                //                                         }
                //                                       });
                //                                     },
                //                                     child: Text(
                //                                       textSetRemove, textScaleFactor: 1,
                //                                       textAlign: TextAlign.center,
                //                                       style: TextStyle(
                //                                           fontSize: 14,
                //                                           fontWeight: FontWeight.w500,
                //                                           color: AppTheme.badgeFgDanger2),
                //                                     ),
                //                                   ),
                //                                 ),
                //                               ),
                //                             ),
                //                           ),
                //                         ),
                //                       ),
                //                       SizedBox(height: 18,),
                //                     ],
                //                   ),
                //                   widget.fromSearch ? SizedBox(height: 141): SizedBox(height: 0)
                //                 ],
                //               ),
                //             ),
                //           ],
                //         );
                //       }
                //       return Container();
                //
                //     }
                //   ),
                // ),
              ])
      ),
    );
  }

  Future<int> removeImgServer(String image) async {
    final response = await http.post(
      Uri.parse('https://smartkyatpos.com/api/images_remove.php'),
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
      body: {
        'rm_image': image,
      },
    );


    // var uri = Uri.parse("https://smartkyatpos.com/api/images_remove.php");
    // var request = new http.Request("POST", uri);
    // request.bodyFields['rm_image'] = image;
    //
    // var response = await request.send();


    return response.statusCode;
  }

  loadingView() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.end,
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
                            '$currencyUnit ' + widget.mainSell.toString(), textScaleFactor: 1,
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
                              fontWeight: FontWeight.w500,
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
            child: Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                      child: CupertinoActivityIndicator(radius: 15,)),
                ),
              ),
            ),
          ),
        ]
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
// changeUnitName2Stock(String split) {
//   if(split == 'main') {
//     return 'inStock1';
//   } else {
//     return 'inStock' + (int.parse(split[3]) + 1).toString();
//   }
// }

// Future<void> addDateExist(prodId, unit , buyPrice, amount, date) async {
//   debugPrint('CHECKING PRODSALE ORD');
//   CollectionReference lossProduct = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(prodID).collection(unit);
//   lossProduct.doc(date.year.toString() + zeroToTen(date.month.toString()) + zeroToTen(date.day.toString())+ '0' + deviceIdNum).update({
//     'count': FieldValue.increment(double.parse(amount.toString())),
//     'buy_price': buyPrice,
//   }).then((value) => debugPrint("User Updated"))
//       .catchError((error) => debugPrint("Failed to update user: $error"));
// }

// Future<void> decStockFromInv(id, unit, num) async {
//   CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');
//
//   // debugPrint('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));
//
//   users
//       .doc(id)
//       .update({changeUnitName2Stock(unit): FieldValue.increment(0 - (double.parse(num.toString())))})
//       .then((value) => debugPrint("User Updated"))
//       .catchError((error) => debugPrint("Failed to update user: $error"));
// }
//
// Future<void> incStockFromInv(id, unit, num) async {
//   CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');
//
//   // debugPrint('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));
//
//   users
//       .doc(id)
//       .update({changeUnitName2Stock(unit): FieldValue.increment(double.parse(num.toString()))})
//       .then((value) => debugPrint("User Updated"))
//       .catchError((error) => debugPrint("Failed to update user: $error"));
// }
//
// Future<void> sub1Execution(subStock, subLink, id, num) async {
//   var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(id).get();
//   if (docSnapshot10.exists) {
//     Map<String, dynamic>? data10 = docSnapshot10.data();
//     subStock[1] = double.parse((data10 ? ['inStock2']).toString());
//     if(subStock[1] > double.parse(num)) {
//       decStockFromInv(id, 'sub1', num);
//     } else {
//       decStockFromInv(id, 'main', ((int.parse(num)  - subStock[1])/int.parse(subLink[0])).ceil());
//       incStockFromInv(id, 'sub1', ((int.parse(num)-subStock[1].round()) % int.parse(subLink[0])) == 0? 0: (int.parse(subLink[0]) - (int.parse(num)-subStock[1].round()) % int.parse(subLink[0])));
//       decStockFromInv(id, 'sub1', subStock[1]);
//     }
//   }
// }
//
// Future<void> sub2Execution(subStock, subLink, id, num) async {
//   var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(id).get();
//   if (docSnapshot10.exists) {
//     Map<String, dynamic>? data10 = docSnapshot10.data();
//     subStock[2] = double.parse((data10 ? ['inStock3']).toString());
//     if(subStock[2] > double.parse(num)) {
//       decStockFromInv(id, 'sub2', num);
//     } else {
//       await incStockFromInv(id, 'sub2', ((int.parse(num)-subStock[2].round()) % int.parse(subLink[1])) == 0? 0: (int.parse(subLink[1]) - (int.parse(num)-subStock[2].round()) % int.parse(subLink[1])));
//       await decStockFromInv(id, 'sub2', subStock[2]);
//       sub1Execution(subStock, subLink, id, ((int.parse(num)  - subStock[2])/int.parse(subLink[1])).ceil().toString());
//     }
//   }
// }
}

subsDataStream(Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream) {
  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: documentStream,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          var output = snapshot.data!.data();
          var prodName = output?['prod_name'];
        }
        return Container();
      });
}

class _productDetails extends StatelessWidget {
  late final String title_text;
  late final String quantity_price;
  _productDetails(this.title_text, this.quantity_price);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            title_text, textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              // letterSpacing: 2,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            quantity_price, textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

SliverPersistentHeader makeTabBarHeader() {
  return SliverPersistentHeader(
    pinned: true,
    delegate: _SliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 50.0,
        child: Container(
          color: Colors.green,
        )
    ),
  );
}



zeroToTen(String string) {
  if (int.parse(string) > 9) {
    return string;
  } else {
    return '0' + string;
  }
}

// class FullscreenSliderDemo extends StatelessWidget {
//   final int index;
//   FullscreenSliderDemo(this.index);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         top: true,
//         bottom: true,
//         child: Builder(
//           builder: (context) {
//             final double height = MediaQuery.of(context).size.height;
//             return Stack(
//               children: [
//                 CarouselSlider(
//                   options: CarouselOptions(
//                     height: height,
//                     initialPage: index,
//                     viewportFraction: 1.0,
//                     enlargeCenterPage: false,
//                     // autoPlay: false,
//                   ),
//                   items: imgList
//                       .map((item) => Container(
//                     child: Center(
//                         child: Image.network(
//                           item,
//                           fit: BoxFit.cover,
//                           height: height,
//                         )),
//                   ))
//                       .toList(),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 15, left: 15),
//                   child: Container(
//                     width: 35,
//                     height: 35,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(5.0),
//                         ),
//                         color: Colors.black),
//                     child: IconButton(
//                         icon: Icon(
//                           Icons.arrow_back_ios_rounded,
//                           size: 16,
//                           color: Colors.white,
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         }),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}