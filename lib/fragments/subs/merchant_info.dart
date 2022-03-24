import 'dart:io';
import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:blue_print_pos/models/blue_device.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/widgets/edit_merchant.dart';
import 'package:smartkyat_pos/widgets/product_details_view.dart';

import '../../app_theme.dart';
import 'merchant_orders_info2.dart';


class MerchantInfoSubs extends StatefulWidget {
  final _callback;
  final _closeCartBtn;
  final _openCartBtn;
  final _printFromOrders;
  const MerchantInfoSubs({Key? key, this.selectedDev, required void printFromOrders(File file, var prodListPR),required void closeCartBtn(), required void openCartBtn(),required this.id, required this.mercName, required this.mercAddress, required this.shopId, required void toggleCoinCallback(String str)}) : _callback = toggleCoinCallback, _closeCartBtn = closeCartBtn, _openCartBtn = openCartBtn,  _printFromOrders = printFromOrders;
  final String id;
  final String shopId;
  final String mercName;
  final String mercAddress;
  final BlueDevice? selectedDev;


  @override
  _MerchantInfoSubsState createState() => _MerchantInfoSubsState();
}

class _MerchantInfoSubsState extends State<MerchantInfoSubs>  with
    TickerProviderStateMixin <MerchantInfoSubs> {
  List<String> prodFieldsValue = [];
  static final _formKey = GlobalKey<FormState>();

  void printFromOrdersFun(File file, var prodListPR) {
    widget._printFromOrders(file, prodListPR);
  }

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

  int _sliding = 0;
  late TabController _controller;

  String textSetSaleCart = 'Add to\nbuy cart';
  String textSetPurchasedOrders = 'Purchased\norders';
  String textSetEdit = 'Edit merchant';
  String textSetSaleInfo = 'Sale info';
  String textSetContactInfo = 'Contact info';
  String textSetInfo = 'MERCHANT INFORMATION';
  String textSetName = 'Name';
  String textSetPhone = 'Phone';
  String textSetAddress = 'Address';
  String textSetBarcode = 'Barcode';
  String textSetDebtAmount = 'Total Unpaid';
  String textSetDebts = 'Total Unpaid Orders';
  String textSetTtlOrders = 'Total Orders';
  String textSetRefunds = 'Total Refunded Orders';
  String textSetSaleTitle = 'SALE INFORMATION';
  bool isEnglish = true;

  @override
  void initState() {
    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          isEnglish = false;
          textSetSaleCart = 'ဝယ်ရန်\nစာရင်းထည့်';
          textSetPurchasedOrders = 'ဝယ်ထားသော\norders များ';
          textSetEdit = 'Edit merchant';
          textSetSaleInfo = 'Sale info';
          textSetContactInfo = 'Contact info';
          textSetInfo = 'MERCHANT INFORMATION';
           textSetName = 'Name';
           textSetPhone = 'Phone';
           textSetAddress = 'Address';
          textSetBarcode = 'Barcode';
          textSetDebtAmount = 'Total Unpaid';
          textSetDebts = 'Total Unpaid Orders';
          textSetTtlOrders = 'Total Orders';
          textSetRefunds = 'Total Refunded Orders';
          textSetSaleTitle = 'SALE INFORMATION';
        });
      }
      else if(value=='english') {
        setState(() {
          isEnglish = true;
          textSetSaleCart = 'Add to\nbuy cart';
          textSetPurchasedOrders = 'Purchased\norders';
          textSetEdit = 'Edit merchant';
          textSetSaleInfo = 'Sale info';
          textSetContactInfo = 'Contact info';
          textSetInfo = 'MERCHANT INFORMATION';
           textSetName = 'Name';
           textSetPhone = 'Phone';
           textSetAddress = 'Address';
          textSetBarcode = 'Barcode';
          textSetDebtAmount = 'Total Unpaid';
          textSetDebts = 'Total Unpaid Orders';
          textSetTtlOrders = 'Total Orders';
          textSetRefunds = 'Total Refunded Orders';
          textSetSaleTitle = 'SALE INFORMATION';
        });
      }
    });
    _controller = new TabController(length: 2, vsync: this);
    _controller.addListener((){
      print('my index is'+ _controller.index.toString());
      if(_controller.index.toString()=='1') {
        setState(() {
          _sliding = 1;
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
                .collection('merchants')
                .doc(widget.id.toString())
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                var output = snapshot.data!.data();
                var merchantName = output?['merchant_name'];
                var address = output?['merchant_address'];
                var phone = output?['merchant_phone'];
                var debtAmount = output?['debtAmount'];
                var debts = output?['debts'];
                var totalOrders = output?['total_orders'];
                var totalRefunds = output?['total_refunds'];
                return Column(crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(height: 15.5),
                                    Text(
                                      address,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5,
                                      ),
                                      strutStyle: StrutStyle(
                                        height: 1.4,
                                        // fontSize:,
                                        forceStrutHeight: true,
                                      ),
                                    ),
                                    Text(
                                      merchantName,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        height: 1.3
                                      ),
                                      strutStyle: StrutStyle(
                                        height: 1.7,
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
                      Expanded(
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  SizedBox(height: 15,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: Container(
                                      height: 100,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          merchantName != 'No merchant' ? Padding(
                                            padding: const EdgeInsets.only(right: 10.0),
                                            child: ButtonTheme(
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
                                                  await widget._callback(widget.id.toString() + '^' + merchantName);
                                                  smartKyatFlash(merchantName.toString() + ' has been successfully added to the buy cart.', 's');
                                                  },
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        top: 16.5,
                                                        left: 0.5,
                                                        child: Icon(
                                                          SmartKyat_POS.merchant,
                                                          size: 19,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 15,
                                                        left: 0,
                                                        child: Text(
                                                          textSetSaleCart,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 16,
                                                          ),
                                                          strutStyle: StrutStyle(
                                                            height: isEnglish? 1.4: 1.6,
                                                            forceStrutHeight: true,
                                                          )
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ) : Container(),
                                          //SizedBox(width: 10),
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
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => MerchantOrdersInfoSubs(id: widget.id, shopId: widget.shopId.toString(),closeCartBtn: widget._closeCartBtn, openCartBtn: widget._openCartBtn, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev, merchName: merchantName, merchAddress: address,)),
                                                );

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
                                                        SmartKyat_POS.order,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 15,
                                                      left: 0,
                                                      child: Text(
                                                        textSetPurchasedOrders,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                        ),
                                                        strutStyle: StrutStyle(
                                                          height: isEnglish? 1.4: 1.6,
                                                          forceStrutHeight: true,
                                                        )
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
                                  ),
                                  SizedBox(height: 5,),
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
                                          merchantName != 'No merchant' ? Padding(
                                            padding: const EdgeInsets.only(right: 10.0),
                                            child: Row(
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
                                                    widget._closeCartBtn();
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => EditMerchant(shopId: widget.shopId, merchId: widget.id, merchName: merchantName, merchAddress: address, merchPhone: phone, )),);
                                                    widget._openCartBtn();

                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 6.0),
                                                          child: Icon(
                                                            Icons.edit_rounded,
                                                            size: 17,
                                                          ),
                                                        ),
                                                        Text(
                                                          textSetEdit,
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
                                            ),
                                          ) : Container(),
                                          Expanded(
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                //SizedBox(width: 10),
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
                                                    child: Text(
                                                     textSetSaleInfo,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                merchantName != 'No merchant' ? FlatButton(
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
                                                    child: Text(
                                                     textSetContactInfo,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black),
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
                                      height: 253,
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
                                                  textSetSaleTitle,
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
                                                              Text(textSetTtlOrders, style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                              Spacer(),
                                                              Text(totalOrders.round().toString(), style:
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
                                                              Text(textSetDebts, style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                              Spacer(),
                                                              Text(debts.round().toString(), style: TextStyle(
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
                                                              Text(textSetDebtAmount, style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w600,
                                                              ),),
                                                              Spacer(),
                                                              Text( 'MMK '+ debtAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w600,
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
                                                                      // color: Colors.grey
                                                                      //     .withOpacity(0.2),
                                                                      color: Colors.transparent,
                                                                      width: 1.0))),
                                                          child: Row(
                                                            children: [
                                                              Text(textSetRefunds, style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w600,
                                                              ),),
                                                              Spacer(),
                                                              Text(totalRefunds.round().toString(), style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.grey,
                                                              ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // Container(
                                                        //   height: 55,
                                                        //   child: Row(
                                                        //     children: [
                                                        //       Text('Barcode', style:
                                                        //       TextStyle(
                                                        //         fontSize: 15,
                                                        //         fontWeight: FontWeight.w600,
                                                        //       ),),
                                                        //       Spacer(),
                                                        //       Text('3kro46456218', style:
                                                        //       TextStyle(
                                                        //         fontSize: 15,
                                                        //         fontWeight: FontWeight.w600,
                                                        //         color: Colors.grey,
                                                        //       ),),
                                                        //     ],
                                                        //   ),
                                                        // ),
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
                                                  textSetInfo,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    letterSpacing: 2,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(height: 15,),
                                                Container(
                                                  height: 165,
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
                                                              Text(textSetName, style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                              Spacer(),
                                                              Text(merchantName, style:
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
                                                              Text(textSetPhone, style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                              Spacer(),
                                                              Text(phone, style: TextStyle(
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
                                                              Text(textSetAddress, style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w600,
                                                              ),),
                                                              Spacer(),
                                                              Text(address, style:
                                                              TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.grey,
                                                              ),),

                                                            ],
                                                          ),
                                                        ),
                                                        // Container(
                                                        //   height: 55,
                                                        //   child: Row(
                                                        //     children: [
                                                        //       Text('Barcode', style:
                                                        //       TextStyle(
                                                        //         fontSize: 15,
                                                        //         fontWeight: FontWeight.w600,
                                                        //       ),),
                                                        //       Spacer(),
                                                        //       Text('3kro46456218', style:
                                                        //       TextStyle(
                                                        //         fontSize: 15,
                                                        //         fontWeight: FontWeight.w600,
                                                        //         color: Colors.grey,
                                                        //       ),),
                                                        //     ],
                                                        //   ),
                                                        // ),
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
                                  ),
                                  SizedBox(height: 15,),
                                  merchantName != 'No merchant' ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: AppTheme.skBorderColor2,
                                                    width: 0.5)
                                            )),
                                        height: 1,
                                      ),

                                  SizedBox(height: 15,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: Text(
                                      'ARCHIVE MERCHANT',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        letterSpacing: 2,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 13,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        color: AppTheme.lightBgColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
                                        child: Container(
                                          // color: Colors.yellow,
                                          child: ListTile(
                                            // leading: Padding(
                                            //   padding: const EdgeInsets.only(top: 2.0),
                                            //   child: Text('jsidfaj'),
                                            // ),
                                            minLeadingWidth: 15,
                                            horizontalTitleGap: 10,
                                            minVerticalPadding: 0,
                                            title: Container(
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 8.0),
                                                child: Text('Remove this merchant', textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
                                                    fontWeight: FontWeight.w500, fontSize: 16, height: 1.2)),
                                              ),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Text('Once you remove it, there is no going back.', style: TextStyle(height: 1.2)),
                                            ),
                                            trailing: Container(
                                              height: 33,
                                              child: FlatButton(
                                                padding: EdgeInsets.only(left: 0, right: 0),
                                                color: AppTheme.badgeBgDanger2,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                onPressed: () async {
                                                  CollectionReference product = await FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('merchants');
                                                  showOkCancelAlertDialog(
                                                    context: context,
                                                    title: 'Are you sure you want to remove this merchant?',
                                                    message: 'This action cannot go back later.',
                                                    defaultType: OkCancelAlertDefaultType.cancel,
                                                  ).then((result) {
                                                    if(result == OkCancelResult.ok) {
                                                      product.doc(
                                                          widget.id)
                                                          .update({
                                                        'archive': true
                                                      }).then((value) {
                                                        Navigator.pop(context);
                                                        smartKyatFlash(merchantName.toString() + ' is successfully removed.', 's');
                                                      }).catchError((error) => print("Failed to update: $error"));

                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  'Remove',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                      color: AppTheme.badgeFgDanger2),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 18,),
                                    ],
                                  ) : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ]
                );
              }
              return Container();
            }),
      ),
    );
  }

  loadingView() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: 15.5),
                        Text(
                          widget.mercAddress,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                          strutStyle: StrutStyle(
                            height: 1.4,
                            // fontSize:,
                            forceStrutHeight: true,
                          ),
                        ),
                        Text(
                          widget.mercName,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.3
                          ),
                          strutStyle: StrutStyle(
                            height: 1.7,
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