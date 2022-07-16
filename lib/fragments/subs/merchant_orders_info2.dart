import 'dart:io';

import 'package:blue_print_pos/models/blue_device.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/subs/buy_list_info.dart';
import 'package:smartkyat_pos/fragments/subs/order_info.dart';

import '../../app_theme.dart';


class MerchantOrdersInfoSubs extends StatefulWidget {
  final _openCartBtn;
  final _closeCartBtn;
  final _printFromOrders;
  const MerchantOrdersInfoSubs({Key? key,required this.isEnglish, required this.fromSearch, required this.merchName, required this.merchAddress, this.selectedDev, required void printFromOrders(File file, var prodListPR), required void openCartBtn(), required void closeCartBtn(), required this.id, required this.shopId}) : _openCartBtn = openCartBtn, _closeCartBtn = closeCartBtn ,_printFromOrders = printFromOrders;
  final String id;
  final String shopId;
  final BlueDevice? selectedDev;
  final String merchName;
  final String merchAddress;
  final bool fromSearch;
  final bool isEnglish;

  @override
  _MerchantOrdersInfoSubsState createState() => _MerchantOrdersInfoSubsState();
}

class _MerchantOrdersInfoSubsState extends State<MerchantOrdersInfoSubs> {

  final cateScCtler = ScrollController();
  final _customScrollViewCtl = ScrollController();
  final _width = 10.0;
  int cateScIndex = 0;
  List<String> subList = [];

  var sectionList3;

  int limitToLast = 6;

  bool loadingDone = true;

  int ayinLength = 0;

  bool endOfResult = false;
  zeroToTen(String string) {
    if (int.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
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

  String textSetAll = 'All';
  String textSetTUnpaid = 'Unpaids';
  String textSetTRefunds = 'Refunds';
  String textSetTPaid = 'Paids';

  @override
  void initState() {
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

      if(widget.isEnglish == true) {

        setState(() {
          textSetAll = 'All';
          textSetTUnpaid = 'Unpadis';
          textSetTRefunds = 'Refunds';
          textSetTPaid = 'Paids';
        });
      } else {
        setState(() {
          textSetAll = 'အားလုံး';
          textSetTUnpaid = 'မရှင်းသေး';
          textSetTRefunds = 'ပြန်အမ်း';
          textSetTPaid = 'ရှင်းပြီး';
        });
      }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 81.0, bottom: widget.fromSearch? 141: 0),
                child: PaginateFirestore(
                  itemsPerPage: 10,
                  onEmpty: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                          child: Container(
                            height: 32,
                            width: MediaQuery.of(context).size.width,
                            // color: Colors.yellow,
                            child: Row(
                              children: [
                                Expanded(
                                  child:  ListView(
                                    controller: cateScCtler,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      SizedBox(
                                        width: 0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                        child: FlatButton(
                                          minWidth: 0,
                                          padding: EdgeInsets.only(left: 12, right: 12),
                                          color: cateScIndex == 0 ? AppTheme.secButtonColor:Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                            side: BorderSide(
                                              color: AppTheme.skBorderColor2,
                                            ),
                                          ),
                                          onPressed: () {
                                            _animateToIndex(0);
                                            setState(() {
                                              cateScIndex = 0;
                                            });
                                          },
                                          child: Container(
                                            child: Text(
                                              textSetAll,  textScaleFactor: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                                        child: FlatButton(
                                          minWidth: 0,
                                          padding: EdgeInsets.only(left: 12, right: 12),
                                          color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                            side: BorderSide(
                                              color: AppTheme.skBorderColor2,
                                            ),
                                          ),
                                          onPressed: () {
                                            _animateToIndex(5.4);
                                            setState(() {
                                              cateScIndex = 1;
                                            });
                                            toggleIndexOne();
                                          },
                                          child: Container(
                                            child: Text(
                                              textSetTUnpaid, textScaleFactor: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                                        child: FlatButton(
                                          minWidth: 0,
                                          padding: EdgeInsets.only(left: 12, right: 12),
                                          color: cateScIndex == 2 ? AppTheme.secButtonColor:Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                            side: BorderSide(
                                              color: AppTheme.skBorderColor2,
                                            ),
                                          ),
                                          onPressed: () {
                                            _animateToIndex(16.4);
                                            setState(() {
                                              cateScIndex = 2;
                                            });
                                          },
                                          child: Container(
                                            child: Text(
                                              textSetTRefunds,  textScaleFactor: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                      //   child: FlatButton(
                                      //     minWidth: 0,
                                      //     padding: EdgeInsets.only(left: 12, right: 12),
                                      //     color: cateScIndex == 3 ? AppTheme.secButtonColor:Colors.white,
                                      //     shape: RoundedRectangleBorder(
                                      //       borderRadius: BorderRadius.circular(20.0),
                                      //       side: BorderSide(
                                      //         color: AppTheme.skBorderColor2,
                                      //       ),
                                      //     ),
                                      //     onPressed: () {
                                      //       _animateToIndex(20);
                                      //       setState(() {
                                      //         cateScIndex = 3;
                                      //       });
                                      //     },
                                      //     child: Container(
                                      //       child: Text(
                                      //         textSetTPaid,
                                      //         textAlign: TextAlign.center,
                                      //         style: TextStyle(
                                      //             fontSize: 14,
                                      //             fontWeight: FontWeight.w500,
                                      //             color: Colors.black),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        width: 11,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),

                          ),
                        ),
                        Expanded(
                          child: Container(
                            // color: AppTheme.lightBgColor,
                            color: Colors.white,
                            child: Center(child: Text('No data found', textScaleFactor: 1, style: TextStyle(fontSize: 15),)),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Use SliverAppBar in header to make it sticky
                  key: cateScIndex == 0? ValueKey<String>('00'): cateScIndex == 1? (togIndOne? ValueKey<String>('11'): ValueKey<String>('12')): cateScIndex == 2? ValueKey<String>('22'): ValueKey<String>('33'),
                  header: SliverAppBar(
                    leading: Container(),
                    elevation: 0,
                    backgroundColor: Colors.white,
                    // Provide a standard title.
                    // Allows the user to reveal the app bar if they begin scrolling
                    // back up the list of items.
                    floating: true,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                      child: Container(
                        height: 32,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.yellow,
                        child: Row(
                          children: [
                            Expanded(
                              child:  ListView(
                                controller: cateScCtler,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  SizedBox(
                                    width: 0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                    child: FlatButton(
                                      minWidth: 0,
                                      padding: EdgeInsets.only(left: 12, right: 12),
                                      color: cateScIndex == 0 ? AppTheme.secButtonColor:Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        side: BorderSide(
                                          color: AppTheme.skBorderColor2,
                                        ),
                                      ),
                                      onPressed: () {
                                        _animateToIndex(0);
                                        setState(() {
                                          cateScIndex = 0;
                                        });
                                      },
                                      child: Container(
                                        child: Text(
                                          textSetAll,  textScaleFactor: 1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                                    child: FlatButton(
                                      minWidth: 0,
                                      padding: EdgeInsets.only(left: 12, right: 12),
                                      color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        side: BorderSide(
                                          color: AppTheme.skBorderColor2,
                                        ),
                                      ),
                                      onPressed: () {
                                        _animateToIndex(5.4);
                                        setState(() {
                                          cateScIndex = 1;
                                        });
                                        toggleIndexOne();
                                      },
                                      child: Container(
                                        child: Text(
                                          textSetTUnpaid,  textScaleFactor: 1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                                    child: FlatButton(
                                      minWidth: 0,
                                      padding: EdgeInsets.only(left: 12, right: 12),
                                      color: cateScIndex == 2 ? AppTheme.secButtonColor:Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        side: BorderSide(
                                          color: AppTheme.skBorderColor2,
                                        ),
                                      ),
                                      onPressed: () {
                                        _animateToIndex(16.4);
                                        setState(() {
                                          cateScIndex = 2;
                                        });
                                      },
                                      child: Container(
                                        child: Text(
                                          textSetTRefunds,  textScaleFactor: 1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                  //   child: FlatButton(
                                  //     minWidth: 0,
                                  //     padding: EdgeInsets.only(left: 12, right: 12),
                                  //     color: cateScIndex == 3 ? AppTheme.secButtonColor:Colors.white,
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(20.0),
                                  //       side: BorderSide(
                                  //         color: AppTheme.skBorderColor2,
                                  //       ),
                                  //     ),
                                  //     onPressed: () {
                                  //       _animateToIndex(20);
                                  //       setState(() {
                                  //         cateScIndex = 3;
                                  //       });
                                  //     },
                                  //     child: Container(
                                  //       child: Text(
                                  //         textSetTPaid,
                                  //         textAlign: TextAlign.center,
                                  //         style: TextStyle(
                                  //             fontSize: 14,
                                  //             fontWeight: FontWeight.w500,
                                  //             color: Colors.black),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    width: 11,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),

                      ),
                    ),),
                  footer: SliverToBoxAdapter(child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 12.0),
                    child: Center(child: Text('End of results',  textScaleFactor: 1, strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),)),
                  ),),
                  bottomLoader: Padding(
                    padding: const EdgeInsets.only(bottom: 34.0),
                    child: Container(
                      child: LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
                    ),
                  ),
                  itemBuilder: (context1, documentSnapshots, index) {
                    Map<String, dynamic> data = documentSnapshots[index].data() as Map<String, dynamic>;
                    DateTime chgDate = DateFormat("yyyy-MM-dd HH:mm").parse(data['dateTime'].substring(0,4) + '-' +data['dateTime'].substring(4,6)  + '-' +data['dateTime'].substring(6,8) + ' ' +data['dateTime'].substring(8,10)  + ':' +data['dateTime'].substring(10,12));
                    debugPrint('chgDate' + chgDate.toString());
                    chgDate = chgDate.add(Duration(minutes: calHourFromTZ(chgDate)));
                    String modDateTime = chgDate.year.toString() + zeroToTen(chgDate.month.toString()) + zeroToTen(chgDate.day.toString()) + zeroToTen(chgDate.hour.toString()) + zeroToTen(chgDate.minute.toString());
                    String item = modDateTime  +'^' + data['deviceId'] + data['orderId'] + '^' + data['total'].toString() + '^' + widget.merchName + '&'+ data['merchantId'] + '^' + data['refund'] + '^' + data['debt'].toString() + '^' + data['discount'].toString() + '^' + data['date'].toDate().hour.toString() + '^' + data['date'].toDate().minute.toString();
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => BuyListInfo(isEnglish : widget.isEnglish, fromSearch: widget.fromSearch, data: item, toggleCoinCallback: () {}, shopId: widget.shopId.toString(), closeCartBtn: widget._closeCartBtn, openCartBtn: widget._openCartBtn, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,),),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppTheme.lightBgColor,
                                  border: Border(
                                    bottom: BorderSide(
                                        color: AppTheme.skBorderColor2,
                                        width: 1.0),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 1.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text('#' + data['deviceId'] + data['orderId'],  textScaleFactor: 1,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 1.0),
                                                child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                covertToDayNum(modDateTime.substring(6,8).toString()) + '/' + modDateTime.substring(4,6).toString() + '/' + modDateTime.substring(0,4).toString() + ' ',
                                                textScaleFactor: 1, style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              ),
                                              ),
                                              Text(convertToHour(modDateTime.substring(8,10).toString()) + ':' + (modDateTime.substring(10,12).toString()) + ' ' + convertToAMPM(modDateTime.substring(8,10).toString()),
                                                textScaleFactor: 1, style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Row(
                                            children: [
                                              Text(widget.merchName,  textScaleFactor: 1, style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              )),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        if(data['debt'].toString() == '0.0')
                                          Padding(
                                            padding: const EdgeInsets.only(left: 0.0),
                                            child: Container(
                                              height: 21,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20.0),
                                                color: AppTheme.badgeBgSuccess,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                                child: Text(widget.isEnglish? 'Paid': 'ရှင်းပြီး',
                                                  textScaleFactor: 1, strutStyle: StrutStyle(
                                                    height: 1.25,
                                                    // fontSize:,
                                                    forceStrutHeight: true,
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: widget.isEnglish? 13: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.white
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                        if(data['debt'].toString() != '0.0' && double.parse(data['total'].toString())  > double.parse(data['debt'].toString()))
                                          Padding(
                                            padding: const EdgeInsets.only(left: 0.0),
                                            child: Container(
                                              height: 21,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20.0),
                                                color: AppTheme.badgeFgDangerLight,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                                child: Text(widget.isEnglish? 'Partially paid': 'တချို့တဝက် ရှင်းပြီး',
                                                  textScaleFactor: 1, strutStyle: StrutStyle(
                                                    height: 1.25,
                                                    // fontSize:,
                                                    forceStrutHeight: true,
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: widget.isEnglish? 13: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: AppTheme.badgeFgDanger
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if(data['debt'].toString()  != '0.0'  && double.parse(data['total'].toString()) == data['debt'])
                                          Padding(
                                            padding: const EdgeInsets.only(left: 0.0),
                                            child: Container(
                                              height: 21,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20.0),
                                                color: AppTheme.badgeFgDanger,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                                child: Text(widget.isEnglish? 'Unpaid': 'မရှင်းသေး',
                                                  textScaleFactor: 1, strutStyle: StrutStyle(
                                                    height: 1.25,
                                                    // fontSize:,
                                                    forceStrutHeight: true,
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: widget.isEnglish? 13: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.white
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if(data['refund'] == 'T')
                                          Padding(
                                            padding: const EdgeInsets.only(left: 6.0),
                                            child: Container(
                                              height: 21,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20.0),
                                                color: AppTheme.badgeBgSecond,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                                child: Text(widget.isEnglish? 'Refunded': 'ပြန်ပေး',
                                                  textScaleFactor: 1, strutStyle: StrutStyle(
                                                    height: 1.25,
                                                    // fontSize:,
                                                    forceStrutHeight: true,
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: widget.isEnglish? 13: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.white
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                        if(data['refund'] == 'P')
                                          Padding(
                                            padding: const EdgeInsets.only(left: 6.0),
                                            child: Container(
                                              height: 21,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20.0),
                                                color: AppTheme.badgeBgSecondLight,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                                child: Text(widget.isEnglish? 'Partially refunded': 'တချို့တဝက် ပြန်ပေး',
                                                  textScaleFactor: 1, strutStyle: StrutStyle(
                                                    height: 1.25,
                                                    // fontSize:,
                                                    forceStrutHeight: true,
                                                  ),
                                                  style: TextStyle(
                                                      fontSize: widget.isEnglish? 13: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: AppTheme.badgeBgSecond
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0, bottom: 5),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('$currencyUnit ' + double.parse(data['total']).toStringAsFixed(2),  textScaleFactor: 1, style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  )),
                                  SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    child: Icon(
                                      Icons
                                          .arrow_forward_ios_rounded,
                                      size: 16,
                                      color: Colors
                                          .blueGrey
                                          .withOpacity(
                                          0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  itemBuilderType:
                  PaginateBuilderType.listView,
                  // cateScIndex
                  // orderBy is compulsory to enable pagination
                  // query: FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('order').where('debt', isGreaterThan: 0),
                  query: queryFilter(),
                  // to fetch real-time data
                  isLive: true,
                ),
              ),
            ),
            Container(
              height: 81,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                          width: 1.0))),
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 15.0),
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
                            widget.merchAddress,  textScaleFactor: 1,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                              //color: Colors.grey,
                            ),
                            strutStyle: StrutStyle(
                              height: 1.5,
                              // fontSize:,
                              forceStrutHeight: true,
                            ),
                          ),
                          Text(
                            widget.merchName,  textScaleFactor: 1,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.3,
                              fontWeight: FontWeight.w600,
                            ),
                            strutStyle: StrutStyle(
                              height: 1.5,
                              // fontSize:,
                              forceStrutHeight: true,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );




  }

  covertToDayNum(String input) {
    if(input[0]=='0') {
      return input[1];
    } else {
      return input;
    }
  }

  queryFilter() {
    debugPrint('cust id ' + widget.id.toString());
    if(cateScIndex == 0) {
      return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrder').where('merchantId', isEqualTo: widget.id).orderBy('date', descending: true);
    } else if(cateScIndex == 1) {
      if(togIndOne) {
        return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrder').where('merchantId', isEqualTo: widget.id).where('debt_filter', isEqualTo: true).orderBy('debt', descending: true);
      }
      return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrder').where('merchantId', isEqualTo: widget.id).where('debt_filter', isEqualTo: true).orderBy('date', descending: true);
    } else if(cateScIndex == 2) {
      return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrder').where('merchantId', isEqualTo: widget.id).where('refund_filter', isEqualTo: true).orderBy('date', descending: true);
    } else {
      return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrder').where('debt', isEqualTo: 0).orderBy('date', descending: true);
    }
  }

  bool togIndOne = true;

  void toggleIndexOne() {
    setState(() {
      togIndOne = !togIndOne;
    });
  }

  convertToAMPM(String input){
    switch (input) {
      case '00':
        return 'AM';
        break;
      case '01':
        return 'AM';
        break;
      case '02':
        return 'AM';
        break;
      case '03':
        return 'AM';
        break;
      case '04':
        return 'AM';
        break;
      case '05':
        return 'AM';
        break;
      case '06':
        return 'AM';
        break;
      case '07':
        return 'AM';
        break;
      case '08':
        return 'AM';
        break;
      case '09':
        return 'AM';
        break;
      case '10':
        return 'AM';
        break;
      case '11':
        return 'AM';
        break;
      case '12':
        return 'PM';
        break;
      case '13':
        return 'PM';
        break;
      case '14':
        return 'PM';
        break;
      case '15':
        return 'PM';
        break;
      case '16':
        return 'PM';
        break;
      case '17':
        return 'PM';
        break;
      case '18':
        return 'PM';
        break;
      case '19':
        return 'PM';
        break;
      case '20':
        return 'PM';
        break;
      case '21':
        return 'PM';
        break;
      case '22':
        return 'PM';
        break;
      case '23':
        return 'PM';
        break;
    }
  }

  convertToMinutes(String input){
    switch (input) {
      case '00':
        return '00';
        break;
      case '01':
        return '01';
        break;
      case '02':
        return '02';
        break;
      case '03':
        return '03';
        break;
      case '04':
        return '04';
        break;
      case '05':
        return '05';
        break;
      case '06':
        return '06';
        break;
      case '07':
        return '07';
        break;
      case '08':
        return '08';
        break;
      case '09':
        return '09';
        break;
      default:
        return input.toString();
        break;
    }
  }

  convertToHour(String input){
    switch (input) {
      case '00':
        return '00';
        break;
      case '01':
        return '01';
        break;
      case '02':
        return '02';
        break;
      case '03':
        return '03';
        break;
      case '04':
        return '04';
        break;
      case '05':
        return '05';
        break;
      case '06':
        return '06';
        break;
      case '07':
        return '07';
        break;
      case '08':
        return '08';
        break;
      case '09':
        return '09';
        break;
      case '10':
        return '10';
        break;
      case '11':
        return '11';
        break;
      case '12':
        return '12';
        break;
      case '13':
        return '1';
        break;
      case '14':
        return '2';
        break;
      case '15':
        return '3';
        break;
      case '16':
        return '4';
        break;
      case '17':
        return '5';
        break;
      case '18':
        return '6';
        break;
      case '19':
        return '7';
        break;
      case '20':
        return '8';
        break;
      case '21':
        return '9';
        break;
      case '22':
        return '10';
        break;
      case '23':
        return '11';
        break;
    }
  }

  calHourFromTZ(DateTime dateTime) {
    return dateTime.timeZoneOffset.inMinutes;
  }

  _animateToIndex(i) {
    // debugPrint((_width * i).toString() + ' BBB ' + cateScCtler.offset.toString() + ' BBB ' + cateScCtler.position.maxScrollExtent.toString());
    if((_width * i) > cateScCtler.position.maxScrollExtent) {
      cateScCtler.animateTo(cateScCtler.position.maxScrollExtent, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    } else {
      cateScCtler.animateTo(_width * i, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    }

  }
}