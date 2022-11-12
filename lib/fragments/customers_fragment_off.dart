
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:blue_print_pos/models/blue_device.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';
// import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/bloc_customers.dart';
import 'package:smartkyat_pos/fragments/subs/customer_info.dart';
import 'package:smartkyat_pos/fragments/subs/language_settings.dart';
import 'package:smartkyat_pos/pages2/single_assets_page.dart';
import 'package:smartkyat_pos/widgets/add_new_customer.dart';
import 'package:smartkyat_pos/fragments/orders_fragment.dart';
import 'package:smartkyat_pos/fragments/subs/buy_list_info.dart';
import 'package:smartkyat_pos/fragments/subs/merchant_info.dart';
import 'package:smartkyat_pos/fragments/subs/order_info.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
import 'package:smartkyat_pos/widgets/product_details_view2.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import '../app_theme.dart';

class CustomersFragment extends StatefulWidget {
  final _callback2;
  final _callback;
  final _callback3;
  final _callback4;
  final _barcodeBtn;
  final _searchBtn;
  final addCust;
  final _closeCartBtn;
  final _openCartBtn;
  final _openDrawerBtn;
  final _closeDrawerBtn;
  final _printFromOrders;
  CustomersFragment({
    this.selectedDev, required void printFromOrders(File file, var prodListPR),
    required void closeDrawerBtn(String str),
    required void openDrawerBtn(String str),
    required void closeCartBtn(String str),
    required void openCartBtn(String str),
    required void toggleCoinCallback6(),
    required void searchBtn(),
    required this.customersSnapshot,
    required this.shopId,
    required this.isEnglish,
    required void barcodeBtn(), required void toggleCoinCallback2(String str), required void toggleCoinCallback(String str), required void toggleCoinCallback3(String str), required void toggleCoinCallback4(String str),Key? key,
  }) : _openDrawerBtn = openDrawerBtn, _closeDrawerBtn = closeDrawerBtn, _closeCartBtn = closeCartBtn ,addCust = toggleCoinCallback6, _searchBtn = searchBtn, _barcodeBtn = barcodeBtn, _callback2 = toggleCoinCallback2,_callback = toggleCoinCallback,_callback3 = toggleCoinCallback3, _callback4 = toggleCoinCallback4, _openCartBtn = openCartBtn,_printFromOrders = printFromOrders, super(key: key);
  final String shopId;
  final customersSnapshot;
  final BlueDevice? selectedDev;
  final bool isEnglish;
  @override
  CustomersFragmentState createState() => CustomersFragmentState();
}

class CustomersFragmentState extends State<CustomersFragment> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<CustomersFragment>{

  TextEditingController _searchController = TextEditingController();
  bool loadingSearch = false;

  FocusNode nodeFirst = FocusNode();

  String searchProdCount = '0';

  bool buySellerStatus = false;

  int custsNumber = 0;

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

  String textSetNewCus = 'Customer';
  String textSetAll = 'All';
  String textSetUnpaids = 'Unpaids';
  String textSetSearch = 'Search';

  List<List> orderList = [];
  var orders;
  var docId;
  var innerId;

  // Stream<QuerySnapshot>? customerSnapshot;

  bool searchOpening = false;

  bool searchOpeningR = false;

  changeSearchOpening(bool index) {
    setState(() {
      searchOpening = index;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        searchOpeningR = index;
      });
    });
  }

  // getLangId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if(prefs.getString('lang') == null) {
  //     return 'english';
  //   }
  //   return prefs.getString('lang');
  // }

  void closeCartFrom() {
    widget._closeCartBtn('customers');
  }

  void openCartFrom() {
    widget._openCartBtn('customers');
  }

  void closeDrawerFrom() {
    widget._closeDrawerBtn('customers');
  }

  void openDrawerFrom() {
    widget._openDrawerBtn('customers');
  }

  var prodsSnap;

  bool i0Clicked = true;
  bool i1Clicked = true;

  @override
  initState() {

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels && !endOfResult) {
        debugPrint('maxxed ');
        Future.delayed(const Duration(milliseconds: 500), () {
          itemPerPage = itemPerPage + 10;
          setState(() {});
        });

      }
    });

    prodsSnap =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('cusArr').snapshots();

    if(widget.isEnglish == true){
      setState(() {
        textSetNewCus = 'Customer';
        textSetAll = 'All';
        textSetUnpaids = 'Unpaids';
        textSetSearch = 'Search';
      });
    }
    else {
      setState(() {
        textSetNewCus = 'ဝယ်သူ';
        textSetAll = 'အားလုံး';
        textSetUnpaids = 'မရှင်းသေး';
        textSetSearch = 'ရှာဖွေရန်';
      });
    }

    super.initState();
  }

  void printFromOrdersFun(File file, var prodListPR) {
    widget._printFromOrders(file, prodListPR);
  }

  @override
  void dispose() {
    super.dispose();
  }

  addCustomer2Cart1(data) {
    widget._callback2(data);
  }

  closeNewProduct() {
    Navigator.pop(context);
  }

  addProduct3(data) {
    widget._callback(data);
  }

  addProduct1(data) {
    widget._callback4(data);
  }

  addMerchant2Cart(data) {
    widget._callback3(data);
  }

  void closeSearch() {
    _searchController.clear();
    debugPrint('clicked testing ');
    FocusScope.of(context).unfocus();
    setState(() {
      loadingSearch = false;
    });
  }
  void unfocusSearch() {
    debugPrint('clicked testing 2');
    FocusScope.of(context).unfocus();
  }

  Map sortMapByNaS(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => ((map[k1]['na'].compareTo(map[k2]['na']))));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }
  Map sortMapByNaR(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => ((map[k2]['na'].compareTo(map[k1]['na']))));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  Map sortMapByImS(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => ((map[k1]['da'].compareTo(map[k2]['da']))));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }
  Map sortMapByImR(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => ((map[k2]['da'].compareTo(map[k1]['da']))));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  final cateScCtler = ScrollController();
  final _width = 10.0;
  int cateScIndex = 0;

  Map<dynamic, dynamic> resProds = {};

  bool endOfResult = false;

  ScrollController _scrollController = ScrollController();
  int itemPerPage = 10;

  @override
  Widget build(BuildContext context) {
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
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 81.0),
                      child:  Container(),
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
                          // FocusScope.of(context).requestFocus(nodeFirst);
                          // setState(() {
                          //   loadingSearch = true;
                          // });
                          // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
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

                                    // if(loadingSearch) {
                                    //   _searchController.clear();
                                    //   FocusScope.of(context).unfocus();
                                    //   setState(() {
                                    //     loadingSearch = false;
                                    //   });
                                    // } else {
                                    //   FocusScope.of(context).requestFocus(nodeFirst);
                                    //   setState(() {
                                    //     loadingSearch = true;
                                    //   });
                                    //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                                    // }
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
                                // Expanded(
                                //   child: Padding(
                                //     padding: EdgeInsets.only(
                                //         left: !loadingSearch? 8.0: 4,
                                //         right: 8.0,
                                //         top: 0.5),
                                //     child: Text('Search'),
                                //   ),
                                // ),
                                Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 13,
                                          bottom: 1.5),
                                      child: Text(
                                        textSetSearch, textScaleFactor: 1,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black.withOpacity(0.55)
                                        ),
                                        strutStyle: StrutStyle(
                                            forceStrutHeight: true,
                                            height: textSetSearch == 'Search'? 1.6: 1.3
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
                                    //   color: Colors.Colors.black,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  _animateToIndex(i) {
    // debugPrint((_width * i).toString() + ' BBB ' + cateScCtler.offset.toString() + ' BBB ' + cateScCtler.position.maxScrollExtent.toString());
    if((_width * i) > cateScCtler.position.maxScrollExtent) {
      cateScCtler.animateTo(cateScCtler.position.maxScrollExtent, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    } else {
      cateScCtler.animateTo(_width * i, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    }
  }

  unpaidCount(int index) {
    return orderList;
  }

  void add2OrderList(int index, int orderLength) {
    setState(() {
      orderList[index].add(orderLength);
    });
  }
}

Future<String> getStoreId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // return(prefs.getString('store'));

  var index = prefs.getString('store');
  debugPrint(index);
  if (index == null) {
    return 'idk';
  } else {
    return index;
  }
}

setStoreId(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // return(prefs.getString('store'));

  prefs.setString('store', id);
}