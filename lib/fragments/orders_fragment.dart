import 'dart:io';

import 'package:blue_print_pos/models/blue_device.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:one_context/one_context.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/subs/buy_list_info.dart';
import 'package:smartkyat_pos/fragments/subs/customer_info.dart';
import 'package:smartkyat_pos/fragments/subs/language_settings.dart';
import 'package:smartkyat_pos/fragments/subs/merchant_info.dart';
import 'package:smartkyat_pos/fragments/subs/order_info.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';
import 'package:smartkyat_pos/widgets/product_details_view.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';
import 'bloc_firestore.dart';

class OrdersFragment extends StatefulWidget {
  final _callback2;
  final _callback3;
  final _callback4;
  final _callback5;
  final _barcodeBtn;
  final _searchBtn;
  final _closeCartBtn;
  final _openCartBtn;
  final _printFromOrders;
  final _openDrawerBtn;
  final _closeDrawerBtn;

  OrdersFragment(
      {
        required void closeDrawerBtn(String str),
        required void openDrawerBtn(String str),
        required this.ordersSnapshot,
        required this.customersSnapshot,
        required this.shopId,
        this.selectedDev,
        required void toggleCoinCallback2(String str),
        required void toggleCoinCallback3(String str),
        required void toggleCoinCallback4(String str),
        required void toggleCoinCallback5(String str),
        required void barcodeBtn(),
        required void searchBtn(),
        required void closeCartBtn(String str),
        required void openCartBtn(String str),
        required void printFromOrders(File file, var prodListPR),
        Key? key,
      })
      :
        _callback2 = toggleCoinCallback2,
        _callback3 = toggleCoinCallback3,
        _callback4 = toggleCoinCallback4,
        _callback5 = toggleCoinCallback5,
        _barcodeBtn = barcodeBtn,
        _searchBtn = searchBtn,
        _closeCartBtn = closeCartBtn,
        _openCartBtn = openCartBtn,
        _printFromOrders = printFromOrders,
        _openDrawerBtn = openDrawerBtn,
        _closeDrawerBtn = closeDrawerBtn,
        super(key: key);

  final String shopId;
  final ordersSnapshot;
  final customersSnapshot;
  final BlueDevice? selectedDev;

  @override
  OrdersFragmentState createState() => OrdersFragmentState();
}

class OrdersFragmentState extends State<OrdersFragment>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<OrdersFragment> {

  TextEditingController _searchController = TextEditingController();
  bool loadingSearch = false;

  FocusNode nodeFirst = FocusNode();

  String searchProdCount = '0';

  bool buySellerStatus = false;

  @override
  bool get wantKeepAlive => true;

  var sectionList;
  var sectionList1;
  var sectionList2;
  var sectionListNo;
  String searchValue = '';
  int slidingSearch = 0;
  bool noSearchData = false;
  bool searchingOverAll = false;
  late TabController _controller;
  late TabController tabController, subTabController;
  String slidedText = 'Products^0';
  String gloSearchText = '';
  int gloSeaProLeng = 0;
  var sectionList3;
  int _sliding = 0;

  String textSetAll = 'All';
  String textSetTUnpaid = 'Unpaids';
  String textSetTRefunds = 'Refunds';
  String textSetTPaid = 'Paids';
  String textSetSearch = 'Search';

  String currencyUnit = 'MMK';

  bool searchOpening = false;

  bool searchOpeningR = false;

  changeSearchOpening(bool index) {
    // setState(() {
    //   searchOpening = index;
    // });
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   setState(() {
    //     searchOpeningR = index;
    //   });
    // });
  }

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

  void closeCartFrom() {
    widget._closeCartBtn('saleorders');
  }

  void openCartFrom() {
    widget._openCartBtn('saleorders');
  }

  void closeDrawerFrom() {
    widget._closeDrawerBtn('saleorders');
  }

  void openDrawerFrom() {
    widget._openDrawerBtn('saleorders');
  }

  void printFromOrdersFun(File file, var prodListPR) {
    widget._printFromOrders(file, prodListPR);
  }

  @override
  initState() {
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
    // getStoreId().then((value) => shopId = value);
    // _searchController.addListener((){
    //   setState(() {
    //     gloSearchText = _searchController.text;
    //     searchValue = _searchController.text;
    //   });
    //   searchKeyChanged();
    //   print(searchValue);
    // });
    // subTabController = TabController(length: 3, vsync: this);
    // slidingSearchCont();
    //
    // var sections = List<ExampleSection>.empty(growable: true);
    // var section = ExampleSection()
    //   ..header = ''
    // // ..items = List.generate(int.parse(document['length']), (index) => document.id)
    // //   ..items = listCreation(document.id, document['data'], document).cast<String>()
    //
    // //   ..items = document['daily_order'].cast<String>()
    //
    //
    //   ..items = ['']
    // // ..items = orderItems(document.id)
    //   ..expanded = true;
    // sections.add(section);
    // sectionList = sections;
    // sectionList1 = sections;
    // sectionList2 = sections;
    // sectionListNo = sections;
    //
    //
    // nodeFirst.addListener(() {
    //   if(nodeFirst.hasFocus) {
    //     setState(() {
    //       loadingSearch = true;
    //     });
    //   }
    // });

    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetAll = 'အားလုံး';
          textSetTUnpaid = 'မရှင်းသေး';
          textSetTRefunds = 'ပြန်အမ်း';
          textSetTPaid = 'ရှင်းပြီး';
          textSetSearch = 'ရှာဖွေရန်';
        });
      } else if(value=='english') {
        setState(() {
          textSetAll = 'All';
          textSetTUnpaid = 'Unpaids';
          textSetTRefunds = 'Refunds';
          textSetTPaid = 'Paids';
          textSetSearch = 'Search';
        });
      }
    });

    super.initState();
  }


  // chgShopIdFrmHomePage() {
  //   setState(() {
  //     getStoreId().then((value) => shopId = value);
  //   });
  // }

  Future<String> getStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));

    var index = prefs.getString('store');
    print(index);
    if (index == null) {
      return 'idk';
    } else {
      return index;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  addProduct3(data) {
    widget._callback3(data);
  }

  addProduct1(data) {
    widget._callback2(data);
  }

  slidingSearchCont() {

    if(slidingSearch == 0) {
      print('gg0');
      subTabController.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);
      setState(() {
      });
    } else if(slidingSearch == 1) {
      print('gg1');
      subTabController.animateTo(1, duration: Duration(milliseconds: 0), curve: Curves.ease);
      setState(() {
      });
    } else if(slidingSearch == 2) {
      print('gg2');
      subTabController.animateTo(2, duration: Duration(milliseconds: 0), curve: Curves.ease);
      setState(() {
      });
    }
  }
  addCustomer2Cart1(data) {
    widget._callback4(data);
  }
  addMerchant2Cart(data) {
    widget._callback5(data);
  }

  void closeSearch() {
    _searchController.clear();
    print('clicked testing ');
    FocusScope.of(context).unfocus();
    setState(() {
      loadingSearch = false;
    });
  }
  void unfocusSearch() {
    print('clicked testing 2');
    FocusScope.of(context).unfocus();
  }

  // changeData3(list, snpsht) {
  //   // list[0].toString()
  //   snpsht.docs.map((document) async {
  //     for (var i = 0; i < list.length; i++) {
  //       if (document.id.toString() == list[i].split('^')[3]) {
  //         list[i] = list[i].split('^')[0] +
  //             '^' +
  //             list[i].split('^')[1] +
  //             '^' +
  //             list[i].split('^')[2] +
  //             '^' +
  //             document['customer_name'].toString() +
  //             '&' +
  //             list[i].split('^')[3] +
  //             '^' +
  //             list[i].split('^')[4] +
  //             '^' +
  //             list[i].split('^')[5] +
  //             '^' +
  //             list[i].split('^')[6] +
  //             '^s'
  //         ;
  //       }
  //     }
  //     // print('changeData ' + document['customer_name'].toString() + list[0].toString());
  //   }).toList();
  //
  //   // print('changeData ' + snpsht.da);
  //   return list;
  // }
  //
  //
  // changeData4(list, snpsht) {
  //   // list[0].toString()
  //   snpsht.docs.map((document) async {
  //     for (var i = 0; i < list.length; i++) {
  //       if (document.id.toString() == list[i].split('^')[3]) {
  //         list[i] = list[i].split('^')[0] +
  //             '^' +
  //             list[i].split('^')[1] +
  //             '^' +
  //             list[i].split('^')[2] +
  //             '^' +
  //             document['merchant_name'].toString() +
  //             '&' +
  //             list[i].split('^')[3] +
  //             '^' +
  //             list[i].split('^')[4] +
  //             '^' +
  //             list[i].split('^')[5] +
  //             '^' +
  //             list[i].split('^')[6] +
  //             '^b'
  //         ;
  //       }
  //     }
  //     // print('changeData ' + document['customer_name'].toString() + list[0].toString());
  //   }).toList();
  //
  //   // print('changeData ' + snpsht.da);
  //   return list;
  // }
  //
  // searchFocus() {
  //
  //   setState(() {
  //     loadingSearch = true;
  //   });
  // }
  //
  // Widget _buildHeader4(BuildContext context, int sectionIndex, int index) {
  //   ExampleSection section = sectionList[sectionIndex];
  //   // if(sectionIndex == 0) {
  //   //   return Container(
  //   //     height: 0.1,
  //   //   );
  //   // }
  //   return InkWell(
  //       child: Container(
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               border: Border(
  //                 bottom: BorderSide(
  //                     color: AppTheme.skBorderColor2,
  //                     width: 1.0),
  //               )
  //           ),
  //           alignment: Alignment.centerLeft,
  //           child: Align(
  //             alignment: Alignment.topCenter,
  //             child: Container(
  //               width: double.infinity,
  //               height: 33,
  //               child: Padding(
  //                 // padding: const EdgeInsets.only(left: 15.0, top: 12, bottom: 0),
  //                 padding: const EdgeInsets.only(left: 15.0, top: 1, bottom: 0),
  //                 child: Row(
  //                   children: [
  //                     Text(
  //                       // "BUY ORDERS",
  //                       'PRODUCTS',
  //                       // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                       style: TextStyle(
  //                           height: 0.8,
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w600,
  //                           letterSpacing: 1.2,
  //                           color: Colors.black
  //                       ),
  //                     ),
  //
  //                     Spacer(),
  //                     searchValue != '' ?
  //                     Padding(
  //                       padding: const EdgeInsets.only(right: 15.0),
  //                       child: section.header != '' ? Text(
  //                         section.header.split('^')[1],
  //                         // '0',
  //                         // '#' + sectionList[sectionIndex].items.length.toString(),
  //                         // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                         style: TextStyle(
  //                           height: 0.8,
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w600,
  //                           letterSpacing: 1.2,
  //                           color: Colors.black,
  //                         ),
  //                         textAlign: TextAlign.right,
  //                       ): Padding(
  //                         padding: const EdgeInsets.only(bottom: 1.0),
  //                         child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
  //                             child: CupertinoActivityIndicator(radius: 8,)),
  //                       ),
  //                     ):
  //                     Padding(
  //                       padding: const EdgeInsets.only(right: 15.0),
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(bottom: 1.0),
  //                         child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
  //                             child: CupertinoActivityIndicator(radius: 8,)),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           )),
  //       onTap: () {
  //         //toggle section expand state
  //         // setState(() {
  //         //   section.setSectionExpanded(!section.isSectionExpanded());
  //         // });
  //       });
  // }
  //
  // Widget _buildHeader1(BuildContext context, int sectionIndex, int index) {
  //   ExampleSection section = sectionList1[sectionIndex];
  //   // if(sectionIndex == 0) {
  //   //   return Container(
  //   //     height: 0.1,
  //   //   );
  //   // }
  //   return InkWell(
  //       child: Container(
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               border: Border(
  //                 bottom: BorderSide(
  //                     color: AppTheme.skBorderColor2,
  //                     width: 1.0),
  //               )
  //           ),
  //           alignment: Alignment.centerLeft,
  //           child: Align(
  //             alignment: Alignment.topCenter,
  //             child: Container(
  //               width: double.infinity,
  //               height: 33,
  //               child: Padding(
  //                 // padding: const EdgeInsets.only(left: 15.0, top: 12, bottom: 0),
  //                 padding: const EdgeInsets.only(left: 15.0, top: 1, bottom: 0),
  //                 child: Row(
  //                   children: [
  //                     Text(
  //                       sectionIndex == 0 ? "BUYERS" : "SELLERS",
  //                       // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                       style: TextStyle(
  //                           height: 0.8,
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w600,
  //                           letterSpacing: 1.2,
  //                           color: Colors.black
  //                       ),
  //                     ),
  //                     Spacer(),
  //                     searchValue != '' ?
  //                     Padding(
  //                       padding: const EdgeInsets.only(right: 15.0),
  //                       child: section.header != '' ? Text(
  //                         section.header.split('^')[1],
  //                         // '0',
  //                         // '#' + sectionList[sectionIndex].items.length.toString(),
  //                         // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                         style: TextStyle(
  //                           height: 0.8,
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w600,
  //                           letterSpacing: 1.2,
  //                           color: Colors.black,
  //                         ),
  //                         textAlign: TextAlign.right,
  //                       ): Padding(
  //                         padding: const EdgeInsets.only(bottom: 1.0),
  //                         child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
  //                             child: CupertinoActivityIndicator(radius: 8,)),
  //                       ),
  //                     ):
  //                     Padding(
  //                       padding: const EdgeInsets.only(right: 15.0),
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(bottom: 1.0),
  //                         child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
  //                             child: CupertinoActivityIndicator(radius: 8,)),
  //                       ),
  //                     )
  //                     ,
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           )),
  //       onTap: () {
  //         //toggle section expand state
  //         // setState(() {
  //         //   section.setSectionExpanded(!section.isSectionExpanded());
  //         // });
  //       });
  // }
  //
  // Widget _buildHeader2(BuildContext context, int sectionIndex, int index) {
  //   ExampleSection section = sectionList2[sectionIndex];
  //   // if(sectionIndex == 0) {
  //   //   return Container(
  //   //     height: 0.1,
  //   //   );
  //   // }
  //   return InkWell(
  //       child: Container(
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               border: Border(
  //                 bottom: BorderSide(
  //                     color: AppTheme.skBorderColor2,
  //                     width: 1.0),
  //               )
  //           ),
  //           alignment: Alignment.centerLeft,
  //           child: Align(
  //             alignment: Alignment.topCenter,
  //             child: Container(
  //               width: double.infinity,
  //               height: 33,
  //               child: Padding(
  //                 // padding: const EdgeInsets.only(left: 15.0, top: 12, bottom: 0),
  //                 padding: const EdgeInsets.only(left: 15.0, top: 1, bottom: 0),
  //                 child: Row(
  //                   children: [
  //                     Text(
  //                       section.header == '' ? 'SALE ORDERS' : section.header.split('^')[0].toUpperCase(),
  //                       // sectionIndex == 0 ? "SALE ORDERS" : "BUY ORDERS",
  //                       // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                       style: TextStyle(
  //                           height: 0.8,
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w600,
  //                           letterSpacing: 1.2,
  //                           color: Colors.black
  //                       ),
  //                     ),
  //                     Spacer(),
  //                     searchValue != '' ?
  //                     Padding(
  //                       padding: const EdgeInsets.only(right: 15.0),
  //                       child: buySellOrderHeaders(section.header),
  //                     ):
  //                     Padding(
  //                       padding: const EdgeInsets.only(right: 15.0),
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(bottom: 1.0),
  //                         child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
  //                             child: CupertinoActivityIndicator(radius: 8,)),
  //                       ),
  //                     )
  //                     ,
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           )),
  //       onTap: () {
  //         //toggle section expand state
  //         // setState(() {
  //         //   section.setSectionExpanded(!section.isSectionExpanded());
  //         // });
  //       });
  // }
  //
  // Widget _buildHeader3(BuildContext context, int sectionIndex, int index) {
  //   return Container(
  //       height: 50,
  //       child: Center(child: Text('Searching...'))
  //   );
  // }
  //
  // Future<void> searchKeyChanged() async {
  //   setState(() {
  //     searchingOverAll = true;
  //   });
  //
  //   if(searchValue != '') {
  //     if(slidingSearch == 2) {
  //       if(searchValue.toLowerCase().contains('b')) {
  //         if(searchValue.contains('-')) {
  //           searchValue = searchValue.split('-')[1];
  //         }
  //         print('hereeee');
  //         sectionList2 = List<ExampleSection>.empty(growable: true);
  //
  //         subTabController.animateTo(2, duration: Duration(microseconds: 0), curve: Curves.ease);
  //
  //         print("search " + searchValue);
  //         String max = searchValue;
  //         // sectionList = [];
  //         List detailIdList = [];
  //
  //         setState(() {
  //           var sections = List<ExampleSection>.empty(growable: true);
  //
  //           var init = ExampleSection()
  //             ..header = ''
  //             ..items = ['']
  //             ..expanded = true;
  //
  //           // var buyOrders = ExampleSection()
  //           //   ..header = 'Products'
  //           //   ..items = ['']
  //           //   ..expanded = true;
  //           sections.add(init);
  //           // sections.add(buyOrders);
  //           sectionList2 = sections;
  //         });
  //
  //         await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders')
  //         // FirebaseFirestore.instance.collection('space')
  //             .where('each_order',  arrayContains: searchValue)
  //             .limit(1)
  //             .get()
  //             .then((QuerySnapshot querySnapshot1) {
  //           print('leng ' + querySnapshot1.docs.length.toString());
  //           if(querySnapshot1.docs.length == 0) {
  //             setState(() {
  //               detailIdList = [];
  //               setState(() {
  //                 var sections = List<ExampleSection>.empty(growable: true);
  //
  //                 var saleOrders = ExampleSection()
  //                   ..header = 'Buy orders^' + 'GG'
  //                   ..items = detailIdList.cast<String>()
  //                   ..expanded = true;
  //
  //                 // var buyOrders = ExampleSection()
  //                 //   ..header = 'Buy orders^' + 'GG'
  //                 //   ..items = detailIdList.cast<String>()
  //                 //   ..expanded = true;
  //
  //                 print('buy ord ' + detailIdList.length.toString());
  //                 sections.add(saleOrders);
  //                 // sections.add(buyOrders);
  //                 sectionList2 = sections;
  //               });
  //             });
  //           }
  //
  //
  //           querySnapshot1.docs.forEach((doc) async {
  //             await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders').doc(doc.id).collection('expansion')
  //                 .where('orderId',  isEqualTo: searchValue)
  //                 .get()
  //                 .then((QuerySnapshot querySnapshot2) async {
  //               querySnapshot2.docs.forEach((doc) {
  //                 String isRef = 'pf';
  //                 if(doc['refund'] == 'TRUE') {
  //                   isRef = 'rf';
  //                 }
  //                 if(doc['refund'] == 'PART') {
  //                   isRef = 'sf';
  //                 }
  //                 setState(() {
  //                   detailIdList.add(doc.id + '^' + doc['deviceId'] + doc['orderId'] + '^' + doc['total'].toString() + '^' + doc['merchantId'] + '^' + isRef + '^' + doc['debt'].toString() + '^' + doc['discount'].toString());
  //                 });
  //               });
  //
  //               await FirebaseFirestore.instance.collection('shops').doc(
  //                   shopId).collection('merchants')
  //                   .get()
  //                   .then((QuerySnapshot querySnapshot3) {
  //                 setState(() {
  //
  //                   // if(detailIdList.length == 0) {
  //                   //   noSearchData = true;
  //                   // } else {
  //                   //   noSearchData = false;
  //                   // }
  //                   var sections = List<ExampleSection>.empty(growable: true);
  //
  //                   var saleOrders = ExampleSection()
  //                     ..header = 'Buy orders^' + detailIdList.length.toString()
  //                     ..items = changeData4(detailIdList.cast<String>(), querySnapshot3)
  //                   // ..items = detailIdList.cast<String>()
  //                     ..expanded = true;
  //
  //                   // var buyOrders = ExampleSection()
  //                   //   ..header = 'Buy orders^' + detailIdList.length.toString()
  //                   //   ..items = detailIdList.cast<String>()
  //                   //   ..expanded = true;
  //
  //                   print('buy ord ' + detailIdList.length.toString());
  //                   sections.add(saleOrders);
  //                   // sections.add(buyOrders);
  //                   sectionList2 = sections;
  //                 });
  //               });
  //
  //
  //
  //             });
  //           });
  //
  //
  //         });
  //       } else {
  //         if(searchValue.contains('-')) {
  //           searchValue = searchValue.split('-')[1];
  //         }
  //         print('hereeee');
  //         sectionList2 = List<ExampleSection>.empty(growable: true);
  //
  //         subTabController.animateTo(2, duration: Duration(microseconds: 0), curve: Curves.ease);
  //
  //         print("search " + searchValue);
  //         String max = searchValue;
  //         // sectionList = [];
  //         List detailIdList = [];
  //
  //         setState(() {
  //           var sections = List<ExampleSection>.empty(growable: true);
  //
  //           var init = ExampleSection()
  //             ..header = ''
  //             ..items = ['']
  //             ..expanded = true;
  //
  //           // var buyOrders = ExampleSection()
  //           //   ..header = 'Products'
  //           //   ..items = ['']
  //           //   ..expanded = true;
  //           sections.add(init);
  //           // sections.add(buyOrders);
  //           sectionList2 = sections;
  //         });
  //
  //         await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders')
  //         // FirebaseFirestore.instance.collection('space')
  //             .where('each_order',  arrayContains: searchValue)
  //             .limit(1)
  //             .get()
  //             .then((QuerySnapshot querySnapshot1) {
  //           print('leng ' + querySnapshot1.docs.length.toString());
  //           if(querySnapshot1.docs.length == 0) {
  //             setState(() {
  //               detailIdList = [];
  //               setState(() {
  //                 var sections = List<ExampleSection>.empty(growable: true);
  //
  //                 var saleOrders = ExampleSection()
  //                   ..header = 'Sale orders^' + 'GG'
  //                   ..items = detailIdList.cast<String>()
  //                   ..expanded = true;
  //
  //                 // var buyOrders = ExampleSection()
  //                 //   ..header = 'Buy orders^' + 'GG'
  //                 //   ..items = detailIdList.cast<String>()
  //                 //   ..expanded = true;
  //
  //                 print('buy ord ' + detailIdList.length.toString());
  //                 sections.add(saleOrders);
  //                 // sections.add(buyOrders);
  //                 sectionList2 = sections;
  //               });
  //             });
  //           }
  //
  //
  //           querySnapshot1.docs.forEach((doc) async {
  //             await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders').doc(doc.id).collection('detail')
  //                 .where('orderId',  isEqualTo: searchValue)
  //                 .get()
  //                 .then((QuerySnapshot querySnapshot2) async {
  //               querySnapshot2.docs.forEach((doc) {
  //                 String isRef = 'pf';
  //                 if(doc['refund'] == 'TRUE') {
  //                   isRef = 'rf';
  //                 }
  //                 if(doc['refund'] == 'PART') {
  //                   isRef = 'sf';
  //                 }
  //                 setState(() {
  //                   detailIdList.add(doc.id + '^' + doc['deviceId'] + doc['orderId'] + '^' + doc['total'].toString() + '^' + doc['customerId'] + '^' + isRef + '^' + doc['debt'].toString() + '^' + '0.0');
  //                 });
  //               });
  //
  //               await FirebaseFirestore.instance.collection('shops').doc(
  //                   shopId).collection('customers')
  //                   .get()
  //                   .then((QuerySnapshot querySnapshot3) {
  //                 setState(() {
  //
  //                   // if(detailIdList.length == 0) {
  //                   //   noSearchData = true;
  //                   // } else {
  //                   //   noSearchData = false;
  //                   // }
  //                   var sections = List<ExampleSection>.empty(growable: true);
  //
  //                   var saleOrders = ExampleSection()
  //                     ..header = 'Sale orders^' + detailIdList.length.toString()
  //                     ..items = changeData3(detailIdList.cast<String>(), querySnapshot3)
  //                   // ..items = detailIdList.cast<String>()
  //                     ..expanded = true;
  //
  //                   // var buyOrders = ExampleSection()
  //                   //   ..header = 'Buy orders^' + detailIdList.length.toString()
  //                   //   ..items = detailIdList.cast<String>()
  //                   //   ..expanded = true;
  //
  //                   print('buy ord ' + detailIdList.length.toString());
  //                   sections.add(saleOrders);
  //                   // sections.add(buyOrders);
  //                   sectionList2 = sections;
  //                 });
  //               });
  //
  //
  //
  //             });
  //           });
  //
  //
  //         });
  //       }
  //
  //
  //       //BUY BUY BUY
  //
  //
  //
  //
  //
  //     } else if (slidingSearch == 1) {
  //       sectionList1 = [];
  //       subTabController.animateTo(1, duration: Duration(microseconds: 1), curve: Curves.ease);
  //
  //       setState(() {
  //         var sections = List<ExampleSection>.empty(growable: true);
  //
  //         var init = ExampleSection()
  //           ..header = ''
  //           ..items = ['']
  //           ..expanded = true;
  //
  //         // var buyOrders = ExampleSection()
  //         //   ..header = 'Products'
  //         //   ..items = ['']
  //         //   ..expanded = true;
  //         sections.add(init);
  //         sections.add(init);
  //         // sections.add(buyOrders);
  //         sectionList1 = sections;
  //       });
  //       List<String> items = [];
  //       List<String> items1 = [];
  //
  //       await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('customers')
  //           .get()
  //           .then((QuerySnapshot querySnapshot) {
  //
  //         String sps = '^sps^';
  //         querySnapshot.docs.forEach((doc) {
  //           if(doc.id != 'name' && doc['customer_name'].toString().toLowerCase().contains(searchValue.toLowerCase())) {
  //             setState(() {
  //               items.add(doc.id + sps + doc['customer_name'] + sps + doc['customer_phone'] + sps + doc['customer_address']);
  //             });
  //
  //             // print(doc['prod_name'].toString());
  //           }
  //         });
  //
  //         if(items.length == 0) {
  //           setState(() {
  //             noSearchData = true;
  //           });
  //         } else {
  //           setState(() {
  //             noSearchData = false;
  //           });
  //         }
  //
  //
  //       });
  //
  //
  //       await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('merchants')
  //           .get()
  //           .then((QuerySnapshot querySnapshot) {
  //
  //         String sps = '^sps^';
  //         querySnapshot.docs.forEach((doc) {
  //           if(doc.id != 'name' && doc['merchant_name'].toString().toLowerCase().contains(searchValue.toLowerCase())) {
  //             setState(() {
  //               items1.add(doc.id + sps + doc['merchant_name'] + sps + doc['merchant_phone'] + sps + doc['merchant_address']);
  //             });
  //
  //             // print(doc['prod_name'].toString());
  //           }
  //         });
  //
  //         if(items1.length == 0) {
  //           setState(() {
  //             noSearchData = true;
  //           });
  //         } else {
  //           setState(() {
  //             noSearchData = false;
  //           });
  //         }
  //
  //
  //       });
  //
  //       setState(() {
  //         var sections = List<ExampleSection>.empty(growable: true);
  //         // var sections1 = List<ExampleSection>.empty(growable: true);
  //
  //         var init = ExampleSection()
  //           ..header = 'Customers^' + items.length.toString()
  //           ..items = items
  //           ..expanded = true;
  //
  //         var init1 = ExampleSection()
  //           ..header = 'Merchants^' + items1.length.toString()
  //           ..items = items1
  //           ..expanded = true;
  //
  //         // var buyOrders = ExampleSection()
  //         //   ..header = 'Products'
  //         //   ..items = ['']
  //         //   ..expanded = true;
  //         sections.add(init);
  //         sections.add(init1);
  //         // sections.add(buyOrders);
  //         sectionList1 = sections;
  //       });
  //
  //
  //     } else {
  //
  //       subTabController.animateTo(0, duration: Duration(microseconds: 0), curve: Curves.ease);
  //
  //       setState(() {
  //         var sections = List<ExampleSection>.empty(growable: true);
  //
  //         var init = ExampleSection()
  //           ..header = ''
  //           ..items = ['']
  //           ..expanded = true;
  //
  //         sections.add(init);
  //         // sections.add(buyOrders);
  //         sectionList = sections;
  //       });
  //       List<String> items = [];
  //
  //       await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products')
  //           .get()
  //           .then((QuerySnapshot querySnapshot) {
  //
  //         String sps = '^sps^';
  //         querySnapshot.docs.forEach((doc) {
  //           if(doc['prod_name'].toString().toLowerCase().contains(searchValue.toLowerCase())) {
  //             setState(() {
  //               items.add(doc.id + sps +
  //                   doc['prod_name'] + sps +
  //                   doc['img_1'] + sps +
  //                   doc['unit_sell'] + '-' + doc['inStock1'].toString() + '-' + doc['unit_name'] + sps +
  //                   doc['sub1_sell'] + '-' + doc['inStock2'].toString() + '-' + doc['sub1_name'] + sps +
  //                   doc['sub2_sell'] + '-' + doc['inStock2'].toString() + '-' + doc['sub2_name']);
  //             });
  //
  //             print(doc['prod_name'].toString());
  //           }
  //         });
  //
  //         if(items.length == 0) {
  //           setState(() {
  //             noSearchData = true;
  //           });
  //         } else {
  //           setState(() {
  //             noSearchData = false;
  //           });
  //         }
  //
  //
  //       });
  //
  //       setState(() {
  //         var sections = List<ExampleSection>.empty(growable: true);
  //
  //         var init = ExampleSection()
  //           ..header = 'Products^' + items.length.toString()
  //           ..items = items
  //           ..expanded = true;
  //
  //         // var buyOrders = ExampleSection()
  //         //   ..header = 'Products'
  //         //   ..items = ['']
  //         //   ..expanded = true;
  //         sections.add(init);
  //         // sections.add(buyOrders);
  //         sectionList = sections;
  //       });
  //
  //
  //     }
  //   } else {
  //     setState(() {
  //       noSearchData = true;
  //     });
  //   }
  //   Future.delayed(const Duration(milliseconds: 500), () async {
  //
  //
  //
  //     Future.delayed(const Duration(milliseconds: 500), () {
  //       setState(() {
  //         searchingOverAll = false;
  //       });
  //     });
  //   });
  //
  // }
  //
  // overAllSearch() {
  //   return StreamBuilder(
  //       stream: FirebaseFirestore.instance
  //           .collection('shops')
  //           .doc(shopId)
  //           .collection('products')
  //           .snapshots(),
  //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //         if(snapshot.hasData) {
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 80.0),
  //             child: IgnorePointer(
  //               ignoring: !loadingSearch,
  //               child: AnimatedOpacity(
  //                 opacity: loadingSearch ? 1 : 0,
  //                 duration: Duration(milliseconds: 170),
  //                 child: Align(
  //                   alignment: Alignment.topCenter,
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         border: Border(
  //                           top: BorderSide(
  //                               color: AppTheme.skBorderColor2,
  //                               // color: Colors.transparent,
  //                               width: 1.0),
  //                         )),
  //                     child: CustomScrollView(
  //                       slivers: <Widget>[
  //                         SliverAppBar(
  //                           elevation: 0,
  //                           backgroundColor: Colors.white,
  //
  //                           // Provide a standard title.
  //
  //                           // Allows the user to reveal the app bar if they begin scrolling
  //                           // back up the list of items.
  //                           floating: true,
  //                           bottom: PreferredSize(                       // Add this code
  //                             preferredSize: Size.fromHeight(-1),      // Add this code
  //                             child: Container(),                           // Add this code
  //                           ),
  //                           flexibleSpace: Padding(
  //                             padding: const EdgeInsets.only(left: 0.0, top: 0.5, bottom: 0.0),
  //                             child: Container(
  //                               height: 58,
  //                               width: MediaQuery.of(context).size.width,
  //                               // color: Colors.yellow,
  //                               child: Container(
  //                                 decoration: BoxDecoration(
  //                                     color: Colors.white,
  //                                     border: Border(
  //                                       bottom: BorderSide(
  //                                         // color: AppTheme.skBorderColor2,
  //                                           color: Colors.white,
  //                                           width: 1.0),
  //                                     )),
  //                                 child: Container(
  //                                   decoration: BoxDecoration(
  //                                       color: Colors.white,
  //                                       border: Border(
  //                                         bottom: BorderSide(
  //                                           // color: AppTheme.skBorderColor2,
  //                                             color: Colors.white,
  //                                             width: 1.0),
  //                                       )),
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.only(top: 12.0, bottom: 8.5, left: 15.0, right: 15.0),
  //                                     child: SizedBox(
  //                                       width: double.infinity,
  //                                       child: CupertinoSlidingSegmentedControl(
  //                                           children: {
  //                                             0: Text('Products'),
  //                                             1: Text('Buy/sellers'),
  //                                             2: Text('Orders'),
  //                                           },
  //                                           groupValue: slidingSearch,
  //                                           onValueChanged: (newValue) {
  //                                             setState(() {
  //                                               slidingSearch = int.parse(newValue.toString());
  //                                             });
  //                                             FocusScope.of(context).unfocus();
  //                                             searchValue = _searchController.text;
  //                                             searchKeyChanged();
  //                                             // searchKeyChanged();
  //                                           }),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //
  //                             ),
  //                           ),
  //                           // Display a placeholder widget to visualize the shrinking size.
  //                           // Make the initial height of the SliverAppBar larger than normal.
  //                           expandedHeight: 20,
  //                         ),
  //                         if(slidingSearch == 0)
  //                           SliverExpandableList(
  //                             builder: SliverExpandableChildDelegate(
  //                               sectionList: sectionList,
  //                               headerBuilder: _buildHeader4,
  //                               itemBuilder: (context, sectionIndex, itemIndex, index) {
  //                                 String item = sectionList[sectionIndex].items[itemIndex];
  //                                 int length = sectionList[sectionIndex].items.length;
  //                                 // if(sectionIndex == 0) {
  //                                 //   return Container(
  //                                 //     height: 0.1,
  //                                 //   );
  //                                 //   // return SliverFillRemaining(
  //                                 //   //   child: new Container(
  //                                 //   //     color: Colors.red,
  //                                 //   //   ),
  //                                 //   // );
  //                                 // }
  //
  //                                 if(searchValue != '' && slidingSearch == 0 && item.contains('^sps^')) {
  //                                   return GestureDetector(
  //                                     onTap: () {
  //                                       Navigator.push(
  //                                         context,
  //                                         MaterialPageRoute(
  //                                             builder: (context) => ProductDetailsView2(
  //                                               idString: item.split('^sps^')[0], toggleCoinCallback:
  //                                             addProduct1, toggleCoinCallback3: addProduct3, shopId: shopId.toString(),)),);
  //                                     },
  //                                     child: Container(
  //                                       color: AppTheme.lightBgColor,
  //                                       child: Padding(
  //                                         padding:
  //                                         EdgeInsets.only(top: index == 0? 10.0: 20.0),
  //                                         child: Container(
  //                                           width: MediaQuery.of(context)
  //                                               .size
  //                                               .width,
  //                                           decoration: BoxDecoration(
  //                                               border: Border(
  //                                                   bottom: index == snapshot.data!.docs.length-1 ?
  //                                                   BorderSide(
  //                                                       color: Colors.transparent,
  //                                                       width: 1.0) :
  //
  //                                                   BorderSide(
  //                                                       color: Colors.grey
  //                                                           .withOpacity(0.3),
  //                                                       width: 1.0)
  //                                               )),
  //                                           child: Padding(
  //                                             padding: const EdgeInsets.symmetric(horizontal: 15.0),
  //                                             child: Column(
  //                                               children: [
  //                                                 Row(
  //                                                   children: [
  //                                                     Column(
  //                                                       children: [
  //                                                         ClipRRect(
  //                                                             borderRadius:
  //                                                             BorderRadius
  //                                                                 .circular(
  //                                                                 5.0),
  //                                                             child: item.split('^sps^')[2] != ""
  //                                                                 ? CachedNetworkImage(
  //                                                               imageUrl:
  //                                                               'https://riftplus.me/smartkyat_pos/api/uploads/' +
  //                                                                   item.split('^sps^')[2],
  //                                                               width: 75,
  //                                                               height: 75,
  //                                                               // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
  //                                                               errorWidget: (context,
  //                                                                   url,
  //                                                                   error) =>
  //                                                                   Icon(Icons
  //                                                                       .error),
  //                                                               fadeInDuration:
  //                                                               Duration(
  //                                                                   milliseconds:
  //                                                                   100),
  //                                                               fadeOutDuration:
  //                                                               Duration(
  //                                                                   milliseconds:
  //                                                                   10),
  //                                                               fadeInCurve:
  //                                                               Curves
  //                                                                   .bounceIn,
  //                                                               fit: BoxFit
  //                                                                   .cover,
  //                                                             )
  //                                                                 : CachedNetworkImage(
  //                                                               imageUrl:
  //                                                               'https://riftplus.me/smartkyat_pos/api/uploads/shark1.jpg',
  //                                                               width: 75,
  //                                                               height: 75,
  //                                                               // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
  //                                                               errorWidget: (context,
  //                                                                   url,
  //                                                                   error) =>
  //                                                                   Icon(Icons
  //                                                                       .error),
  //                                                               fadeInDuration:
  //                                                               Duration(
  //                                                                   milliseconds:
  //                                                                   100),
  //                                                               fadeOutDuration:
  //                                                               Duration(
  //                                                                   milliseconds:
  //                                                                   10),
  //                                                               fadeInCurve:
  //                                                               Curves
  //                                                                   .bounceIn,
  //                                                               fit: BoxFit
  //                                                                   .cover,
  //                                                             )),
  //                                                       ],
  //                                                     ),
  //                                                     SizedBox(
  //                                                       width: 15,
  //                                                     ),
  //                                                     Column(
  //                                                       crossAxisAlignment:
  //                                                       CrossAxisAlignment
  //                                                           .start,
  //                                                       children: [
  //                                                         SizedBox(
  //                                                           height: 2,
  //                                                         ),
  //                                                         Text(
  //                                                           item.split('^sps^')[1],
  //                                                           style: TextStyle(
  //                                                             height: 1,
  //                                                             fontSize: 18,
  //                                                             fontWeight:
  //                                                             FontWeight.w500,
  //                                                           ),
  //                                                         ),
  //                                                         SizedBox(
  //                                                           height: 10,
  //                                                         ),
  //                                                         Row(
  //                                                           children: [
  //                                                             Text(
  //                                                               'MMK ' + item.split('^sps^')[3].split('-')[0],
  //                                                               style: TextStyle(
  //                                                                 height: 1.3,
  //                                                                 fontSize: 15,
  //                                                                 fontWeight:
  //                                                                 FontWeight.w500,
  //                                                               ),
  //                                                             ),
  //                                                             Text(
  //                                                               item.split('^sps^')[4].split('-')[2] != '' && item.split('^sps^')[5].split('-')[2] == '' ? ' - ' + item.split('^sps^')[4].split('-')[0] : item.split('^sps^')[4].split('-')[2] != '' && item.split('^sps^')[5].split('-')[2] != '' ? ' - ' + item.split('^sps^')[5].split('-')[0] : '',
  //                                                               style: TextStyle(
  //                                                                 height: 1.3,
  //                                                                 fontSize: 15,
  //                                                                 fontWeight:
  //                                                                 FontWeight.w500,
  //                                                               ),
  //                                                             ),
  //                                                           ],
  //                                                         ),
  //                                                         SizedBox(
  //                                                           height: 2,
  //                                                         ),
  //                                                         Row(
  //                                                           crossAxisAlignment: CrossAxisAlignment.start,
  //                                                           mainAxisAlignment: MainAxisAlignment.start,
  //                                                           children: [
  //                                                             Text(
  //                                                                 item.split('^sps^')[3].split('-')[1].toString()+ ' '  + item.split('^sps^')[3].split('-')[2] + ' ', style: TextStyle(
  //                                                               height: 1.3,
  //                                                               fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
  //                                                             )),
  //                                                             Padding(
  //                                                               padding: const EdgeInsets.only(top: 2.0),
  //                                                               child: Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
  //                                                             ),
  //
  //                                                             item.split('^sps^')[4].split('-')[2] != '' && item.split('^sps^')[5].split('-')[2] == ''?
  //                                                             Text(
  //                                                                 '  +1 Sub item', style: TextStyle(
  //                                                               height: 1.3,
  //                                                               fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
  //                                                             )) : item.split('^sps^')[4].split('-')[2] != '' && item.split('^sps^')[5].split('-')[2] != '' ? Text(
  //                                                                 '  +2 Sub items', style: TextStyle(
  //                                                               height: 1.3,
  //                                                               fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
  //                                                             )): Container(),
  //
  //                                                             // StreamBuilder(
  //                                                             //     stream: FirebaseFirestore
  //                                                             //         .instance
  //                                                             //         .collection(
  //                                                             //         'space')
  //                                                             //         .doc(
  //                                                             //         '0NHIS0Jbn26wsgCzVBKT')
  //                                                             //         .collection(
  //                                                             //         'shops')
  //                                                             //         .doc(
  //                                                             //         'PucvhZDuUz3XlkTgzcjb')
  //                                                             //         .collection(
  //                                                             //         'products')
  //                                                             //         .doc(version)
  //                                                             //         .collection(
  //                                                             //         'versions')
  //                                                             //         .where('type',
  //                                                             //         isEqualTo:
  //                                                             //         'sub3')
  //                                                             //         .snapshots(),
  //                                                             //     builder: (BuildContext
  //                                                             //     context,
  //                                                             //         AsyncSnapshot<
  //                                                             //             QuerySnapshot>
  //                                                             //         snapshot5) {
  //                                                             //       if (snapshot5
  //                                                             //           .hasData) {
  //                                                             //         int quantity3 =
  //                                                             //         0;
  //                                                             //         var sub3Quantity;
  //                                                             //         snapshot5
  //                                                             //             .data!
  //                                                             //             .docs
  //                                                             //             .map((DocumentSnapshot
  //                                                             //         document) {
  //                                                             //           Map<String,
  //                                                             //               dynamic>
  //                                                             //           data4 =
  //                                                             //           document.data()! as Map<
  //                                                             //               String,
  //                                                             //               dynamic>;
  //                                                             //           if (data4[
  //                                                             //           'unit_qtity'] !=
  //                                                             //               '') {
  //                                                             //             quantity3 +=
  //                                                             //                 int.parse(
  //                                                             //                     data4['unit_qtity']);
  //                                                             //             sub3Quantity =
  //                                                             //                 quantity3
  //                                                             //                     .toString();
  //                                                             //           } else
  //                                                             //             return Container();
  //                                                             //         }).toList();
  //                                                             //         // print(sub1Quantity);
  //                                                             //         // print(mainQuantity);
  //                                                             //         if (sub3Quantity !=
  //                                                             //             null) {
  //                                                             //           return Text(
  //                                                             //               '$sub3Quantity $sub3Name');
  //                                                             //         }
  //                                                             //         return Container();
  //                                                             //       }
  //                                                             //       return Container();
  //                                                             //     }),
  //                                                           ],
  //                                                         ),
  //
  //                                                         // Text(
  //                                                         //   'MMK',
  //                                                         //   style:
  //                                                         //       TextStyle(
  //                                                         //     fontSize: 14,
  //                                                         //     fontWeight: FontWeight.w400,
  //                                                         //     color: Colors.blueGrey.withOpacity(1.0),
  //                                                         //   ),
  //                                                         // ),
  //                                                         // SizedBox(
  //                                                         //   height:
  //                                                         //       7,
  //                                                         // ),
  //                                                         // Text(
  //                                                         //   '55',
  //                                                         //   style:
  //                                                         //       TextStyle(
  //                                                         //     fontSize: 14,
  //                                                         //     fontWeight: FontWeight.w400,
  //                                                         //     color: Colors.blueGrey.withOpacity(1.0),
  //                                                         //   ),
  //                                                         // ),
  //                                                       ],
  //                                                     ),
  //                                                     // Padding(
  //                                                     //   padding:
  //                                                     //       const EdgeInsets.only(
  //                                                     //           bottom: 20.0),
  //                                                     //   child: IconButton(
  //                                                     //     icon: Icon(
  //                                                     //       Icons
  //                                                     //           .arrow_forward_ios_rounded,
  //                                                     //       size: 16,
  //                                                     //       color: Colors.blueGrey
  //                                                     //           .withOpacity(0.8),
  //                                                     //     ),
  //                                                     //     onPressed: () {
  //                                                     //       Navigator.push(
  //                                                     //         context,
  //                                                     //         MaterialPageRoute(
  //                                                     //             builder: (context) => ProductDetailsView(
  //                                                     //                 idString: version, toggleCoinCallback:
  //                                                     //             addProduct1, toggleCoinCallback3: addProduct3)),);
  //                                                     //     },
  //                                                     //   ),
  //                                                     // ),
  //                                                     Spacer(),
  //                                                     Padding(
  //                                                       padding:
  //                                                       const EdgeInsets.only(
  //                                                           bottom: 6.0),
  //                                                       child: Icon(
  //                                                         Icons
  //                                                             .arrow_forward_ios_rounded,
  //                                                         size: 16,
  //                                                         color: Colors.blueGrey
  //                                                             .withOpacity(0.8),
  //                                                       ),),
  //                                                   ],
  //                                                 ),
  //                                                 SizedBox(height: 20),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   );
  //                                 } else if(slidingSearch == 1 && item.contains('^sps^')) {
  //                                   return GestureDetector(
  //                                     onTap: () {
  //                                       Navigator.push(
  //                                         context,
  //                                         MaterialPageRoute(
  //                                             builder: (
  //                                                 context) =>
  //                                                 CustomerInfoSubs(
  //                                                   id: item.split('^sps^')[0],
  //                                                   toggleCoinCallback: addCustomer2Cart1, shopId: shopId.toString(),)),
  //                                       );
  //                                     },
  //                                     child: Padding(
  //                                       padding:
  //                                       EdgeInsets.only(
  //                                           top: index == 0
  //                                               ? 10.0
  //                                               : 15.0),
  //                                       child: Container(
  //                                         width: MediaQuery
  //                                             .of(context)
  //                                             .size
  //                                             .width,
  //                                         decoration: BoxDecoration(
  //                                             border: Border(
  //                                                 bottom: index ==
  //                                                     length -
  //                                                         1
  //                                                     ?
  //                                                 BorderSide(
  //                                                     color: Colors.transparent,
  //                                                     width: 1.0)
  //                                                     :
  //
  //                                                 BorderSide(
  //                                                     color: Colors.grey
  //                                                         .withOpacity(
  //                                                         0.3),
  //                                                     width: 1.0)
  //                                             )),
  //                                         child: Column(
  //                                           children: [
  //                                             Padding(
  //                                               padding: const EdgeInsets
  //                                                   .only(
  //                                                   bottom: 18.0),
  //                                               child: ListTile(
  //                                                 title: Text(
  //                                                   item.split('^sps^')[1].toString(),
  //                                                   style: TextStyle(
  //                                                     fontSize: 18,
  //                                                     fontWeight:
  //                                                     FontWeight
  //                                                         .w500,
  //                                                   ),),
  //                                                 subtitle: Padding(
  //                                                   padding: const EdgeInsets
  //                                                       .only(
  //                                                       top: 8.0),
  //                                                   child: Column(
  //                                                     crossAxisAlignment: CrossAxisAlignment
  //                                                         .start,
  //                                                     children: [
  //                                                       Text(
  //                                                           item.split('^sps^')[2].toString(),
  //                                                           style: TextStyle(
  //                                                             fontSize: 14,
  //                                                             fontWeight: FontWeight
  //                                                                 .w500,
  //                                                             color: Colors.grey,
  //                                                           )),
  //                                                       SizedBox(
  //                                                         height: 5,),
  //                                                       Text(
  //                                                           item.split('^sps^')[3].toString(),
  //                                                           style: TextStyle(
  //                                                             fontSize: 14,
  //                                                             fontWeight: FontWeight
  //                                                                 .w500,
  //                                                             color: Colors.grey,
  //                                                           )),
  //                                                     ],
  //                                                   ),
  //                                                 ),
  //                                                 trailing: Padding(
  //                                                   padding: const EdgeInsets
  //                                                       .only(
  //                                                       top: 10.0),
  //                                                   child: Container(
  //                                                     child: Row(
  //                                                       mainAxisSize: MainAxisSize.min,
  //                                                       mainAxisAlignment: MainAxisAlignment.start,
  //                                                       crossAxisAlignment: CrossAxisAlignment.start,
  //                                                       children: [
  //                                                         StreamBuilder(
  //                                                             stream: FirebaseFirestore.instance
  //                                                                 .collection('shops')
  //                                                                 .doc(shopId)
  //                                                                 .collection('customers')
  //                                                                 .doc(item.split('^sps^')[0].toString())
  //                                                                 .collection('orders')
  //                                                                 .where('debt', isGreaterThan: 0)
  //                                                                 .snapshots(),
  //                                                             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
  //                                                               // orderList[index] = 0;
  //                                                               int orderLength = 0;
  //                                                               int i = 0;
  //                                                               if(snapshot2.hasData) {
  //                                                                 return snapshot2.data!.docs.length > 0? Container(
  //                                                                   height: 21,
  //                                                                   decoration: BoxDecoration(
  //                                                                     borderRadius: BorderRadius.circular(20.0),
  //                                                                     color: AppTheme.badgeFgDanger,
  //                                                                   ),
  //                                                                   child: Padding(
  //                                                                     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
  //                                                                     child: Text(snapshot2.data!.docs.length.toString() + ' unpaid',
  //                                                                       style: TextStyle(
  //                                                                           fontSize: 13,
  //                                                                           fontWeight: FontWeight.w500,
  //                                                                           color: Colors.white
  //                                                                       ),
  //                                                                     ),
  //                                                                   ),
  //                                                                 ): Container(
  //                                                                 );
  //                                                                 // int quantity = 0;
  //                                                                 // snapshot2.data!.docs.map((DocumentSnapshot document2) {
  //                                                                 //   Map<String, dynamic> data2 = document2.data()! as Map<String, dynamic>;
  //                                                                 //   orders = data2['daily_order'];
  //                                                                 //   quantity += int.parse(orders.length.toString());
  //                                                                 //
  //                                                                 //   return Text(snapshot2.data!.docs[index].id);
  //                                                                 // }).toList();
  //                                                               }
  //                                                               return Container();
  //                                                             }
  //                                                         ),
  //
  //                                                         // Container(
  //                                                         //   height: 21,
  //                                                         //   decoration: BoxDecoration(
  //                                                         //     borderRadius: BorderRadius.circular(20.0),
  //                                                         //     color: AppTheme.badgeFgDanger,
  //                                                         //   ),
  //                                                         //   child: Padding(
  //                                                         //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
  //                                                         //     child: Text(unpaidCount(index).toString() + ' unpaid',
  //                                                         //       style: TextStyle(
  //                                                         //           fontSize: 13,
  //                                                         //           fontWeight: FontWeight.w500,
  //                                                         //           color: Colors.white
  //                                                         //       ),
  //                                                         //     ),
  //                                                         //   ),
  //                                                         // ),
  //
  //                                                         // Text(orderList.toString()),
  //
  //                                                         // Container(
  //                                                         //   height: 21,
  //                                                         //   decoration: BoxDecoration(
  //                                                         //     borderRadius: BorderRadius.circular(20.0),
  //                                                         //     color: AppTheme.badgeFgDanger,
  //                                                         //   ),
  //                                                         //   child: Padding(
  //                                                         //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
  //                                                         //     child: Text('2 unpaid',
  //                                                         //       style: TextStyle(
  //                                                         //           fontSize: 13,
  //                                                         //           fontWeight: FontWeight.w500,
  //                                                         //           color: Colors.white
  //                                                         //       ),
  //                                                         //     ),
  //                                                         //   ),
  //                                                         // )
  //
  //                                                         // Container(
  //                                                         //   height: 21,
  //                                                         //   decoration: BoxDecoration(
  //                                                         //     borderRadius: BorderRadius.circular(20.0),
  //                                                         //     color: AppTheme.badgeFgDanger,
  //                                                         //   ),
  //                                                         //   child: Padding(
  //                                                         //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
  //                                                         //     child: Text(unpaidCount(index).toString() + ' unpaid',
  //                                                         //       style: TextStyle(
  //                                                         //           fontSize: 13,
  //                                                         //           fontWeight: FontWeight.w500,
  //                                                         //           color: Colors.white
  //                                                         //       ),
  //                                                         //     ),
  //                                                         //   ),
  //                                                         // ),
  //                                                         SizedBox(
  //                                                             width: 12),
  //                                                         Padding(
  //                                                           padding: const EdgeInsets.only(top: 2.0),
  //                                                           child: Icon(
  //                                                             Icons
  //                                                                 .arrow_forward_ios_rounded,
  //                                                             size: 16,
  //                                                             color: Colors.blueGrey
  //                                                                 .withOpacity(
  //                                                                 0.8),
  //                                                           ),
  //                                                         ),
  //                                                       ],
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //
  //                                               ),
  //                                             )
  //
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   );
  //                                 } else if(searchValue == '') {
  //                                   return Container();
  //                                 }
  //                                 return Container(
  //                                   // child: Text('Loading...')
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //
  //
  //                         // if(slidingSearch == 1)
  //                         //   SliverPersistentHeader(
  //                         //     pinned: true,
  //                         //     delegate: SliverAppBarDelegate1(
  //                         //         child: PreferredSize(
  //                         //           preferredSize: Size.fromHeight(33.0),
  //                         //           child: Container(
  //                         //             width: double.infinity,
  //                         //             height: 33,
  //                         //             decoration: BoxDecoration(
  //                         //                 color: Colors.white,
  //                         //                 border: Border(
  //                         //                   bottom: BorderSide(
  //                         //                       color: AppTheme.skBorderColor2,
  //                         //                       width: 1.0),
  //                         //                 )
  //                         //             ),
  //                         //             child: Padding(
  //                         //               // padding: const EdgeInsets.only(left: 15.0, top: 12, bottom: 0),
  //                         //               padding: const EdgeInsets.only(left: 15.0, top: 1, bottom: 0),
  //                         //               child: Row(
  //                         //                 children: [
  //                         //                   Text(
  //                         //                     'BUY',
  //                         //                     // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                         //                     style: TextStyle(
  //                         //                         height: 0.8,
  //                         //                         fontSize: 14,
  //                         //                         fontWeight: FontWeight.w600,
  //                         //                         letterSpacing: 1.2,
  //                         //                         color: Colors.black
  //                         //                     ),
  //                         //                   ),
  //                         //                   Padding(
  //                         //                     padding: const EdgeInsets.only(left: 4.0, right: 5.0, bottom: 3.0),
  //                         //                     child: FlutterSwitch(
  //                         //                       width: 31.0,
  //                         //                       height: 18.0,
  //                         //                       valueFontSize: 5.0,
  //                         //                       toggleSize: 13.0,
  //                         //                       padding: 2.5,
  //                         //                       value: buySellerStatus,
  //                         //                       onToggle: (val) {
  //                         //                         setState(() {
  //                         //                           buySellerStatus = val;
  //                         //                         });
  //                         //                       },
  //                         //                     ),
  //                         //                   ),
  //                         //                   Text(
  //                         //                     'SELLERS',
  //                         //                     // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                         //                     style: TextStyle(
  //                         //                         height: 0.8,
  //                         //                         fontSize: 14,
  //                         //                         fontWeight: FontWeight.w600,
  //                         //                         letterSpacing: 1.2,
  //                         //                         color: Colors.black
  //                         //                     ),
  //                         //                   ),
  //                         //                   Expanded(
  //                         //                     child: Padding(
  //                         //                       padding: const EdgeInsets.only(right: 15.0),
  //                         //                       child: Text(/
  //                         //                         '0',
  //                         //                         // '#' + sectionList[sectionIndex].items.length.toString(),
  //                         //                         // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                         //                         style: TextStyle(
  //                         //                           height: 0.8,
  //                         //                           fontSize: 14,
  //                         //                           fontWeight: FontWeight.w600,
  //                         //                           letterSpacing: 1.2,
  //                         //                           color: Colors.black,
  //                         //                         ),
  //                         //                         textAlign: TextAlign.right,
  //                         //                       ),
  //                         //                     ),
  //                         //                   ),
  //                         //                 ],
  //                         //               ),
  //                         //             ),
  //                         //           ),
  //                         //         )
  //                         //     ),
  //                         //   ),
  //                         if(slidingSearch == 1)
  //                           SliverExpandableList(
  //                             builder: SliverExpandableChildDelegate(
  //                               sectionList: sectionList1,
  //                               headerBuilder: _buildHeader1,
  //                               itemBuilder: (context, sectionIndex, itemIndex, index) {
  //                                 String item = sectionList1[sectionIndex].items[itemIndex];
  //                                 int length = sectionList1[sectionIndex].items.length;
  //                                 // if(sectionIndex == 0) {
  //                                 //   return Container(
  //                                 //     height: 0.1,
  //                                 //   );
  //                                 //   // return SliverFillRemaining(
  //                                 //   //   child: new Container(
  //                                 //   //     color: Colors.red,
  //                                 //   //   ),
  //                                 //   // );
  //                                 // }
  //
  //                                 if(searchValue == '') {
  //                                   return Container();
  //                                 }
  //                                 if(item == '') {
  //                                   return Container();
  //                                 } else {
  //                                   if(sectionIndex == 0) {
  //                                     return GestureDetector(
  //                                       onTap: () {
  //                                         Navigator.push(
  //                                           context,
  //                                           MaterialPageRoute(
  //                                               builder: (
  //                                                   context) =>
  //                                                   CustomerInfoSubs(
  //                                                     id: item.split('^sps^')[0],
  //                                                     toggleCoinCallback: addCustomer2Cart1, shopId: shopId.toString(),)),
  //                                         );
  //                                       },
  //                                       child: Container(
  //                                         color: AppTheme.lightBgColor,
  //                                         child: Padding(
  //                                           padding:
  //                                           EdgeInsets.only(
  //                                               top: 15.0),
  //                                           child: Container(
  //                                             width: MediaQuery
  //                                                 .of(context)
  //                                                 .size
  //                                                 .width,
  //                                             decoration: BoxDecoration(
  //                                                 border: Border(
  //                                                     bottom: index ==
  //                                                         length
  //                                                         ?
  //                                                     BorderSide(
  //                                                         color: Colors.grey
  //                                                             .withOpacity(
  //                                                             0.3),
  //                                                         width: 1.0)
  //                                                         :
  //
  //                                                     BorderSide(
  //                                                         color: Colors.grey
  //                                                             .withOpacity(
  //                                                             0.3),
  //                                                         width: 1.0)
  //                                                 )),
  //                                             child: Column(
  //                                               children: [
  //                                                 Padding(
  //                                                   padding: const EdgeInsets
  //                                                       .only(
  //                                                       bottom: 18.0),
  //                                                   child: ListTile(
  //                                                     title: Text(
  //                                                       item.split('^sps^')[1].toString(),
  //                                                       style: TextStyle(
  //                                                         fontSize: 18,
  //                                                         fontWeight:
  //                                                         FontWeight
  //                                                             .w500,
  //                                                       ),),
  //                                                     subtitle: Padding(
  //                                                       padding: const EdgeInsets
  //                                                           .only(
  //                                                           top: 8.0),
  //                                                       child: Column(
  //                                                         crossAxisAlignment: CrossAxisAlignment
  //                                                             .start,
  //                                                         children: [
  //                                                           Text(
  //                                                               item.split('^sps^')[2].toString(),
  //                                                               // 'sps',
  //                                                               style: TextStyle(
  //                                                                 fontSize: 14,
  //                                                                 fontWeight: FontWeight
  //                                                                     .w500,
  //                                                                 color: Colors.grey,
  //                                                               )),
  //                                                           SizedBox(
  //                                                             height: 5,),
  //                                                           Text(
  //                                                             // 'sps',
  //                                                               item.split('^sps^')[3].toString(),
  //                                                               style: TextStyle(
  //                                                                 fontSize: 14,
  //                                                                 fontWeight: FontWeight
  //                                                                     .w500,
  //                                                                 color: Colors.grey,
  //                                                               )),
  //                                                         ],
  //                                                       ),
  //                                                     ),
  //                                                     trailing: Padding(
  //                                                       padding: const EdgeInsets
  //                                                           .only(
  //                                                           top: 10.0),
  //                                                       child: Container(
  //                                                         child: Row(
  //                                                           mainAxisSize: MainAxisSize.min,
  //                                                           mainAxisAlignment: MainAxisAlignment.start,
  //                                                           crossAxisAlignment: CrossAxisAlignment.start,
  //                                                           children: [
  //                                                             StreamBuilder(
  //                                                                 stream: FirebaseFirestore.instance
  //                                                                     .collection('shops')
  //                                                                     .doc(shopId)
  //                                                                     .collection('customers')
  //                                                                     .doc(item.split('^sps^')[0].toString())
  //                                                                     .collection('orders')
  //                                                                     .where('debt', isGreaterThan: 0)
  //                                                                     .snapshots(),
  //                                                                 builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
  //                                                                   // orderList[index] = 0;
  //                                                                   int orderLength = 0;
  //                                                                   int i = 0;
  //                                                                   if(snapshot2.hasData) {
  //                                                                     return snapshot2.data!.docs.length > 0? Container(
  //                                                                       height: 21,
  //                                                                       decoration: BoxDecoration(
  //                                                                         borderRadius: BorderRadius.circular(20.0),
  //                                                                         color: AppTheme.badgeFgDanger,
  //                                                                       ),
  //                                                                       child: Padding(
  //                                                                         padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
  //                                                                         child: Text(snapshot2.data!.docs.length.toString() + ' unpaid',
  //                                                                           style: TextStyle(
  //                                                                               fontSize: 13,
  //                                                                               fontWeight: FontWeight.w500,
  //                                                                               color: Colors.white
  //                                                                           ),
  //                                                                         ),
  //                                                                       ),
  //                                                                     ): Container(
  //                                                                     );
  //                                                                     // int quantity = 0;
  //                                                                     // snapshot2.data!.docs.map((DocumentSnapshot document2) {
  //                                                                     //   Map<String, dynamic> data2 = document2.data()! as Map<String, dynamic>;
  //                                                                     //   orders = data2['daily_order'];
  //                                                                     //   quantity += int.parse(orders.length.toString());
  //                                                                     //
  //                                                                     //   return Text(snapshot2.data!.docs[index].id);
  //                                                                     // }).toList();
  //                                                                   }
  //                                                                   return Container();
  //                                                                 }
  //                                                             ),
  //                                                             SizedBox(
  //                                                                 width: 12),
  //                                                             Padding(
  //                                                               padding: const EdgeInsets.only(top: 2.0),
  //                                                               child: Icon(
  //                                                                 Icons
  //                                                                     .arrow_forward_ios_rounded,
  //                                                                 size: 16,
  //                                                                 color: Colors.blueGrey
  //                                                                     .withOpacity(
  //                                                                     0.8),
  //                                                               ),
  //                                                             ),
  //                                                           ],
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //
  //                                                   ),
  //                                                 )
  //
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     );
  //                                   }
  //                                 }
  //                                 return GestureDetector(
  //                                   onTap: () {
  //                                     Navigator.push(
  //                                       context,
  //                                       MaterialPageRoute(
  //                                           builder: (
  //                                               context) =>
  //                                               MerchantInfoSubs(
  //                                                 id: item.split('^sps^')[0],
  //                                                 toggleCoinCallback: addMerchant2Cart, shopId: shopId.toString(),)),
  //                                     );
  //                                   },
  //                                   child: Container(
  //                                     color: AppTheme.lightBgColor,
  //                                     child: Padding(
  //                                       padding:
  //                                       EdgeInsets.only(
  //                                           top: 15.0),
  //                                       child: Container(
  //                                         width: MediaQuery
  //                                             .of(context)
  //                                             .size
  //                                             .width,
  //                                         decoration: BoxDecoration(
  //                                             border: Border(
  //                                                 bottom: index ==
  //                                                     length
  //                                                     ?
  //                                                 BorderSide(
  //                                                     color: Colors.grey
  //                                                         .withOpacity(
  //                                                         0.3),
  //                                                     width: 1.0)
  //                                                     :
  //
  //                                                 BorderSide(
  //                                                     color: Colors.grey
  //                                                         .withOpacity(
  //                                                         0.3),
  //                                                     width: 1.0)
  //                                             )),
  //                                         child: Column(
  //                                           children: [
  //                                             Padding(
  //                                               padding: const EdgeInsets
  //                                                   .only(
  //                                                   bottom: 18.0),
  //                                               child: ListTile(
  //                                                 title: Text(
  //                                                   item.split('^sps^')[1].toString(),
  //                                                   style: TextStyle(
  //                                                     fontSize: 18,
  //                                                     fontWeight:
  //                                                     FontWeight
  //                                                         .w500,
  //                                                   ),),
  //                                                 subtitle: Padding(
  //                                                   padding: const EdgeInsets
  //                                                       .only(
  //                                                       top: 8.0),
  //                                                   child: Column(
  //                                                     crossAxisAlignment: CrossAxisAlignment
  //                                                         .start,
  //                                                     children: [
  //                                                       Text(
  //                                                           item.split('^sps^')[2].toString(),
  //                                                           // 'sps',
  //                                                           style: TextStyle(
  //                                                             fontSize: 14,
  //                                                             fontWeight: FontWeight
  //                                                                 .w500,
  //                                                             color: Colors.grey,
  //                                                           )),
  //                                                       SizedBox(
  //                                                         height: 5,),
  //                                                       Text(
  //                                                         // 'sps',
  //                                                           item.split('^sps^')[3].toString(),
  //                                                           style: TextStyle(
  //                                                             fontSize: 14,
  //                                                             fontWeight: FontWeight
  //                                                                 .w500,
  //                                                             color: Colors.grey,
  //                                                           )),
  //                                                     ],
  //                                                   ),
  //                                                 ),
  //                                                 trailing: Padding(
  //                                                   padding: const EdgeInsets
  //                                                       .only(
  //                                                       top: 10.0),
  //                                                   child: Container(
  //                                                     child: Row(
  //                                                       mainAxisSize: MainAxisSize.min,
  //                                                       mainAxisAlignment: MainAxisAlignment.start,
  //                                                       crossAxisAlignment: CrossAxisAlignment.start,
  //                                                       children: [
  //                                                         StreamBuilder(
  //                                                             stream: FirebaseFirestore.instance
  //                                                                 .collection('shops')
  //                                                                 .doc(shopId)
  //                                                                 .collection('merchants')
  //                                                                 .doc(item.split('^sps^')[0].toString())
  //                                                                 .collection('buyOrders')
  //                                                                 .where('debt', isGreaterThan: 0)
  //                                                                 .snapshots(),
  //                                                             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
  //                                                               // orderList[index] = 0;
  //                                                               int orderLength = 0;
  //                                                               int i = 0;
  //                                                               if(snapshot2.hasData) {
  //                                                                 return snapshot2.data!.docs.length > 0? Container(
  //                                                                   height: 21,
  //                                                                   decoration: BoxDecoration(
  //                                                                     borderRadius: BorderRadius.circular(20.0),
  //                                                                     color: AppTheme.badgeFgDanger,
  //                                                                   ),
  //                                                                   child: Padding(
  //                                                                     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
  //                                                                     child: Text(snapshot2.data!.docs.length.toString() + ' unpaid',
  //                                                                       style: TextStyle(
  //                                                                           fontSize: 13,
  //                                                                           fontWeight: FontWeight.w500,
  //                                                                           color: Colors.white
  //                                                                       ),
  //                                                                     ),
  //                                                                   ),
  //                                                                 ): Container(
  //                                                                 );
  //                                                                 // int quantity = 0;
  //                                                                 // snapshot2.data!.docs.map((DocumentSnapshot document2) {
  //                                                                 //   Map<String, dynamic> data2 = document2.data()! as Map<String, dynamic>;
  //                                                                 //   orders = data2['daily_order'];
  //                                                                 //   quantity += int.parse(orders.length.toString());
  //                                                                 //
  //                                                                 //   return Text(snapshot2.data!.docs[index].id);
  //                                                                 // }).toList();
  //                                                               }
  //                                                               return Container();
  //                                                             }
  //                                                         ),
  //                                                         SizedBox(
  //                                                             width: 12),
  //                                                         Padding(
  //                                                           padding: const EdgeInsets.only(top: 2.0),
  //                                                           child: Icon(
  //                                                             Icons
  //                                                                 .arrow_forward_ios_rounded,
  //                                                             size: 16,
  //                                                             color: Colors.blueGrey
  //                                                                 .withOpacity(
  //                                                                 0.8),
  //                                                           ),
  //                                                         ),
  //                                                       ],
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //
  //                                               ),
  //                                             )
  //
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //                         // if(slidingSearch == 1)
  //                         //   SliverPersistentHeader(
  //                         //     pinned: true,
  //                         //     delegate: SliverAppBarDelegate(
  //                         //         child: PreferredSize(
  //                         //           preferredSize: Size.fromHeight(33.0),
  //                         //           child: Container(
  //                         //             width: double.infinity,
  //                         //             height: 33,
  //                         //             decoration: BoxDecoration(
  //                         //                 color: Colors.white,
  //                         //                 border: Border(
  //                         //                   bottom: BorderSide(
  //                         //                       color: AppTheme.skBorderColor2,
  //                         //                       width: 1.0),
  //                         //                 )
  //                         //             ),
  //                         //             child: Padding(
  //                         //               // padding: const EdgeInsets.only(left: 15.0, top: 12, bottom: 0),
  //                         //               padding: const EdgeInsets.only(left: 15.0, top: 1, bottom: 0),
  //                         //               child: Row(
  //                         //                 children: [
  //                         //                   Text(
  //                         //                     'SELLERS',
  //                         //                     // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                         //                     style: TextStyle(
  //                         //                         height: 0.8,
  //                         //                         fontSize: 14,
  //                         //                         fontWeight: FontWeight.w600,
  //                         //                         letterSpacing: 1.2,
  //                         //                         color: Colors.black
  //                         //                     ),
  //                         //                   ),
  //                         //
  //                         //                   Expanded(
  //                         //                     child: Padding(
  //                         //                       padding: const EdgeInsets.only(right: 15.0),
  //                         //                       child: Text(
  //                         //                         '0',
  //                         //                         // '#' + sectionList[sectionIndex].items.length.toString(),
  //                         //                         // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                         //                         style: TextStyle(
  //                         //                           height: 0.8,
  //                         //                           fontSize: 14,
  //                         //                           fontWeight: FontWeight.w600,
  //                         //                           letterSpacing: 1.2,
  //                         //                           color: Colors.black,
  //                         //                         ),
  //                         //                         textAlign: TextAlign.right,
  //                         //                       ),
  //                         //                     ),
  //                         //                   ),
  //                         //                 ],
  //                         //               ),
  //                         //             ),
  //                         //           ),
  //                         //         )
  //                         //     ),
  //                         //   ),
  //                         // if(slidingSearch == 1)
  //                         //   SliverList(
  //                         //     delegate: SliverChildListDelegate(
  //                         //       [
  //                         //         Container(
  //                         //           height: 100,
  //                         //           color: AppTheme.lightBgColor,
  //                         //           child: Padding(
  //                         //             padding: const EdgeInsets.all(15.0),
  //                         //             child: Text('Each seller'),
  //                         //           ),
  //                         //         ),
  //                         //       ],
  //                         //     ),
  //                         //   ),
  //
  //
  //                         if(slidingSearch == 2)
  //                           SliverExpandableList(
  //                             builder: SliverExpandableChildDelegate(
  //                               sectionList: sectionList2,
  //                               headerBuilder: _buildHeader2,
  //                               itemBuilder: (context, sectionIndex, itemIndex, index) {
  //                                 String item = sectionList2[sectionIndex].items[itemIndex];
  //                                 int length = sectionList2[sectionIndex].items.length;
  //                                 // if(sectionIndex == 0) {
  //                                 //   return Container(
  //                                 //     height: 0.1,
  //                                 //   );
  //                                 //   // return SliverFillRemaining(
  //                                 //   //   child: new Container(
  //                                 //   //     color: Colors.red,
  //                                 //   //   ),
  //                                 //   // );
  //                                 // }
  //
  //                                 if(searchValue == '') {
  //                                   return Container();
  //                                 }
  //                                 if(item == '') {
  //                                   return Container();
  //                                 } else {
  //                                   if(item.split('^')[7] == 'b') {
  //                                     return GestureDetector(
  //                                       onTap: () {
  //                                         // print(item.split('^')[1]);
  //                                         Navigator.push(
  //                                           context,
  //                                           MaterialPageRoute(
  //                                               builder: (context) => BuyListInfo(data: item, toggleCoinCallback: () {}, shopId: shopId.toString(),)),
  //                                         );
  //                                       },
  //                                       child: Stack(
  //                                         alignment: Alignment.center,
  //
  //                                         children: [
  //                                           Padding(
  //                                             padding: const EdgeInsets.only(left: 0.0, right: 0.0),
  //                                             child: Container(
  //                                               decoration: BoxDecoration(
  //                                                   color: AppTheme.lightBgColor,
  //                                                   border: Border(
  //                                                     bottom: BorderSide(
  //                                                         color: AppTheme.skBorderColor2,
  //                                                         width: 1.0),
  //                                                   )),
  //                                               child: Padding(
  //                                                 padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
  //                                                 child: Column(
  //                                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                                   children: [
  //                                                     Padding(
  //                                                       padding: const EdgeInsets.only(left: 1.0),
  //                                                       child: Column(
  //                                                         mainAxisAlignment: MainAxisAlignment.start,
  //                                                         crossAxisAlignment: CrossAxisAlignment.start,
  //                                                         children: [
  //                                                           Row(
  //                                                             mainAxisAlignment: MainAxisAlignment.start,
  //                                                             children: [
  //                                                               Text('#' + item.split('^')[1],
  //                                                                 style: TextStyle(
  //                                                                     fontSize: 16,
  //                                                                     fontWeight: FontWeight.w500
  //                                                                 ),
  //                                                               ),
  //                                                               SizedBox(width: 8),
  //                                                               Padding(
  //                                                                 padding: const EdgeInsets.only(bottom: 1.0),
  //                                                                 child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
  //                                                               ),
  //                                                               SizedBox(width: 4),
  //                                                               Text(convertToHour(item.split('^')[0]) + ':' + item.split('^')[0].substring(10,12) +' ' + convertToAMPM(item.split('^')[0]),
  //                                                                 style: TextStyle(
  //                                                                   fontSize: 13,
  //                                                                   fontWeight: FontWeight.w400,
  //                                                                   color: Colors.grey,
  //                                                                 ),
  //                                                               ),
  //                                                             ],
  //                                                           ),
  //                                                           // Padding(
  //                                                           //   padding: const EdgeInsets.only(top: 8.0, bottom: 3.0),
  //                                                           //   child: Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2)),
  //                                                           // ),
  //                                                           SizedBox(
  //                                                             height: 6,
  //                                                           ),
  //                                                           Row(
  //                                                             children: [
  //                                                               Text(item.split('^')[3].split('&')[0],
  //                                                                 style: TextStyle(
  //                                                                   fontSize: 15,
  //                                                                   fontWeight: FontWeight.w500,
  //                                                                   color: Colors.grey,
  //                                                                 ),),
  //
  //                                                             ],
  //                                                           ),
  //                                                         ],
  //                                                       ),
  //                                                     ),
  //                                                     SizedBox(
  //                                                       height: 8,
  //                                                     ),
  //                                                     Row(
  //                                                       children: [
  //                                                         if(item.split('^')[5] == '0.0')
  //                                                           Padding(
  //                                                             padding: const EdgeInsets.only(left: 0.0),
  //                                                             child: Container(
  //                                                               height: 21,
  //                                                               decoration: BoxDecoration(
  //                                                                 borderRadius: BorderRadius.circular(20.0),
  //                                                                 color: AppTheme.badgeBgSuccess,
  //                                                               ),
  //                                                               child: Padding(
  //                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                                 child: Text('Paid',
  //                                                                   style: TextStyle(
  //                                                                       fontSize: 13,
  //                                                                       fontWeight: FontWeight.w500,
  //                                                                       color: Colors.white
  //                                                                   ),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //
  //                                                         if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
  //                                                           Padding(
  //                                                             padding: const EdgeInsets.only(left: 0.0),
  //                                                             child: Container(
  //                                                               height: 21,
  //                                                               decoration: BoxDecoration(
  //                                                                 borderRadius: BorderRadius.circular(20.0),
  //                                                                 color: AppTheme.badgeFgDangerLight,
  //                                                               ),
  //                                                               child: Padding(
  //                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                                 child: Text('Partially paid',
  //                                                                   style: TextStyle(
  //                                                                       fontSize: 13,
  //                                                                       fontWeight: FontWeight.w500,
  //                                                                       color: AppTheme.badgeFgDanger
  //                                                                   ),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //                                                         if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
  //                                                           Padding(
  //                                                             padding: const EdgeInsets.only(left: 0.0),
  //                                                             child: Container(
  //                                                               height: 21,
  //                                                               decoration: BoxDecoration(
  //                                                                 borderRadius: BorderRadius.circular(20.0),
  //                                                                 color: AppTheme.badgeFgDanger,
  //                                                               ),
  //                                                               child: Padding(
  //                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                                 child: Text('Unpaid',
  //                                                                   style: TextStyle(
  //                                                                       fontSize: 13,
  //                                                                       fontWeight: FontWeight.w500,
  //                                                                       color: Colors.white
  //                                                                   ),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //                                                         if(item.split('^')[4][0] == 'r')
  //                                                           Padding(
  //                                                             padding: const EdgeInsets.only(left: 6.0),
  //                                                             child: Container(
  //                                                               height: 21,
  //                                                               decoration: BoxDecoration(
  //                                                                 borderRadius: BorderRadius.circular(20.0),
  //                                                                 color: AppTheme.badgeBgSecond,
  //                                                               ),
  //                                                               child: Padding(
  //                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                                 child: Text('Refunded',
  //                                                                   style: TextStyle(
  //                                                                       fontSize: 13,
  //                                                                       fontWeight: FontWeight.w500,
  //                                                                       color: Colors.white
  //                                                                   ),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //
  //                                                         if(item.split('^')[4][0] == 's')
  //                                                           Padding(
  //                                                             padding: const EdgeInsets.only(left: 6.0),
  //                                                             child: Container(
  //                                                               height: 21,
  //                                                               decoration: BoxDecoration(
  //                                                                 borderRadius: BorderRadius.circular(20.0),
  //                                                                 color: AppTheme.badgeBgSecondLight,
  //                                                               ),
  //                                                               child: Padding(
  //                                                                 padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
  //                                                                 child: Text('Partially refunded',
  //                                                                   style: TextStyle(
  //                                                                       fontSize: 13,
  //                                                                       fontWeight: FontWeight.w500,
  //                                                                       color: AppTheme.badgeBgSecond
  //                                                                   ),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //
  //                                                       ],
  //                                                     )
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                           Padding(
  //                                             padding: const EdgeInsets.only(right: 15.0, bottom: 5),
  //                                             child: Align(
  //                                               alignment: Alignment.centerRight,
  //                                               child: Row(
  //                                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                                 children: [
  //                                                   Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
  //                                                     fontSize: 15,
  //                                                     fontWeight: FontWeight.w500,
  //                                                   )),
  //                                                   SizedBox(width: 10),
  //                                                   Padding(
  //                                                     padding: const EdgeInsets.only(bottom: 2.0),
  //                                                     child: Icon(
  //                                                       Icons
  //                                                           .arrow_forward_ios_rounded,
  //                                                       size: 16,
  //                                                       color: Colors.blueGrey
  //                                                           .withOpacity(
  //                                                           0.8),
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                     );
  //                                   } else {
  //                                     return GestureDetector(
  //                                       onTap: () {
  //                                         // print(item.split('^')[1]);
  //                                         Navigator.push(
  //                                           context,
  //                                           MaterialPageRoute(
  //                                               builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {}, shopId: shopId.toString(),)),
  //                                         );
  //                                       },
  //                                       child: Stack(
  //                                         alignment: Alignment.center,
  //
  //                                         children: [
  //                                           Padding(
  //                                             padding: const EdgeInsets.only(left: 0.0, right: 0.0),
  //                                             child: Container(
  //                                               decoration: BoxDecoration(
  //                                                   color: AppTheme.lightBgColor,
  //                                                   border: Border(
  //                                                     bottom: BorderSide(
  //                                                         color: AppTheme.skBorderColor2,
  //                                                         width: 1.0),
  //                                                   )),
  //                                               child: Padding(
  //                                                 padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
  //                                                 child: Column(
  //                                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                                   children: [
  //                                                     Padding(
  //                                                       padding: const EdgeInsets.only(left: 1.0),
  //                                                       child: Column(
  //                                                         mainAxisAlignment: MainAxisAlignment.start,
  //                                                         crossAxisAlignment: CrossAxisAlignment.start,
  //                                                         children: [
  //                                                           Row(
  //                                                             mainAxisAlignment: MainAxisAlignment.start,
  //                                                             children: [
  //                                                               Text('#' + item.split('^')[1],
  //                                                                 style: TextStyle(
  //                                                                     fontSize: 16,
  //                                                                     fontWeight: FontWeight.w500
  //                                                                 ),
  //                                                               ),
  //                                                               SizedBox(width: 8),
  //                                                               Padding(
  //                                                                 padding: const EdgeInsets.only(bottom: 1.0),
  //                                                                 child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
  //                                                               ),
  //                                                               SizedBox(width: 4),
  //                                                               Text(convertToHour(item.split('^')[0]) + ':' + item.split('^')[0].substring(10,12) +' ' + convertToAMPM(item.split('^')[0]),
  //                                                                 style: TextStyle(
  //                                                                   fontSize: 13,
  //                                                                   fontWeight: FontWeight.w400,
  //                                                                   color: Colors.grey,
  //                                                                 ),
  //                                                               ),
  //                                                             ],
  //                                                           ),
  //                                                           // Padding(
  //                                                           //   padding: const EdgeInsets.only(top: 8.0, bottom: 3.0),
  //                                                           //   child: Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2)),
  //                                                           // ),
  //                                                           SizedBox(
  //                                                             height: 6,
  //                                                           ),
  //                                                           Row(
  //                                                             children: [
  //                                                               Text(item.split('^')[3].split('&')[0],
  //                                                                 style: TextStyle(
  //                                                                   fontSize: 15,
  //                                                                   fontWeight: FontWeight.w500,
  //                                                                   color: Colors.grey,
  //                                                                 ),),
  //
  //                                                             ],
  //                                                           ),
  //                                                         ],
  //                                                       ),
  //                                                     ),
  //                                                     SizedBox(
  //                                                       height: 8,
  //                                                     ),
  //                                                     Row(
  //                                                       children: [
  //                                                         if(item.split('^')[5] == '0.0')
  //                                                           Padding(
  //                                                             padding: const EdgeInsets.only(left: 0.0),
  //                                                             child: Container(
  //                                                               height: 21,
  //                                                               decoration: BoxDecoration(
  //                                                                 borderRadius: BorderRadius.circular(20.0),
  //                                                                 color: AppTheme.badgeBgSuccess,
  //                                                               ),
  //                                                               child: Padding(
  //                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                                 child: Text('Paid',
  //                                                                   style: TextStyle(
  //                                                                       fontSize: 13,
  //                                                                       fontWeight: FontWeight.w500,
  //                                                                       color: Colors.white
  //                                                                   ),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //
  //                                                         if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
  //                                                           Padding(
  //                                                             padding: const EdgeInsets.only(left: 0.0),
  //                                                             child: Container(
  //                                                               height: 21,
  //                                                               decoration: BoxDecoration(
  //                                                                 borderRadius: BorderRadius.circular(20.0),
  //                                                                 color: AppTheme.badgeFgDangerLight,
  //                                                               ),
  //                                                               child: Padding(
  //                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                                 child: Text('Partially paid',
  //                                                                   style: TextStyle(
  //                                                                       fontSize: 13,
  //                                                                       fontWeight: FontWeight.w500,
  //                                                                       color: AppTheme.badgeFgDanger
  //                                                                   ),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //                                                         if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
  //                                                           Padding(
  //                                                             padding: const EdgeInsets.only(left: 0.0),
  //                                                             child: Container(
  //                                                               height: 21,
  //                                                               decoration: BoxDecoration(
  //                                                                 borderRadius: BorderRadius.circular(20.0),
  //                                                                 color: AppTheme.badgeFgDanger,
  //                                                               ),
  //                                                               child: Padding(
  //                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                                 child: Text('Unpaid',
  //                                                                   style: TextStyle(
  //                                                                       fontSize: 13,
  //                                                                       fontWeight: FontWeight.w500,
  //                                                                       color: Colors.white
  //                                                                   ),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //                                                         if(item.split('^')[4][0] == 'r')
  //                                                           Padding(
  //                                                             padding: const EdgeInsets.only(left: 6.0),
  //                                                             child: Container(
  //                                                               height: 21,
  //                                                               decoration: BoxDecoration(
  //                                                                 borderRadius: BorderRadius.circular(20.0),
  //                                                                 color: AppTheme.badgeBgSecond,
  //                                                               ),
  //                                                               child: Padding(
  //                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                                 child: Text('Refunded',
  //                                                                   style: TextStyle(
  //                                                                       fontSize: 13,
  //                                                                       fontWeight: FontWeight.w500,
  //                                                                       color: Colors.white
  //                                                                   ),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //
  //                                                         if(item.split('^')[4][0] == 's')
  //                                                           Padding(
  //                                                             padding: const EdgeInsets.only(left: 6.0),
  //                                                             child: Container(
  //                                                               height: 21,
  //                                                               decoration: BoxDecoration(
  //                                                                 borderRadius: BorderRadius.circular(20.0),
  //                                                                 color: AppTheme.badgeBgSecondLight,
  //                                                               ),
  //                                                               child: Padding(
  //                                                                 padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
  //                                                                 child: Text('Partially refunded',
  //                                                                   style: TextStyle(
  //                                                                       fontSize: 13,
  //                                                                       fontWeight: FontWeight.w500,
  //                                                                       color: AppTheme.badgeBgSecond
  //                                                                   ),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //
  //                                                       ],
  //                                                     )
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                           Padding(
  //                                             padding: const EdgeInsets.only(right: 15.0, bottom: 5),
  //                                             child: Align(
  //                                               alignment: Alignment.centerRight,
  //                                               child: Row(
  //                                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                                 children: [
  //                                                   Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
  //                                                     fontSize: 15,
  //                                                     fontWeight: FontWeight.w500,
  //                                                   )),
  //                                                   SizedBox(width: 10),
  //                                                   Padding(
  //                                                     padding: const EdgeInsets.only(bottom: 2.0),
  //                                                     child: Icon(
  //                                                       Icons
  //                                                           .arrow_forward_ios_rounded,
  //                                                       size: 16,
  //                                                       color: Colors.blueGrey
  //                                                           .withOpacity(
  //                                                           0.8),
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                     );
  //                                   }
  //                                 }
  //
  //                               },
  //                             ),
  //                           ),
  //                         // SliverPersistentHeader(
  //                         //   pinned: true,
  //                         //   delegate: SliverAppBarDelegate2(
  //                         //       child: PreferredSize(
  //                         //         preferredSize: Size.fromHeight(33.0),
  //                         //         child: Container(
  //                         //           width: double.infinity,
  //                         //           height: 33,
  //                         //           decoration: BoxDecoration(
  //                         //               color: Colors.white,
  //                         //               border: Border(
  //                         //                 bottom: BorderSide(
  //                         //                     color: AppTheme.skBorderColor2,
  //                         //                     width: 1.0),
  //                         //               )
  //                         //           ),
  //                         //           child: Padding(
  //                         //             // padding: const EdgeInsets.only(left: 15.0, top: 12, bottom: 0),
  //                         //             padding: const EdgeInsets.only(left: 15.0, top: 1, bottom: 0),
  //                         //             child: Row(
  //                         //               children: [
  //                         //                 Text(
  //                         //                   'BUY',
  //                         //                   // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                         //                   style: TextStyle(
  //                         //                       height: 0.8,
  //                         //                       fontSize: 14,
  //                         //                       fontWeight: FontWeight.w600,
  //                         //                       letterSpacing: 1.2,
  //                         //                       color: Colors.black
  //                         //                   ),
  //                         //                 ),
  //                         //                 Padding(
  //                         //                   padding: const EdgeInsets.only(left: 4.0, right: 5.0, bottom: 3.0),
  //                         //                   child: FlutterSwitch(
  //                         //                     width: 31.0,
  //                         //                     height: 18.0,
  //                         //                     valueFontSize: 5.0,
  //                         //                     toggleSize: 13.0,
  //                         //                     padding: 2.5,
  //                         //                     value: buySellerStatus,
  //                         //                     onToggle: (val) {
  //                         //                       setState(() {
  //                         //                         buySellerStatus = val;
  //                         //                       });
  //                         //                     },
  //                         //                   ),
  //                         //                 ),
  //                         //                 Text(
  //                         //                   'SELL ORDERS',
  //                         //                   // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                         //                   style: TextStyle(
  //                         //                       height: 0.8,
  //                         //                       fontSize: 14,
  //                         //                       fontWeight: FontWeight.w600,
  //                         //                       letterSpacing: 1.2,
  //                         //                       color: Colors.black
  //                         //                   ),
  //                         //                 ),
  //                         //                 Expanded(
  //                         //                   child: Padding(
  //                         //                     padding: const EdgeInsets.only(right: 15.0),
  //                         //                     child: Text(
  //                         //                       '0',
  //                         //                       // '#' + sectionList[sectionIndex].items.length.toString(),
  //                         //                       // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                         //                       style: TextStyle(
  //                         //                         height: 0.8,
  //                         //                         fontSize: 14,
  //                         //                         fontWeight: FontWeight.w600,
  //                         //                         letterSpacing: 1.2,
  //                         //                         color: Colors.black,
  //                         //                       ),
  //                         //                       textAlign: TextAlign.right,
  //                         //                     ),
  //                         //                   ),
  //                         //                 ),
  //                         //               ],
  //                         //             ),
  //                         //           ),
  //                         //         ),
  //                         //       )
  //                         //   ),
  //                         // ),
  //                         // if(slidingSearch == 2)
  //                         //   SliverList(
  //                         //     delegate: SliverChildListDelegate(
  //                         //       [
  //                         //         Container(
  //                         //           height: 100,
  //                         //           color: AppTheme.lightBgColor,
  //                         //           child: Padding(
  //                         //             padding: const EdgeInsets.all(15.0),
  //                         //             child: Text('Each buyorder'),
  //                         //           ),
  //                         //         ),
  //                         //       ],
  //                         //     ),
  //                         //   ),
  //
  //
  //                         // if(slidingSearch == 2)
  //                         //   SliverPersistentHeader(
  //                         //     pinned: true,
  //                         //     delegate: SliverAppBarDelegate2(
  //                         //         child: PreferredSize(
  //                         //           preferredSize: Size.fromHeight(33.0),
  //                         //           child: Container(
  //                         //             width: double.infinity,
  //                         //             height: 33,
  //                         //             decoration: BoxDecoration(
  //                         //                 color: Colors.white,
  //                         //                 border: Border(
  //                         //                   bottom: BorderSide(
  //                         //                       color: AppTheme.skBorderColor2,
  //                         //                       width: 1.0),
  //                         //                 )
  //                         //             ),
  //                         //             child: Padding(
  //                         //               // padding: const EdgeInsets.only(left: 15.0, top: 12, bottom: 0),
  //                         //               padding: const EdgeInsets.only(left: 15.0, top: 1, bottom: 0),
  //                         //               child: Row(
  //                         //                 children: [
  //                         //                   Text(
  //                         //                     'SELL ORDERS',
  //                         //                     // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                         //                     style: TextStyle(
  //                         //                         height: 0.8,
  //                         //                         fontSize: 14,
  //                         //                         fontWeight: FontWeight.w600,
  //                         //                         letterSpacing: 1.2,
  //                         //                         color: Colors.black
  //                         //                     ),
  //                         //                   ),
  //                         //
  //                         //                   Expanded(
  //                         //                     child: Padding(
  //                         //                       padding: const EdgeInsets.only(right: 15.0),
  //                         //                       child: Text(
  //                         //                         '0',
  //                         //                         // '#' + sectionList[sectionIndex].items.length.toString(),
  //                         //                         // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //                         //                         style: TextStyle(
  //                         //                           height: 0.8,
  //                         //                           fontSize: 14,
  //                         //                           fontWeight: FontWeight.w600,
  //                         //                           letterSpacing: 1.2,
  //                         //                           color: Colors.black,
  //                         //                         ),
  //                         //                         textAlign: TextAlign.right,
  //                         //                       ),
  //                         //                     ),
  //                         //                   ),
  //                         //                 ],
  //                         //               ),
  //                         //             ),
  //                         //           ),
  //                         //         )
  //                         //     ),
  //                         //   ),
  //                         // if(slidingSearch == 2)
  //                         //   SliverList(
  //                         //     delegate: SliverChildListDelegate(
  //                         //       [
  //                         //         Container(
  //                         //           height: 100,
  //                         //           color: AppTheme.lightBgColor,
  //                         //           child: Padding(
  //                         //             padding: const EdgeInsets.all(15.0),
  //                         //             child: Text('Each sellorder'),
  //                         //           ),
  //                         //         ),
  //                         //       ],
  //                         //     ),
  //                         //   ),
  //
  //
  //                         // SliverFillRemaining(
  //                         //   child: TabBarView(
  //                         //     physics: NeverScrollableScrollPhysics(),
  //                         //     controller: subTabController,
  //                         //     children: <Widget>[
  //                         //       Column(
  //                         //         children: [
  //                         //           Container(
  //                         //             height: 100,
  //                         //               color: Colors.green,
  //                         //               child: Center(child: Text('Content of SubTab1'))
  //                         //           ),
  //                         //         ],
  //                         //       ),
  //                         //       Column(
  //                         //         children: [
  //                         //           Container(
  //                         //               height: 100,
  //                         //               color: Colors.blue,
  //                         //               child: Center(child: Text('Content of SubTab1'))
  //                         //           ),
  //                         //         ],
  //                         //       ),
  //                         //       Column(
  //                         //         children: [
  //                         //           Container(
  //                         //               height: 100,
  //                         //               color: Colors.yellow,
  //                         //               child: Center(child: Text('Content of SubTab1'))
  //                         //           ),
  //                         //         ],
  //                         //       ),
  //                         //     ],
  //                         //   ),
  //                         // ),
  //
  //
  //                         // SliverFillRemaining(
  //                         //   // 剩余补充内容TabBarView
  //                         //   child: TabBarView(
  //                         //     controller: this.tabController,
  //                         //     children: <Widget>[
  //                         //       Center(child: Text('Content of Home')),
  //                         //       Center(child: Text('Content of Profile')),
  //                         //     ],
  //                         //   ),
  //                         // ),
  //
  //
  //                         // if(!searchingOverAll && noSearchData)
  //                         //   SliverExpandableList(
  //                         //     builder: SliverExpandableChildDelegate(
  //                         //       sectionList: sectionListNo,
  //                         //       headerBuilder: _buildHeader2,
  //                         //       itemBuilder: (context, sectionIndex, itemIndex, index) {
  //                         //         String item = sectionListNo[sectionIndex].items[itemIndex];
  //                         //         int length = sectionListNo[sectionIndex].items.length;
  //                         //         return Container(
  //                         //           height: 0.1,
  //                         //         );
  //                         //       },
  //                         //     ),
  //                         //   ),
  //                         // if(searchingOverAll)
  //                         //   SliverExpandableList(
  //                         //     builder: SliverExpandableChildDelegate(
  //                         //       sectionList: sectionListNo,
  //                         //       headerBuilder: _buildHeader3,
  //                         //       itemBuilder: (context, sectionIndex, itemIndex, index) {
  //                         //         String item = sectionListNo[sectionIndex].items[itemIndex];
  //                         //         int length = sectionListNo[sectionIndex].items.length;
  //                         //         return Container(
  //                         //           height: 0.1,
  //                         //         );
  //                         //       },
  //                         //     ),
  //                         //   ),
  //
  //
  //
  //
  //                         // if(!noSearchData && !searchingOverAll)
  //
  //                         // SliverExpandableList(
  //                         //   builder: SliverExpandableChildDelegate(
  //                         //     sectionList: sectionList,
  //                         //     headerBuilder: _buildHeader,
  //                         //     itemBuilder: (context, sectionIndex, itemIndex, index) {
  //                         //       String item = sectionList[sectionIndex].items[itemIndex];
  //                         //       int length = sectionList[sectionIndex].items.length;
  //                         //       if(sectionIndex == 0) {
  //                         //         return Container(
  //                         //           height: 0.1,
  //                         //         );
  //                         //         // return SliverFillRemaining(
  //                         //         //   child: new Container(
  //                         //         //     color: Colors.red,
  //                         //         //   ),
  //                         //         // );
  //                         //       }
  //                         //
  //                         //       if(slidingSearch == 0 && item.contains('^sps^')) {
  //                         //         return GestureDetector(
  //                         //           onTap: () {
  //                         //             // Navigator.push(
  //                         //             //   context,
  //                         //             //   MaterialPageRoute(
  //                         //             //       builder: (context) => ProductDetailsView2(
  //                         //             //           idString: version, toggleCoinCallback:
  //                         //             //       addProduct1, toggleCoinCallback3: addProduct3)),);
  //                         //           },
  //                         //           child: Padding(
  //                         //             padding:
  //                         //             EdgeInsets.only(top: index == 0? 10.0: 20.0),
  //                         //             child: Container(
  //                         //               width: MediaQuery.of(context).size.width,
  //                         //               decoration: BoxDecoration(
  //                         //                   border: Border(
  //                         //                       bottom: index == length-1 ?
  //                         //                       BorderSide(
  //                         //                           color: Colors.transparent,
  //                         //                           width: 1.0) :
  //                         //
  //                         //                       BorderSide(
  //                         //                           color: Colors.grey
  //                         //                               .withOpacity(0.3),
  //                         //                           width: 1.0)
  //                         //                   )),
  //                         //               child: Padding(
  //                         //                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
  //                         //                 child: Column(
  //                         //                   children: [
  //                         //                     Row(
  //                         //                       children: [
  //                         //                         Column(
  //                         //                           children: [
  //                         //                             ClipRRect(
  //                         //                                 borderRadius: BorderRadius
  //                         //                                     .circular(
  //                         //                                     5.0),
  //                         //                                 child: item.split('^sps^')[2] != ""
  //                         //                                     ? CachedNetworkImage(
  //                         //                                   imageUrl:
  //                         //                                   'https://riftplus.me/smartkyat_pos/api/uploads/' +
  //                         //                                       item.split('^sps^')[2],
  //                         //                                   width: 75,
  //                         //                                   height: 75,
  //                         //                                   // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
  //                         //                                   errorWidget: (context,
  //                         //                                       url,
  //                         //                                       error) =>
  //                         //                                       Icon(Icons
  //                         //                                           .error),
  //                         //                                   fadeInDuration:
  //                         //                                   Duration(
  //                         //                                       milliseconds:
  //                         //                                       100),
  //                         //                                   fadeOutDuration:
  //                         //                                   Duration(
  //                         //                                       milliseconds:
  //                         //                                       10),
  //                         //                                   fadeInCurve:
  //                         //                                   Curves
  //                         //                                       .bounceIn,
  //                         //                                   fit: BoxFit
  //                         //                                       .cover,
  //                         //                                 )
  //                         //                                     : CachedNetworkImage(
  //                         //                                   imageUrl:
  //                         //                                   'https://riftplus.me/smartkyat_pos/api/uploads/shark1.jpg',
  //                         //                                   width: 75,
  //                         //                                   height: 75,
  //                         //                                   // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
  //                         //                                   errorWidget: (context,
  //                         //                                       url,
  //                         //                                       error) =>
  //                         //                                       Icon(Icons
  //                         //                                           .error),
  //                         //                                   fadeInDuration:
  //                         //                                   Duration(
  //                         //                                       milliseconds:
  //                         //                                       100),
  //                         //                                   fadeOutDuration:
  //                         //                                   Duration(
  //                         //                                       milliseconds:
  //                         //                                       10),
  //                         //                                   fadeInCurve:
  //                         //                                   Curves
  //                         //                                       .bounceIn,
  //                         //                                   fit: BoxFit
  //                         //                                       .cover,
  //                         //                                 )),
  //                         //                           ],
  //                         //                         ),
  //                         //                         SizedBox(
  //                         //                           width: 15,
  //                         //                         ),
  //                         //                         Column(
  //                         //                           crossAxisAlignment:
  //                         //                           CrossAxisAlignment
  //                         //                               .start,
  //                         //                           children: [
  //                         //                             Text(
  //                         //                               item.split('^sps^')[1],
  //                         //                               style: TextStyle(
  //                         //                                 fontSize: 18,
  //                         //                                 fontWeight:
  //                         //                                 FontWeight.w500,
  //                         //                               ),
  //                         //                             ),
  //                         //                             SizedBox(
  //                         //                               height: 10,
  //                         //                             ),
  //                         //                             Row(
  //                         //                               children: [
  //                         //                                 Text(
  //                         //                                   'MMK ' + item.split('^sps^')[3].split('-')[0],
  //                         //                                   style: TextStyle(
  //                         //                                     fontSize: 15,
  //                         //                                     fontWeight:
  //                         //                                     FontWeight.w500,
  //                         //                                   ),
  //                         //                                 ),
  //                         //                                 Text(
  //                         //                                   item.split('^sps^')[4].split('-')[2] != '' && item.split('^sps^')[5].split('-')[2] == '' ? ' - ' + item.split('^sps^')[4].split('-')[0] : item.split('^sps^')[4].split('-')[2] != '' && item.split('^sps^')[5].split('-')[2] != '' ? ' - ' + item.split('^sps^')[5].split('-')[0] : '',
  //                         //                                   style: TextStyle(
  //                         //                                     fontSize: 15,
  //                         //                                     fontWeight:
  //                         //                                     FontWeight.w500,
  //                         //                                   ),
  //                         //                                 ),
  //                         //                               ],
  //                         //                             ),
  //                         //                             SizedBox(
  //                         //                               height: 2,
  //                         //                             ),
  //                         //                             Row(
  //                         //                               children: [
  //                         //                                 Row(
  //                         //                                   children: [
  //                         //                                     Text(
  //                         //                                         item.split('^sps^')[3].split('-')[1].toString()+ ' '  + item.split('^sps^')[3].split('-')[2] + ' ', style: TextStyle(
  //                         //                                       fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
  //                         //                                     )),
  //                         //                                     Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
  //                         //                                     // sub1Name != '' ? Text(' | ', style: TextStyle(
  //                         //                                     //   fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
  //                         //                                     // )) : Text(''),
  //                         //                                   ],
  //                         //                                 ),
  //                         //
  //                         //                                 item.split('^sps^')[4].split('-')[2] != '' && item.split('^sps^')[5].split('-')[2] == ''?
  //                         //                                 Text(
  //                         //                                     '  (+1 Sub item)', style: TextStyle(
  //                         //                                   fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
  //                         //                                 )) : item.split('^sps^')[4].split('-')[2] != '' && item.split('^sps^')[5].split('-')[2] != '' ? Text(
  //                         //                                     '  (+2 Sub items)', style: TextStyle(
  //                         //                                   fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
  //                         //                                 )): Container(),
  //                         //
  //                         //                                 // StreamBuilder(
  //                         //                                 //     stream: FirebaseFirestore
  //                         //                                 //         .instance
  //                         //                                 //         .collection(
  //                         //                                 //         'space')
  //                         //                                 //         .doc(
  //                         //                                 //         '0NHIS0Jbn26wsgCzVBKT')
  //                         //                                 //         .collection(
  //                         //                                 //         'shops')
  //                         //                                 //         .doc(
  //                         //                                 //         'PucvhZDuUz3XlkTgzcjb')
  //                         //                                 //         .collection(
  //                         //                                 //         'products')
  //                         //                                 //         .doc(version)
  //                         //                                 //         .collection(
  //                         //                                 //         'versions')
  //                         //                                 //         .where('type',
  //                         //                                 //         isEqualTo:
  //                         //                                 //         'sub3')
  //                         //                                 //         .snapshots(),
  //                         //                                 //     builder: (BuildContext
  //                         //                                 //     context,
  //                         //                                 //         AsyncSnapshot<
  //                         //                                 //             QuerySnapshot>
  //                         //                                 //         snapshot5) {
  //                         //                                 //       if (snapshot5
  //                         //                                 //           .hasData) {
  //                         //                                 //         int quantity3 =
  //                         //                                 //         0;
  //                         //                                 //         var sub3Quantity;
  //                         //                                 //         snapshot5
  //                         //                                 //             .data!
  //                         //                                 //             .docs
  //                         //                                 //             .map((DocumentSnapshot
  //                         //                                 //         document) {
  //                         //                                 //           Map<String,
  //                         //                                 //               dynamic>
  //                         //                                 //           data4 =
  //                         //                                 //           document.data()! as Map<
  //                         //                                 //               String,
  //                         //                                 //               dynamic>;
  //                         //                                 //           if (data4[
  //                         //                                 //           'unit_qtity'] !=
  //                         //                                 //               '') {
  //                         //                                 //             quantity3 +=
  //                         //                                 //                 int.parse(
  //                         //                                 //                     data4['unit_qtity']);
  //                         //                                 //             sub3Quantity =
  //                         //                                 //                 quantity3
  //                         //                                 //                     .toString();
  //                         //                                 //           } else
  //                         //                                 //             return Container();
  //                         //                                 //         }).toList();
  //                         //                                 //         // print(sub1Quantity);
  //                         //                                 //         // print(mainQuantity);
  //                         //                                 //         if (sub3Quantity !=
  //                         //                                 //             null) {
  //                         //                                 //           return Text(
  //                         //                                 //               '$sub3Quantity $sub3Name');
  //                         //                                 //         }
  //                         //                                 //         return Container();
  //                         //                                 //       }
  //                         //                                 //       return Container();
  //                         //                                 //     }),
  //                         //                               ],
  //                         //                             ),
  //                         //
  //                         //                             // Text(
  //                         //                             //   'MMK',
  //                         //                             //   style:
  //                         //                             //       TextStyle(
  //                         //                             //     fontSize: 14,
  //                         //                             //     fontWeight: FontWeight.w400,
  //                         //                             //     color: Colors.blueGrey.withOpacity(1.0),
  //                         //                             //   ),
  //                         //                             // ),
  //                         //                             // SizedBox(
  //                         //                             //   height:
  //                         //                             //       7,
  //                         //                             // ),
  //                         //                             // Text(
  //                         //                             //   '55',
  //                         //                             //   style:
  //                         //                             //       TextStyle(
  //                         //                             //     fontSize: 14,
  //                         //                             //     fontWeight: FontWeight.w400,
  //                         //                             //     color: Colors.blueGrey.withOpacity(1.0),
  //                         //                             //   ),
  //                         //                             // ),
  //                         //                           ],
  //                         //                         ),
  //                         //                         // Padding(
  //                         //                         //   padding:
  //                         //                         //       const EdgeInsets.only(
  //                         //                         //           bottom: 20.0),
  //                         //                         //   child: IconButton(
  //                         //                         //     icon: Icon(
  //                         //                         //       Icons
  //                         //                         //           .arrow_forward_ios_rounded,
  //                         //                         //       size: 16,
  //                         //                         //       color: Colors.blueGrey
  //                         //                         //           .withOpacity(0.8),
  //                         //                         //     ),
  //                         //                         //     onPressed: () {
  //                         //                         //       Navigator.push(
  //                         //                         //         context,
  //                         //                         //         MaterialPageRoute(
  //                         //                         //             builder: (context) => ProductDetailsView(
  //                         //                         //                 idString: version, toggleCoinCallback:
  //                         //                         //             addProduct1, toggleCoinCallback3: addProduct3)),);
  //                         //                         //     },
  //                         //                         //   ),
  //                         //                         // ),
  //                         //                         Spacer(),
  //                         //                         Padding(
  //                         //                           padding:
  //                         //                           const EdgeInsets.only(
  //                         //                               bottom: 12.0),
  //                         //                           child: Icon(
  //                         //                             Icons
  //                         //                                 .arrow_forward_ios_rounded,
  //                         //                             size: 16,
  //                         //                             color: Colors.blueGrey
  //                         //                                 .withOpacity(0.8),
  //                         //                           ),),
  //                         //                       ],
  //                         //                     ),
  //                         //                     SizedBox(height: 20),
  //                         //                   ],
  //                         //                 ),
  //                         //               ),
  //                         //             ),
  //                         //           ),
  //                         //         );
  //                         //       } else if(slidingSearch == 1 && item.contains('^sps^')) {
  //                         //         return GestureDetector(
  //                         //           onTap: () {
  //                         //             Navigator.push(
  //                         //               context,
  //                         //               MaterialPageRoute(
  //                         //                   builder: (
  //                         //                       context) =>
  //                         //                       CustomerInfoSubs(
  //                         //                           id: item.split('^sps^')[0],
  //                         //                           toggleCoinCallback: addCustomer2Cart1)),
  //                         //             );
  //                         //           },
  //                         //           child: Padding(
  //                         //             padding:
  //                         //             EdgeInsets.only(
  //                         //                 top: index == 0
  //                         //                     ? 10.0
  //                         //                     : 15.0),
  //                         //             child: Container(
  //                         //               width: MediaQuery
  //                         //                   .of(context)
  //                         //                   .size
  //                         //                   .width,
  //                         //               decoration: BoxDecoration(
  //                         //                   border: Border(
  //                         //                       bottom: index ==
  //                         //                           length -
  //                         //                               1
  //                         //                           ?
  //                         //                       BorderSide(
  //                         //                           color: Colors
  //                         //                               .Colors.transparent,
  //                         //                           width: 1.0)
  //                         //                           :
  //                         //
  //                         //                       BorderSide(
  //                         //                           color: Colors
  //                         //                               .Colors.grey
  //                         //                               .withOpacity(
  //                         //                               0.3),
  //                         //                           width: 1.0)
  //                         //                   )),
  //                         //               child: Column(
  //                         //                 children: [
  //                         //                   Padding(
  //                         //                     padding: const EdgeInsets
  //                         //                         .only(
  //                         //                         bottom: 18.0),
  //                         //                     child: ListTile(
  //                         //                       title: Text(
  //                         //                         item.split('^sps^')[1].toString(),
  //                         //                         style: TextStyle(
  //                         //                           fontSize: 18,
  //                         //                           fontWeight:
  //                         //                           FontWeight
  //                         //                               .w500,
  //                         //                         ),),
  //                         //                       subtitle: Padding(
  //                         //                         padding: const EdgeInsets
  //                         //                             .only(
  //                         //                             top: 8.0),
  //                         //                         child: Column(
  //                         //                           crossAxisAlignment: CrossAxisAlignment
  //                         //                               .start,
  //                         //                           children: [
  //                         //                             Text(
  //                         //                                 item.split('^sps^')[2].toString(),
  //                         //                                 style: TextStyle(
  //                         //                                   fontSize: 14,
  //                         //                                   fontWeight: FontWeight
  //                         //                                       .w500,
  //                         //                                   color: Colors
  //                         //                                       .Colors.grey,
  //                         //                                 )),
  //                         //                             SizedBox(
  //                         //                               height: 5,),
  //                         //                             Text(
  //                         //                                 item.split('^sps^')[3].toString(),
  //                         //                                 style: TextStyle(
  //                         //                                   fontSize: 14,
  //                         //                                   fontWeight: FontWeight
  //                         //                                       .w500,
  //                         //                                   color: Colors
  //                         //                                       .Colors.grey,
  //                         //                                 )),
  //                         //                           ],
  //                         //                         ),
  //                         //                       ),
  //                         //                       trailing: Padding(
  //                         //                         padding: const EdgeInsets
  //                         //                             .only(
  //                         //                             top: 10.0),
  //                         //                         child: Container(
  //                         //                           child: Row(
  //                         //                             mainAxisSize: MainAxisSize.min,
  //                         //                             mainAxisAlignment: MainAxisAlignment.start,
  //                         //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                         //                             children: [
  //                         //                               StreamBuilder(
  //                         //                                   stream: FirebaseFirestore.instance
  //                         //                                       .collection('space')
  //                         //                                       .doc('0NHIS0Jbn26wsgCzVBKT')
  //                         //                                       .collection('shops')
  //                         //                                       .doc('PucvhZDuUz3XlkTgzcjb')
  //                         //                                       .collection('customers')
  //                         //                                       .doc(item.split('^sps^')[0].toString())
  //                         //                                       .collection('orders')
  //                         //                                       .where('debt', isGreaterThan: 0)
  //                         //                                       .snapshots(),
  //                         //                                   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
  //                         //                                     // orderList[index] = 0;
  //                         //                                     int orderLength = 0;
  //                         //                                     int i = 0;
  //                         //                                     if(snapshot2.hasData) {
  //                         //                                       return snapshot2.data!.docs.length > 0? Container(
  //                         //                                         height: 21,
  //                         //                                         decoration: BoxDecoration(
  //                         //                                           borderRadius: BorderRadius.circular(20.0),
  //                         //                                           color: AppTheme.badgeFgDanger,
  //                         //                                         ),
  //                         //                                         child: Padding(
  //                         //                                           padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
  //                         //                                           child: Text(snapshot2.data!.docs.length.toString() + ' unpaid',
  //                         //                                             style: TextStyle(
  //                         //                                                 fontSize: 13,
  //                         //                                                 fontWeight: FontWeight.w500,
  //                         //                                                 color: Colors.white
  //                         //                                             ),
  //                         //                                           ),
  //                         //                                         ),
  //                         //                                       ): Container(
  //                         //                                       );
  //                         //                                       // int quantity = 0;
  //                         //                                       // snapshot2.data!.docs.map((DocumentSnapshot document2) {
  //                         //                                       //   Map<String, dynamic> data2 = document2.data()! as Map<String, dynamic>;
  //                         //                                       //   orders = data2['daily_order'];
  //                         //                                       //   quantity += int.parse(orders.length.toString());
  //                         //                                       //
  //                         //                                       //   return Text(snapshot2.data!.docs[index].id);
  //                         //                                       // }).toList();
  //                         //                                     }
  //                         //                                     return Container();
  //                         //                                   }
  //                         //                               ),
  //                         //
  //                         //                               // Container(
  //                         //                               //   height: 21,
  //                         //                               //   decoration: BoxDecoration(
  //                         //                               //     borderRadius: BorderRadius.circular(20.0),
  //                         //                               //     color: AppTheme.badgeFgDanger,
  //                         //                               //   ),
  //                         //                               //   child: Padding(
  //                         //                               //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
  //                         //                               //     child: Text(unpaidCount(index).toString() + ' unpaid',
  //                         //                               //       style: TextStyle(
  //                         //                               //           fontSize: 13,
  //                         //                               //           fontWeight: FontWeight.w500,
  //                         //                               //           color: Colors.white
  //                         //                               //       ),
  //                         //                               //     ),
  //                         //                               //   ),
  //                         //                               // ),
  //                         //
  //                         //                               // Text(orderList.toString()),
  //                         //
  //                         //                               // Container(
  //                         //                               //   height: 21,
  //                         //                               //   decoration: BoxDecoration(
  //                         //                               //     borderRadius: BorderRadius.circular(20.0),
  //                         //                               //     color: AppTheme.badgeFgDanger,
  //                         //                               //   ),
  //                         //                               //   child: Padding(
  //                         //                               //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
  //                         //                               //     child: Text('2 unpaid',
  //                         //                               //       style: TextStyle(
  //                         //                               //           fontSize: 13,
  //                         //                               //           fontWeight: FontWeight.w500,
  //                         //                               //           color: Colors.white
  //                         //                               //       ),
  //                         //                               //     ),
  //                         //                               //   ),
  //                         //                               // )
  //                         //
  //                         //                               // Container(
  //                         //                               //   height: 21,
  //                         //                               //   decoration: BoxDecoration(
  //                         //                               //     borderRadius: BorderRadius.circular(20.0),
  //                         //                               //     color: AppTheme.badgeFgDanger,
  //                         //                               //   ),
  //                         //                               //   child: Padding(
  //                         //                               //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
  //                         //                               //     child: Text(unpaidCount(index).toString() + ' unpaid',
  //                         //                               //       style: TextStyle(
  //                         //                               //           fontSize: 13,
  //                         //                               //           fontWeight: FontWeight.w500,
  //                         //                               //           color: Colors.white
  //                         //                               //       ),
  //                         //                               //     ),
  //                         //                               //   ),
  //                         //                               // ),
  //                         //                               SizedBox(
  //                         //                                   width: 12),
  //                         //                               Padding(
  //                         //                                 padding: const EdgeInsets.only(top: 2.0),
  //                         //                                 child: Icon(
  //                         //                                   Icons
  //                         //                                       .arrow_forward_ios_rounded,
  //                         //                                   size: 16,
  //                         //                                   color: Colors
  //                         //                                       .Colors.blueGrey
  //                         //                                       .withOpacity(
  //                         //                                       0.8),
  //                         //                                 ),
  //                         //                               ),
  //                         //                             ],
  //                         //                           ),
  //                         //                         ),
  //                         //                       ),
  //                         //
  //                         //                     ),
  //                         //                   )
  //                         //
  //                         //                 ],
  //                         //               ),
  //                         //             ),
  //                         //           ),
  //                         //         );
  //                         //       }
  //                         //       return GestureDetector(
  //                         //         onTap: () {
  //                         //           print('Items'+item);
  //                         //           // Navigator.push(
  //                         //           //   context,
  //                         //           //   MaterialPageRoute(
  //                         //           //       builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {})),
  //                         //           // );
  //                         //         },
  //                         //         child: Stack(
  //                         //           alignment: Alignment.center,
  //                         //
  //                         //           children: [
  //                         //             Padding(
  //                         //               padding: const EdgeInsets.only(left: 0.0, right: 0.0),
  //                         //               child: Container(
  //                         //                 decoration: BoxDecoration(
  //                         //                     color: AppTheme.lightBgColor,
  //                         //                     border: Border(
  //                         //                       bottom: BorderSide(
  //                         //                           color: AppTheme.skBorderColor2,
  //                         //                           width: 1.0),
  //                         //                     )),
  //                         //                 child: Padding(
  //                         //                   padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
  //                         //                   child: Column(
  //                         //                     mainAxisAlignment: MainAxisAlignment.start,
  //                         //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                         //                     children: [
  //                         //                       Padding(
  //                         //                         padding: const EdgeInsets.only(left: 1.0),
  //                         //                         child: Column(
  //                         //                           mainAxisAlignment: MainAxisAlignment.start,
  //                         //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                         //                           children: [
  //                         //                             Row(
  //                         //                               mainAxisAlignment: MainAxisAlignment.start,
  //                         //                               children: [
  //                         //                                 Text('#Text',
  //                         //                                   style: TextStyle(
  //                         //                                       fontSize: 16,
  //                         //                                       fontWeight: FontWeight.w500
  //                         //                                   ),
  //                         //                                 ),
  //                         //                                 SizedBox(width: 8),
  //                         //                                 Padding(
  //                         //                                   padding: const EdgeInsets.only(bottom: 1.0),
  //                         //                                   child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
  //                         //                                 ),
  //                         //                                 SizedBox(width: 4),
  //                         //                                 Text('Text1',
  //                         //                                   style: TextStyle(
  //                         //                                     fontSize: 14,
  //                         //                                     fontWeight: FontWeight.w500,
  //                         //                                     color: Colors.grey,
  //                         //                                   ),
  //                         //                                 ),
  //                         //                               ],
  //                         //                             ),
  //                         //                             SizedBox(
  //                         //                               height: 6,
  //                         //                             ),
  //                         //                             Row(
  //                         //                               children: [
  //                         //                                 Text('Text2', style: TextStyle(
  //                         //                                   fontSize: 15,
  //                         //                                   fontWeight: FontWeight.w500,
  //                         //                                   color: Colors.grey,
  //                         //                                 )),
  //                         //
  //                         //                               ],
  //                         //                             ),
  //                         //                           ],
  //                         //                         ),
  //                         //                       ),
  //                         //                       SizedBox(
  //                         //                         height: 8,
  //                         //                       ),
  //                         //                       Row(
  //                         //                         children: [
  //                         //                           // if(item.split('^')[5] == '0.0')
  //                         //                           Padding(
  //                         //                             padding: const EdgeInsets.only(right: 6.0),
  //                         //                             child: Container(
  //                         //                               height: 21,
  //                         //                               decoration: BoxDecoration(
  //                         //                                 borderRadius: BorderRadius.circular(20.0),
  //                         //                                 color: AppTheme.badgeBgSuccess,
  //                         //                               ),
  //                         //                               child: Padding(
  //                         //                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                         //                                 child: Text('Paid',
  //                         //                                   style: TextStyle(
  //                         //                                       fontSize: 13,
  //                         //                                       fontWeight: FontWeight.w500,
  //                         //                                       color: Colors.white
  //                         //                                   ),
  //                         //                                 ),
  //                         //                               ),
  //                         //                             ),
  //                         //                           ),
  //                         //
  //                         //                           // if(item.split('^')[5] != '0.0')
  //                         //                           //   Padding(
  //                         //                           //     padding: const EdgeInsets.only(right: 6.0),
  //                         //                           //     child: Container(
  //                         //                           //       height: 21,
  //                         //                           //       decoration: BoxDecoration(
  //                         //                           //         borderRadius: BorderRadius.circular(20.0),
  //                         //                           //         color: AppTheme.badgeFgDanger,
  //                         //                           //       ),
  //                         //                           //       child: Padding(
  //                         //                           //         padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                         //                           //         child: Text('Unpaid',
  //                         //                           //           style: TextStyle(
  //                         //                           //               fontSize: 13,
  //                         //                           //               fontWeight: FontWeight.w500,
  //                         //                           //               color: Colors.white
  //                         //                           //           ),
  //                         //                           //         ),
  //                         //                           //       ),
  //                         //                           //     ),
  //                         //                           //   ),
  //                         //
  //                         //                           // if(item.split('^')[4][0] == 'r')
  //                         //                           //   Padding(
  //                         //                           //     padding: const EdgeInsets.only(right: 6.0),
  //                         //                           //     child: Container(
  //                         //                           //       height: 21,
  //                         //                           //       decoration: BoxDecoration(
  //                         //                           //         borderRadius: BorderRadius.circular(20.0),
  //                         //                           //         color: AppTheme.badgeBgSecond,
  //                         //                           //       ),
  //                         //                           //       child: Padding(
  //                         //                           //         padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                         //                           //         child: Text('Refunded',
  //                         //                           //           style: TextStyle(
  //                         //                           //               fontSize: 13,
  //                         //                           //               fontWeight: FontWeight.w500,
  //                         //                           //               color: Colors.white
  //                         //                           //           ),
  //                         //                           //         ),
  //                         //                           //       ),
  //                         //                           //     ),
  //                         //                           //   ),
  //                         //
  //                         //                           // if(item.split('^')[4][0] == 's')
  //                         //                           //   Padding(
  //                         //                           //     padding: const EdgeInsets.only(right: 6.0),
  //                         //                           //     child: Container(
  //                         //                           //       height: 21,
  //                         //                           //       decoration: BoxDecoration(
  //                         //                           //         borderRadius: BorderRadius.circular(20.0),
  //                         //                           //         color: AppTheme.badgeBgSecond,
  //                         //                           //       ),
  //                         //                           //       child: Padding(
  //                         //                           //         padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
  //                         //                           //         child: Text('Partially refunded',
  //                         //                           //           style: TextStyle(
  //                         //                           //               fontSize: 13,
  //                         //                           //               fontWeight: FontWeight.w500,
  //                         //                           //               color: Colors.white
  //                         //                           //           ),
  //                         //                           //         ),
  //                         //                           //       ),
  //                         //                           //     ),
  //                         //                           //   ),
  //                         //
  //                         //
  //                         //                         ],
  //                         //                       )
  //                         //                     ],
  //                         //                   ),
  //                         //                 ),
  //                         //               ),
  //                         //             ),
  //                         //             Padding(
  //                         //               padding: const EdgeInsets.only(right: 15.0, bottom: 1),
  //                         //               child: Align(
  //                         //                 alignment: Alignment.centerRight,
  //                         //                 child: Row(
  //                         //                   mainAxisAlignment: MainAxisAlignment.end,
  //                         //                   children: [
  //                         //                     Text('MMK ', style: TextStyle(
  //                         //                       fontSize: 15,
  //                         //                       fontWeight: FontWeight.w500,
  //                         //                     )),
  //                         //                     SizedBox(width: 10),
  //                         //                     Icon(
  //                         //                       Icons
  //                         //                           .arrow_forward_ios_rounded,
  //                         //                       size: 16,
  //                         //                       color: Colors.blueGrey.withOpacity(0.8),
  //                         //                     ),
  //                         //                   ],
  //                         //                 ),
  //                         //               ),
  //                         //             )
  //                         //           ],
  //                         //         ),
  //                         //       );
  //                         //     },
  //                         //   ),
  //                         // ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           );
  //         }
  //         return Container();
  //       }
  //   );
  // }
  //
  //
  // String slidedTextFun() {
  //   if(slidingSearch == 1) {
  //     return 'Buy/Sells';
  //   } else if(slidingSearch == 2) {
  //     return 'Buy orders';
  //   }
  //   return 'SOmething';
  // }
  //
  // buySellOrderHeaders(String header) {
  //
  //   if(header.contains('GG')) {
  //     return Text(
  //       '0',
  //       // '0',
  //       // '#' + sectionList[sectionIndex].items.length.toString(),
  //       // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //       style: TextStyle(
  //         height: 0.8,
  //         fontSize: 14,
  //         fontWeight: FontWeight.w600,
  //         letterSpacing: 1.2,
  //         color: Colors.black,
  //       ),
  //       textAlign: TextAlign.right,
  //     );
  //   } else {
  //     return header != '' ? Text(
  //       header.split('^')[1],
  //       // '0',
  //       // '#' + sectionList[sectionIndex].items.length.toString(),
  //       // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
  //       style: TextStyle(
  //         height: 0.8,
  //         fontSize: 14,
  //         fontWeight: FontWeight.w600,
  //         letterSpacing: 1.2,
  //         color: Colors.black,
  //       ),
  //       textAlign: TextAlign.right,
  //     ): Padding(
  //       padding: const EdgeInsets.only(bottom: 1.0),
  //       child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
  //           child: CupertinoActivityIndicator(radius: 8,)),
  //     );
  //   }
  // }
  //
  // Future<String> countDocuments(myDoc) async {
  //   QuerySnapshot _myDoc = await myDoc.get();
  //   List<DocumentSnapshot> _myDocCount = _myDoc.docs;
  //   return _myDocCount.length.toString();
  // }

  final cateScCtler = ScrollController();
  final _width = 10.0;
  int cateScIndex = 0;

  zeroToTen(String string) {
    if (int.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference daily_exps = ;
    DocumentSnapshot? lastDoc;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        brightness: Brightness.light,
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.white,
          child: SafeArea(
            top: true,
            bottom: true,
            child: Stack(
              children: [
                if(!searchOpening)
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      // padding: const EdgeInsets.only(top: 138.0),
                      padding: const EdgeInsets.only(top: 81.0),
                      child: Container(
                          height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders')
                                  .where('date', isGreaterThan: DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.subtract(Duration(days: 6)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 6)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 6)).day.toString()) + ' 00:00:00'))
                                  .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(today.day.toString()) + ' 23:59:59'))
                                  .orderBy('date', descending: true).snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                                if(snapshot.hasData) {
                                  var sections = List<ExampleSection>.empty(growable: true);
                                  int docInc = 0;
                                  print('HHHEEEE' + snapshot.data!.docs.length.toString() + ' ');
                                  snapshot.data!.docs.map((document) async {

                                    // List<String> dailyOrders = document['daily_order'].cast<String>();
                                    List<String> dailyOrders = [];
                                    for(String str in document['daily_order']) {
                                      if(cateScIndex == 2) {
                                        if(str.split('^')[4] == 'PART' || str.split('^')[4] == 'TRUE') {
                                          dailyOrders.add(str);
                                        }
                                      } else if(cateScIndex == 1) {
                                        if(str.split('^')[5] != '0.0') {
                                          dailyOrders.add(str);
                                        }
                                      } else if(cateScIndex == 3) {
                                        if(str.split('^')[5] == '0.0') {
                                          dailyOrders.add(str);
                                        }
                                      } else if(cateScIndex == 0) {
                                        dailyOrders.add(str);
                                      }

                                    }
                                    if(docInc>0) {
                                      Map<String,dynamic> dataLow = snapshot.data!.docs[docInc-1].data()! as Map< String, dynamic>;
                                      List<String> dataLowDailyOrder = [];
                                      for(String str in dataLow['daily_order']) {
                                        if(cateScIndex == 2) {
                                          if(str.split('^')[4] == 'PART' || str.split('^')[4] == 'TRUE') {
                                            dataLowDailyOrder.add(str);
                                          }
                                        } else if(cateScIndex == 1) {
                                          if(str.split('^')[5] != '0.0') {
                                            dataLowDailyOrder.add(str);
                                          }
                                        } else if(cateScIndex == 3) {
                                          if(str.split('^')[5] == '0.0') {
                                            dataLowDailyOrder.add(str);
                                          }
                                        } else if(cateScIndex == 0) {
                                          dataLowDailyOrder.add(str);
                                        }

                                      }


                                      print('DATA LOW ' + dataLow['date'].toDate().toString());
                                      if( document['date'].toDate().year.toString() + document['date'].toDate().month.toString() + document['date'].toDate().day.toString()
                                          ==
                                          dataLow['date'].toDate().year.toString() + dataLow['date'].toDate().month.toString() + dataLow['date'].toDate().day.toString()
                                      ) {
                                        var section = ExampleSection()
                                          ..header = document['date'].toDate().year.toString() + zeroToTen(document['date'].toDate().month.toString()) + zeroToTen(document['date'].toDate().day.toString())
                                        // ..items = List.generate(int.parse(document['length']), (index) => document.id)
                                        //   ..items = listCreation(document.id, document['data'], document).cast<String>()

                                        //   ..items = document['daily_order'].cast<String>()


                                        // ..items = sortList(changeData(dataLow['daily_order'].cast<String>(), snapshot2)) + sortList(changeData(document['daily_order'].cast<String>(), snapshot2))
                                          ..items = sortList(changeDataNew(dataLowDailyOrder.cast<String>()) + changeDataNew(dailyOrders.cast<String>()))
                                        // ..items = orderItems(document.id)
                                          ..expanded = true;
                                        // sections.add(section);
                                        sections[sections.length-1] = section;
                                      } else {
                                        // print('herre ' + document.id);
                                        var section = ExampleSection()
                                          ..header = document['date'].toDate().year.toString() + zeroToTen(document['date'].toDate().month.toString()) + zeroToTen(document['date'].toDate().day.toString())
                                        // ..items = List.generate(int.parse(document['length']), (index) => document.id)
                                        //   ..items = listCreation(document.id, document['data'], document).cast<String>()

                                        //   ..items = document['daily_order'].cast<String>()


                                          ..items = sortList(changeDataNew(dailyOrders.cast<String>()))
                                        // ..items = orderItems(document.id)
                                          ..expanded = true;
                                        sections.add(section);
                                      }
                                    } else {
                                      // print('herre ' + document.id);
                                      var section = ExampleSection()
                                        ..header = document['date'].toDate().year.toString() + zeroToTen(document['date'].toDate().month.toString()) + zeroToTen(document['date'].toDate().day.toString())
                                      // ..items = List.generate(int.parse(document['length']), (index) => document.id)
                                      //   ..items = listCreation(document.id, document['data'], document).cast<String>()

                                      //   ..items = document['daily_order'].cast<String>()


                                        ..items = sortList(changeDataNew(dailyOrders.cast<String>()))
                                      // ..items = orderItems(document.id)
                                        ..expanded = true;
                                      sections.add(section);
                                    }



                                    docInc++;
                                  }).toList();
                                  sectionList3 = sections;

                                  return CustomScrollView(
                                    slivers: <Widget>[
                                      SliverAppBar(
                                        elevation: 0,
                                        backgroundColor: Colors.white,

                                        // Provide a standard title.

                                        // Allows the user to reveal the app bar if they begin scrolling
                                        // back up the list of items.
                                        floating: true,
                                        bottom: PreferredSize(                       // Add this code
                                          preferredSize: Size.fromHeight(-2.0),      // Add this code
                                          child: Container(),                           // Add this code
                                        ),
                                        flexibleSpace: Padding(
                                          padding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 0.0),
                                          child: Container(
                                            height: 32,
                                            width: MediaQuery.of(context).size.width,
                                            // color: Colors.yellow,
                                            child: Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    FlatButton(
                                                      padding: EdgeInsets.only(left: 10, right: 10),
                                                      color: AppTheme.secButtonColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        side: BorderSide(
                                                          color: AppTheme.skBorderColor2,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        // widget._callback();
                                                        _showDatePicker(OneContext().context);
                                                      },
                                                      child: Container(
                                                        child: Row(
                                                          // mainAxisAlignment: Main,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(right: 3.0),
                                                              child: Icon(
                                                                Icons.calendar_view_day_rounded,
                                                                size: 18,
                                                              ),
                                                            ),
                                                            Text(
                                                              selectDaysCast() + ' (7D)',
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
                                                Expanded(
                                                  child: ListView(
                                                    controller: cateScCtler,
                                                    scrollDirection: Axis.horizontal,
                                                    children: [
                                                      SizedBox(
                                                        width: 4,
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
                                                              textSetAll,
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
                                                          },
                                                          child: Container(
                                                            child: Text(
                                                              textSetTUnpaid,
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
                                                              textSetTRefunds,
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
                                                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                                        child: FlatButton(
                                                          minWidth: 0,
                                                          padding: EdgeInsets.only(left: 12, right: 12),
                                                          color: cateScIndex == 3 ? AppTheme.secButtonColor:Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20.0),
                                                            side: BorderSide(
                                                              color: AppTheme.skBorderColor2,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            _animateToIndex(20);
                                                            setState(() {
                                                              cateScIndex = 3;
                                                            });
                                                          },
                                                          child: Container(
                                                            child: Text(
                                                              textSetTPaid,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.black),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
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
                                        // Display a placeholder widget to visualize the shrinking size.
                                        // Make the initial height of the SliverAppBar larger than normal.
                                        expandedHeight: 20,
                                      ),
                                      SliverExpandableList(
                                        builder: SliverExpandableChildDelegate(
                                          sectionList: sectionList3,
                                          headerBuilder: _buildHeader,
                                          itemBuilder: (context, sectionIndex, itemIndex, index) {
                                            String item = sectionList3[sectionIndex].items[itemIndex];
                                            int length = sectionList3[sectionIndex].items.length;

                                            if(itemIndex == length-1) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  closeDrawerFrom();
                                                  // print(item.split('^')[1]);
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => OrderInfoSub(printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev, closeCartBtn: closeCartFrom, data: item, toggleCoinCallback: () {}, shopId: widget.shopId.toString(), openCartBtn: openCartFrom,)),
                                                  );
                                                  openDrawerFrom();
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
                                                                        Text('#' + item.split('^')[1],
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
                                                                        Text(convertToHour(item.split('^')[0]) + ':' + item.split('^')[0].substring(10,12) +' ' + convertToAMPM(item.split('^')[0]),
                                                                          style: TextStyle(
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w400,
                                                                            color: Colors.grey,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    // Padding(
                                                                    //   padding: const EdgeInsets.only(top: 8.0, bottom: 3.0),
                                                                    //   child: Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2)),
                                                                    // ),
                                                                    SizedBox(
                                                                      height: 6,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(item.split('^')[3].split('&')[0],
                                                                          style: TextStyle(
                                                                            fontSize: 15,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: Colors.grey,
                                                                          ),
                                                                          strutStyle: StrutStyle(
                                                                            height: 1.3,
                                                                            // fontSize:,
                                                                            forceStrutHeight: true,
                                                                          ),
                                                                        ),

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
                                                                  if(item.split('^')[5] == '0.0')
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 0.0),
                                                                      child: Container(
                                                                        height: 21,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(20.0),
                                                                          color: AppTheme.badgeBgSuccess,
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                                          child: Text('Paid',
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.white
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),

                                                                  if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 0.0),
                                                                      child: Container(
                                                                        height: 21,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(20.0),
                                                                          color: AppTheme.badgeFgDangerLight,
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                                          child: Text('Partially paid',
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: AppTheme.badgeFgDanger
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 0.0),
                                                                      child: Container(
                                                                        height: 21,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(20.0),
                                                                          color: AppTheme.badgeFgDanger,
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                                          child: Text('Unpaid',
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.white
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if(item.split('^')[4] == 'TRUE')
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 6.0),
                                                                      child: Container(
                                                                        height: 21,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(20.0),
                                                                          color: AppTheme.badgeBgSecond,
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                                          child: Text('Refunded',
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.white
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),

                                                                  if(item.split('^')[4] == 'PART')
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 6.0),
                                                                      child: Container(
                                                                        height: 21,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(20.0),
                                                                          color: AppTheme.badgeBgSecondLight,
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
                                                                          child: Text('Partially refunded',
                                                                            style: TextStyle(
                                                                                fontSize: 13,
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
                                                            Text('$currencyUnit ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
                                                              fontSize: 15,fontWeight: FontWeight.w500,
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
                                            }
                                            return GestureDetector(
                                              onTap: () async {
                                                closeDrawerFrom();
                                                print('Items'+item);
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => OrderInfoSub(printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev, closeCartBtn: closeCartFrom, data: item, toggleCoinCallback: () {}, shopId: widget.shopId.toString(), openCartBtn: openCartFrom,)),
                                                );
                                                openDrawerFrom();
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
                                                                      Text('#' + item.split('^')[1],
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
                                                                      Text(convertToHour(item.split('^')[0]) + ':' + item.split('^')[0].substring(10,12) +' ' + convertToAMPM(item.split('^')[0]),
                                                                        style: TextStyle(
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
                                                                      Text(item.split('^')[3].split('&')[0], style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey,
                                                                      ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1.3,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
                                                                        ),

                                                                      ),

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
                                                                if(item.split('^')[5] == '0.0')
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 0.0),
                                                                    child: Container(
                                                                      height: 21,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(20.0),
                                                                        color: AppTheme.badgeBgSuccess,
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                                        child: Text('Paid',
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.white
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 0.0),
                                                                    child: Container(
                                                                      height: 21,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(20.0),
                                                                        color: AppTheme.badgeFgDangerLight,
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                                        child: Text('Partially paid',
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: AppTheme.badgeFgDanger
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 0.0),
                                                                    child: Container(
                                                                      height: 21,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(20.0),
                                                                        color: AppTheme.badgeFgDanger,
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                                        child: Text('Unpaid',
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.white
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                if(item.split('^')[4] == 'TRUE')
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 6.0),
                                                                    child: Container(
                                                                      height: 21,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(20.0),
                                                                        color: AppTheme.badgeBgSecond,
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                                        child: Text('Refunded',
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.white
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                if(item.split('^')[4] == 'PART')
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 6.0),
                                                                    child: Container(
                                                                      height: 21,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(20.0),
                                                                        color: AppTheme.badgeBgSecondLight,
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
                                                                        child: Text('Partially refunded',
                                                                          style: TextStyle(
                                                                              fontSize: 13,
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
                                                          Text('$currencyUnit ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
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

                                            // return Container(
                                            //   child: Text(item)
                                            // );
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return Container();
                                }

                              }
                          )
                      ),
                    ),
                  ),
                if(searchOpeningR)
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                            child: CupertinoActivityIndicator(radius: 15,)),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                              color: AppTheme.skBorderColor2,
                              width: 1.0),
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 15.0, right: 15.0, bottom: 15),
                      child: GestureDetector(
                        onTap: () {
                          widget._searchBtn();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: loadingSearch? Colors.blue: Colors.transparent,
                              style: BorderStyle.solid,
                              width: 1.0,
                            ),
                            color: AppTheme.secButtonColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 11.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if(loadingSearch) {
                                      _searchController.clear();
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        loadingSearch = false;
                                      });
                                    } else {
                                      FocusScope.of(context).requestFocus(nodeFirst);
                                      setState(() {
                                        loadingSearch = true;
                                      });
                                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Container(
                                      child: Stack(
                                        children: [
                                          !loadingSearch? Padding(
                                            padding: const EdgeInsets.only(left: 5.0),
                                            child: Icon(
                                              SmartKyat_POS.search,
                                              size: 17,
                                            ),
                                          ): Padding(
                                            padding: const EdgeInsets.only(left: 2, bottom: 1.0),
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 24,
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 13,
                                          bottom: 1.5),
                                      child: Text(
                                        textSetSearch,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black.withOpacity(0.55)
                                        ),
                                      )
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget._barcodeBtn();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 15.0,
                                    ),
                                    // child: Icon(
                                    //   SmartKyat_POS.barcode,
                                    //   color: Colors.black,
                                    //   size: 25,
                                    // ),
                                    child: Container(
                                        child: Image.asset('assets/system/barcode.png', height: 28,)
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //overAllSearch()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _animateToIndex(i) {
    // print((_width * i).toString() + ' BBB ' + cateScCtler.offset.toString() + ' BBB ' + cateScCtler.position.maxScrollExtent.toString());
    if((_width * i) > cateScCtler.position.maxScrollExtent) {
      cateScCtler.animateTo(cateScCtler.position.maxScrollExtent, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    } else {
      cateScCtler.animateTo(_width * i, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    }

  }



  covertToDayNum(String input) {
    if(input[0]=='0') {
      return input[1];
    } else {
      return input;
    }
  }

  checkTest(String input) {
    print("CHECK TEST " + input);
  }

  convertToAMPM(String input){
    switch (input.substring(8,10)) {
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

  convertToHour(String input){
    switch (input.substring(8,10)) {
      case '00':
        return '12';
        break;
      case '01':
        return '1';
        break;
      case '02':
        return '2';
        break;
      case '03':
        return '3';
        break;
      case '04':
        return '4';
        break;
      case '05':
        return '5';
        break;
      case '06':
        return '6';
        break;
      case '07':
        return '7';
        break;
      case '08':
        return '8';
        break;
      case '09':
        return '9';
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

  convertToDate(String input) {
    switch (input.substring(4,6)) {
      case '01':
        return 'JANUARY';
        break;
      case '02':
        return 'FEBRUARY';
        break;
      case '03':
        return 'MARCH';
        break;
      case '04':
        return 'APRIL';
        break;
      case '05':
        return 'MAY';
        break;
      case '06':
        return 'JUN';
        break;
      case '07':
        return 'JULY';
        break;
      case '08':
        return 'AUGUST';
        break;
      case '09':
        return 'SEPTEMBER';
        break;
      case '10':
        return 'OCTOBER';
        break;
      case '11':
        return 'NOVEMBER';
        break;
      case '12':
        return 'DECEMBER';
        break;
    }
  }

  changeDataNew(list) {
    for (var i = 0; i < list.length; i++) {
      if(list[i].split('^')[3].contains('<>')) {
        if(list[i].split('^')[3].split('<>')[1] == 'name') {
          list[i] = list[i].split('^')[0] +
              '^' +
              list[i].split('^')[1] +
              '^' +
              list[i].split('^')[2] +
              '^' +
              'No customer' +
              '&' +
              list[i].split('^')[3].split('<>')[0] +
              '^' +
              list[i].split('^')[4] +
              '^' +
              list[i].split('^')[5] +
              '^' +
              list[i].split('^')[6]
          ;
        } else {
          list[i] = list[i].split('^')[0] +
              '^' +
              list[i].split('^')[1] +
              '^' +
              list[i].split('^')[2] +
              '^' +
              list[i].split('^')[3].split('<>')[1] +
              '&' +
              list[i].split('^')[3].split('<>')[0] +
              '^' +
              list[i].split('^')[4] +
              '^' +
              list[i].split('^')[5] +
              '^' +
              list[i].split('^')[6]
          ;
        }

      } else {
        list[i] = list[i].split('^')[0] +
            '^' +
            list[i].split('^')[1] +
            '^' +
            list[i].split('^')[2] +
            '^' +
            'Check in new version' +
            '&' +
            list[i].split('^')[3] +
            '^' +
            list[i].split('^')[4] +
            '^' +
            list[i].split('^')[5] +
            '^' +
            list[i].split('^')[6]
        ;
      }

    }

    // print('changeData ' + snpsht.da);
    return list;
  }

  changeData(list, snpsht) {
    // list[0].toString()
    snpsht.data!.docs.map((document) async {
      for (var i = 0; i < list.length; i++) {
        if (document.id.toString() == list[i].split('^')[3]) {
          list[i] = list[i].split('^')[0] +
              '^' +
              list[i].split('^')[1] +
              '^' +
              list[i].split('^')[2] +
              '^' +
              document['customer_name'].toString() +
              '&' +
              list[i].split('^')[3] +
              '^' +
              list[i].split('^')[4] +
              '^' +
              list[i].split('^')[5] +
              '^' +
              list[i].split('^')[6]
          ;
        }
      }
      // print('changeData ' + document['customer_name'].toString() + list[0].toString());
    }).toList();

    // print('changeData ' + snpsht.da);
    return list;
  }

  changeData2(list, snpsht) {
    // list[0].toString()
    snpsht.data!.docs.map((document) async {
      for (var i = 0; i < list.length; i++) {
        if (document.id.toString() == list[i].split('^')[3]) {
          list[i] = list[i].split('^')[0] +
              '^' +
              list[i].split('^')[1] +
              '^' +
              list[i].split('^')[2] +
              '^' +
              // document['customer_name'].toString() +
              '&' +
              list[i].split('^')[3] +
              '^' +
              list[i].split('^')[4];
        }
      }
      // print('changeData ' + document['customer_name'].toString() + list[0].toString());
    }).toList();

    // print('changeData ' + snpsht.da);
    return list;
  }

  sortList(list) {
    var dlist = list;
    dlist.sort();
    var newList = List.from(dlist.reversed);
    // dlist.sort((a, b) => b.compareTo(a));
    return newList.cast<String>();
    // list.sort(alphabetic('name'));
  }

  Widget _buildHeader(BuildContext context, int sectionIndex, int index) {
    ExampleSection section = sectionList3[sectionIndex];
    // print('section check '+ sectionList3[sectionIndex].items.length.toString());
    if(sectionList3[sectionIndex].items.length == 0) {
      return Container();
    }
    return InkWell(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                      color: AppTheme.skBorderColor2,
                      width: 1.0),
                )
            ),
            alignment: Alignment.centerLeft,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                height: 33,
                child: Padding(
                  // padding: const EdgeInsets.only(left: 15.0, top: 12, bottom: 0),
                  padding: const EdgeInsets.only(left: 15.0, top: 1, bottom: 0),
                  child: Row(
                    children: [
                      Text(
                        // "TODAY",
                        // checkTest(section.header),
                        covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                        style: TextStyle(
                            height: 0.8,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: Colors.black
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            // "#30",
                            '#' + sectionList3[sectionIndex].items.length.toString(),
                            // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                            style: TextStyle(
                              height: 0.8,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        onTap: () {

          //toggle section expand state
          // setState(() {
          //   section.setSectionExpanded(!section.isSectionExpanded());
          // });
        });
  }

  List<String> gloTemp = [];

  // listCreation(String id, data, document) {
  //   List<String> temp = [];
  //   // temp.add('add');
  //   // temp.add('add2');UzZeGlXAnNfrH7icA1ki
  //
  //   // FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(id).collection('detail')
  //   //     .get()
  //   //     .then((QuerySnapshot querySnapshot) {
  //   //   querySnapshot.docs.forEach((doc) {
  //   //     temp.add(doc["cust_name"]);
  //   //     // setState(() {
  //   //     //   gloTemp = temp;
  //   //     // });
  //   //     // gloTemp = temp;
  //   //   });
  //   //
  //   // }).then((value) {
  //   //   // print('here ' + temp.toString());
  //   //   //return temp;
  //   //   // return gloTemp;
  //   // });
  //   // print('here2 ' + temp.toString());
  //   // return gloTemp;
  //
  //
  //   // for()
  //   // var noExe = true;
  //
  //
  //   temp = data.split('^');
  //
  // }

  addDailyExp(priContext) {
    // myController.clear();
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
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

  DateTime today = DateTime.now();
  DateTime? _dateTime;
  String _format = 'yyyy-MMMM-dd';



  void _showDatePicker(context) {
    DatePicker.showDatePicker(
      context,
      onMonthChangeStartWithFirstDate: true,
      pickerTheme: DateTimePickerTheme(
        showTitle: false,
        confirm: Text('Done', style: TextStyle(color: Colors.blue)),
      ),
      minDateTime: DateTime.parse('2010-05-12'),
      // maxDateTime: DateTime.parse('2021-11-25'),
      maxDateTime: DateTime.now().add(const Duration(days: 365)),
      initialDateTime: today,
      dateFormat: _format,
      locale: DateTimePickerLocale.en_us,
      onClose: () {
        setState((){
          _dateTime = _dateTime;
          today = today;
          // DateTime td = DateTime.now();
          print('closed 1 ' + today.toString());
          // print('closed 2 ' + td.toString());
        });
        // fetchOrders();
      },
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        // setState(() {
        today = dateTime;
        _dateTime = dateTime;
        // });


      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          today = dateTime;
          _dateTime = dateTime;
        });
      },
    );
  }

  DateTime lossDayStart() {
    // DateTime today = DateTime.now();
    // DateTime yearStart = DateTime.now();
    // DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
    // today.
    String endDateOfMonth = '31';
    if(today.month.toString() == '9' || today.month.toString() == '4' || today.month.toString() == '6' || today.month.toString() == '11') {
      endDateOfMonth = '30';
    } else if(today.month.toString() == '2') {
      endDateOfMonth = '29';
    } else {
      endDateOfMonth = '31';
    }
    DateTime yearStart = DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + endDateOfMonth + ' 23:59:59');
    print('DDDDD ' + yearStart.toString());
    return yearStart;
  }

  DateTime lossDayEnd() {
    // DateTime today = DateTime.now();
    // DateTime yearStart = DateTime.now();
    // DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
    // today.
    DateTime notTday = today;
    notTday = today;
    DateTime yearStart = DateFormat("yyyy-MM-dd hh:mm:ss").parse(notTday.year.toString() + '-' + zeroToTen(notTday.month.toString()) + '-00 23:59:59');
    print('DDDDDD ' + yearStart.toString());
    return yearStart;

  }

  String selectDaysCast() {
    print("TTT " + today.year.toString().length.toString());
    // if(_sliding==0) {
    // today.year.toString().substring(today.year.toString().length-2, today.year.toString().length
    if(today.month == 9) {
      return 'Sep ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 1) {
      return 'Jan ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 2) {
      return 'Feb ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 3) {
      return 'Mar ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 4) {
      return 'Apr ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 5) {
      return 'May ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 6) {
      return 'Jun ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 7) {
      return 'Jul ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 8) {
      return 'Aug ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 10) {
      return 'Oct ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 11) {
      return 'Nov ' + today.day.toString() + ', ' + today.year.toString();
    } else if(today.month == 12) {
      return 'Dec ' + today.day.toString() + ', ' + today.year.toString();
    } else {
      return '';
    }

  }

  ordersQuery() {
    // DateTime greaterThan = DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.subtract(Duration(days: 6)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 6)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 6)).day.toString()) + ' 00:00:00');
    return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders')
        .where('date', isGreaterThan: DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.subtract(Duration(days: 6)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 6)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 6)).day.toString()) + ' 00:00:00'))
        .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(today.add(Duration(days: 1)).day.toString()) + ' 00:00:00'))
        .orderBy('date', descending: true);
  }
// List<String> orderItems(String id) {}
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final Container _tabBar;

  @override
  double get minExtent => 101;
  @override
  double get maxExtent => 101;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      height: 200,
      color: Colors.transparent,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

///Section model example
///
///Section model must implements ExpandableListSection<T>, each section has
///expand state, sublist. "T" is the model of each item in the sublist.
class ExampleSection implements ExpandableListSection<String> {
  //store expand state.
  late bool expanded;

  //return item model list.
  late List<String> items;

  //example header, optional
  late String header;

  @override
  List<String> getItems() {
    return items;
  }

  @override
  bool isSectionExpanded() {
    return expanded;
  }

  @override
  void setSectionExpanded(bool expanded) {
    this.expanded = expanded;
  }
}

// print(item.split('^')[0].substring(0,8));
// var dateId = '';
// FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
// // FirebaseFirestore.instance.collection('space')
// .where('date', isEqualTo: item.split('^')[0].substring(0,8))
// .get()
//     .then((QuerySnapshot querySnapshot) {
// querySnapshot.docs.forEach((doc) {
// dateId = doc.id;
// FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId)
//
//     .update({
// 'daily_order': FieldValue.arrayRemove([item])
// })
//     .then((value) {
// print('array removed');
//
// FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId)
//
//     .update({
// 'daily_order': FieldValue.arrayUnion([item.split('^')[0]+'^'+item.split('^')[1]+'^total^name^fp'])
// })
//     .then((value) {
// print('array updated');
// });
//
//
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
