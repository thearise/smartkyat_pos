import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/loss_fragment.dart';
import 'package:smartkyat_pos/fragments/subs/language_settings.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';
import 'package:smartkyat_pos/widgets/edit_product.dart';
import '../app_theme.dart';
import 'fill_product.dart';

class ProductDetailsView2 extends StatefulWidget {
  final _callback;
  final _callback3;
  final _closeCartBtn;
  final _openCartBtn;
  const ProductDetailsView2(
      {Key? key,
        required this.shopId,
        required this.idString,
        required void toggleCoinCallback(String str),
        required void toggleCoinCallback3(String str),
        required void openCartBtn(),
        required void closeCartBtn(),
      })
      : _callback = toggleCoinCallback,
        _callback3 = toggleCoinCallback3,
        _openCartBtn = openCartBtn,
        _closeCartBtn = closeCartBtn;

  final String idString;
  final String shopId;

  @override
  _ProductDetailsViewState2 createState() => _ProductDetailsViewState2();
}

class _ProductDetailsViewState2 extends State<ProductDetailsView2>  with
    TickerProviderStateMixin <ProductDetailsView2> {

  var deviceIdNum;
  final auth = FirebaseAuth.instance;

  addProduct2(data) {
    widget._callback(data);
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

  String textSetAddtoCart = 'Add to\nsell cart';
  String textSetRefill =  'Refill to\ninventory';
  String textSetAddLoss = 'Add\nLoss item';
  String textSetEdit = 'EDIT';
  String textSetMainUnit = 'MAIN UNIT';
  String textSetSub1 = 'SUB-1 UNIT';
  String textSetSub2 = 'SUB-2 UNIT';
  String textSetSalePrice = 'Sale price';
  String textSetInStock = 'In stock items';
  String textSetLoss = 'Loss items';
  String textSetBarcode = 'Barcode';
  String textSetOtherInfo = 'OTHER INFORMATION';
  String textSetTotalSale = 'Total items sold';
  String textSetBuyPrice = 'Buy price';

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

  @override
  void initState() {
    getDeviceId().then((value) {
      deviceIdNum = value;
    });
    _controller = new TabController(length: 3, vsync: this);
    _controller.addListener((){
      print('my index is'+ _controller.index.toString());
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

    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetAddtoCart = 'Add to\nsell cart';
          textSetRefill =  'Refill to\ninventory';
          textSetAddLoss = 'Add\nLoss item';
          textSetEdit = 'EDIT';
          textSetMainUnit = 'MAIN UNIT';
          textSetSub1 = 'SUB-1 UNIT';
          textSetSub2 = 'SUB-2 UNIT';
          textSetSalePrice = 'Sale price';
          textSetInStock = 'In stock items';
          textSetLoss = 'Loss items';
          textSetBarcode = 'Barcode';
          textSetOtherInfo = 'OTHER INFORMATION';
          textSetTotalSale = 'Total items sold';
          textSetBuyPrice = 'Buy price';
        });
      } else if(value=='english') {
        setState(() {
          textSetAddtoCart = 'Add to\nsell cart';
          textSetRefill =  'Refill to\ninventory';
          textSetAddLoss = 'Add\nLoss item';
          textSetEdit = 'EDIT';
          textSetMainUnit = 'MAIN UNIT';
          textSetSub1 = 'SUB-1 UNIT';
          textSetSub2 = 'SUB-2 UNIT';
          textSetSalePrice = 'Sale price';
          textSetInStock = 'In stock items';
          textSetLoss = 'Loss items';
          textSetBarcode = 'Barcode';
          textSetOtherInfo = 'OTHER INFORMATION';
          textSetTotalSale = 'Total items sold';
          textSetBuyPrice = 'Buy price';
        });
      }
    });

    super.initState();
  }
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('shops')
                .doc(widget.shopId)
                .collection('products')
                .doc(widget.idString)
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                var output = snapshot.data!.data();
                var prodName = output?['prod_name'];
                var mainName = output?['unit_name'];
                var sub1Name = output?['sub1_name'];
                var sub2Name = output?['sub2_name'];
                var sub3Name = output?['sub3_name'];
                var barcode = output?['bar_code'];
                var mainPrice = output?['unit_sell'];
                var sub1Price = output?['sub1_sell'];
                var sub2Price = output?['sub2_sell'];
                var sub3Price = output?['sub3_sell'];
                var sub1Unit = output?['sub1_link'];
                var sub2Unit = output?['sub2_link'];
                var sub3Unit = output?['sub3_link'];
                var subExist = output?['sub_exist'];
                // var mainLoss = output?['Loss1'].round();
                // var sub1Loss = output?['Loss2'].round();
                // var sub2Loss = output?['Loss3'].round();
                var mainQty = output?['inStock1'];
                var sub1Qty = output?['inStock2'];
                var sub2Qty = output?['inStock3'];
                var image = output?['img_1'];
                var totalSale = output?['mainSellUnit'];
                var totalSale2 = output?['mainSellUnit'];
                var totalSale3 = output?['mainSellUnit'];
                var buyPrice1 =  output?['buyPrice1'];
                var buyPrice2 =  output?['buyPrice2'];
                var buyPrice3 =  output?['buyPrice3'];

                List<String> subSell = [];
                List<String> subLink = [];
                List<String> subName = [];
                for(int i = 0; i < int.parse(subExist); i++) {
                  subSell.add(output?['sub' + (i+1).toString() + '_sell']);
                  subLink.add(output?['sub' + (i+1).toString() + '_link']);
                  subName.add(output?['sub' + (i+1).toString() + '_name']);
                }
                print(subSell.toString() + subLink.toString() + subName.toString());
                return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('users')
                        .where('email', isEqualTo: auth.currentUser!.email.toString())
                        .limit(1)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotUser) {
                      if(snapshotUser.hasData) {
                        Map<String, dynamic> dataUser = snapshotUser.data!.docs[0].data()! as Map<String, dynamic>;
                        var role = dataUser['role'];
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
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'MMK $mainPrice',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              prodName,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontSize: 18,
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
                                child: CustomScrollView(
                                  slivers: <Widget>[
                                    SliverList(
                                      delegate: SliverChildListDelegate(
                                        [
                                          SizedBox(height: 15,),
                                          Container(
                                            height: 100,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 15.0),
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              7.0),
                                                          child: image != ""
                                                              ? CachedNetworkImage(
                                                            imageUrl:
                                                            'https://riftplus.me/smartkyat_pos/api/uploads/' +
                                                                image,
                                                            width: 133,
                                                            height: 100,
                                                            // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                                            fadeInDuration: Duration(milliseconds: 100),
                                                            fadeOutDuration: Duration(milliseconds: 10),
                                                            fadeInCurve: Curves.bounceIn,
                                                            fit: BoxFit.cover,
                                                          ): Container(
                                                              height: 100,
                                                              width: 130,
                                                              color: AppTheme.themeColor
                                                          )
                                                        // : Image.asset('assets/system/default-product.png', height: 100, width: 130)
                                                      ),
                                                      ButtonTheme(
                                                        minWidth: 133,
                                                        //minWidth: 50,
                                                        splashColor: Colors.transparent,
                                                        height: 100,
                                                        child: FlatButton(
                                                          color: Colors.white.withOpacity(0.85),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(7.0),
                                                            side: BorderSide(
                                                              color: Colors.white.withOpacity(0.85),
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            if (subExist == '0') {
                                                              widget._callback(widget.idString + '^' + '^' + output?['unit_sell'] +
                                                                  '^unit_name^1');
                                                            } else {
                                                              final result =
                                                              await showModalActionSheet<String>(
                                                                context: context,
                                                                actions: [
                                                                  SheetAction(
                                                                    icon: SmartKyat_POS.prodm,
                                                                    label: '1 ' + output?['unit_name'],
                                                                    key: widget.idString +
                                                                        '^' +
                                                                        '^' +
                                                                        output?['unit_sell'] +
                                                                        '^unit_name^1',
                                                                  ),
                                                                  for(int i =0; i < subSell.length; i++)
                                                                    if(subSell[i] != '')
                                                                      SheetAction(
                                                                        icon: i == 0? SmartKyat_POS.prods1: SmartKyat_POS.prods2,
                                                                        label: '1 ' + subName[i],
                                                                        key: widget.idString +
                                                                            '^' + subLink[i] +
                                                                            '^' +
                                                                            subSell[i] +
                                                                            '^sub' + (i+1).toString() + '_name^1',
                                                                      ),
                                                                ],
                                                              );
                                                              widget._callback(result.toString());
                                                            }
                                                            //if(output?['inStock1'] - 1 <= 0) {smartKyatFlash('Out of Stock', 'w');}
                                                          },
                                                          child: Container(
                                                            width: 100,
                                                            height: 100,
                                                            child: Stack(
                                                              children: [
                                                                Positioned(
                                                                  left: 0,
                                                                  top: 15,
                                                                  child: Icon(SmartKyat_POS.order,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  left: 0,
                                                                  bottom: 15,
                                                                  child: Text(
                                                                    textSetAddtoCart,
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 16,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                ( role == 'admin' || role == 'owner' ) ? ButtonTheme(
                                                  minWidth: 133,
                                                  //minWidth: 50,
                                                  splashColor: Colors.transparent,
                                                  height: 100,
                                                  child: FlatButton(
                                                    color: AppTheme.buttonColor2,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(7.0),
                                                      side: BorderSide(
                                                        color: AppTheme.buttonColor2,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      if (subExist == '0') {
                                                        widget._closeCartBtn();
                                                        await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => FillProduct(
                                                                  idString: widget.idString,
                                                                  toggleCoinCallback: addProduct2,
                                                                  toggleCoinCallback3: addProduct3,
                                                                  unitname: 'unit_name', shopId: widget.shopId,
                                                                )));
                                                        widget._openCartBtn();
                                                      } else {
                                                        final result =
                                                        await showModalActionSheet<String>(
                                                          context: context,
                                                          actions: [
                                                            SheetAction(
                                                                icon: SmartKyat_POS.prodm,
                                                                label: '1 ' + mainName,
                                                                key: 'unit_name'),
                                                            if (sub1Price != '')
                                                              SheetAction(
                                                                  icon: SmartKyat_POS.prods1,
                                                                  label: '1 ' + sub1Name,
                                                                  key: 'sub1_name'),
                                                            if (sub2Price != '')
                                                              SheetAction(
                                                                  icon: SmartKyat_POS.prods2,
                                                                  label: '1 ' + sub2Name,
                                                                  key: 'sub2_name'),
                                                            if (sub3Price != '')
                                                              SheetAction(
                                                                  icon: Icons.info,
                                                                  label: '1 ' + sub3Name,
                                                                  key: 'sub3_name'),
                                                          ],
                                                        );
                                                        if (result != null) {
                                                          widget._closeCartBtn();
                                                          await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => FillProduct(
                                                                    idString: widget.idString,
                                                                    toggleCoinCallback: addProduct2,
                                                                    toggleCoinCallback3: addProduct3,
                                                                    unitname: result, shopId: widget.shopId,
                                                                  )));
                                                          widget._openCartBtn();
                                                        }
                                                      }

                                                    },
                                                    child: Container(
                                                      width: 100,
                                                      height: 100,
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            top: 17,
                                                            left: 0,
                                                            child: Icon(
                                                              SmartKyat_POS.product,
                                                              size: 18,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 15,
                                                            left: 0,
                                                            child: Text(
                                                              textSetRefill,
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ) : Container(),
                                                SizedBox(width: 11.5),
                                                ( role == 'admin' || role == 'owner' ) ? Padding(
                                                  padding: const EdgeInsets.only(right: 15.0),
                                                  child: ButtonTheme(
                                                    minWidth: 130,
                                                    splashColor: Colors.transparent,
                                                    height: 100,
                                                    child: FlatButton(
                                                      color: AppTheme.clearColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(7.0),
                                                        side: BorderSide(
                                                          color: AppTheme.clearColor,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        if (subExist == '0') {
                                                          widget._closeCartBtn();
                                                          await Navigator.push(
                                                              context, MaterialPageRoute( builder: (context) => LossProduct(idString: widget.idString, prodID: widget.idString + '-' + '-' + output?['unit_sell'] +
                                                              '-unit_name', shopId: widget.shopId, price1: buyPrice1, price2: buyPrice2, price3: buyPrice3,
                                                          )
                                                          ));
                                                          widget._openCartBtn();
                                                        } else {
                                                          final result =
                                                          await showModalActionSheet<String>(
                                                            context: context,
                                                            actions: [
                                                              SheetAction(
                                                                icon: SmartKyat_POS.prodm,
                                                                label: '1 ' + output?['unit_name'],
                                                                key: widget.idString +
                                                                    '-' +
                                                                    '-' +
                                                                    output?['unit_sell'] +
                                                                    '-unit_name',
                                                              ),
                                                              for(int i =0; i < subSell.length; i++)
                                                                if(subSell[i] != '')
                                                                  SheetAction(
                                                                    icon: i == 0? SmartKyat_POS.prods1: SmartKyat_POS.prods2,
                                                                    label: '1 ' + subName[i],
                                                                    key: widget.idString +
                                                                        '-' + subLink[i] +
                                                                        '-' +
                                                                        subSell[i] +
                                                                        '-sub' + (i+1).toString() + '_name',
                                                                  ),
                                                            ],
                                                          );
                                                          if (result != null) {
                                                            widget._closeCartBtn();
                                                            await Navigator.push(
                                                                context, MaterialPageRoute( builder: (context) => LossProduct(idString: widget.idString, prodID: result, shopId: widget.shopId, price1: buyPrice1, price2: buyPrice2, price3: buyPrice3,
                                                            )
                                                            ));
                                                            widget._openCartBtn();
                                                          }

                                                        }
                                                        // final amount = await showTextInputDialog(
                                                        //   context: context,
                                                        //   textFields: [
                                                        //     DialogTextField(
                                                        //       keyboardType: TextInputType.number,
                                                        //       hintText: '0',
                                                        //       suffixText: prodID.split('-')[3] == 'unit_name' ? mainName : prodID.split('-')[3] == 'sub1_name' ? sub1Name : sub2Name,
                                                        //     ),
                                                        //   ],
                                                        //   title: 'Loss Unit',
                                                        //   message: 'Type Loss Amount',
                                                        // );
                                                        //
                                                        //
                                                        // var dateExist = false;
                                                        // codeDialog = int.parse(amount![0]);
                                                        // List<String> subLink1 = [];
                                                        // List<String> subName1 = [];
                                                        // List<double> subStock1 = [];
                                                        // var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(
                                                        //     widget.shopId).collection('products').doc(
                                                        //     prodID.split('-')[0])
                                                        //     .get();
                                                        //
                                                        // if (docSnapshot10.exists) {
                                                        //   Map<String, dynamic>? data10 = docSnapshot10.data();
                                                        //   for(int i = 0; i < int.parse(data10 ? ["sub_exist"]) + 1; i++) {
                                                        //     subLink1.add(data10 ? ['sub' + (i+1).toString() + '_link']);
                                                        //     subName1.add(data10 ? ['sub' + (i+1).toString() + '_name']);
                                                        //     print('inStock' + (i+1).toString());
                                                        //     subStock1.add(double.parse((data10 ? ['inStock' + (i+1).toString()]).toString()));
                                                        //   }
                                                        // }
                                                        // DateTime now = DateTime.now();
                                                        // String buyPriceUnit = '';
                                                        // String buyPrice = '';
                                                        // String unit = '';
                                                        //
                                                        // if (prodID.split('-')[3] == 'unit_name') {
                                                        //   decStockFromInv(prodID.split('-')[0], 'main', amount[0].toString());
                                                        //   unit = 'loss1';
                                                        //   buyPriceUnit = 'buyPrice1';
                                                        // }
                                                        // else if (prodID.split('-')[3] == 'sub1_name') {
                                                        //   sub1Execution(subStock1, subLink1, prodID.split('-')[0], amount[0].toString());
                                                        //   // setState(() {
                                                        //   unit = 'loss2';
                                                        //   buyPriceUnit = 'buyPrice2';
                                                        //   // });
                                                        // }
                                                        // else if (prodID.split('-')[3] == 'sub2_name') {
                                                        //   sub2Execution(
                                                        //       subStock1, subLink1,
                                                        //       prodID.split('-')[0],
                                                        //       amount[0].toString());
                                                        //   unit = 'loss3';
                                                        //   buyPriceUnit = 'buyPrice3';
                                                        // }
                                                        // var dateId = '';
                                                        //
                                                        // FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(prodID.split('-')[0]).get().then((value) async {
                                                        //   buyPrice = value.data()![buyPriceUnit].toString();
                                                        //
                                                        //   print("SHOP ID " + widget.shopId + ' ' + prodID.split('-')[0]);
                                                        //   FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(prodID.split('-')[0]).collection(unit)
                                                        //       .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 00:00:00'))
                                                        //       .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 23:59:59'))
                                                        //       .get()
                                                        //       .then((QuerySnapshot qsNew)  async {
                                                        //
                                                        //     print("LENGTH " + qsNew.docs.length.toString());
                                                        //
                                                        //     qsNew.docs.forEach((doc) {
                                                        //       dateExist = true;
                                                        //       dateId = doc.id;
                                                        //       print('UNIT ' + doc.id.toString());
                                                        //     });
                                                        //
                                                        //     print('Unit' + unit + ' ' + now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + '0' + deviceIdNum);
                                                        //     print('dick exist - > ' + dateExist.toString());
                                                        //     CollectionReference lossProduct = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(prodID.split('-')[0]).collection(unit);
                                                        //     //
                                                        //     if(dateExist){
                                                        //       lossProduct.doc(dateId).update({
                                                        //         'count': FieldValue.increment(double.parse(amount[0].toString())),
                                                        //         'buy_price': buyPrice,
                                                        //       }).then((value) => print("User Updated"))
                                                        //           .catchError((error) => print("Failed to update dateexist: $error"));
                                                        //     }
                                                        //     else {
                                                        //       lossProduct.doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + '0' + deviceIdNum).set({
                                                        //         'count': FieldValue
                                                        //             .increment(
                                                        //             double.parse(
                                                        //                 amount[0]
                                                        //                     .toString())),
                                                        //         'buy_price': buyPrice,
                                                        //         'date': now,
                                                        //       }).then((value) =>
                                                        //           print("User Updated"))
                                                        //           .catchError((error) =>
                                                        //           print(
                                                        //               "Failed to update datenotexist: $error"));
                                                        //     }
                                                        //   });
                                                        // });
                                                      },
                                                      child: Container(
                                                        width: 100,
                                                        height: 100,
                                                        child: Stack(
                                                          children: [
                                                            Positioned(
                                                              top: 15,
                                                              left: 0,
                                                              child: Icon(
                                                                Icons.delete,
                                                                size: 22,
                                                              ),
                                                            ),
                                                            Positioned(
                                                              bottom: 15,
                                                              left: 0,
                                                              child: Text(
                                                                textSetAddLoss,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ) : Container(),
                                              ],
                                            ),
                                          ),
                                          // (role == 'admin' || role == 'owner') ? Align(
                                          //   alignment: Alignment.topRight,
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
                                          //     child: Container(
                                          //       child: GestureDetector(
                                          //         onTap: () async {
                                          //           widget._closeCartBtn();
                                          //           var result = await Navigator.push(
                                          //               context,
                                          //               MaterialPageRoute(
                                          //                   builder: (context) => EditProduct(image: image, shopId: widget.shopId, prodId: widget.idString, prodName: prodName, mainQty: mainQty.toString(), mainName: mainName, mainBuy: buyPrice1, mainSell: mainPrice, barcode: barcode, sub1perUnit: sub1Unit, sub1UnitName: sub1Name, sub1Qty: sub1Qty.toString(), sub1Sell: sub1Price, sub2perUnit: sub2Unit, sub2UnitName: sub2Name, sub2Qty: sub2Qty.toString(), sub2Sell: sub2Price, subExist: subExist, openCartBtn: openCartFrom,)));
                                          //           widget._openCartBtn();
                                          //           print('result check ' + result.toString());
                                          //         },
                                          //         child: Text(
                                          //           'EDIT',
                                          //           style: TextStyle(
                                          //             fontWeight: FontWeight.bold,
                                          //             fontSize: 14,
                                          //             letterSpacing: 2,
                                          //             color: Colors.blue,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ) : Container(),
                                          SizedBox(height: 5)
                                        ],
                                      ),
                                    ),
                                    SliverPersistentHeader(
                                      pinned: true,
                                      delegate: _SliverAppBarDelegate(
                                          minHeight: 56.0,
                                          maxHeight: 56.0,
                                          child: Container(
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 15, right: 0.0, top: 12.0, bottom: 12.0),
                                              child: Row(
                                                children: [
                                                  (role == 'admin' || role == 'owner')? Row(
                                                    children: [
                                                      FlatButton(
                                                        padding: EdgeInsets.only(left: 0, right: 0),
                                                        color: AppTheme.secButtonColor,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          side: BorderSide(
                                                            color: AppTheme.skBorderColor2,
                                                          ),
                                                        ),
                                                        onPressed: () async {
                                                          // widget._callback();
                                                          widget._closeCartBtn();
                                                          var result = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => EditProduct(image: image, shopId: widget.shopId, prodId: widget.idString, prodName: prodName, mainQty: mainQty.toString(), mainName: mainName, mainBuy: buyPrice1, mainSell: mainPrice, barcode: barcode, sub1perUnit: sub1Unit, sub1UnitName: sub1Name, sub1Qty: sub1Qty.toString(), sub1Sell: sub1Price, sub2perUnit: sub2Unit, sub2UnitName: sub2Name, sub2Qty: sub2Qty.toString(), sub2Sell: sub2Price, subExist: subExist,)));
                                                          widget._openCartBtn();
                                                          print('result check ' + result.toString());
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                          child: Row(
                                                            // mainAxisAlignment: Main,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 6.0),
                                                                child: Icon(
                                                                  Icons.edit_rounded,
                                                                  size: 17,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Edit item',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Container(
                                                        color: Colors.grey.withOpacity(0.2),
                                                        width: 1.5,
                                                        height: 30,
                                                      )
                                                    ],
                                                  ): Container(),
                                                  Expanded(
                                                    child: ListView(
                                                      scrollDirection: Axis.horizontal,
                                                      children: [
                                                        (role == 'admin' || role == 'owner')? SizedBox(width: 10): Container(),
                                                        FlatButton(
                                                          minWidth: 0,
                                                          padding: EdgeInsets.only(left: 8, right: 12),
                                                          color: _sliding == 0 ? AppTheme.secButtonColor:Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(50.0),
                                                            side: BorderSide(
                                                              color: AppTheme.skBorderColor2,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            _controller.animateTo(0);
                                                          },
                                                          child:Container(
                                                            child: Row(
                                                              children: [
                                                                Icon(SmartKyat_POS.prodm, size: 20, color: Colors.grey),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  mainName,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.black),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        sub1Name != '' ? SizedBox(width: 10): Container(),
                                                        sub1Name != '' ? FlatButton(
                                                          minWidth: 0,
                                                          padding: EdgeInsets.only(left: 8, right: 12),
                                                          color: _sliding == 1 ? AppTheme.secButtonColor:Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                            side: BorderSide(
                                                              color: AppTheme.skBorderColor2,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            _controller.animateTo(1);
                                                          },
                                                          child:Container(
                                                            child: Row(
                                                              children: [
                                                                Icon(SmartKyat_POS.prods1, size: 20, color: Colors.grey),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  sub1Name,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.black),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ) : Container(),
                                                        sub2Name != '' ? SizedBox(width: 10): Container(),
                                                        sub2Name != '' ? FlatButton(
                                                          minWidth: 0,
                                                          padding: EdgeInsets.only(left: 8, right: 12),
                                                          color: _sliding == 2 ? AppTheme.secButtonColor:Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                            side: BorderSide(
                                                              color: AppTheme.skBorderColor2,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            _controller.animateTo(2);
                                                          },
                                                          child:Container(
                                                            child: Row(
                                                              children: [
                                                                Icon(SmartKyat_POS.prods2, size: 20, color: Colors.grey),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  sub2Name,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.black),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ) : Container(),
                                                        SizedBox(width: 15),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                    SliverList(
                                      delegate: SliverChildListDelegate(
                                        [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Container(
                                              height: 560,
                                              child: TabBarView(
                                                controller: _controller,
                                                physics: NeverScrollableScrollPhysics(),
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          textSetMainUnit,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            letterSpacing: 2,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        SizedBox(height: 15,),
                                                        Container(
                                                          height: 220,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                            color: AppTheme.lightBgColor,
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(
                                                                      color: Colors.grey
                                                                          .withOpacity(0.2),
                                                                      width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetSalePrice, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text('MMK ' + mainPrice.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetInStock, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text(mainQty.round().toString() + ' ' + mainName, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetLoss, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      StreamBuilder(
                                                                          stream: FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('loss').where('prod_id', isEqualTo : widget.idString).where('type', isEqualTo : 'loss1').snapshots(),
                                                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot12) {
                                                                            if(snapshot12.hasData) {
                                                                              var quantity = 0.0;
                                                                              snapshot12.data!.docs
                                                                                  .map((DocumentSnapshot document) {
                                                                                Map<String, dynamic> data5 = document
                                                                                    .data()! as Map<String, dynamic>;
                                                                                quantity  = data5['amount'] + quantity;
                                                                              }).toList();
                                                                              return Text(quantity.round().toString() + ' ' + mainName, style:
                                                                              TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.grey,
                                                                              ),);
                                                                            }
                                                                            return Container();
                                                                          }
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetBarcode, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text(barcode, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        Container(
                                                          height: 1,
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(
                                                              color: Colors.grey
                                                                  .withOpacity(0.4),
                                                              width: 1.0))),),
                                                        SizedBox(height: 20),
                                                        Text(
                                                          textSetOtherInfo,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            letterSpacing: 2,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        SizedBox(height: 15,),
                                                        Container(
                                                          height: 220,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                            color: AppTheme.lightBgColor,
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetTotalSale, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text(totalSale.round().toString() + ' $mainName', style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetInStock, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text('124 Far', style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetLoss, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text('5 Far', style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetBarcode, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text('3kro46456218', style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          textSetSub1,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            letterSpacing: 2,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        SizedBox(height: 15,),
                                                        Container(
                                                          height: 220,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                            color: AppTheme.lightBgColor,
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(
                                                                      color: Colors.grey
                                                                          .withOpacity(0.2),
                                                                      width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetSalePrice, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text('MMK ' + sub1Price.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetInStock, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text( sub1Qty.round().toString() + ' ' + sub1Name, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetLoss, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      StreamBuilder(
                                                                          stream: FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('loss').where('prod_id', isEqualTo : widget.idString).where('type', isEqualTo : 'loss2').snapshots(),
                                                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot12) {
                                                                            if(snapshot12.hasData) {
                                                                              var quantity = 0.0;
                                                                              snapshot12.data!.docs
                                                                                  .map((DocumentSnapshot document) {
                                                                                Map<String, dynamic> data5 = document
                                                                                    .data()! as Map<String, dynamic>;
                                                                                quantity  = data5['amount'] + quantity;
                                                                              }).toList();
                                                                              return Text(quantity.round().toString() + ' ' + sub1Name, style:
                                                                              TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.grey,
                                                                              ),);
                                                                            }
                                                                            return Container();
                                                                          }
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetBarcode, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text(barcode, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        Container(
                                                          height: 1,
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(
                                                              color: Colors.grey
                                                                  .withOpacity(0.2),
                                                              width: 1.0))),),
                                                        SizedBox(height: 20),
                                                        Text(
                                                          textSetOtherInfo,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            letterSpacing: 2,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        SizedBox(height: 15,),
                                                        Container(
                                                          height: 220,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                            color: AppTheme.lightBgColor,
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetTotalSale, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text(totalSale2.round().toString() + ' $sub1Name', style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetInStock, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text('124 Far', style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetLoss, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text('5 Far', style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetBarcode, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text('3kro46456218', style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          textSetSub2,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            letterSpacing: 2,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        SizedBox(height: 15,),
                                                        Container(
                                                          height: 220,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                            color: AppTheme.lightBgColor,
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(
                                                                      color: Colors.grey
                                                                          .withOpacity(0.2),
                                                                      width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetSalePrice, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text('MMK ' + sub2Price.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetInStock, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text(sub2Qty.round().toString() + ' ' + sub2Name, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [Text(textSetLoss,
                                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,),),
                                                                      Spacer(),
                                                                      StreamBuilder(
                                                                          stream: FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('loss').where('prod_id', isEqualTo : widget.idString).where('type', isEqualTo : 'loss3').snapshots(),
                                                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot12) {
                                                                            if(snapshot12.hasData) {
                                                                              var quantity = 0.0;
                                                                              snapshot12.data!.docs
                                                                                  .map((DocumentSnapshot document) {
                                                                                Map<String, dynamic> data5 = document
                                                                                    .data()! as Map<String, dynamic>;
                                                                                quantity  = data5['amount'] + quantity;
                                                                              }).toList();
                                                                              return Text(quantity.round().toString() + ' ' + sub2Name, style:
                                                                              TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.grey,
                                                                              ),);
                                                                            }
                                                                            return Container();
                                                                          }
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetBarcode, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text(barcode, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 20),
                                                        Container(
                                                          height: 1,
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(
                                                              color: Colors.grey
                                                                  .withOpacity(0.2),
                                                              width: 1.0))),),
                                                        SizedBox(height: 20),
                                                        Text(
                                                          textSetOtherInfo,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            letterSpacing: 2,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        SizedBox(height: 15,),
                                                        Container(
                                                          height: 220,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                            color: AppTheme.lightBgColor,
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetTotalSale, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                      ),
                                                                      Spacer(),
                                                                      Text(totalSale3.round().toString() + ' $sub2Name', style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetInStock, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text('124 Far', style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  decoration: BoxDecoration(
                                                                      border: Border(
                                                                          bottom: BorderSide(
                                                                              color: Colors.grey
                                                                                  .withOpacity(0.2),
                                                                              width: 1.0))),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetLoss, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text('5 Far', style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 55,
                                                                  child: Row(
                                                                    children: [
                                                                      Text(textSetBarcode, style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                      ),),
                                                                      Spacer(),
                                                                      Text('3kro46456218', style:
                                                                      TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                      }
                      return Container();
                    }
                );
              }
              return Container();
            }),
      ),
    );
  }
// changeUnitName2Stock(String split) {
//   if(split == 'main') {
//     return 'inStock1';
//   } else {
//     return 'inStock' + (int.parse(split[3]) + 1).toString();
//   }
// }

// Future<void> addDateExist(prodId, unit , buyPrice, amount, date) async {
//   print('CHECKING PRODSALE ORD');
//   CollectionReference lossProduct = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(prodID).collection(unit);
//   lossProduct.doc(date.year.toString() + zeroToTen(date.month.toString()) + zeroToTen(date.day.toString())+ '0' + deviceIdNum).update({
//     'count': FieldValue.increment(double.parse(amount.toString())),
//     'buy_price': buyPrice,
//   }).then((value) => print("User Updated"))
//       .catchError((error) => print("Failed to update user: $error"));
// }

// Future<void> decStockFromInv(id, unit, num) async {
//   CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');
//
//   // print('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));
//
//   users
//       .doc(id)
//       .update({changeUnitName2Stock(unit): FieldValue.increment(0 - (double.parse(num.toString())))})
//       .then((value) => print("User Updated"))
//       .catchError((error) => print("Failed to update user: $error"));
// }
//
// Future<void> incStockFromInv(id, unit, num) async {
//   CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');
//
//   // print('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));
//
//   users
//       .doc(id)
//       .update({changeUnitName2Stock(unit): FieldValue.increment(double.parse(num.toString()))})
//       .then((value) => print("User Updated"))
//       .catchError((error) => print("Failed to update user: $error"));
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
            title_text,
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
            quantity_price,
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
