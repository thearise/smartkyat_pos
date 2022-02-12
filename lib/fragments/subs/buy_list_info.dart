import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:blue_print_pos/models/blue_device.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/fragments/subs/buy_list_refund2.dart';
import 'package:smartkyat_pos/widgets/pay_debt_buylist.dart';
import 'package:smartkyat_pos/widgets/pay_debt_items.dart';
import 'package:intl/intl.dart';
import 'package:smartkyat_pos/widgets/print_receipt_route.dart';
import '../../app_theme.dart';
import 'order_refund_sub2.dart';
import 'package:dotted_line/dotted_line.dart';

class BuyListInfo extends StatefulWidget {
  final _callback;
  final _openCartBtn;
  final _closeCartBtn;
  final _printFromOrders;
  const BuyListInfo(
      {Key? key, this.selectedDev, required void printFromOrders(File file, var prodListPR), required void openCartBtn(), required void closeCartBtn(), required this.data, required this.shopId,required void toggleCoinCallback()})
      : _callback = toggleCoinCallback, _openCartBtn = openCartBtn, _closeCartBtn = closeCartBtn, _printFromOrders = printFromOrders;
  final String data;
  final String shopId;
  final BlueDevice? selectedDev;

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

  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  bool _connectionStatus = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            setState(() {
              _connectionStatus = true;
            });
          }
        } on SocketException catch (_) {
          setState(() {
            _connectionStatus = false;
          });
        }
        break;
      default:
        setState(() {
          // _connectionStatus = 'Failed to get connectivity.')
          _connectionStatus = false;
        });
        break;
    }
  }

  void printFromOrdersFun(File file, var prodListPR) {
    widget._printFromOrders(file, prodListPR);
  }

  String currencyUnit = 'MMK';

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }

  String textSetPurchase = 'PURCHASED ITEMS';
  String textSetRefund = 'REFUNDED ITEMS';
  String textSetDebt = 'Debt Amount';
  String textSetDiscount = 'Discount';
  String textSetAmount = 'Amount applied';
  String textSetRefBtn = 'Refund items';
  String textSetPayCashBtn = 'Pay cash remains';
  String textSetPrint = 'Print receipt';
  String textSetPercent = 'Percentage';
  String textSetAllRefund = 'All Items Refunded';
  String textSetFullyRef = 'FULLY REFUNDED';

  @override
  initState() {

    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetPurchase = 'PURCHASED ITEMS';
          textSetRefund = 'REFUNDED ITEMS';
          textSetDebt = 'Debt Amount';
          textSetDiscount = 'Discount';
          textSetAmount = 'Amount applied';
          textSetRefBtn = 'Refund items';
          textSetPayCashBtn = 'Pay cash remains';
          textSetPrint = 'Print receipt';
          textSetPercent = 'Percentage';
          textSetAllRefund = 'All Items Refunded';
          textSetFullyRef = 'FULLY REFUNDED';
        });
      } else if(value=='english') {
        setState(() {
           textSetPurchase = 'PURCHASED ITEMS';
           textSetRefund = 'REFUNDED ITEMS';
           textSetDebt = 'Debt Amount';
           textSetDiscount = 'Discount';
           textSetAmount = 'Amount applied';
           textSetRefBtn = 'Refund\nitems';
           textSetPayCashBtn = 'Pay cash\nremains';
           textSetPrint = 'Print\nreceipt';
           textSetPercent = 'Percentage';
           textSetAllRefund = 'All Items Refunded';
           textSetFullyRef = 'FULLY REFUNDED';
        });
      }
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
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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
    // FirebaseFirestore.instance
    //     .collection('shops')
    //     .doc(widget.shopId)
    //     .collection('buyOrder')
    //     .where('deviceId', isEqualTo: result.split('^')[0].split('-')[0] + '-')
    //     .where('orderId', isEqualTo: result.split('^')[0].split('-')[1])
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     innerId = doc.id;
    //   });
    //   setState(() {
    //     docId = innerId;
    //   });
    docId = (widget.data.split('^')[1].split('-')[0] + widget.data.split('^')[1].split('-')[1]).toString();
    print('DOC ID ' + docId.toString());
    // return docId;
    // return Container();
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  List prodListPrint = [];
  double ttlQ = 0;
  double ttlR = 0;
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
    }
    else if(type == 'w') {
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
    }
    else if(type == 'e') {
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
    }
    else if(type == 'i') {
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

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
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
                                  Text('$currencyUnit ' + (double.parse(result.split('^')[2]).toStringAsFixed(2)).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),),

                                  Text('#' + widget.data.split('^')[1] +' - ' + widget.data.split('^')[3].split('&')[0],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

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
                          if(output1?['subs'] == null) {
                            //smartKyatFlash('Internet connection is required to take this action.', 'w');
                            return Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                      child: CupertinoActivityIndicator(radius: 15,)),
                                ),
                              ),
                            );
                          }
                          List prodList = output1?['subs'];
                          var debt = output1?['debt'];
                          var documentId = output1?['documentId'];
                          List prodListView = [];
                          prodListView.add(prodList[0]);
                          totalPrice = 0;
                          totalRealPrice = 0;
                          print(totalPrice.toString() +
                              'totalPrice ' +
                              prodList.toString());

                          for (int j=0;j< prodList.length; j++) {
                            totalPrice += double.parse(prodList[j].split('-')[4]) * (double.parse(prodList[j].split('-')[3]) - double.parse(prodList[j].split('-')[7]));
                          }
                          for (int j=0;j< prodList.length; j++) {
                            totalRealPrice += double.parse(prodList[j].split('-')[4]) * double.parse(prodList[j].split('-')[3]);
                          }

                          if(widget.data.split('^')[6] != '0.0') {
                            if(widget.data.split('^')[6].split('-')[1] == 'p') {
                              totalPrice = totalPrice - (totalPrice * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100));
                            } else {
                              totalPrice = totalPrice - (totalPrice * (double.parse(widget.data.split('^')[6].split('-')[0])/totalRealPrice));
                            }
                          }

                          double ttlQtity = double.parse(prodList[0].split('-')[3]);
                          double ttlRefun = double.parse(prodList[0].split('-')[3]);
                          for (int j=1;j< prodList.length; j++) {

                            int k = prodListView.length-1;
                            if(prodList[j].split('-')[0] == prodListView[k].split('-')[0] && prodList[j].split('-')[5] == prodListView[k].split('-')[5]) {
                              ttlQtity += double.parse(prodList[j].split('-')[3]);
                              ttlRefun += int.parse(prodList[j].split('-')[7]);
                              prodListView[k] = prodListView[k].split('-')[0] + '-' + prodListView[k].split('-')[1] + '-' + prodListView[k].split('-')[2] + '-' + ttlQtity.toString() + '-' +
                                  prodListView[k].split('-')[4] + '-' + prodListView[k].split('-')[5] + '-' + prodListView[k].split('-')[6] + '-' + (int.parse(prodListView[k].split('-')[7])+int.parse(prodList[j].split('-')[7])).toString() + '-' +
                                  prodListView[k].split('-')[8] ;
                            } else {
                              prodListView.add(prodList[j]);
                              ttlQtity = double.parse(prodList[j].split('-')[3]);
                              ttlRefun += double.parse(prodList[j].split('-')[7]);
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

                          for (int i = 0; i < prodListView.length; i++) {
                            ttlR += double.parse(prodListView[i].split('-')[7]);
                            ttlQ += double.parse(prodListView[i].split('-')[3]);
                          }

                          return Expanded(
                            // height: 580,
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _connectionStatus ? Container(
                                        height: 100,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            SizedBox(width: 15),
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

                                                  widget._closeCartBtn();

                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            BuyListRefund(
                                                              data: result,
                                                              data2: prodList,
                                                              realPrice: totalRealPrice,
                                                              toggleCoinCallback:
                                                                  () {}, shopId: widget.shopId, docId: docId.toString(), documentId: documentId.toString(),),
                                                      ));
                                                  widget._openCartBtn();
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
                                                          textSetRefBtn,
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
                                            debt.toString() != '0.0' ? ButtonTheme(
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
                                                  widget._closeCartBtn();
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => PayDebtBuyList(debt: debt.toString(), data: widget.data, docId: docId, shopId: widget.shopId, documentId: documentId.toString(),))
                                                  );
                                                  widget._openCartBtn();
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 10.0),
                                                          child: Icon(
                                                            SmartKyat_POS.pay,
                                                            size: 22,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 6),
                                                          child: Container(
                                                            child: Text(
                                                              textSetPayCashBtn,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ) : Container(),
                                            debt.toString() != '0.0' ? SizedBox(width: 12) : Container(),
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

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => PrintReceiptRoute(printFromOrders: printFromOrdersFun, data: result, prodList: prodListPrint, shopId: widget.shopId, currency: currencyUnit,))
                                                  );

                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 10.0),
                                                          child: Icon(
                                                            Icons.print_rounded,
                                                            size: 23,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 6),
                                                          child: Container(
                                                            child: Text(
                                                             textSetPrint,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 16,
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
                                            SizedBox(width: 15),
                                          ],
                                        ),
                                      ) :
                                      Container(
                                        height: 100,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            SizedBox(width: 15),
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
                                                onPressed: () {
                                                  smartKyatFlash('Internet connection is required to take this action.', 'w');
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
                                                          textSetRefBtn,
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
                                            debt.toString() != '0.0' ? ButtonTheme(
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
                                                onPressed: () {
                                                  smartKyatFlash('Check your internet connection and try again.', 'w');
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 10.0),
                                                          child: Icon(
                                                            SmartKyat_POS.pay,
                                                            size: 22,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 6),
                                                          child: Container(
                                                            child: Text(
                                                              textSetPayCashBtn,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ) : Container(),
                                            debt.toString() != '0.0' ? SizedBox(width: 12) : Container(),
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

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => PrintReceiptRoute(printFromOrders: printFromOrdersFun, data: result, prodList: prodListPrint, shopId: widget.shopId, currency: currencyUnit,))
                                                  );
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 10.0),
                                                          child: Icon(
                                                            Icons.print_rounded,
                                                            size: 23,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 6),
                                                          child: Container(
                                                            child: Text(
                                                              textSetPrint,
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 16,
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
                                            SizedBox(width: 15),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      (ttlQ - ttlR).round().toString() != '0' ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Text(textSetPurchase, style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 2,
                                          color: Colors.grey,
                                        ),),
                                      ):  ((widget.data.split('^')[6]) != '0.0') || ((widget.data.split('^')[5]) != '0.0') ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Text(textSetFullyRef, style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          letterSpacing: 2,
                                          color: Colors.grey,
                                        ),),
                                      ): Container(),
                                    ],
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
                                        print('image htwet ' + prodListView[i].toString());
                                        if(i == 0) {
                                          prodListPrint = [];
                                          prodListPrint.add(
                                              output2?['prod_name'] + '^' +
                                                  output2?[prodListView[i].split('-')[5]] + '^' +
                                                  prodListView[i].split('-')[4] + '^' + (double.parse(prodListView[i].split('-')[3]) - double.parse(prodListView[i].split('-')[7])).toString() + '^'
                                          );
                                        } else {
                                          prodListPrint.add(
                                              output2?['prod_name'] + '^' +
                                                  output2?[prodListView[i].split('-')[5]] + '^' +
                                                  prodListView[i].split('-')[4] + '^' +
                                                  (double.parse(prodListView[i].split('-')[3]) - double.parse(prodListView[i].split('-')[7])).toString() + '^'
                                          );
                                        }
                                        return  (double.parse(prodListView[i].split('-')[3]) - double.parse(prodListView[i].split('-')[7])).round().toString() != '0' ? Stack(
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
                                                      child: image != "" || image != null
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
                                                          fontWeight: FontWeight.w500, fontSize: 16, height: 0.9),
                                                    ),
                                                    subtitle: Padding(
                                                      padding: const EdgeInsets.only(top: 4.0),
                                                      child: Row(
                                                        children: [
                                                          Text(output2?[prodListView[i].split('-')[5]] + ' ', style: TextStyle(
                                                              fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey, height: 0.9
                                                          )),
                                                          if (prodListView[i].split('-')[5] == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
                                                          else if(prodListView[i].split('-')[5] == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
                                                          else Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
                                                        ],
                                                      ),
                                                    ),
                                                    trailing: Text('$currencyUnit ' + (double.parse(prodListView[i].split('-')[4]) * (double.parse(prodListView[i].split('-')[3]) - double.parse(prodListView[i].split('-')[7]))).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                                                            BorderSide(color: i == prodListView.length - 1 ? Colors.transparent: AppTheme.skBorderColor2, width: 0.5),
                                                          )),),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top : 11,
                                              right: MediaQuery.of(context).size.width - 80,
                                              child: Container(
                                                // height: 20,
                                                // width: 30,
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
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 8.5, right: 8.5, top: 1, bottom: 1),
                                                  child: Text((double.parse(prodListView[i].split('-')[3]) - double.parse(prodListView[i].split('-')[7])).round().toString(), style: TextStyle(
                                                      fontSize: 11, fontWeight: FontWeight.w500
                                                  )),
                                                ),
                                              ),
                                            ),
                                            // Positioned(
                                            //   top : 8,
                                            //   left : 50,
                                            //   child: Container(
                                            //     height: 20,
                                            //     width: 30,
                                            //     alignment: Alignment.center,
                                            //     decoration: BoxDecoration(
                                            //         color: AppTheme.skBorderColor2,
                                            //         borderRadius:
                                            //         BorderRadius.circular(
                                            //             10.0),
                                            //         border: Border.all(
                                            //           color: Colors.white,
                                            //           width: 2,
                                            //         )),
                                            //     child: Text((int.parse(prodListView[i].split('-')[3]) - int.parse(prodListView[i].split('-')[7])).toString(), style: TextStyle(
                                            //       fontSize: 11, fontWeight: FontWeight.w500,
                                            //     )),
                                            //   ),
                                            // ),
                                          ],
                                        )
                                            : Container();
                                      }
                                      return Container();
                                    },
                                  ),
                                Container(
                                  // color: Colors.blue,
                                  child: Column(
                                    children: [
                                      // ListTile (
                                      //   title: Text('Sub Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //   // subtitle: Text('Amount applied', style: TextStyle(
                                      //   //   fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                      //   // )),
                                      //   trailing: Text('$currencyUnit ' + totalRealPrice.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      // ),
                                      // if ((widget.data.split('^')[6]) != '0.0') Container(
                                      //   child: (widget.data.split('^')[6]).split('-')[1] == 'p' ?
                                      //   ListTile(
                                      //     title: Text('SubTotal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //
                                      //     trailing: Text('$currencyUnit ' + (double.parse(widget.data.split('^')[2]) + (totalRealPrice * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100))).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //
                                      //   ) :  ListTile (
                                      //     title: Text('Sub Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //
                                      //     trailing: Text('$currencyUnit ' + (double.parse(widget.data.split('^')[2]) + double.parse(widget.data.split('^')[6].split('-')[0])).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //   ),
                                      // ) else ListTile (
                                      //   title: Text('Sub Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //   trailing: Text('$currencyUnit ' + (widget.data.split('^')[2]).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      // ),
                                      (ttlQ - ttlR).round().toString() == '0' ?
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                        ),
                                      ): (ttlQ - ttlR).round().toString() == '0' && widget.data.split('^')[6] != '0.0'?
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Container(
                                        ),
                                      ):
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: Container(height: 1,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                top:
                                                BorderSide(color: AppTheme.skBorderColor2, width: 0.5),
                                              )),
                                        ),
                                      ),
                                      if ((widget.data.split('^')[6]) != '0.0') Container(
                                        child: (widget.data.split('^')[6]).split('-')[1] == 'p' ?
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                                          child: ListTile(
                                            title: Text(textSetDiscount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                            subtitle: Text('$textSetPercent (' +  (widget.data.split('^')[6]).split('-')[0] + '%)', style: TextStyle(
                                              fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                            )),
                                            trailing: Text('- $currencyUnit ' + (totalRealPrice * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100)).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                            // trailing: Text('- $currencyUnit ' + (int.parse(prodListView[i].split('-')[4]) * (int.parse(prodListView[i].split('-')[3]) - int.parse(prodListView[i].split('-')[7]))).toString()),
                                            //trailing: Text('- $currencyUnit ' + (int.parse(TtlProdListPriceInit()) - int.parse((widget.data.split('^')[2]))).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

                                          ),
                                        ) :  Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                                          child: ListTile (
                                            title: Text(textSetDiscount, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                            subtitle: Text(textSetAmount, style: TextStyle(
                                              fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                            )),
                                            trailing: Text('- $currencyUnit ' + (widget.data.split('^')[6]).split('-')[0], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                          ),
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
                                      //   trailing: Text('$currencyUnit ' + (widget.data.split('^')[2]).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      // ),
                                      // ListTile (
                                      //   title: Text('Paid', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      //   // subtitle: Text('Amount applied', style: TextStyle(
                                      //   //   fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
                                      //   // )),
                                      //   trailing: Text('- $currencyUnit ' + (double.parse(widget.data.split('^')[2]) - double.parse(widget.data.split('^')[5])).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      // ),

                                      if ((widget.data.split('^')[5]) != '0.0')
                                        Container(
                                          // color: Colors.green,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                        top:
                                                        BorderSide(color: AppTheme.skBorderColor2, width: 0.5),
                                                      )),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 8.0, bottom: 11.0),
                                                    child: ListTile(
                                                      contentPadding: EdgeInsets.only(left: 0.0, right: 15),
                                                      title: Text(textSetDebt, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

                                                      trailing: Text('$currencyUnit ' + (widget.data.split('^')[5]).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) else Container(),

                                    ],
                                  ),
                                ),
                                if(ttlR.round().toString() != '0')
                                  Container(
                                    decoration: (ttlQ - ttlR).round().toString() != '0' ? BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: AppTheme.skBorderColor2, width: 0.5),
                                        )) : (ttlQ - ttlR).round().toString() == '0' && widget.data.split('^')[6] != '0.0'? BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: AppTheme.skBorderColor2, width: 0.5),
                                        )) : BoxDecoration(),
                                    child: Padding(
                                      padding: (ttlQ - ttlR).round().toString() != '0'? EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 0) : (ttlQ - ttlR).round().toString() == '0' && widget.data.split('^')[6] != '0.0'? EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 0): EdgeInsets.only(left: 15.0, right: 15.0, bottom: 0),
                                      child: Text(textSetRefund, style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        letterSpacing: 2,
                                        color: Colors.grey,
                                      ),),
                                    ),
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
                                          return double.parse(prodListView[i].split('-')[7]).round().toString() != '0' ? Stack(
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
                                                              : Image.asset('assets/system/default-product.png', height: 75, width: 75)),
                                                      title: Text(
                                                        output2?[
                                                          'prod_name'],
                                                        style:
                                                        TextStyle(
                                                            fontWeight: FontWeight.w500, fontSize: 16, height: 0.9),
                                                      ),
                                                      subtitle: Padding(
                                                        padding: const EdgeInsets.only(top: 4.0),
                                                        child: Row(
                                                          children: [
                                                            Text(output2?[prodListView[i].split('-')[5]] + ' ', style: TextStyle(
                                                                fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey, height: 0.9
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
                                                              BorderSide(color: i == prodListView.length - 1 ? Colors.transparent: AppTheme.skBorderColor2, width: 0.5),
                                                            )),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Positioned(
                                              //   top : 8,
                                              //   left : 50,
                                              //   child: Container(
                                              //     height: 20,
                                              //     width: 30,
                                              //     alignment: Alignment.center,
                                              //     decoration: BoxDecoration(
                                              //         color: AppTheme.skBorderColor2,
                                              //         borderRadius:
                                              //         BorderRadius.circular(
                                              //             10.0),
                                              //         border: Border.all(
                                              //           color: Colors.white,
                                              //           width: 2,
                                              //         )),
                                              //     child: Text(prodListView[i].split('-')[7].toString(), style: TextStyle(
                                              //       fontSize: 11, fontWeight: FontWeight.w500,
                                              //     )),
                                              //   ),
                                              // ),
                                              Positioned(
                                                top : 11,
                                                right: MediaQuery.of(context).size.width - 80,
                                                child: Container(
                                                  // height: 20,
                                                  // width: 30,
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
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 8.5, right: 8.5, top: 1, bottom: 1),
                                                    child: Text(double.parse(prodListView[i].split('-')[7]).round().toString(), style: TextStyle(
                                                        fontSize: 11, fontWeight: FontWeight.w500
                                                    )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                              : Container();
                                        }
                                        return Container();
                                      },
                                    )
                              ],
                            ),
                          );
                        }

                        return Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                  child: CupertinoActivityIndicator(radius: 15,)),
                            ),
                          ),
                        );
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
      Text((double.parse(prodList.split('-')[4]) - (double.parse(prodList.split('-')[4]) * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100))).toStringAsFixed(2) + ' $currencyUnit'):
      Text((double.parse(prodList.split('-')[4]) - (double.parse(prodList.split('-')[4]) * (double.parse(widget.data.split('^')[6].split('-')[0])/totalRealPrice))).toStringAsFixed(2) + ' $currencyUnit');
    } else {
      return Text(double.parse(prodList.split('-')[4]).toStringAsFixed(2));
    }

  }

  discTra(String str, String prodList) {
    if(str != '0.0') {
      return widget.data.split('^')[6].split('-')[1] == 'p' ?
      Text('$currencyUnit ' +((double.parse(prodList.split('-')[4]) * (double.parse(prodList.split('-')[7]))) - ((double.parse(prodList.split('-')[4]) * (double.parse(prodList.split('-')[7]))) * (double.parse(widget.data.split('^')[6].split('-')[0]) / 100))).toStringAsFixed(2).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),) :
      Text('$currencyUnit ' +((double.parse(prodList.split('-')[4]) * (double.parse(prodList.split('-')[7]))) - ((double.parse(prodList.split('-')[4]) * (double.parse(prodList.split('-')[7]))) * (double.parse(widget.data.split('^')[6].split('-')[0])/totalRealPrice))).toStringAsFixed(2).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),);
    } else {
      return Text('$currencyUnit ' +(double.parse(prodList.split('-')[4]) * double.parse(prodList.split('-')[7])).toStringAsFixed(2).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),);
    }

  }
}