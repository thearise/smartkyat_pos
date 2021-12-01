import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/pages2/home_page3.dart';

import '../app_theme.dart';
import 'fill_product.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
];

class ProductDetailsView2 extends StatefulWidget {
  final _callback;
  final _callback3;

  const ProductDetailsView2(
      {Key? key,
        required this.shopId,
        required this.idString,
        required void toggleCoinCallback(String str),
        required void toggleCoinCallback3(String str)})
      : _callback = toggleCoinCallback,
        _callback3 = toggleCoinCallback3;

  final String idString;
  final String shopId;

  @override
  _ProductDetailsViewState2 createState() => _ProductDetailsViewState2();
}

class _ProductDetailsViewState2 extends State<ProductDetailsView2>  with
    TickerProviderStateMixin <ProductDetailsView2> {


  addProduct2(data) {
    widget._callback(data);
  }

  addProduct3(data) {
    widget._callback3(data);
  }

  routeFill(res) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FillProduct(
              idString: widget.idString,
              toggleCoinCallback: addProduct2,
              toggleCoinCallback3: addProduct3,
              unitname: res, shopId: widget.shopId,
            )));
  }



  TextEditingController _textFieldController = TextEditingController();

  late int codeDialog =0;
  String prodID = '';


  late TabController _controller;
  int _sliding = 0;

  @override
  void initState() {
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
    super.initState();
  }


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
                var mainLoss = output?['Loss1'].round();
                var sub1Loss = output?['Loss2'].round();
                var sub2Loss = output?['Loss3'].round();
                var mainQty = output?['inStock1'].round();
                var sub1Qty = output?['inStock2'].round();
                var sub2Qty = output?['inStock3'].round();
                var image = output?['img_1'];
                var totalSale = output?['mainSellUnit'];
                var totalSale2 = output?['mainSellUnit'];
                var totalSale3 = output?['mainSellUnit'];

                List<String> subSell = [];
                List<String> subLink = [];
                List<String> subName = [];
                for(int i = 0; i < int.parse(subExist); i++) {
                  subSell.add(output?['sub' + (i+1).toString() + '_sell']);
                  subLink.add(output?['sub' + (i+1).toString() + '_link']);
                  subName.add(output?['sub' + (i+1).toString() + '_name']);
                }
                print(subSell.toString() + subLink.toString() + subName.toString());
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.end,
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
                                            'MMK $mainPrice',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        prodName,
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
                                                    errorWidget: (context,
                                                        url,
                                                        error) =>
                                                        Icon(Icons
                                                            .error),
                                                    fadeInDuration:
                                                    Duration(
                                                        milliseconds:
                                                        100),
                                                    fadeOutDuration:
                                                    Duration(
                                                        milliseconds:
                                                        10),
                                                    fadeInCurve:
                                                    Curves
                                                        .bounceIn,
                                                    fit: BoxFit
                                                        .cover,
                                                  )
                                                      : CachedNetworkImage(
                                                    imageUrl:
                                                    'https://riftplus.me/smartkyat_pos/api/uploads/shark1.jpg',
                                                    width: 130,
                                                    height: 100,
                                                    // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                    errorWidget: (context,
                                                        url,
                                                        error) =>
                                                        Icon(Icons
                                                            .error),
                                                    fadeInDuration:
                                                    Duration(
                                                        milliseconds:
                                                        100),
                                                    fadeOutDuration:
                                                    Duration(
                                                        milliseconds:
                                                        10),
                                                    fadeInCurve:
                                                    Curves
                                                        .bounceIn,
                                                    fit: BoxFit
                                                        .cover,
                                                  )),
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
                                                      widget._callback(widget.idString + '-' + '-' + output?['unit_sell'] +
                                                          '-unit_name-1');
                                                    } else {
                                                      final result =
                                                      await showModalActionSheet<String>(
                                                        context: context,
                                                        actions: [
                                                          SheetAction(
                                                            icon: Icons.info,
                                                            label: '1 ' + output?['unit_name'],
                                                            key: widget.idString +
                                                                '-' +
                                                                '-' +
                                                                output?['unit_sell'] +
                                                                '-unit_name-1',
                                                          ),
                                                          for(int i =0; i < subSell.length; i++)
                                                            if(subSell[i] != '')
                                                              SheetAction(
                                                                icon: Icons.info,
                                                                label: '1 ' + subName[i],
                                                                key: widget.idString +
                                                                    '-' + subLink[i] +
                                                                    '-' +
                                                                    subSell[i] +
                                                                    '-sub' + (i+1).toString() + '_name-1',
                                                              ),
                                                        ],
                                                      );
                                                      widget._callback(result.toString());
                                                    }
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
                                                            'Add to\nsell cart',
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
                                        ButtonTheme(
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
                                                routeFill('unit_name');
                                              } else {
                                                final result =
                                                await showModalActionSheet<String>(
                                                  context: context,
                                                  actions: [
                                                    SheetAction(
                                                        icon: Icons.info,
                                                        label: '1 ' + mainName,
                                                        key: 'unit_name'),
                                                    if (sub1Price != '')
                                                      SheetAction(
                                                          icon: Icons.info,
                                                          label: '1 ' + sub1Name,
                                                          key: 'sub1_name'),
                                                    if (sub2Price != '')
                                                      SheetAction(
                                                          icon: Icons.info,
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
                                                  routeFill(result);
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
                                                      'Refill to\ninventory',
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
                                        SizedBox(width: 11.5),
                                        Padding(
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
                                                  prodID = widget.idString + '-' + '-' + output?['unit_sell'] +
                                                      '-unit_name';
                                                } else {
                                                  final result =
                                                  await showModalActionSheet<String>(
                                                    context: context,
                                                    actions: [
                                                      SheetAction(
                                                        icon: Icons.info,
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
                                                            icon: Icons.info,
                                                            label: '1 ' + subName[i],
                                                            key: widget.idString +
                                                                '-' + subLink[i] +
                                                                '-' +
                                                                subSell[i] +
                                                                '-sub' + (i+1).toString() + '_name',
                                                          ),
                                                    ],
                                                  );
                                                  prodID =result.toString();
                                                }
                                                final amount = await showTextInputDialog(
                                                  context: context,
                                                  textFields: [
                                                    DialogTextField(
                                                      keyboardType: TextInputType.number,
                                                      hintText: '0',
                                                      suffixText:  prodID.split('-')[3] == 'unit_name' ? mainName : prodID.split('-')[3] == 'sub1_name' ? sub1Name : sub2Name,
                                                      // initialText: 'mono0926@gmail.com',
                                                    ),
                                                  ],
                                                  title: 'Loss Unit',
                                                  message: 'Type Loss Amount',
                                                );
                                                setState(() async {
                                                  codeDialog = int.parse(amount![0]);
                                                  List<String> subLink = [];
                                                  List<String> subName = [];
                                                  List<double> subStock = [];
                                                  var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(
                                                      widget.shopId).collection('products').doc(
                                                      prodID.split('-')[0])
                                                      .get();

                                                  if (docSnapshot10.exists) {
                                                    Map<String, dynamic>? data10 = docSnapshot10.data();
                                                    for(int i = 0; i < int.parse(data10 ? ["sub_exist"]) + 1; i++) {
                                                      subLink.add(data10 ? ['sub' + (i+1).toString() + '_link']);
                                                      subName.add(data10 ? ['sub' + (i+1).toString() + '_name']);
                                                      print('inStock' + (i+1).toString());
                                                      subStock.add(double.parse((data10 ? ['inStock' + (i+1).toString()]).toString()));
                                                    }
                                                  }
                                                  bool loss1Exist = false;
                                                  bool loss2Exist = false;
                                                  bool loss3Exist = false;
                                                  DateTime now = DateTime.now();
                                                  CollectionReference lossProduct1 = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(prodID.split('-')[0]).collection('loss1');
                                                  CollectionReference lossProduct2 = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(prodID.split('-')[0]).collection('loss2');
                                                  CollectionReference lossProduct3 = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(prodID.split('-')[0]).collection('loss3');

                                                  var buyPrice1 = '';
                                                  var buyPrice2 = '';
                                                  var buyPrice3 = '';

                                                  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(prodID.split('-')[0]).get().then((value) async {
                                                    buyPrice1 = value.data()!["buyPrice1"].toString();
                                                    buyPrice2 = value.data()!["buyPrice2"].toString();
                                                    buyPrice3 = value.data()!["buyPrice3"].toString();

                                                  if (prodID.split('-')[3] == 'unit_name') {
                                                    decStockFromInv(prodID.split('-')[0], 'main', amount[0].toString());
                                                    lossProduct1.doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) +zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString())).set({
                                                     'count': FieldValue.increment(double.parse(amount[0].toString())),
                                                      'buy_price': buyPrice1,
                                                      'date': now,
                                                    }).then((value) => print("User Updated"))
                                                      .catchError((error) => print("Failed to update user: $error"));

                                                    // await FirebaseFirestore.instance.collection('shops').doc(
                                                    //     widget.shopId).collection('products').doc(
                                                    //     prodID.split('-')[0])
                                                    //     .update({'Loss1': FieldValue.increment(double.parse(amount[0].toString()))})
                                                    //     .then((value) => print("User Updated"))
                                                    //     .catchError((error) => print("Failed to update user: $error"));


                                                  } else if (prodID.split('-')[3] == 'sub1_name') {
                                                    sub1Execution(subStock, subLink, prodID.split('-')[0], amount[0].toString());

                                                    lossProduct2.doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) +zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString())).set({
                                                      'count': FieldValue.increment(double.parse(amount[0].toString())),
                                                      'buy_price': buyPrice2,
                                                      'date': now,
                                                    }).then((value) => print("User Updated"))
                                                        .catchError((error) => print("Failed to update user: $error"));

                                                    // await FirebaseFirestore.instance.collection('shops').doc(
                                                    //     widget.shopId).collection('products').doc(
                                                    //     prodID.split('-')[0])
                                                    //     .update({'Loss2': FieldValue.increment(double.parse(amount[0].toString()))})
                                                    //     .then((value) => print("User Updated"))
                                                    //     .catchError((error) => print("Failed to update user: $error"));


                                                  } else if (prodID.split('-')[3] == 'sub2_name') {
                                                    sub2Execution(subStock, subLink, prodID.split('-')[0], amount[0].toString());

                                                    lossProduct3.doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) +zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString())).set({
                                                      'count': FieldValue.increment(double.parse(amount[0].toString())),
                                                      'buy_price': buyPrice3,
                                                      'date': now,
                                                    }).then((value) => print("User Updated"))
                                                        .catchError( (error) => print("Failed to update user: $error"));

                                                    // await FirebaseFirestore.instance.collection('shops').doc(
                                                    //     widget.shopId).collection('products').doc(
                                                    //     prodID.split('-')[0])
                                                    //     .update({'Loss3': FieldValue.increment(double.parse(amount[0].toString()))})
                                                    //     .then((value) => print("User Updated"))
                                                    //     .catchError((error) => print("Failed to update user: $error"));
                                                }); });
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
                                                        'Add\nLoss item',
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 3,),
                                ],
                              ),
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _SliverAppBarDelegate(
                                  minHeight: 56.0,
                                  maxHeight: 56.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15, right: 15.0, top: 12.0, bottom: 12.0),
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
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
                                            SizedBox(width: 10),
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
                                            SizedBox(width: 10),
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
                                          ],
                                        ),
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
                                                  'MAIN UNIT PRICING',
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
                                                              Text('Sell price', style:
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
                                                              Text('In stock', style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                              Spacer(),
                                                              Text(mainQty.toString() + ' ' + mainName, style:
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
                                                              Text('Loss', style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                              Spacer(),
                                                              Text(mainLoss.toString() + ' ' + mainName, style:
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
                                                              Text('Barcode', style:
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
                                                  'OTHER INFORMATION',
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
                                                              Text('Total sale', style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                              Spacer(),
                                                              Text(totalSale.toString() + ' $mainName', style:
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
                                                              Text('In stock', style:
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
                                                              Text('Loss', style:
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
                                                              Text('Barcode', style:
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
                                                  'SUB-1 UNIT PRICING',
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
                                                              Text('Sell price', style:
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
                                                              Text('In stock', style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                              Spacer(),
                                                              Text( sub1Qty.toString() + ' ' + sub1Name, style:
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
                                                              Text('Loss', style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                              Spacer(),
                                                              Text(sub1Loss.toString() + ' ' + sub1Name, style:
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
                                                              Text('Barcode', style:
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
                                                  'OTHER INFORMATION',
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
                                                              Text('Total sale', style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                              Spacer(),
                                                              Text(totalSale2.toString() + ' $sub1Name', style:
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
                                                              Text('In stock', style:
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
                                                              Text('Loss', style:
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
                                                              Text('Barcode', style:
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
                                                  'SUB-2 UNIT PRICING',
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
                                                              Text('Sell price', style:
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
                                                              Text('In stock', style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                              Spacer(),
                                                              Text(sub2Qty.toString() + ' ' + sub2Name, style:
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
                                                              Text('Loss', style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                              Spacer(),
                                                              Text(sub2Loss.toString() + ' ' + sub2Name, style:
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
                                                              Text('Barcode', style:
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
                                                  'OTHER INFORMATION',
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
                                                              Text('Total sale', style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                              Spacer(),
                                                              Text(totalSale3.toString() + ' $sub2Name', style:
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
                                                              Text('In stock', style:
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
                                                              Text('Loss', style:
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
                                                              Text('Barcode', style:
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
            }),
      ),
    );
  }
  changeUnitName2Stock(String split) {
    if(split == 'main') {
      return 'inStock1';
    } else {
      return 'inStock' + (int.parse(split[3]) + 1).toString();
    }
  }

  Future<void> decStockFromInv(id, unit, num) async {
    CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');

    // print('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));

    users
        .doc(id)
        .update({changeUnitName2Stock(unit): FieldValue.increment(0 - (double.parse(num.toString())))})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> incStockFromInv(id, unit, num) async {
    CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');

    // print('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));

    users
        .doc(id)
        .update({changeUnitName2Stock(unit): FieldValue.increment(double.parse(num.toString()))})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> sub1Execution(subStock, subLink, id, num) async {
    var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(id).get();
    if (docSnapshot10.exists) {
      Map<String, dynamic>? data10 = docSnapshot10.data();
      subStock[1] = double.parse((data10 ? ['inStock2']).toString());
      if(subStock[1] > double.parse(num)) {
        decStockFromInv(id, 'sub1', num);
      } else {
        decStockFromInv(id, 'main', ((int.parse(num)  - subStock[1])/int.parse(subLink[0])).ceil());
        incStockFromInv(id, 'sub1', ((int.parse(num)-subStock[1].round()) % int.parse(subLink[0])) == 0? 0: (int.parse(subLink[0]) - (int.parse(num)-subStock[1].round()) % int.parse(subLink[0])));
        decStockFromInv(id, 'sub1', subStock[1]);
      }
    }
  }

  Future<void> sub2Execution(subStock, subLink, id, num) async {
    var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(id).get();
    if (docSnapshot10.exists) {
      Map<String, dynamic>? data10 = docSnapshot10.data();
      subStock[2] = double.parse((data10 ? ['inStock3']).toString());
      if(subStock[2] > double.parse(num)) {
        decStockFromInv(id, 'sub2', num);
      } else {
        await incStockFromInv(id, 'sub2', ((int.parse(num)-subStock[2].round()) % int.parse(subLink[1])) == 0? 0: (int.parse(subLink[1]) - (int.parse(num)-subStock[2].round()) % int.parse(subLink[1])));
        await decStockFromInv(id, 'sub2', subStock[2]);
        sub1Execution(subStock, subLink, id, ((int.parse(num)  - subStock[2])/int.parse(subLink[1])).ceil().toString());
      }
    }
  }

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
