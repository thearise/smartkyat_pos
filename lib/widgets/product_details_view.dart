import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../app_theme.dart';
import 'fill_product.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
];

class ProductDetailsView extends StatefulWidget {
  final _callback;
  final _callback3;

  const ProductDetailsView(
      {Key? key,
        required this.idString,
        required void toggleCoinCallback(String str),
        required void toggleCoinCallback3(String str)})
      : _callback = toggleCoinCallback,
        _callback3 = toggleCoinCallback3;

  final String idString;

  @override
  _ProductDetailsViewState createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
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
              unitname: res,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('space')
                  .doc('0NHIS0Jbn26wsgCzVBKT')
                  .collection('shops')
                  .doc('PucvhZDuUz3XlkTgzcjb')
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
                  var mainPrice = output?['main_sprice'];
                  var sub1Price = output?['sub1_sprice'];
                  var sub2Price = output?['sub2_sprice'];
                  var sub3Price = output?['sub3_sprice'];
                  var sub1Unit = output?['sub1_unit'];
                  var sub2Unit = output?['sub2_unit'];
                  var sub3Unit = output?['sub3_unit'];
                  return Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 70,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.withOpacity(0.3),
                                      width: 1.0))),
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
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                              Text(
                                'Product Details',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                    color: AppTheme.skThemeColor2),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {}),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          prodName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            children: [
                              ButtonTheme(
                                //minWidth: 50,
                                splashColor: Colors.transparent,
                                height: 120,
                                child: FlatButton(
                                  color: AppTheme.skThemeColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    side: BorderSide(
                                      color: AppTheme.skThemeColor,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (sub1Name == '') {
                                      widget._callback(widget.idString +
                                          '-' +
                                          '-' +
                                          mainPrice +
                                          '-unit_name-1'.toString());
                                    } else {
                                      final result =
                                      await showModalActionSheet<String>(
                                        context: context,
                                        actions: [
                                          SheetAction(
                                            icon: Icons.info,
                                            label: '1 ' + mainName,
                                            key: widget.idString +
                                                '-' +
                                                '-' +
                                                mainPrice +
                                                '-unit_name-1',
                                          ),
                                          if (sub1Price != '')
                                            SheetAction(
                                              icon: Icons.info,
                                              label: '1 ' + sub1Name,
                                              key: widget.idString +
                                                  '-' +
                                                  '-' +
                                                  sub1Price +
                                                  '-sub1_name-1',
                                            ),
                                          if (sub2Price != '')
                                            SheetAction(
                                              icon: Icons.info,
                                              label: '1 ' + sub2Name,
                                              key: widget.idString +
                                                  '-' +
                                                  '-' +
                                                  sub2Price +
                                                  '-sub2_name-1',
                                            ),
                                          if (sub3Price != '')
                                            SheetAction(
                                              icon: Icons.info,
                                              label: '1 ' + sub3Name,
                                              key: widget.idString +
                                                  '-' +
                                                  '-' +
                                                  sub3Price +
                                                  '-sub3_name-1',
                                            ),
                                        ],
                                      );

                                      widget._callback(result.toString());
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Add to cart',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              ButtonTheme(
                                //minWidth: 50,
                                splashColor: Colors.transparent,
                                height: 120,
                                child: FlatButton(
                                  color: AppTheme.skThemeColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    side: BorderSide(
                                      color: AppTheme.skThemeColor,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (sub1Name == '') {
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
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Fill Product',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text('Edit all'),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            //height: MediaQuery.of(context).size.height,
                              child: ListView(children: [
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
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Text('Main Unit Versions'),
                                            SizedBox(height: 15,),
                                            StreamBuilder(
                                                stream: FirebaseFirestore.instance
                                                    .collection('space')
                                                    .doc('0NHIS0Jbn26wsgCzVBKT')
                                                    .collection('shops')
                                                    .doc('PucvhZDuUz3XlkTgzcjb')
                                                    .collection('products')
                                                    .doc(widget.idString)
                                                    .collection('versions')
                                                    .where('type', isEqualTo: 'main')
                                                    .where('unit_qtity', isNotEqualTo: '0')
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                    snapshot6) {
                                                  if (snapshot6.hasData) {
                                                    return ListView(
                                                      shrinkWrap: true,
                                                      physics:
                                                      NeverScrollableScrollPhysics(),
                                                      children: snapshot6.data!.docs.map(
                                                              (DocumentSnapshot document) {
                                                            Map<String, dynamic> data6 =
                                                            document.data()!
                                                            as Map<String, dynamic>;
                                                            var mainPrices = data6['buy_price'];
                                                            var mainQtity = data6['unit_qtity'];
                                                            var date = data6['date'];
                                                            return Column(
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                      context)
                                                                      .size
                                                                      .width,
                                                                  height: 50,
                                                                  color: Colors.grey
                                                                      .withOpacity(0.3),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Text('$mainQtity $mainName'),
                                                                        Spacer(),
                                                                        Text('$mainPrices MMK'),
                                                                        Spacer(),
                                                                        Text('Date: $date'),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(height: 10,),
                                                              ],
                                                            );
                                                          }).toList(),
                                                    );
                                                  }
                                                  return Container();
                                                }), ],
                                        ),
                                        sub1Name!=''? Column(
                                          children: [
                                            Text('Sub1 Versions'),
                                            SizedBox(height: 15,),
                                            StreamBuilder(
                                                stream: FirebaseFirestore.instance
                                                    .collection('space')
                                                    .doc('0NHIS0Jbn26wsgCzVBKT')
                                                    .collection('shops')
                                                    .doc('PucvhZDuUz3XlkTgzcjb')
                                                    .collection('products')
                                                    .doc(widget.idString)
                                                    .collection('versions')
                                                    .where('type', isEqualTo: 'sub1')
                                                    .where('unit_qtity', isNotEqualTo: '0')
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                    snapshot6) {
                                                  if (snapshot6.hasData) {
                                                    return ListView(
                                                      shrinkWrap: true,
                                                      physics:
                                                      NeverScrollableScrollPhysics(),
                                                      children: snapshot6.data!.docs.map(
                                                              (DocumentSnapshot document) {
                                                            Map<String, dynamic> data6 =
                                                            document.data()!
                                                            as Map<String, dynamic>;
                                                            var mainPrices = data6['buy_price'];
                                                            var mainQtity = data6['unit_qtity'];
                                                            var date = data6['date'];
                                                            return Column(
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                      context)
                                                                      .size
                                                                      .width,
                                                                  height: 50,
                                                                  color: Colors.grey
                                                                      .withOpacity(0.3),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Text('$mainQtity $sub1Name'),
                                                                        Spacer(),
                                                                        Text('$mainPrices MMK'),
                                                                        Spacer(),
                                                                        Text('Date: $date'),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(height: 10,),
                                                              ],
                                                            );
                                                          }).toList(),
                                                    );
                                                  }
                                                  return Container();
                                                }), ],
                                        ): Container(),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Quantity",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 2,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          children: [
                                            StreamBuilder(
                                                stream: FirebaseFirestore.instance
                                                    .collection('space')
                                                    .doc('0NHIS0Jbn26wsgCzVBKT')
                                                    .collection('shops')
                                                    .doc('PucvhZDuUz3XlkTgzcjb')
                                                    .collection('products')
                                                    .doc(widget.idString)
                                                    .collection('versions')
                                                    .where('type',
                                                    isEqualTo: 'main')
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                    snapshot2) {
                                                  if (snapshot2.hasData) {
                                                    int quantity = 0;
                                                    var mainQuantity;
                                                    snapshot2.data!.docs.map(
                                                            (DocumentSnapshot
                                                        document) {
                                                          Map<String, dynamic> data1 =
                                                          document.data()! as Map<
                                                              String, dynamic>;

                                                          quantity += int.parse(
                                                              data1['unit_qtity']);
                                                          mainQuantity =
                                                              quantity.toString();
                                                        }).toList();
                                                    return Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Main Quantity',
                                                            style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 16,
                                                              // letterSpacing: 2,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '$mainQuantity $mainName',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            color: Colors.blueGrey
                                                                .withOpacity(1.0),
                                                          ),
                                                        ),
                                                        Container(
                                                            width: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .width,
                                                            height: 1.5,
                                                            color: Colors.grey
                                                                .withOpacity(0.3)),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  return Container();
                                                }),
                                            StreamBuilder(
                                                stream: FirebaseFirestore.instance
                                                    .collection('space')
                                                    .doc('0NHIS0Jbn26wsgCzVBKT')
                                                    .collection('shops')
                                                    .doc('PucvhZDuUz3XlkTgzcjb')
                                                    .collection('products')
                                                    .doc(widget.idString)
                                                    .collection('versions')
                                                    .where('type',
                                                    isEqualTo: 'sub1')
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                    snapshot3) {
                                                  if (snapshot3.hasData) {
                                                    int quantity1 = 0;
                                                    var sub1Quantity;
                                                    snapshot3.data!.docs.map(
                                                            (DocumentSnapshot
                                                        document) {
                                                          Map<String, dynamic> data2 =
                                                          document.data()! as Map<
                                                              String, dynamic>;
                                                          if (data2['unit_qtity'] !=
                                                              '') {
                                                            quantity1 += int.parse(
                                                                data2['unit_qtity']);
                                                            sub1Quantity =
                                                                quantity1.toString();
                                                          } else
                                                            return Container();
                                                        }).toList();
                                                    // print(sub1Quantity);
                                                    // print(mainQuantity);

                                                    if (sub1Quantity != null) {
                                                      return Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              'Sub1 Quantity',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.w500,
                                                                fontSize: 16,
                                                                // letterSpacing: 2,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            '$sub1Quantity $sub1Name',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              color: Colors.blueGrey
                                                                  .withOpacity(1.0),
                                                            ),
                                                          ),
                                                          Container(
                                                              width: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              height: 1.5,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                  0.3)),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                    return Container();
                                                  }
                                                  return Container();
                                                }),
                                            StreamBuilder(
                                                stream: FirebaseFirestore.instance
                                                    .collection('space')
                                                    .doc('0NHIS0Jbn26wsgCzVBKT')
                                                    .collection('shops')
                                                    .doc('PucvhZDuUz3XlkTgzcjb')
                                                    .collection('products')
                                                    .doc(widget.idString)
                                                    .collection('versions')
                                                    .where('type',
                                                    isEqualTo: 'sub2')
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                    snapshot4) {
                                                  if (snapshot4.hasData) {
                                                    int quantity2 = 0;
                                                    var sub2Quantity;
                                                    snapshot4.data!.docs.map(
                                                            (DocumentSnapshot
                                                        document) {
                                                          Map<String, dynamic> data3 =
                                                          document.data()! as Map<
                                                              String, dynamic>;
                                                          if (data3['unit_qtity'] !=
                                                              '') {
                                                            quantity2 += int.parse(
                                                                data3['unit_qtity']);
                                                            sub2Quantity =
                                                                quantity2.toString();
                                                          } else
                                                            return Container();
                                                        }).toList();
                                                    if (sub2Quantity != null) {
                                                      return Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              'Sub2 Quantity',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.w500,
                                                                fontSize: 16,
                                                                // letterSpacing: 2,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            '$sub2Quantity $sub2Name',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              color: Colors.blueGrey
                                                                  .withOpacity(1.0),
                                                            ),
                                                          ),
                                                          Container(
                                                              width: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              height: 1.5,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                  0.3)),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                    return Container();
                                                  }
                                                  return Container();
                                                }),
                                            StreamBuilder(
                                                stream: FirebaseFirestore.instance
                                                    .collection('space')
                                                    .doc('0NHIS0Jbn26wsgCzVBKT')
                                                    .collection('shops')
                                                    .doc('PucvhZDuUz3XlkTgzcjb')
                                                    .collection('products')
                                                    .doc(widget.idString)
                                                    .collection('versions')
                                                    .where('type',
                                                    isEqualTo: 'sub3')
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                    snapshot5) {
                                                  if (snapshot5.hasData) {
                                                    int quantity3 = 0;
                                                    var sub3Quantity;
                                                    snapshot5.data!.docs.map(
                                                            (DocumentSnapshot
                                                        document) {
                                                          Map<String, dynamic> data4 =
                                                          document.data()! as Map<
                                                              String, dynamic>;
                                                          if (data4['unit_qtity'] !=
                                                              '') {
                                                            quantity3 += int.parse(
                                                                data4['unit_qtity']);
                                                            sub3Quantity =
                                                                quantity3.toString();
                                                          } else
                                                            return Container();
                                                        }).toList();
                                                    // print(sub1Quantity);
                                                    // print(mainQuantity);
                                                    if (sub3Quantity != null) {
                                                      return Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              'Sub3 Quantity',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.w500,
                                                                fontSize: 16,
                                                                // letterSpacing: 2,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            '$sub3Quantity $sub3Name',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                              FontWeight.w400,
                                                              color: Colors.blueGrey
                                                                  .withOpacity(1.0),
                                                            ),
                                                          ),
                                                          Container(
                                                              width: MediaQuery.of(
                                                                  context)
                                                                  .size
                                                                  .width,
                                                              height: 1.5,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                  0.3)),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                    return Container();
                                                  }
                                                  return Container();
                                                }),
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Pricing",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 2,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: Text(
                                            'Main Unit Price',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              // letterSpacing: 2,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          mainPrice,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.blueGrey.withOpacity(1.0),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                            width:
                                            MediaQuery.of(context).size.width,
                                            height: 1.5,
                                            color: Colors.grey.withOpacity(0.3)),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        sub1Price != ""
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                'Sub1 Price',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  // letterSpacing: 2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              sub1Price,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blueGrey
                                                    .withOpacity(1.0),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        )
                                            : Container(),
                                        sub2Price != ""
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                'Sub2 Price',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  // letterSpacing: 2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              sub2Price,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blueGrey
                                                    .withOpacity(1.0),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        )
                                            : Container(),
                                        sub3Price != ""
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                'Sub3 Price',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  // letterSpacing: 2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              sub3Price,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blueGrey
                                                    .withOpacity(1.0),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        )
                                            : Container(),
                                        sub1Unit != ""
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Sub per Main Unit",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 2,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              child: Text(
                                                'Sub1',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  // letterSpacing: 2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              sub1Unit,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blueGrey
                                                    .withOpacity(1.0),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                            : Container(),
                                        sub2Unit != ""
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                'Sub2',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  // letterSpacing: 2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              sub2Unit,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blueGrey
                                                    .withOpacity(1.0),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                            : Container(),
                                        sub3Unit != ""
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                'Sub3',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  // letterSpacing: 2,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              sub3Unit,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.blueGrey
                                                    .withOpacity(1.0),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                            : Container(),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "OTHER INFORMATION",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              letterSpacing: 2,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _productDetails('Bar Code', barcode),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "PRODUCT IMAGES",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              letterSpacing: 2,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 100,
                                          child: ListView(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FullscreenSliderDemo(
                                                                    0)));
                                                  },
                                                  child: Image.network(
                                                    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
                                                    fit: BoxFit.cover,
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FullscreenSliderDemo(
                                                                    1)));
                                                  },
                                                  child: Image.network(
                                                    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
                                                    fit: BoxFit.cover,
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FullscreenSliderDemo(
                                                                    2)));
                                                  },
                                                  child: Image.network(
                                                    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
                                                    fit: BoxFit.cover,
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FullscreenSliderDemo(
                                                                    3)));
                                                  },
                                                  child: Image.network(
                                                    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
                                                    fit: BoxFit.cover,
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FullscreenSliderDemo(
                                                                    4)));
                                                  },
                                                  child: Image.network(
                                                    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
                                                    fit: BoxFit.cover,
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ])),
                        ),
                      ]);
                }
                return Container();
              }),
        ),
      ),
    );
  }
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

class FullscreenSliderDemo extends StatelessWidget {
  final int index;
  FullscreenSliderDemo(this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Builder(
          builder: (context) {
            final double height = MediaQuery.of(context).size.height;
            return Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: height,
                    initialPage: index,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    // autoPlay: false,
                  ),
                  items: imgList
                      .map((item) => Container(
                    child: Center(
                        child: Image.network(
                          item,
                          fit: BoxFit.cover,
                          height: height,
                        )),
                  ))
                      .toList(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        color: Colors.black),
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
