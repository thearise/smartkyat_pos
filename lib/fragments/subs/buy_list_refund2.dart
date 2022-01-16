import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fraction/fraction.dart';
import 'package:intl/intl.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';

import '../../app_theme.dart';

class BuyListRefund extends StatefulWidget {
  final _callback;
  final _openCartBtn;
  const BuyListRefund(
      {Key? key, required void openCartBtn(), required this.documentId, required this.data, required this.docId, required this.shopId, required this.data2, required this.realPrice, required void toggleCoinCallback()})
      : _callback = toggleCoinCallback, _openCartBtn = openCartBtn;
  final String data;
  final List data2;
  final double realPrice;
  final String shopId;
  final String docId;
  final String documentId;

  @override
  _BuyListRefundState createState() => _BuyListRefundState();
}

class _BuyListRefundState extends State<BuyListRefund>
    with TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<BuyListRefund>{
  @override
  bool get wantKeepAlive => true;
  List<int> refundItems = [];
  List<int> deffItems = [];

  @override
  initState() {
    // var innerId = '';
    // FirebaseFirestore.instance
    //     .collection('shops')
    //     .doc(widget.shopId)
    //     .collection('buyOrders')
    //     .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.data.split('^')[0].substring(0, 4) + '-' + widget.data.split('^')[0].substring(4, 6) + '-' + widget.data.split('^')[0].substring(6, 8) + ' 00:00:00'))
    //     .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.data.split('^')[0].substring(0, 4) + '-' + widget.data.split('^')[0].substring(4, 6) + '-' + widget.data.split('^')[0].substring(6, 8) + ' 23:59:59'))
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     innerId = doc.id;
    //   });
    //   setState(() {
    //     documentId = innerId;
    //   });
    //   // return docId;
    //   // return Container();
    // });
    super.initState();
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
  @override
  void dispose() {
    widget._openCartBtn();
    super.dispose();
  }

  bool initAttempt = false;
  int changedPrice = 0;
  List<String> prodListView = [];
  bool disableTouch = false;
  bool loadingState = false;
  bool firstTime = true;
  double homeBotPadding = 0;
  @override
  Widget build(BuildContext context) {
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
                                          widget._openCartBtn();
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
                                        //color: Colors.grey,
                                      ),),

                                    StreamBuilder<
                                        DocumentSnapshot<
                                            Map<String, dynamic>>>(
                                        stream: FirebaseFirestore.instance
                                            .collection('shops')
                                            .doc(widget.shopId)
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
                                                fontWeight: FontWeight.w600,
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
                  if (widget.docId != null && widget.docId != '')
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('shops')
                            .doc(widget.shopId)
                            .collection('buyOrder')
                            .doc(widget.docId)
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
                                              .collection('shops')
                                              .doc(widget.shopId)
                                              .collection('products')
                                              .doc(prodListView[i].split('-')[0])
                                              .snapshots(),
                                          builder: (BuildContext context, snapshot10) {
                                            if (snapshot10.hasData) {
                                              var output2 = snapshot10.data!.data();
                                              var image = output2?['img_1'];
                                              return
                                                  Container(
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
                                                                        :  Image.asset('assets/system/default-product.png', height: 75, width: 75),),
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
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: homeBotPadding),
                                          child: Container(
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0, bottom: 15.0),
                                              child: ButtonTheme(
                                                minWidth: MediaQuery.of(context).size.width,
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
                                                    setState(() {
                                                      loadingState = true;
                                                      disableTouch = true;
                                                    });
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
                                                        var docSnapshot = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId)
                                                            .collection('products').doc(prodList[i].split('-')[0]).get();
                                                        if (docSnapshot.exists) {
                                                          Map<String, dynamic>? data = docSnapshot.data();
                                                          CollectionReference prods = await  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products');
                                                          prods.doc(prodList[i].split('-')[0])
                                                              .update({changeUnitName2Stock(prodList[i].split('-')[5]): FieldValue.increment(0 - double.parse(refNum.toString()))
                                                          })
                                                              .then((value) => print("User Updated"))
                                                              .catchError((error) => print("Failed to update user: $error"));
                                                        }
                                                      }
                                                    }

                                                    double debt = double.parse(widget.data.split('^')[5]);
                                                    String refundAmount = 'FALSE';

                                                    if(total <= double.parse(widget.data.split('^')[5])) {
                                                      debt = total;
                                                    }

                                                    String isRef = 'p';
                                                    for (int i = 0; i < prodList.length; i++) {
                                                      if (prodList[i].split('-')[7] != '0' && prodList[i].split('-')[7] == prodList[i].split('-')[3]) {
                                                        isRef = 'r';
                                                        refundAmount = 'TRUE';
                                                      }
                                                      if (prodList[i].split('-')[7] != '0' && prodList[i].split('-')[7] != prodList[i].split('-')[3]) {
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
                                                        refundAmount + '^' + debt.toString() + '^' + data.split('^')[6];

                                                    print('result___ ' + data + dataRm);

                                                    CollectionReference dOrder = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrder');
                                                    CollectionReference cusRefund = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('merchants');
                                                    CollectionReference dailyOrders = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrders');


                                                    dailyOrders.doc(widget.documentId).update({
                                                      'daily_order':
                                                      FieldValue.arrayRemove([dataRm])
                                                    }).then((value) {print('array removed');})
                                                        .catchError((error) => print("Failed to update user: $error"));

                                                    dailyOrders.doc(widget.documentId).update({
                                                      'daily_order':
                                                      FieldValue.arrayUnion([data])
                                                    }).then((value) { print('array updated');})
                                                        .catchError((error) => print("Failed to update user: $error"));

                                                    dOrder.doc(widget.docId).update({
                                                      'subs': prodList,
                                                      'total': total.toString(),
                                                      'refund' : refundAmount,
                                                      'debt' : debt,
                                                    }).then((value) { print('detail updated');})
                                                        .catchError((error) => print("Failed to update user: $error"));

                                                    int totalRefunds = 0;
                                                    double chgDebts = 0;
                                                    int ttlDebts = 0;
                                                    print('leesin ' +widget.data.split('^')[4].toString());


                                                    if (double.parse(widget.data.split('^')[5]) != debt) {
                                                      chgDebts = double.parse(widget.data.split('^')[5]) - debt;
                                                    } else {
                                                      chgDebts = 0;
                                                    }

                                                    if (double.parse(widget.data.split('^')[5]) != debt && debt == 0) {
                                                      ttlDebts = 1;
                                                    } else {
                                                      ttlDebts = 0;
                                                    }

                                                    if(widget.data.split('^')[4] == 'FALSE') {
                                                      totalRefunds = 1;
                                                    } else {
                                                      totalRefunds = 0;
                                                    }

                                                    if(widget.data.split('^')[3].split('&')[1] !='name') {
                                                      cusRefund.doc(widget.data.split('^')[3].split('&')[1]).update({
                                                        'total_refunds' : FieldValue.increment(double.parse(totalRefunds.toString())),
                                                        'debts' : FieldValue.increment(0 - double.parse(ttlDebts.toString())),
                                                        'debtAmount' : FieldValue.increment(0 - double.parse(chgDebts.toString())),
                                                      }).then((value) {
                                                        print('merchant updated');
                                                      }).catchError((error) => print("Failed to update user: $error"));
                                                    }

                                                      setState(() {
                                                        loadingState = false;
                                                        disableTouch = false;
                                                      });

                                                    widget._openCartBtn();

                                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                                    smartKyatFlash('MMK' + totalRefund().toString() + 'is successfully refunded to #' + widget.data.split('^')[1].toString(), 's');
                                                  },
                                                  child: loadingState == true ? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                      child: CupertinoActivityIndicator(radius: 10,)) : Padding(
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
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            );
                          }
                          return Container();
                        }
                        ),
                ]
            ),
        ),
      ),
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
