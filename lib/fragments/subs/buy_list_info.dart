import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/fragments/subs/buy_list_refund2.dart';
import 'package:smartkyat_pos/widgets/pay_debt_buylist.dart';
import 'package:smartkyat_pos/widgets/pay_debt_items.dart';
import 'package:intl/intl.dart';
import '../../app_theme.dart';
import 'order_refund_sub2.dart';
import 'package:dotted_line/dotted_line.dart';

class BuyListInfo extends StatefulWidget {
  final _callback;
  const BuyListInfo(
      {Key? key, required this.data, required this.shopId,required void toggleCoinCallback()})
      : _callback = toggleCoinCallback;
  final String data;
  final String shopId;

  @override
  _BuyListInfoState createState() => _BuyListInfoState();
}

class _BuyListInfoState extends State<BuyListInfo>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<BuyListInfo> {
  @override
  bool get wantKeepAlive => true;
  var docId = '';
  String result = '';
  Stream<DocumentSnapshot>? buyInfoSnapshot;
  Stream<DocumentSnapshot>? prodSnapshot;
  Stream<DocumentSnapshot>? merchantSnapshot;


  @override
  initState() {
    merchantSnapshot = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('merchants').doc(widget.data.split('^')[3].split('&')[1]).snapshots();
    //prodSnapshot = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc('kkk').snapshots();

    var innerId = '';
    result = widget.data
        .split('^')[0] +
        '^' +
        widget.data
            .split('^')[1] +
        '^' +
        widget.data
            .split('^')[2] +
        '^' +
        widget.data
            .split('^')[3] +
        '^' +
        widget.data
            .split('^')[4] + '^' + widget.data.split('^')[5] + '^' + widget.data
        .split('^')[6];

    print('ccccccc' + result.split('^')[0].split('-')[0].toString());
    FirebaseFirestore.instance
        .collection('shops')
        .doc(widget.shopId)
        .collection('buyOrder')
        .where('deviceId', isEqualTo: result.split('^')[0].split('-')[0] + '-')
        .where('orderId', isEqualTo: result.split('^')[0].split('-')[1])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        innerId = doc.id;
      });
      setState(() {
        docId = innerId;
      });

      print('DOC ID ' + docId.toString());
      buyInfoSnapshot = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrder').doc(docId.toString()).snapshots();
      // return docId;
      // return Container();
    });
    super.initState();
  }

  double totalPrice = 0;
  double totalRealPrice = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          top: true,
          bottom: true,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        height: 80,
                        child:
                        Row(
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
                                  Text('MMK ' + (double.parse(result.split('^')[2]).toStringAsFixed(2)).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),),

                                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                      stream:  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('merchants').doc(widget.data.split('^')[3].split('&')[1]).snapshots(),
                                      builder: (BuildContext context, snapshot10) {
                                        if (snapshot10.hasData) {
                                          var output10 = snapshot10.data!.data();
                                          var mainUnit = output10?['merchant_name'];
                                          return Text('#' +
                                              widget.data.split('^')[1] +' - ' + mainUnit,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }
                                        return Container();
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),

                      ),
                    ),
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                  width: 1.0))),
                    ),
                  ],
                ),

                // orderDateId(widget.data)
                if (docId != null && docId != '')
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('shops')
                          .doc(widget.shopId)
                          .collection('buyOrder')
                          .doc(docId)
                          .snapshots(),
                      builder: (BuildContext context, snapshot2) {
                        if (snapshot2.hasData) {
                          var output1 = snapshot2.data!.data();
                          // print(output1?['subs'].toString());
                          List prodList = output1?['subs'];
                          var debt = output1?['debt'];
                          List prodListView = [];
                          prodListView.add(prodList[0]);
                          totalPrice = 0;
                          totalRealPrice = 0;
                          print(totalPrice.toString() +
                              'totalPrice ' +
                              prodList.toString());

                          for (int j=0;j< prodList.length; j++) {
                            totalPrice += int.parse(prodList[j].split('-')[4]) * (int.parse(prodList[j].split('-')[3]) - int.parse(prodList[j].split('-')[7]));
                          }
                          for (int j=0;j< prodList.length; j++) {
                            totalRealPrice += int.parse(prodList[j].split('-')[4]) * int.parse(prodList[j].split('-')[3]);
                          }

                          if(widget.data.split('^')[6] != '0.0') {
                            if(widget.data.split('^')[6].split('-')[1] == 'p') {
                              totalPrice = totalPrice - (totalPrice * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100));
                            } else {
                              totalPrice = totalPrice - (totalPrice * (double.parse(widget.data.split('^')[6].split('-')[0])/totalRealPrice));
                            }
                          }

                          int ttlQtity = int.parse(prodList[0].split('-')[3]);
                          int ttlRefun = int.parse(prodList[0].split('-')[3]);
                          for (int j=1;j< prodList.length; j++) {

                            int k = prodListView.length-1;
                            if(prodList[j].split('-')[0] == prodListView[k].split('-')[0] && prodList[j].split('-')[5] == prodListView[k].split('-')[5]) {
                              ttlQtity += int.parse(prodList[j].split('-')[3]);
                              ttlRefun += int.parse(prodList[j].split('-')[7]);
                              prodListView[k] = prodListView[k].split('-')[0] + '-' + prodListView[k].split('-')[1] + '-' + prodListView[k].split('-')[2] + '-' + ttlQtity.toString() + '-' +
                                  prodListView[k].split('-')[4] + '-' + prodListView[k].split('-')[5] + '-' + prodListView[k].split('-')[6] + '-' + (int.parse(prodListView[k].split('-')[7])+int.parse(prodList[j].split('-')[7])).toString() + '-' +
                                  prodListView[k].split('-')[8] ;
                            } else {
                              prodListView.add(prodList[j]);
                              ttlQtity = int.parse(prodList[j].split('-')[3]);
                              ttlRefun += int.parse(prodList[j].split('-')[7]);
                            }

                          }

                          print('view ' + prodListView.toString());



                          result = widget.data
                              .split('^')[0] +
                              '^' +
                              widget.data
                                  .split('^')[1] +
                              '^' +
                              totalPrice
                                  .toString() +
                              '^' +
                              widget.data
                                  .split('^')[3] +
                              '^' +
                              widget.data
                                  .split('^')[4] + '^' + widget.data.split('^')[5] + '^' + widget.data
                              .split('^')[6];

                          return Expanded(
                            // height: 580,
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 100,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              ButtonTheme(
                                                minWidth: 133,
                                                child: FlatButton(
                                                  color: AppTheme.buttonColor2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(7.0),
                                                    side: BorderSide(
                                                      color: Colors.white.withOpacity(0.85),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    String isRef = 'p';
                                                    double debt = double.parse(widget.data.split('^')[5]);
                                                    print('result__1 ' + result.toString());
                                                    for (int i = 0; i < prodListView.length; i++) {
                                                      if (prodListView[i].split('-')[7] != '0' && prodListView[i].split('-')[7] == prodListView[i].split('-')[3]) {
                                                        isRef = 'r';
                                                      }
                                                      if (prodListView[i].split('-')[7] != '0' && prodListView[i].split('-')[7] != prodListView[i].split('-')[3]) {
                                                        isRef = 's';
                                                      }
                                                    }

                                                    if(totalPrice <= double.parse(widget.data.split('^')[5])) {
                                                      debt = totalPrice;
                                                    }

                                                    result = widget.data
                                                        .split('^')[0] +
                                                        '^' +
                                                        widget.data
                                                            .split('^')[1] +
                                                        '^' +
                                                        totalPrice
                                                            .toString() +
                                                        '^' +
                                                        widget.data
                                                            .split('^')[3] +
                                                        '^' +
                                                        widget.data
                                                            .split('^')[4] + '^' + debt.toString() + '^' + widget.data
                                                        .split('^')[6];


                                                    result = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              BuyListRefund(
                                                                data: result,
                                                                data2: prodList,
                                                                realPrice: totalRealPrice,
                                                                toggleCoinCallback:
                                                                    () {}, shopId: widget.shopId, docId: docId.toString(),),
                                                    ));

                                                    print('result__2 ' + result.toString());
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
                                                            'Refund\nitems',
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
                                              SizedBox(width: 12),
                                              ButtonTheme(
                                                minWidth: 133,
                                                child: FlatButton(
                                                  color: AppTheme.buttonColor2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(7.0),
                                                    side: BorderSide(
                                                      color: Colors.white.withOpacity(0.85),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => PayDebtBuyList(debt: debt.toString(), data: widget.data, docId: docId, shopId: widget.shopId,))
                                                    );
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
                                                            'Pay debt\nitems',
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
                                        SizedBox(height: 20,),
                                        Text('PURCHASED ITEMS', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 2,
                                          color: Colors.grey,
                                        ),),
                                      ],
                                    ),
                                  ),
                                ),

                                for (int i = 0; i < prodListView.length; i++)
                                // if (prodListView[i].split('-')[3] != prodListView[i].split('-')[7])
                                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection('shops')
                                        .doc(widget.shopId)
                                        .collection('products')
                                        .doc(prodListView[i].split('-')[0])
                                        .snapshots(),
                                    builder: (BuildContext context, snapshot2) {
                                      if (snapshot2.hasData) {
                                        var output2 = snapshot2.data!.data();
                                        var image = output2?['img_1'];

                                        return  Stack(
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 12),
                                                  ListTile(
                                                    leading: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            5.0),
                                                        child: image != ""
                                                            ? CachedNetworkImage(
                                                          imageUrl:
                                                          'https://riftplus.me/smartkyat_pos/api/uploads/' +
                                                              image,
                                                          width: 58,
                                                          height: 58,
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
                                                          'https://pbs.twimg.com/media/Bj6ZCa9CYAA95tG?format=jpg',
                                                          width: 58,
                                                          height: 58,
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
                                                    title: Text(
                                                      output2?[
                                                      'prod_name'],
                                                      style:
                                                      TextStyle(
                                                          fontWeight: FontWeight.w500, fontSize: 16),
                                                    ),
                                                    subtitle: Padding(
                                                      padding: const EdgeInsets.only(top: 4.0),
                                                      child: Row(
                                                        children: [
                                                          Text(output2?[prodListView[i].split('-')[5]] + ' ', style: TextStyle(
                                                            fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                                          )),
                                                          if (prodListView[i].split('-')[5] == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
                                                          else if(prodListView[i].split('-')[5] == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
                                                          else Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
                                                        ],
                                                      ),
                                                    ),
                                                    trailing: Text('MMK ' + (int.parse(prodListView[i].split('-')[4]) * (int.parse(prodListView[i].split('-')[3]) - int.parse(prodListView[i].split('-')[7]))).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                      ),),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 15.0),
                                                    child: Container(height: 12,
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                            bottom:
                                                            BorderSide(color: AppTheme.skBorderColor2, width: 1.0),
                                                          )),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top : 8,
                                              left : 50,
                                              child: Container(
                                                height: 20,
                                                width: 30,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: AppTheme.skBorderColor2,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10.0),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    )),
                                                child: Text((int.parse(prodListView[i].split('-')[3]) - int.parse(prodListView[i].split('-')[7])).toString(), style: TextStyle(
                                                  fontSize: 11, fontWeight: FontWeight.w500,
                                                )),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return Container();
                                    },
                                  ),

                                Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      // ListTile (
                                      //   title: Text('Sub Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //   // subtitle: Text('Amount applied', style: TextStyle(
                                      //   //   fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                      //   // )),
                                      //   trailing: Text('MMK ' + totalRealPrice.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      // ),
                                      // if ((widget.data.split('^')[6]) != '0.0') Container(
                                      //   child: (widget.data.split('^')[6]).split('-')[1] == 'p' ?
                                      //   ListTile(
                                      //     title: Text('SubTotal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //
                                      //     trailing: Text('MMK ' + (double.parse(widget.data.split('^')[2]) + (totalRealPrice * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100))).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //
                                      //   ) :  ListTile (
                                      //     title: Text('Sub Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //
                                      //     trailing: Text('MMK ' + (double.parse(widget.data.split('^')[2]) + double.parse(widget.data.split('^')[6].split('-')[0])).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //   ),
                                      // ) else ListTile (
                                      //   title: Text('Sub Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //   trailing: Text('MMK ' + (widget.data.split('^')[2]).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      // ),
                                      if ((widget.data.split('^')[6]) != '0.0') Container(
                                        child: (widget.data.split('^')[6]).split('-')[1] == 'p' ?
                                        ListTile(
                                          title: Text('Discount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                          subtitle: Text('Percentage (' +  (widget.data.split('^')[6]).split('-')[0] + '%)', style: TextStyle(
                                            fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                          )),
                                          trailing: Text('- MMK ' + (totalRealPrice * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100)).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                          // trailing: Text('- MMK ' + (int.parse(prodListView[i].split('-')[4]) * (int.parse(prodListView[i].split('-')[3]) - int.parse(prodListView[i].split('-')[7]))).toString()),
                                          //trailing: Text('- MMK ' + (int.parse(TtlProdListPriceInit()) - int.parse((widget.data.split('^')[2]))).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

                                        ) :  ListTile (
                                          title: Text('Discount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                          subtitle: Text('Amount applied', style: TextStyle(
                                            fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                          )),
                                          trailing: Text('- MMK ' + (widget.data.split('^')[6]).split('-')[0], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                        ),
                                      ) else Container(),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(left: 15.0),
                                      //   child: Container(height: 12,
                                      //     decoration: BoxDecoration(
                                      //         border: Border(
                                      //           bottom:
                                      //           BorderSide(color: AppTheme.skBorderColor2, width: 1.0),
                                      //         )),),
                                      // ),
                                      // ListTile (
                                      //   title: Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //   // subtitle: Text('Amount applied', style: TextStyle(
                                      //   //   fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                      //   // )),
                                      //   trailing: Text('MMK ' + (widget.data.split('^')[2]).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      // ),
                                      // ListTile (
                                      //   title: Text('Paid', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //   // subtitle: Text('Amount applied', style: TextStyle(
                                      //   //   fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                      //   // )),
                                      //   trailing: Text('- MMK ' + (double.parse(widget.data.split('^')[2]) - double.parse(widget.data.split('^')[5])).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      // ),

                                      if ((widget.data.split('^')[5]) != '0.0')
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 0.0),
                                              child: Container(height: 12,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom:
                                                      BorderSide(color: AppTheme.skBorderColor2, width: 1.0),
                                                    )),),
                                            ),
                                            ListTile(
                                              title: Text('Debt Amount',
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

                                              trailing: Text('MMK ' + (widget.data.split('^')[5]).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

                                            ),
                                          ],
                                        ) else Container(),

                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 18.0, top: 10),
                                  child: DottedLine(lineThickness: 2,dashLength: 8, dashColor: AppTheme.skBorderColor2,),
                                ),
                                for (int i = 0; i < prodListView.length; i++)
                                  if (prodListView[i].split('-')[7] != '0')
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: Text('REFUNDED ITEMS', style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        letterSpacing: 2,
                                        color: Colors.grey,
                                      ),),
                                    ),

                                for (int i = 0; i < prodListView.length; i++)
                                  if (prodListView[i].split('-')[7] != '0')
                                    StreamBuilder<
                                        DocumentSnapshot<
                                            Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection('shops')
                                          .doc(widget.shopId)
                                          .collection('products')
                                          .doc(prodListView[i].split('-')[0])
                                          .snapshots(),
                                      builder:
                                          (BuildContext context, snapshot2) {
                                        if (snapshot2.hasData) {
                                          var output2 =
                                          snapshot2.data!.data();
                                          var image = output2?['img_1'];
                                          return Slidable(
                                            key: UniqueKey(),
                                            actionPane:
                                            SlidableDrawerActionPane(),
                                            actionExtentRatio:
                                            0.25,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 12),
                                                      ListTile(
                                                        leading: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                5.0),
                                                            child: image != ""
                                                                ? CachedNetworkImage(
                                                              imageUrl:
                                                              'https://riftplus.me/smartkyat_pos/api/uploads/' +
                                                                  image,
                                                              width: 58,
                                                              height: 58,
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
                                                              'https://pbs.twimg.com/media/Bj6ZCa9CYAA95tG?format=jpg',
                                                              width: 58,
                                                              height: 58,
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
                                                        title: Text(
                                                          output2?[
                                                          'prod_name'],
                                                          style:
                                                          TextStyle(
                                                              fontWeight: FontWeight.w500, fontSize: 16),
                                                        ),
                                                        subtitle: Padding(
                                                          padding: const EdgeInsets.only(top: 4.0),
                                                          child: Row(
                                                            children: [
                                                              Text(output2?[prodListView[i].split('-')[5]] + ' ', style: TextStyle(
                                                                fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                                              )),
                                                              if (prodListView[i].split('-')[5] == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
                                                              else if(prodListView[i].split('-')[5] == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
                                                              else Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
                                                            ],
                                                          ),
                                                        ),
                                                        trailing: discTra(widget.data.split('^')[6], prodListView[i]),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 15.0),
                                                        child: Container(height: 12,
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                bottom:
                                                                BorderSide(color: AppTheme.skBorderColor2, width: 1.0),
                                                              )),),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  top : 8,
                                                  left : 50,
                                                  child: Container(
                                                    height: 20,
                                                    width: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: AppTheme.skBorderColor2,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                        border: Border.all(
                                                          color: Colors.white,
                                                          width: 2,
                                                        )),
                                                    child: Text(prodListView[i].split('-')[7].toString(), style: TextStyle(
                                                      fontSize: 11, fontWeight: FontWeight.w500,
                                                    )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            dismissal:
                                            SlidableDismissal(
                                              child:
                                              SlidableDrawerDismissal(),
                                              onDismissed:
                                                  (actionType) {
                                                setState((){
                                                });
                                              },
                                            ),
                                            secondaryActions: <
                                                Widget>[
                                              IconSlideAction(
                                                caption: 'Delete',
                                                color: Colors.red,
                                                icon:
                                                Icons.delete,
                                                onTap: () {
                                                  setState((){
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        }
                                        return Container();
                                      },
                                    )

                                // orderLoading?Text('Loading'):Text('')
                              ],
                            ),
                          );
                        }

                        return Container();
                      })
              ])),
    );
  }

  addDailyExp(priContext) {
    // myController.clear();
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: MediaQuery.of(priContext).padding.top,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                              color: Colors.white.withOpacity(0.5)),
                        ),
                        SizedBox(
                          height: 14,
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

                          child: Container(
                            width: 150,
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                    ),
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.transparent,
                                        ),
                                        onPressed: () {},
                                      ),
                                      Text(
                                        "New Expense",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontFamily: 'capsulesans',
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.left,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          print('clicked');
                                        },
                                      )
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
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.yellow,
                    height: 100,
                  ),
                )
              ],
            ),
          );
        });

  }

  Widget discSub(String str, String prodList) {
    if(str != '0.0') {
      return str.split('-')[1] == 'p' ?
      Text((double.parse(prodList.split('-')[4]) - (double.parse(prodList.split('-')[4]) * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100))).toStringAsFixed(2) + ' MMK'):
      Text((double.parse(prodList.split('-')[4]) - (double.parse(prodList.split('-')[4]) * (double.parse(widget.data.split('^')[6].split('-')[0])/totalRealPrice))).toStringAsFixed(2) + ' MMK');
    } else {
      return Text(double.parse(prodList.split('-')[4]).toStringAsFixed(2));
    }

  }

  discTra(String str, String prodList) {
    if(str != '0.0') {
      return widget.data.split('^')[6].split('-')[1] == 'p' ?
      Text('MMK ' +((double.parse(prodList.split('-')[4]) * (double.parse(prodList.split('-')[7]))) - ((double.parse(prodList.split('-')[4]) * (double.parse(prodList.split('-')[7]))) * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100))).toStringAsFixed(2).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),) :
      Text('MMK ' +((double.parse(prodList.split('-')[4]) * (double.parse(prodList.split('-')[7]))) - ((double.parse(prodList.split('-')[4]) * (double.parse(prodList.split('-')[7]))) * (double.parse(widget.data.split('^')[6].split('-')[0])/totalRealPrice))).toStringAsFixed(2).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),);
    } else {
      return Text('MMK ' +(double.parse(prodList.split('-')[4]) * double.parse(prodList.split('-')[7])).toStringAsFixed(2).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),);
    }

  }
}