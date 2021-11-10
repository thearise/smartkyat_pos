import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fraction/fraction.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';

import '../../app_theme.dart';

class BuyListRefund extends StatefulWidget {
  final _callback;
  const BuyListRefund(
      {Key? key, required this.data, required this.data2, required this.realPrice, required void toggleCoinCallback()})
      : _callback = toggleCoinCallback;
  final String data;
  final List data2;
  final double realPrice;

  @override
  _BuyListRefundState createState() => _BuyListRefundState();
}

class _BuyListRefundState extends State<BuyListRefund>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<BuyListRefund> {
  @override
  bool get wantKeepAlive => true;
  var docId = '';
  List<int> refundItems = [];
  List<int> deffItems = [];
  @override
  initState() {
    var innerId = '';
    FirebaseFirestore.instance
        .collection('space')
        .doc('0NHIS0Jbn26wsgCzVBKT')
        .collection('shops')
        .doc('PucvhZDuUz3XlkTgzcjb')
        .collection('buyOrders')
    // FirebaseFirestore.instance.collection('space')
        .where('date', isEqualTo: widget.data.split('^')[0].substring(0, 8))
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        innerId = doc.id;
      });
      setState(() {
        docId = innerId;
      });
      // return docId;
      // return Container();
    });

    super.initState();
  }

  // Future orderDateId(data) async {
  //   // var docId = '';
  //   FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
  //   // FirebaseFirestore.instance.collection('space')
  //       .where('date', isEqualTo: data.split('^')[0].substring(0,8))
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //       querySnapshot.docs.forEach((doc) {
  //         docId = doc.id;
  //       });
  //       return docId;
  //     // return Container();
  //   });
  // }
  bool initAttempt = false;
  int changedPrice = 0;
  List<String> prodListView = [];
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
                                      }
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('MMK ' + (double.parse(widget.data.split('^')[2]).toStringAsFixed(2)).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),),

                                  StreamBuilder<
                                      DocumentSnapshot<
                                          Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection('space')
                                          .doc('0NHIS0Jbn26wsgCzVBKT')
                                          .collection('shops')
                                          .doc('PucvhZDuUz3XlkTgzcjb')
                                          .collection('merchants')
                                          .doc(widget.data
                                          .split('^')[3]
                                          .split('&')[1])
                                          .snapshots(),
                                      builder:
                                          (BuildContext context, snapshot2) {
                                        if (snapshot2.hasData) {
                                          var output1 = snapshot2.data!.data();
                                          var mainUnit =
                                          output1?['merchant_name'];
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
                          .collection('space')
                          .doc('0NHIS0Jbn26wsgCzVBKT')
                          .collection('shops')
                          .doc('PucvhZDuUz3XlkTgzcjb')
                          .collection('buyOrders')
                          .doc(docId)
                          .collection('expansion')
                          .doc(widget.data.split('^')[0])
                          .snapshots(),
                      builder: (BuildContext context, snapshot2) {
                        if (snapshot2.hasData) {
                          var output1 = snapshot2.data!.data();
                          // print(output1?['subs'].toString());
                          List prodList = output1?['subs'];
                          List prodListBefore = widget.data2;
                          prodListView = [];
                          prodListView.add(prodList[0]);

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

                          if (!initAttempt) {
                            for (int i = 0; i < prodListView.length; i++) {
                              // refundItems[i] = int.parse(prodList[i].split('-')[5]);
                              refundItems
                                  .add(int.parse(prodListView[i].split('-')[7]));
                              deffItems
                                  .add(int.parse(prodListView[i].split('-')[7]));
                            }
                            initAttempt = true;
                          }

                          return Expanded(
                            child: ListView(
                              children: [

                                for (int i = 0; i < prodListView.length; i++)
                                  StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection('space')
                                        .doc('0NHIS0Jbn26wsgCzVBKT')
                                        .collection('shops')
                                        .doc('PucvhZDuUz3XlkTgzcjb')
                                        .collection('products')
                                        .doc(prodListView[i].split('-')[0])
                                        .snapshots(),
                                    builder: (BuildContext context, snapshot2) {
                                      if (snapshot2.hasData) {
                                        var output2 = snapshot2.data!.data();
                                        var image = output2?['img_1'];
                                        return Container(
                                          color: Colors.white,
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
                                                      trailing: Container(

                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                if(prodListView[i].split('-')[7] == '0' || int.parse(prodListView[i].split('-')[7]) < refundItems[i]) {
                                                                  setState(() {
                                                                    if (refundItems[i] <= 0) {
                                                                    } else {
                                                                      refundItems[i] =
                                                                          refundItems[i] - 1;
                                                                    }
                                                                  });
                                                                }
                                                                print('dataRMM' + widget.data.toString());

                                                              },
                                                              child: Container(
                                                                width: 42,
                                                                height: 42,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.circular(10.0),
                                                                    color: AppTheme.buttonColor2),
                                                                child: Container(
                                                                    child: Icon(
                                                                      Icons.remove, size: 20,
                                                                    )
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 20),
                                                            Text(refundItems[i].toString(), style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                            ),),
                                                            SizedBox(width: 20),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  if ((refundItems[i]) >=
                                                                      int.parse(prodListView[i]
                                                                          .split('-')[3])) {
                                                                  } else {
                                                                    refundItems[i] =
                                                                        refundItems[i] + 1;
                                                                  }
                                                                });
                                                              },
                                                              child: Container(
                                                                width: 42,
                                                                height: 42,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.circular(10.0),
                                                                    color: AppTheme.themeColor),
                                                                child: Container(
                                                                    child: Icon(
                                                                      Icons.add, size: 20,
                                                                    )
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
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
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ListTile(
                                  title: Text(
                                    'Total refunds',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                        FontWeight
                                            .w500),
                                  ),
                                  subtitle: totalItems() == 1? Text(totalItems().toString() + ' item',
                                      style: TextStyle(
                                        fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                      )) : Text(totalItems().toString() + ' items',
                                      style: TextStyle(
                                        fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                      )),
                                  trailing: Text('MMK '+
                                      totalPriceView().toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                        FontWeight
                                            .w500),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Total refund Amount',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                        FontWeight
                                            .w500),
                                  ),
                                  subtitle: totalItems() == 1? Text(totalItems().toString() + ' item',
                                      style: TextStyle(
                                        fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                      )) : Text(totalItems().toString() + ' items',
                                      style: TextStyle(
                                        fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                      )),
                                  trailing: Text('MMK '+
                                      totalRefund().toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                        FontWeight
                                            .w500),
                                  ),
                                ),

                                // Text(
                                //   totalPriceView().toString()
                                // ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: ButtonTheme(
                                    //minWidth: 50,
                                    splashColor: Colors.transparent,
                                    height: 50,
                                    child: FlatButton(
                                      color: AppTheme.skThemeColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        side: BorderSide(
                                          color: AppTheme.skThemeColor,
                                        ),
                                      ),
                                      onPressed: () async {
                                        double total = 0;
                                        bool refund = false;
                                        List<String> ref2Cust = [];
                                        List<String> ref2Shop = [];
                                        for (int i = 0; i < refundItems.length; i++) {
                                          prodListView[i] = prodListView[i].split('-')[0] + '-' + prodListView[i].split('-')[1] + '-' + prodListView[i].split('-')[2] + '-' +
                                              prodListView[i].split('-')[3] + '-' + prodListView[i].split('-')[4] + '-' + prodListView[i].split('-')[5] + '-' +
                                              prodListView[i].split('-')[6] +
                                              '-' +
                                              refundItems[i].toString() +
                                              '-' +
                                              prodListView[i].split('-')[8];
                                          total += (int.parse(prodListView[i]
                                              .split('-')[3]) -
                                              refundItems[i]) *
                                              int.parse(
                                                  prodListView[i].split('-')[4]);

                                          if (refundItems[i] > 0) {
                                            refund = true;
                                          }

                                          print('unit _name' + prodListView[i]);
                                          print('unit ' + deffItems[i].toString() + ' ' + refundItems[i].toString() + (deffItems[i] - refundItems[i]).toString());

                                          ref2Cust = [];
                                          ref2Shop = [];
                                          for(int i=0; i < deffItems.length; i++) {
                                            if(deffItems[i] - refundItems[i] < 0) {
                                              print('ref to shop ' + prodListView[i].split('-')[3] + ' ' + prodListView[i].split('-')[5]);
                                              ref2Shop.add(prodListView[i].split('-')[0] + '-' + prodListView[i].split('-')[1] + '-' + (deffItems[i] - refundItems[i]).abs().toString() + '-' + prodListView[i].split('-')[5]);
                                            } else if(deffItems[i] - refundItems[i] > 0) {
                                              print('ref to cust ' + prodListView[i].split('-')[3] + ' ' + prodListView[i].split('-')[5]);
                                            }
                                          }
                                        }

                                        print('che ' + ref2Shop.toString());
                                        print('che2 ' + prodListView.toString());

                                        print('prodList 5  1 ' + total.toString() + ' ' + prodList.toString());

                                        if(widget.data.split('^')[6] != '0.0') {
                                          if(widget.data.split('^')[6].split('-')[1] == 'p') {
                                            total = total - (total * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100));
                                          } else {
                                            total = total - (total * (double.parse(widget.data.split('^')[6].split('-')[0])/widget.realPrice));
                                          }
                                        }
                                        print('result__ 3' + total.toString());
                                        print('prodListBef 1 ' + prodListBefore.toString());

                                        for(int i=0; i < prodListView.length; i++) {
                                          // int.parse(ref2Shop[i].split('-')[2])
                                          int value = int.parse(prodListView[i].split('-')[7]);
                                          String prodId = prodListView[i].split('-')[0];
                                          String prodTp = prodListView[i].split('-')[5];

                                          print(prodId + ' ' + prodTp);

                                          for(int j=0; j< prodList.length; j++) {
                                            print('debuug ' + i.toString() + ' ' + j.toString() + ' ' + value.toString());
                                            int refund = 0;
                                            if(prodId == prodList[j].split('-')[0] && prodTp == prodList[j].split('-')[5] && value <= int.parse(prodList[j].split('-')[3])) {
                                              refund = value - int.parse(prodList[j].split('-')[7]);
                                              print('refun ' + refund.toString() + ' ' + value.toString() + ' ' + prodList[j].split('-')[7]);
                                              prodList[j] = prodList[j].split('-')[0] + '-' + prodList[j].split('-')[1] + '-' + prodList[j].split('-')[2] + '-' + prodList[j].split('-')[3] + '-' + prodList[j].split('-')[4] + '-' + prodList[j].split('-')[5] + '-' + prodList[j].split('-')[6] + '-' +
                                                  value.toString() + '-' + prodList[j].split('-')[8];

                                              // prodListBefore[j] = prodListBefore[j].split('-')[0] + '-' + prodListBefore[j].split('-')[1] + '-' + prodListBefore[j].split('-')[2] + '-' + prodListBefore[j].split('-')[3] + '-' + prodListBefore[j].split('-')[4] + '-' + prodListBefore[j].split('-')[5] + '-' + prodListBefore[j].split('-')[6] + '-' +
                                              //     refund.toString() + '-' + prodListBefore[j].split('-')[8];
                                              break;
                                            } else if (prodId == prodList[j].split('-')[0] && prodTp == prodList[j].split('-')[5] && value > int.parse(prodList[j].split('-')[3])) {
                                              refund = value - int.parse(prodList[j].split('-')[7]);
                                              print('refun ' + refund.toString() + ' ' + value.toString() + ' ' + prodList[j].split('-')[7]);
                                              prodList[j] = prodList[j].split('-')[0] + '-' + prodList[j].split('-')[1] + '-' + prodList[j].split('-')[2] + '-' + prodList[j].split('-')[3] + '-' + prodList[j].split('-')[4] + '-' + prodList[j].split('-')[5] + '-' + prodList[j].split('-')[6] + '-' +
                                                  prodList[j].split('-')[3] + '-' + prodList[j].split('-')[8];
                                              value = value - int.parse(prodList[j].split('-')[3]);
                                            }
                                          }
                                        }

                                        print('prodList 5  2 ' + total.toString() + ' ' + prodList.toString());
                                        print('prodListBef 2 ' + prodListBefore.toString());
                                        List prodRets = prodList;
                                        for(int i=0; i < prodList.length; i++) {
                                          int refNum = int.parse(prodList[i].split('-')[7]) - int.parse(prodListBefore[i].split('-')[7]);
                                          if(refNum > 0) {
                                            print('pyan thwin ' + prodList[i].split('-')[0] + '-' + prodList[i].split('-')[1] + '-' + refNum.toString());
                                            var docSnapshot = await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb')
                                                .collection('products').doc(prodList[i].split('-')[0]).get();
                                            if (docSnapshot.exists) {
                                              Map<String, dynamic>? data = docSnapshot.data();
                                              // String value = data?['unit_qtity'];
                                              FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops')
                                                  .doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodList[i].split('-')[0])
                                                  .update({changeUnitName2Stock(prodList[i].split('-')[5]): FieldValue.increment(0 - double.parse(refNum.toString()))
                                              })
                                                  .then((value) =>
                                                  print("User Updated"))
                                                  .catchError((error) => print(
                                                  "Failed to update user: $error"));
                                            }
                                          }
                                        }

                                        double debt = double.parse(widget.data.split('^')[5]);
                                        String refundAmount = 'FALSE';

                                        if(total <= double.parse(widget.data.split('^')[5])) {
                                          debt = total;
                                        }

                                        String isRef = 'p';
                                        for (int i = 0; i < prodListView.length; i++) {
                                          if (prodListView[i].split('-')[7] != '0' && prodListView[i].split('-')[7] == prodListView[i].split('-')[3]) {
                                            isRef = 'r';
                                            refundAmount = 'TRUE';
                                          }
                                          if (prodListView[i].split('-')[7] != '0' && prodListView[i].split('-')[7] != prodListView[i].split('-')[3]) {
                                            isRef = 's';
                                            refundAmount = 'PART';
                                          }
                                        }

                                        String data = widget.data;

                                        String dataRm = data.split('^')[0] +
                                            '^' +
                                            data.split('^')[1] +
                                            '^' +
                                            data.split('^')[2] +
                                            '^' +
                                            data.split('^')[3].split('&')[1] +
                                            '^' +
                                            data.split('^')[4] + '^' + data.split('^')[5] + '^' + data.split('^')[6];

                                        data = data.split('^')[0] +
                                            '^' +
                                            data.split('^')[1] +
                                            '^' +
                                            total.toString() +
                                            '^' +
                                            data
                                                .split('^')[3]
                                                .split('&')[1] +
                                            '^' +
                                            isRef +
                                            data.split('^')[4][1] + '^' + debt.toString() + '^' + data.split('^')[6];




                                        print('result___ ' + data + dataRm);

                                        FirebaseFirestore.instance
                                            .collection('space')
                                            .doc('0NHIS0Jbn26wsgCzVBKT')
                                            .collection('shops')
                                            .doc('PucvhZDuUz3XlkTgzcjb')
                                            .collection('buyOrders')
                                            .doc(docId)
                                            .update({
                                          'daily_order':
                                          FieldValue.arrayRemove([dataRm])
                                        }).then((value) {
                                          print('array removed');

                                          FirebaseFirestore.instance
                                              .collection('space')
                                              .doc('0NHIS0Jbn26wsgCzVBKT')
                                              .collection('shops')
                                              .doc('PucvhZDuUz3XlkTgzcjb')
                                              .collection('buyOrders')
                                              .doc(docId)
                                              .update({
                                            'daily_order':
                                            FieldValue.arrayUnion([data])
                                          }).then((value) {
                                            print('array updated');

                                            FirebaseFirestore.instance
                                                .collection('space')
                                                .doc('0NHIS0Jbn26wsgCzVBKT')
                                                .collection('shops')
                                                .doc('PucvhZDuUz3XlkTgzcjb')
                                                .collection('buyOrders')
                                                .doc(docId)
                                                .collection('expansion')
                                                .doc(data.split('^')[0])
                                                .update({
                                              'subs': prodList,
                                              'total': total.toString(),
                                              'refund' : refundAmount,
                                              'debt' : debt,
                                            }).then((value) =>
                                                print('subs updated'));

                                            if(widget.data.split('^')[3].split('&')[1].toString() != 'name') {
                                              FirebaseFirestore.instance
                                                  .collection('space')
                                                  .doc('0NHIS0Jbn26wsgCzVBKT')
                                                  .collection('shops')
                                                  .doc('PucvhZDuUz3XlkTgzcjb')
                                                  .collection('merchants')
                                                  .doc(widget.data
                                                  .split('^')[3]
                                                  .split('&')[1])
                                                  .collection('buyOrders')
                                                  .doc(data.split('^')[0])
                                                  .update({
                                                'refund': refundAmount,
                                                'debt' : debt,
                                                'total' : total.toString(),
                                              }).then((value) =>
                                                  print('subs updated'));
                                            }

                                            Navigator.pop(context, data);
                                          });
                                        });





                                        // // FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId).collection('detail')
                                        // // .doc(item.split('^')[0])
                                        // //
                                        // //     .update({
                                        // //   'daily_order': FieldValue.arrayUnion([item.split('^')[0]+'^'+item.split('^')[1]+'^total^name^fp'])
                                        // // })
                                        // //     .then((value) {
                                        // //   print('array updated');
                                        // // });
                                        // // 2021081601575511001^1-1001^total^name^pf
                                        //
                                        // });
                                        // });
                                        // });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 2.0),
                                        child: Container(
                                          child: Text(
                                            'Refund',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // orderLoading?Text('Loading'):Text('')
                              ],
                            ),
                          );
                        }

                        return Container();
                      })

                // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                //     stream: FirebaseFirestore.instance
                //         .collection('space')
                //         .doc('0NHIS0Jbn26wsgCzVBKT')
                //         .collection('shops')
                //         .doc('PucvhZDuUz3XlkTgzcjb')
                //         .collection('products')
                //         .doc(widget.idString)
                //         .snapshots(),
                //     builder: (BuildContext context,snapshot2) {
                //       if (snapshot2.hasData) {
                //         var output1 = snapshot2.data!.data();
                //         var mainUnit = output1 ? ['unit_name'];
                //         var sub1Unit = output1 ? ['sub1_name'];
                //         var sub2Unit = output1 ? ['sub2_name'];
                //         var sub3Unit = output1 ? ['sub3_name'];
                //         return Column(
                //           crossAxisAlignment: CrossAxisAlignment.stretch,
                //           children: [
                //             Container(
                //               height: 70,
                //               decoration: BoxDecoration(
                //                   border: Border(
                //                       bottom: BorderSide(
                //                           color: Colors.grey.withOpacity(0.3), width: 1.0))),
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   Container(
                //                     width: 35,
                //                     height: 35,
                //                     decoration: BoxDecoration(
                //                         borderRadius: BorderRadius.all(
                //                           Radius.circular(5.0),
                //                         ),
                //                         color: Colors.grey.withOpacity(0.3)),
                //                     child: IconButton(
                //                         icon: Icon(
                //                           Icons.arrow_back_ios_rounded,
                //                           size: 16,
                //                           color: Colors.black,
                //                         ),
                //                         onPressed: () {
                //                           Navigator.pop(context);
                //                         }),
                //                   ),
                //                   Text(
                //                     'Version Details',
                //                     style: TextStyle(
                //                       fontSize: 20,
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //                   ),
                //                   Container(
                //                     width: 35,
                //                     height: 35,
                //                     decoration: BoxDecoration(
                //                         borderRadius: BorderRadius.all(
                //                           Radius.circular(5.0),
                //                         ),
                //                         color: AppTheme.skThemeColor2),
                //                     child: IconButton(
                //                         icon: Icon(
                //                           Icons.check,
                //                           size: 20,
                //                           color: Colors.white,
                //                         ),
                //                         onPressed: () {
                //                           Navigator.pop(context);
                //                         }),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             SizedBox(height: 20,),
                //             Padding(
                //               padding: const EdgeInsets.only(right: 120.0),
                //               child: ButtonTheme(
                //                 //minWidth: 50,
                //                 splashColor: Colors.transparent,
                //                 height: 120,
                //                 child: FlatButton(
                //                   color: AppTheme.skThemeColor,
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(7.0),
                //                     side: BorderSide(
                //                       color: AppTheme.skThemeColor,
                //                     ),
                //                   ),
                //                   onPressed: () async {
                //                     final result = await showModalActionSheet<String>(
                //                       context: context,
                //                       actions: [
                //                         SheetAction(
                //                           icon: Icons.info,
                //                           label: '1 ' + mainUnit,
                //                           key: widget.idString + '-' + widget.versionID + '-' + mainPrice + '-unit_name-1',
                //                         ),
                //                         if(sub1Unit!='')
                //                           SheetAction(
                //                             icon: Icons.info,
                //                             label: '1 ' + sub1Unit,
                //                             key: widget.idString + '-' + widget.versionID + '-' + sub1Price + '-sub1_name-1',
                //                           ),
                //                         if(sub2Unit!='')
                //                           SheetAction(
                //                             icon: Icons.info,
                //                             label: '1 ' + sub2Unit,
                //                             key: widget.idString + '-' + widget.versionID + '-' + sub2Price + '-sub2_name-1',
                //                           ),
                //                         if(sub3Unit!='')
                //                           SheetAction(
                //                             icon: Icons.info,
                //                             label: '1 ' + sub3Unit,
                //                             key: widget.idString + '-' + widget.versionID + '-' + sub3Price + '-sub3_name-1',
                //                           ),
                //                       ],
                //                     );
                //                     widget._callback(result.toString());
                //                   },
                //                   child: Padding(
                //                     padding: const EdgeInsets.only(right: 120.0),
                //                     child: Column(
                //                       crossAxisAlignment: CrossAxisAlignment.start,
                //                       children: [
                //                         Icon(
                //                           Icons.add,
                //                           size: 40,
                //                         ),
                //                         SizedBox(
                //                           height: 20,
                //                         ),
                //                         Text(
                //                           'Add to cart',
                //                           style: TextStyle(
                //                             fontWeight: FontWeight.bold,
                //                             fontSize: 18,
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             Container(
                //               alignment: Alignment.topRight,
                //               child: TextButton(
                //                 onPressed: () {
                //                 },
                //                 child: Text('Edit',
                //                   style: TextStyle(
                //                     fontWeight: FontWeight.bold,
                //                     fontSize: 16,
                //                   ),),
                //               ),
                //             ),
                //             Expanded(
                //               child: Container(
                //                 child: ListView(
                //                     children: [
                //                       Container(
                //                         // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
                //                         width: double.infinity,
                //                         decoration: BoxDecoration(
                //                           borderRadius: BorderRadius.only(
                //                             topLeft: Radius.circular(15.0),
                //                             topRight: Radius.circular(15.0),
                //                           ),
                //                           color: Colors.white,
                //                         ),
                //                         child: Column(
                //                             children: [
                //                               Container(
                //                                 alignment: Alignment.topLeft,
                //                                 child: Text(
                //                                   "MERCHANT",
                //                                   style: TextStyle(
                //                                     fontWeight: FontWeight.bold,
                //                                     fontSize: 16,
                //                                     letterSpacing: 2,
                //                                     color: Colors.grey,
                //                                   ),
                //                                 ),
                //                               ),
                //                               SizedBox(
                //                                 height: 20,
                //                               ),
                //                               Column(
                //                                 crossAxisAlignment: CrossAxisAlignment.start,
                //                                 children: [
                //                                   _productDetails('Merchant Name'),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                     width: MediaQuery.of(context).size.width,
                //                                     child: Text(
                //                                       quantity,
                //                                       style: TextStyle(
                //                                         fontSize: 15,
                //                                         //fontWeight: FontWeight.w500,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                       width: MediaQuery.of(context).size.width,
                //                                       height: 1.5,
                //                                       color: Colors.grey.withOpacity(0.3)
                //                                   ),
                //                                 ],
                //                               ),
                //                               SizedBox(
                //                                 height: 20,
                //                               ),
                //                               Container(
                //                                 alignment: Alignment.topLeft,
                //                                 child: Text(
                //                                   "QUANTITY",
                //                                   style: TextStyle(
                //                                     fontWeight: FontWeight.bold,
                //                                     fontSize: 16,
                //                                     letterSpacing: 2,
                //                                     color: Colors.grey,
                //                                   ),
                //                                 ),
                //                               ),
                //                               SizedBox(
                //                                 height: 20,
                //                               ),
                //                               Column(
                //                                 crossAxisAlignment: CrossAxisAlignment.start,
                //                                 children: [
                //                                   _productDetails('Main Unit Quantity'),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                     width: MediaQuery.of(context).size.width,
                //                                     child: Text(
                //                                       '$quantity $mainUnit',
                //                                       style: TextStyle(
                //                                         fontSize: 15,
                //                                         //fontWeight: FontWeight.w500,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                       width: MediaQuery.of(context).size.width,
                //                                       height: 1.5,
                //                                       color: Colors.grey.withOpacity(0.3)
                //                                   ),
                //                                 ],
                //                               ),
                //                               SizedBox(
                //                                 height: 20,
                //                               ),
                //                               sub1quantity != "" ? Column(
                //                                 crossAxisAlignment: CrossAxisAlignment.start,
                //                                 children: [
                //                                   _productDetails('#1 Sub Unit Quantity'),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                     width: MediaQuery.of(context).size.width,
                //                                     child: Text(
                //                                       '$sub1quantity $sub1Unit',
                //                                       style: TextStyle(
                //                                         fontSize: 15,
                //                                         //fontWeight: FontWeight.w500,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                       width: MediaQuery.of(context).size.width,
                //                                       height: 1.5,
                //                                       color: Colors.grey.withOpacity(0.3)
                //                                   ),
                //                                   SizedBox(height: 20,),
                //                                 ],
                //                               ) : Container(),
                //                               sub2quantity != "" ? Column(
                //                                 crossAxisAlignment: CrossAxisAlignment.start,
                //                                 children: [
                //                                   _productDetails('#2 Sub Unit Quantity'),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                     width: MediaQuery.of(context).size.width,
                //                                     child: Text(
                //                                       '$sub2quantity $sub2Unit',
                //                                       style: TextStyle(
                //                                         fontSize: 15,
                //                                         //fontWeight: FontWeight.w500,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                       width: MediaQuery.of(context).size.width,
                //                                       height: 1.5,
                //                                       color: Colors.grey.withOpacity(0.3)
                //                                   ),
                //                                   SizedBox(height: 20,),
                //                                 ],
                //                               ): Container(),
                //                               sub3quantity != "" ? Column(
                //                                 crossAxisAlignment: CrossAxisAlignment.start,
                //                                 children: [
                //                                   _productDetails('#3 Sub Unit Quantity'),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                     width: MediaQuery.of(context).size.width,
                //                                     child: Text(
                //                                       '$sub3quantity $sub3Unit',
                //                                       style: TextStyle(
                //                                         fontSize: 15,
                //                                         //fontWeight: FontWeight.w500,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                       width: MediaQuery.of(context).size.width,
                //                                       height: 1.5,
                //                                       color: Colors.grey.withOpacity(0.3)
                //                                   ),
                //                                   SizedBox(height: 20,),
                //                                 ],
                //                               ): Container(),
                //                               Container(
                //                                 alignment: Alignment.topLeft,
                //                                 child: Text(
                //                                   "PRICING",
                //                                   style: TextStyle(
                //                                     fontWeight: FontWeight.bold,
                //                                     fontSize: 16,
                //                                     letterSpacing: 2,
                //                                     color: Colors.grey,
                //                                   ),
                //                                 ),
                //                               ),
                //                               SizedBox(
                //                                 height: 25,
                //                               ),
                //                               Column(
                //                                 crossAxisAlignment: CrossAxisAlignment.start,
                //                                 children: [
                //                                   _productDetails('Main Unit Price'),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                     width: MediaQuery.of(context).size.width,
                //                                     child: Text(
                //                                       '$mainPrice MMK',
                //                                       style: TextStyle(
                //                                         fontSize: 15,
                //                                         //fontWeight: FontWeight.w500,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                       width: MediaQuery.of(context).size.width,
                //                                       height: 1.5,
                //                                       color: Colors.grey.withOpacity(0.3)
                //                                   ),
                //                                 ],
                //                               ),
                //                               SizedBox(
                //                                 height: 25,
                //                               ),
                //
                //                               sub1Price != "" ?  Column(
                //                                 crossAxisAlignment: CrossAxisAlignment.start,
                //                                 children: [
                //                                   _productDetails('#1 Sub Unit Price'),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                     width: MediaQuery.of(context).size.width,
                //                                     child: Text(
                //                                       '$sub1Price MMK',
                //                                       style: TextStyle(
                //                                         fontSize: 15,
                //                                         //fontWeight: FontWeight.w500,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                       width: MediaQuery.of(context).size.width,
                //                                       height: 1.5,
                //                                       color: Colors.grey.withOpacity(0.3)
                //                                   ),
                //                                   SizedBox(height: 20,),
                //                                 ],
                //                               ) : Container(),
                //                               sub2Price != "" ?  Column(
                //                                 crossAxisAlignment: CrossAxisAlignment.start,
                //                                 children: [
                //                                   _productDetails('#2 Sub Unit Price'),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                     width: MediaQuery.of(context).size.width,
                //                                     child: Text(
                //                                       '$sub2Price MMK',
                //                                       style: TextStyle(
                //                                         fontSize: 15,
                //                                         //fontWeight: FontWeight.w500,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                       width: MediaQuery.of(context).size.width,
                //                                       height: 1.5,
                //                                       color: Colors.grey.withOpacity(0.3)
                //                                   ),
                //                                   SizedBox(height: 20,),
                //                                 ],
                //                               ) : Container(),
                //                               sub3Price != "" ?  Column(
                //                                 crossAxisAlignment: CrossAxisAlignment.start,
                //                                 children: [
                //                                   _productDetails('#3 Sub Unit Price'),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                     width: MediaQuery.of(context).size.width,
                //                                     child: Text(
                //                                       '$sub3Price MMK',
                //                                       style: TextStyle(
                //                                         fontSize: 15,
                //                                         //fontWeight: FontWeight.w500,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                   SizedBox(height:15),
                //                                   Container(
                //                                       width: MediaQuery.of(context).size.width,
                //                                       height: 1.5,
                //                                       color: Colors.grey.withOpacity(0.3)
                //                                   ),
                //                                   SizedBox(height: 20,),
                //                                 ],
                //                               ) : Container(),
                //                             ]
                //                         ),
                //                       ),
                //                     ]
                //                 ),
                //               ),
                //             )
                //           ],
                //         );
                //       }
                //       return Container();
                //     }
                // )
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
                                          Navigator.pop(context, changedPrice);
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
  zeroToTen(String string) {
    if (int.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
  }

  totalItems() {
    int totalItems = 0;
    for(int i=0; i<refundItems.length; i++) {
      totalItems += refundItems[i];
    }
    return totalItems;
  }

  totalRefund() {
    double totalM = 0.0;
    double debtM = 0.0;
    double refundAmount = 0.0;
    totalM = double.parse(widget.data.split('^')[2]) - totalPriceView();
    debtM = double.parse(widget.data.split('^')[2]) -  double.parse(widget.data.split('^')[5]);
    if(debtM > totalM) {
      refundAmount = debtM - totalM;
    } else refundAmount = 0.0;
    return refundAmount;
  }

  totalPriceView() {
    double totalPrice = 0.0;
    for(int i=0; i<refundItems.length; i++) {
      totalPrice += refundItems[i] * double.parse(prodListView[i].split('-')[4]);
    }

    // widget.data.split('^')[6].split('-')[1] == 'p' ?
    if(widget.data.split('^')[6] != '0.0') {
      if(widget.data.split('^')[6].split('-')[1] == 'p') {
        totalPrice = totalPrice - (totalPrice * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100));
      } else {
        totalPrice = totalPrice - (totalPrice * (double.parse(widget.data.split('^')[6].split('-')[0])/widget.realPrice));
      }
    }

    return totalPrice;
  }

  changeUnitName2Stock(String split) {
    if(split == 'unit_name') {
      return 'inStock1';
    } else {
      return 'inStock' + (int.parse(split[3]) + 1).toString();
    }
  }

}
