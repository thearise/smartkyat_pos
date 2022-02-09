import 'dart:io';
import 'dart:math';

import 'package:blue_print_pos/models/blue_device.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';
import 'package:smartkyat_pos/widgets/edit_customer.dart';
import '../../app_theme.dart';
import 'customer_orders_info2.dart';

class CustomerInfoSubs extends StatefulWidget {
  final _callback;
  final _closeCartBtn;
  final _openCartBtn;
  final _printFromOrders;
  const CustomerInfoSubs({Key? key, this.selectedDev, required void printFromOrders(File file), required void closeCartBtn(), required this.id, required this.shopId, required void openCartBtn(), required void toggleCoinCallback(String str)}) : _callback = toggleCoinCallback, _closeCartBtn = closeCartBtn, _openCartBtn = openCartBtn,  _printFromOrders = printFromOrders;
  final String id;
  final String shopId;
  final BlueDevice? selectedDev;

  @override
  _CustomerInfoSubsState createState() => _CustomerInfoSubsState();
}

class _CustomerInfoSubsState extends State<CustomerInfoSubs> with
    TickerProviderStateMixin <CustomerInfoSubs> {
  List<String> prodFieldsValue = [];
  static final _formKey = GlobalKey<FormState>();

  int _sliding = 0;
  late TabController _controller;

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }
  
  String textSetSaleCart = 'Add to\nsale cart';
  String textSetPurchasedOrders = 'Purchased\norders';
  String textSetEdit = 'Edit customer';
  String textSetSaleInfo = 'Sale info';
  String textSetContactInfo = 'Contact info';
  String textSetInfo = 'CUSTOMER INFORMATION';
  String textSetName = 'Name';
  String textSetPhone = 'Phone';
  String textSetAddress = 'Address';
  String textSetBarcode = 'Barcode';
  String textSetDebtAmount = 'Total Unpaid';
  String textSetDebts = 'Total Unpaid Orders';
  String textSetTtlOrders = 'Total Orders';
  String textSetRefunds = 'Total Refunded Orders';
  String textSetSaleTitle = 'SALE INFORMATION';
  @override
  void initState() {
    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
           textSetSaleCart = 'Add to\nsale cart';
           textSetPurchasedOrders = 'Purchased\norders';
           textSetEdit = 'Edit customer';
           textSetSaleInfo = 'Sale info';
           textSetContactInfo = 'Contact info';
           textSetInfo = 'CUSTOMER INFORMATION';
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
           textSetSaleCart = 'Add to\nsale cart';
           textSetPurchasedOrders = 'Purchased\norders';
           textSetEdit = 'Edit customer';
           textSetSaleInfo = 'Sale info';
           textSetContactInfo = 'Contact info';
           textSetInfo = 'CUSTOMER INFORMATION';
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

  void printFromOrdersFun(File file) {
    widget._printFromOrders(file);
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
                .collection('customers')
                .doc(widget.id.toString())
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                var output = snapshot.data!.data();
                var customerName = output?['customer_name'];
                var address = output?['customer_address'];
                var phone = output?['customer_phone'];
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
                          padding: const EdgeInsets.only(left: 18.0, right: 15.0),
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
                                      address,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        //color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      customerName,
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: Container(
                                      height: 110,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          customerName != 'No customer' ? Padding(
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
                                                  widget._callback(widget.id.toString() + '^' + customerName);
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        top: 10,
                                                        left: 0,
                                                        child: Stack(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 7.0),
                                                              child: Icon(
                                                                SmartKyat_POS.customer1,
                                                                size: 17.5,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 14.0, top: 11.0),
                                                              child: Icon(
                                                                SmartKyat_POS.customer2,
                                                                size: 9,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 5.0, top: 5),
                                                              child: Container(
                                                                width: 8,
                                                                height: 7.5,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                    color: Colors.black),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 14.5, top: 7.5),
                                                              child: Container(
                                                                width: 5,
                                                                height: 4.5,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                    color: Colors.black),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 10,
                                                        left: 0,
                                                        child: Text(
                                                         textSetSaleCart,
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
                                                    builder: (context) => CustomerOrdersInfoSubs(id: widget.id, shopId: widget.shopId, closeCartBtn: widget._closeCartBtn, openCartBtn: widget._openCartBtn, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev, custName: customerName, custAddress: address,),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      top: 10,
                                                      left: 0,
                                                      child: Icon(
                                                        SmartKyat_POS.order,
                                                        size: 21,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 10,
                                                      left: 0,
                                                      child: Text(
                                                        textSetPurchasedOrders,
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
                                          customerName != 'No customer' ?
                                          Padding(
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
                                                          builder: (context) => EditCustomer(shopId: widget.shopId, cusId: widget.id, cusName: customerName, cusAddress: address, cusPhone: phone,)),);
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
                                          ) :Container(),
                                          Expanded(
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                               // SizedBox(width: 10),
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
                                                customerName != 'No customer' ? FlatButton(
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
                                                ) :
                                                Container(),
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
                                      height: 300,
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
                                                                      color: Colors.grey
                                                                          .withOpacity(0.2),
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
                                                              Text(customerName, style:
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
                                  )
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