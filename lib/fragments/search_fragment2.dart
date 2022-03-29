import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:blue_print_pos/models/blue_device.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/search_blocs/products_bloc.dart';
import 'package:smartkyat_pos/fragments/subs/customer_info.dart';
import 'package:smartkyat_pos/fragments/subs/language_settings.dart';
import 'package:smartkyat_pos/fragments/subs/merchant_info.dart';
import 'package:smartkyat_pos/widgets/add_new_merchant.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
import 'package:smartkyat_pos/fragments/orders_fragment.dart';
import 'package:smartkyat_pos/fragments/subs/buy_list_info.dart';
import 'package:smartkyat_pos/fragments/subs/order_info.dart';
import 'package:smartkyat_pos/widgets/product_details_view.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import '../app_theme.dart';

class SearchFragment extends StatefulWidget {
  final _callback3;
  final _callback;
  final _callback2;
  final _callback4;
  final _barcodeBtn;
  final _chgIndex;
  final _closeCartBtn;
  final _openCartBtn;
  final _openDrawerBtn;
  final _closeDrawerBtn;
  final _printFromOrders;

  SearchFragment( {
    this.selectedDev, required void printFromOrders(File file, var prodListPR),
    required void closeDrawerBtn(String str),
    required void openDrawerBtn(String str),
    required this.productsSnapshot,
    required void barcodeBtn(),
    required void toggleCoinCallback3(String str),
    required void toggleCoinCallback(String str),
    required void toggleCoinCallback2(String str),
    required void toggleCoinCallback4(String str),
    required void closeCartBtn(String str),
    required void openCartBtn(String str),
    required this.shopId,
    Key? key,
    required Function(dynamic index) chgIndexFromSearch,}
      ) : _closeCartBtn = closeCartBtn,
        _openCartBtn = openCartBtn,
        _chgIndex = chgIndexFromSearch,
        _barcodeBtn = barcodeBtn,
        _callback3 = toggleCoinCallback3, _callback = toggleCoinCallback, _callback2 = toggleCoinCallback2,_callback4 = toggleCoinCallback4, _openDrawerBtn = openDrawerBtn, _closeDrawerBtn = closeDrawerBtn, _printFromOrders = printFromOrders, super(key: key);
  final productsSnapshot;
  final BlueDevice? selectedDev;
  final String shopId;

  @override
  SearchFragmentState createState() => SearchFragmentState();
}

class SearchFragmentState extends State<SearchFragment> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<SearchFragment>{
  String? shopId;

  TextEditingController _searchController = TextEditingController();
  bool loadingSearch = true;

  FocusNode nodeFirst = FocusNode();

  String searchProdCount = '0';

  bool buySellerStatus = false;

  String currencyUnit = 'MMK';

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

  List<List> orderList = [];
  var orders;
  var docId;
  var innerId;

  String textSetSearch = 'Search';

  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

  void closeCartFrom() {
    widget._closeCartBtn('search');
  }

  void openCartFrom() {
    widget._openCartBtn('search');
  }

  void closeDrawerFrom() {
    widget._closeDrawerBtn('search');
  }

  void openDrawerFrom() {
    widget._openDrawerBtn('search');
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
    getStoreId().then((value) => shopId = value);
    _searchController.addListener((){
      // setState(() {
      gloSearchText = _searchController.text;
      searchValue = _searchController.text.toLowerCase();
      // });
      searchKeyChanged();
      print(searchValue);
    });
    subTabController = TabController(length: 3, vsync: this);
    slidingSearchCont();

    var sections = List<ExampleSection>.empty(growable: true);
    var section = ExampleSection()
      ..header = ''
    // ..items = List.generate(int.parse(document['length']), (index) => document.id)
    //   ..items = listCreation(document.id, document['data'], document).cast<String>()

    //   ..items = document['daily_order'].cast<String>()


      ..items = ['']
    // ..items = orderItems(document.id)
      ..expanded = true;
    sections.add(section);
    sectionList = sections;
    sectionList1 = sections;
    sectionList2 = sections;
    sectionListNo = sections;


    nodeFirst.addListener(() {
      if(nodeFirst.hasFocus) {
        setState(() {
          loadingSearch = true;
        });
      }
    });
    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetSearch = 'ရှာဖွေရန်';

        });
      } else if(value=='english') {
        setState(() {
          textSetSearch = 'Search';
        });
      }
    });
    super.initState();
    // WidgetsBinding.instance!
    //     .addPostFrameCallback((_) {
    //   FocusScope.of(context).requestFocus(nodeFirst);
    // });
  }

  focusSearch() {
    FocusScope.of(context).requestFocus(nodeFirst);
  }


  @override
  void dispose() {
    super.dispose();
  }

  addProduct3(data) {
    widget._callback2(data);
  }

  addProduct1(data) {
    widget._callback(data);
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

  chgShopIdFrmHomePage() {
    setState(() {
      getStoreId().then((value) => shopId = value);
    });
  }

  addCustomer2Cart1(data) {
    widget._callback4(data);
  }
  addMerchant2Cart(data) {
    widget._callback3(data);
  }

  void closeSearch() {
    _searchController.clear();
    print('clicked testing ');
    FocusScope.of(context).unfocus();
    setState(() {
      loadingSearch = true;
    });
  }
  void unfocusSearch() {
    print('clicked testing 2');
    // FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus!.unfocus();
  }

  searchFocus() {

    setState(() {
      loadingSearch = true;
    });
  }

  Widget _buildHeader1(BuildContext context, int sectionIndex, int index) {
    ExampleSection section = sectionList1[sectionIndex];
    // if(sectionIndex == 0) {
    //   return Container(
    //     height: 0.1,
    //   );
    // }
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
                        sectionIndex == 0 ? "BUYERS" : "SELLERS",
                        // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                        style: TextStyle(
                            height: 0.8,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: Colors.black
                        ),
                      ),
                      Spacer(),
                      searchValue != '' ?
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: section.header != '' ? Text(
                          section.header.split('^')[1],
                          // '0',
                          // '#' + sectionList[sectionIndex].items.length.toString(),
                          // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                          style: TextStyle(
                            height: 0.8,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.right,
                        ): Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                              child: CupertinoActivityIndicator(radius: 8,)),
                        ),
                      ):
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                              child: CupertinoActivityIndicator(radius: 8,)),
                        ),
                      )
                      ,
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

  Widget _buildHeader2(BuildContext context, int sectionIndex, int index) {
    ExampleSection section = sectionList2[sectionIndex];
    // if(sectionIndex == 0) {
    //   return Container(
    //     height: 0.1,
    //   );
    // }
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
                        section.header == '' ? 'SALE ORDERS' : section.header.split('^')[0].toUpperCase(),
                        // sectionIndex == 0 ? "SALE ORDERS" : "BUY ORDERS",
                        // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                        style: TextStyle(
                            height: 0.8,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: Colors.black
                        ),
                      ),
                      Spacer(),
                      searchValue != '' ?
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: buySellOrderHeaders(section.header),
                      ):
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                              child: CupertinoActivityIndicator(radius: 8,)),
                        ),
                      )
                      ,
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

  Widget _buildHeader3(BuildContext context, int sectionIndex, int index) {
    return Container(
        height: 50,
        child: Center(child: Text('Searching...'))
    );
  }

  Future<List<String>>changeData3(list) async {
    // list[0].toString()

    for(int i = 0; i < list.length; i++) {
      await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('customers').doc(list[i].split('^')[3])
          .get().then((value) async {
        if(value.exists) {
          print('customer name ' + value.data()!['customer_name'].toString());
          list[i] = list[i].split('^')[0] +
              '^' +
              list[i].split('^')[1] +
              '^' +
              list[i].split('^')[2] +
              '^' +
              value.data()!['customer_name'].toString() +
              '&' +
              list[i].split('^')[3] +
              '^' +
              list[i].split('^')[4] +
              '^' +
              list[i].split('^')[5] +
              '^' +
              list[i].split('^')[6] +
              '^' +
              list[i].split('^')[7] +
              '^' +
              list[i].split('^')[8]+
              '^' + 's'
          ;
        } else {
          print('customer name ' + value.data()!['customer_name'].toString());
          list[i] = list[i].split('^')[0] +
              '^' +
              list[i].split('^')[1] +
              '^' +
              list[i].split('^')[2] +
              '^' +
              'Loading' +
              '&' +
              list[i].split('^')[3] +
              '^' +
              list[i].split('^')[4] +
              '^' +
              list[i].split('^')[5] +
              '^' +
              list[i].split('^')[6] +
              '^' +
              list[i].split('^')[7] +
              '^' +
              list[i].split('^')[8]+
              '^' + 's'
          ;
        }
        // length = int.parse(value.data()!['customer_name'].toString());

      });
    }
    // snpsht.docs.map((document) async {
    //   for (var i = 0; i < list.length; i++) {
    //     if (document.id.toString() == list[i].split('^')[3]) {
    //       list[i] = list[i].split('^')[0] +
    //           '^' +
    //           list[i].split('^')[1] +
    //           '^' +
    //           list[i].split('^')[2] +
    //           '^' +
    //           document['customer_name'].toString() +
    //           '&' +
    //           list[i].split('^')[3] +
    //           '^' +
    //           list[i].split('^')[4] +
    //           '^' +
    //           list[i].split('^')[5] +
    //           '^' +
    //           list[i].split('^')[6] +
    //           '^' +
    //           list[i].split('^')[7] +
    //           '^' +
    //           list[i].split('^')[8]+
    //           '^' + 's'
    //       ;
    //     }
    //   }
    // print('changeData ' + document['customer_name'].toString() + list[0].toString());
    // }).toList();

    // print('changeData ' + snpsht.da);
    return list;
  }

  Future<List<String>>changeData4Fut(list) async {
    // list[0].toString()

    for(int i = 0; i < list.length; i++) {
      await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('merchants').doc(list[i].split('^')[3])
          .get().then((value) async {
        if(value.exists) {
          print('merchant name ' + value.data()!['merchant_name'].toString());
          list[i] = list[i].split('^')[0] +
              '^' +
              list[i].split('^')[1] +
              '^' +
              list[i].split('^')[2] +
              '^' +
              value.data()!['merchant_name'].toString() +
              '&' +
              list[i].split('^')[3] +
              '^' +
              list[i].split('^')[4] +
              '^' +
              list[i].split('^')[5] +
              '^' +
              list[i].split('^')[6] +
              '^' +
              list[i].split('^')[7] +
              '^' +
              list[i].split('^')[8]+
              '^' + 's'
          ;
        } else {
          print('merchant name ' + value.data()!['merchant_name'].toString());
          list[i] = list[i].split('^')[0] +
              '^' +
              list[i].split('^')[1] +
              '^' +
              list[i].split('^')[2] +
              '^' +
              'Loading' +
              '&' +
              list[i].split('^')[3] +
              '^' +
              list[i].split('^')[4] +
              '^' +
              list[i].split('^')[5] +
              '^' +
              list[i].split('^')[6] +
              '^' +
              list[i].split('^')[7] +
              '^' +
              list[i].split('^')[8]+
              '^' + 's'
          ;
        }
        // length = int.parse(value.data()!['customer_name'].toString());

      });
    }
    // snpsht.docs.map((document) async {
    //   for (var i = 0; i < list.length; i++) {
    //     if (document.id.toString() == list[i].split('^')[3]) {
    //       list[i] = list[i].split('^')[0] +
    //           '^' +
    //           list[i].split('^')[1] +
    //           '^' +
    //           list[i].split('^')[2] +
    //           '^' +
    //           document['customer_name'].toString() +
    //           '&' +
    //           list[i].split('^')[3] +
    //           '^' +
    //           list[i].split('^')[4] +
    //           '^' +
    //           list[i].split('^')[5] +
    //           '^' +
    //           list[i].split('^')[6] +
    //           '^' +
    //           list[i].split('^')[7] +
    //           '^' +
    //           list[i].split('^')[8]+
    //           '^' + 's'
    //       ;
    //     }
    //   }
    // print('changeData ' + document['customer_name'].toString() + list[0].toString());
    // }).toList();

    // print('changeData ' + snpsht.da);
    return list;
  }
  changeData4(list, snpsht) {
    // list[0].toString()
    snpsht.docs.map((document) async {
      for (var i = 0; i < list.length; i++) {
        if (document.id.toString() == list[i].split('^')[3]) {
          list[i] = list[i].split('^')[0] +
              '^' +
              list[i].split('^')[1] +
              '^' +
              list[i].split('^')[2] +
              '^' +
              document['merchant_name'].toString() +
              '&' +
              list[i].split('^')[3] +
              '^' +
              list[i].split('^')[4] +
              '^' +
              list[i].split('^')[5] +
              '^' +
              list[i].split('^')[6] +
              '^' +
              list[i].split('^')[7] +
              '^' +
              list[i].split('^')[8] +
              '^' + 'b'
          ;
        }
      }
      // print('changeData ' + document['customer_name'].toString() + list[0].toString());
    }).toList();

    // print('changeData ' + snpsht.da);
    return list;
  }

  Future<void> searchKeyChanged() async {
    setState(() {
      searchingOverAll = true;
    });

    if(searchValue != '') {
      if(slidingSearch == 2) {
        if(searchValue.toLowerCase().contains('b')) {
          if(searchValue.contains('-')) {
            searchValue = searchValue.split('-')[1].toLowerCase();
          }
          print('hereeee');
          sectionList2 = List<ExampleSection>.empty(growable: true);

          subTabController.animateTo(2, duration: Duration(microseconds: 0), curve: Curves.ease);

          print("search " + searchValue);
          String max = searchValue;
          // sectionList = [];
          List detailIdList = [];

          setState(() {
            var sections = List<ExampleSection>.empty(growable: true);

            var init = ExampleSection()
              ..header = ''
              ..items = ['']
              ..expanded = true;

            // var buyOrders = ExampleSection()
            //   ..header = 'Products'
            //   ..items = ['']
            //   ..expanded = true;
            sections.add(init);
            // sections.add(buyOrders);
            sectionList2 = sections;
          });

          await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrder')
              .where('orderId',  isEqualTo: searchValue)
              .limit(10)
              .get()
              .then((QuerySnapshot querySnapshot2) async {
            if(querySnapshot2.docs.length == 0) {
              setState(() {
                detailIdList = [];
                setState(() {
                  var sections = List<ExampleSection>.empty(growable: true);

                  var saleOrders = ExampleSection()
                    ..header = 'Buy orders^' + 'GG'
                    ..items = detailIdList.cast<String>()
                    ..expanded = true;

                  // var buyOrders = ExampleSection()
                  //   ..header = 'Buy orders^' + 'GG'
                  //   ..items = detailIdList.cast<String>()
                  //   ..expanded = true;

                  print('buy ord ' + detailIdList.length.toString());
                  sections.add(saleOrders);
                  // sections.add(buyOrders);
                  sectionList2 = sections;
                });
              });
            }
            querySnapshot2.docs.forEach((doc) {
              setState(() {
                detailIdList.add(doc['dateTime'].substring(0,4) + doc['dateTime'].substring(4,6) +  doc['dateTime'].substring(6,8) +  doc['dateTime'].substring(8,10) +  doc['dateTime'].substring(10,12) + '^' + doc['deviceId'] + doc['orderId'] + '^' + doc['total'].toString() + '^' + doc['merchantId'] + '^' + doc['refund'] + '^' + doc['debt'].toString() + '^' + doc['discount'].toString() + '^' + doc['date'].toDate().hour.toString() + '^' + doc['date'].toDate().minute.toString());
              });
            });


            changeData4Fut(detailIdList.cast<String>()).then((value) {
              setState(() {

                // if(detailIdList.length == 0) {
                //   noSearchData = true;
                // } else {
                //   noSearchData = false;
                // }
                var sections = List<ExampleSection>.empty(growable: true);

                var saleOrders = ExampleSection()
                  ..header = 'Buy orders^' + detailIdList.length.toString()
                  ..items = value.cast<String>()
                // ..items = detailIdList.cast<String>()
                  ..expanded = true;

                // var buyOrders = ExampleSection()
                //   ..header = 'Buy orders^' + detailIdList.length.toString()
                //   ..items = detailIdList.cast<String>()
                //   ..expanded = true;

                // print('buy ord ' + detailIdList.length.toString());
                sections.add(saleOrders);
                // sections.add(buyOrders);
                sectionList2 = sections;
              });
            });

            // await FirebaseFirestore.instance.collection('shops').doc(
            //     shopId).collection('merchants')
            //     .where("merchant_name", arrayContains: searchValue)
            //     .limit(10)
            //     .get()
            //     .then((QuerySnapshot querySnapshot3) {
            //   setState(() {
            //
            //     // if(detailIdList.length == 0) {
            //     //   noSearchData = true;
            //     // } else {
            //     //   noSearchData = false;
            //     // }
            //
            //     var sections = List<ExampleSection>.empty(growable: true);
            //
            //     var saleOrders = ExampleSection()
            //       ..header = 'Buy orders^' + detailIdList.length.toString()
            //       ..items = changeData4(detailIdList.cast<String>(), querySnapshot3)
            //     // ..items = detailIdList.cast<String>()
            //       ..expanded = true;
            //
            //     // var buyOrders = ExampleSection()
            //     //   ..header = 'Buy orders^' + detailIdList.length.toString()
            //     //   ..items = detailIdList.cast<String>()
            //     //   ..expanded = true;
            //
            //     //  print('buy ord ' + detailIdList.length.toString());
            //     sections.add(saleOrders);
            //     // sections.add(buyOrders);
            //     sectionList2 = sections;
            //   });
            // });
          });
        } else {
          if(searchValue.contains('-')) {
            searchValue = searchValue.split('-')[1].toLowerCase();
          }
          print('hereeee');
          sectionList2 = List<ExampleSection>.empty(growable: true);

          subTabController.animateTo(2, duration: Duration(microseconds: 0), curve: Curves.ease);

          print("search " + searchValue);
          String max = searchValue;
          // sectionList = [];
          List detailIdList = [];

          setState(() {
            var sections = List<ExampleSection>.empty(growable: true);

            var init = ExampleSection()
              ..header = ''
              ..items = ['']
              ..expanded = true;

            // var buyOrders = ExampleSection()
            //   ..header = 'Products'
            //   ..items = ['']
            //   ..expanded = true;
            sections.add(init);
            // sections.add(buyOrders);
            sectionList2 = sections;
          });

          await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('order')
              .where('orderId',  isEqualTo: searchValue)
              .limit(10)
              .get()
              .then((QuerySnapshot querySnapshot2) async {
            print('searching mf ' + searchValue.toString() + ' ' + querySnapshot2.docs.length.toString());
            if(querySnapshot2.docs.length == 0) {
              setState(() {
                detailIdList = [];
                setState(() {
                  var sections = List<ExampleSection>.empty(growable: true);

                  var saleOrders = ExampleSection()
                    ..header = 'Sale orders^' + 'GG'
                    ..items = detailIdList.cast<String>()
                    ..expanded = true;

                  // var buyOrders = ExampleSection()
                  //   ..header = 'Buy orders^' + 'GG'
                  //   ..items = detailIdList.cast<String>()
                  //   ..expanded = true;

                  print('sale ord ' + detailIdList.length.toString());
                  sections.add(saleOrders);
                  // sections.add(buyOrders);
                  sectionList2 = sections;
                });
              });
            }
            querySnapshot2.docs.forEach((doc) {

              setState(() {
                print('trying');
                try {
                  detailIdList.add(doc['dateTime'].substring(0,4) + doc['dateTime'].substring(4,6) +  doc['dateTime'].substring(6,8) +  doc['dateTime'].substring(8,10) +  doc['dateTime'].substring(10,12) + '^' + doc['deviceId'] + doc['orderId'] + '^' + doc['total'].toString() + '^' + doc['customerId'] + '^' + doc['refund'] + '^' + doc['debt'].toString() + '^' + doc['discount'].toString() + '^' + doc['date'].toDate().hour.toString() + '^' + doc['date'].toDate().minute.toString());
                } catch (e) {
                  detailIdList.add(doc['date'].toDate().year.toString() +  zeroToTen(doc['date'].toDate().month.toString()) +  zeroToTen(doc['date'].toDate().day.toString()) +  zeroToTen(doc['date'].toDate().hour.toString()) +  zeroToTen(doc['date'].toDate().minute.toString()) + '^' + doc['deviceId'] + doc['orderId'] + '^' + doc['total'].toString() + '^' + doc['customerId'] + '^' + doc['refund'] + '^' + doc['debt'].toString() + '^' + doc['discount'].toString() + '^' + doc['date'].toDate().hour.toString() + '^' + doc['date'].toDate().minute.toString());
                }

                // if(doc['dateTime'] == null) {
                //   detailIdList.add(doc['date'].toDate().year.toString() +  zeroToTen(doc['date'].toDate().month.toString()) +  zeroToTen(doc['date'].toDate().day.toString()) +  zeroToTen(doc['date'].toDate().hour.toString()) +  zeroToTen(doc['date'].toDate().minute.toString()) + doc['deviceId'].split('-')[0] + doc['orderId'] + '^' + doc['deviceId'] + doc['orderId'] + '^' + doc['total'].toString() + '^' + doc['customerId'] + '^' + doc['refund'] + '^' + doc['debt'].toString() + '^' + doc['discount'].toString() + '^' + doc['date'].toDate().hour.toString() + '^' + doc['date'].toDate().minute.toString());
                // } else {
                //
                // }
              });
            });

            // await FirebaseFirestore.instance.collection('shops').doc(
            //     shopId).collection('customers')
            //     .get()
            //     .then((QuerySnapshot querySnapshot3) {
            //
            // });

            changeData3(detailIdList.cast<String>()).then((value) {
              setState(() {

                // if(detailIdList.length == 0) {
                //   noSearchData = true;
                // } else {
                //   noSearchData = false;
                // }
                var sections = List<ExampleSection>.empty(growable: true);

                var saleOrders = ExampleSection()
                  ..header = 'Sale orders^' + detailIdList.length.toString()
                  ..items = value.cast<String>()
                // ..items = detailIdList.cast<String>()
                  ..expanded = true;

                // var buyOrders = ExampleSection()
                //   ..header = 'Buy orders^' + detailIdList.length.toString()
                //   ..items = detailIdList.cast<String>()
                //   ..expanded = true;

                // print('buy ord ' + detailIdList.length.toString());
                sections.add(saleOrders);
                // sections.add(buyOrders);
                sectionList2 = sections;
              });
            });


          });
        }


        //BUY BUY BUY





      } else if (slidingSearch == 1) {
        sectionList1 = [];
        subTabController.animateTo(1, duration: Duration(microseconds: 1), curve: Curves.ease);

        setState(() {
          var sections = List<ExampleSection>.empty(growable: true);

          var init = ExampleSection()
            ..header = ''
            ..items = ['']
            ..expanded = true;

          // var buyOrders = ExampleSection()
          //   ..header = 'Products'
          //   ..items = ['']
          //   ..expanded = true;
          sections.add(init);
          sections.add(init);
          // sections.add(buyOrders);
          sectionList1 = sections;
        });
        List<String> items = [];
        List<String> items1 = [];

        await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('customers')
            .where('archive' ,isNotEqualTo: true)
            .where("search_name", arrayContains: searchValue)
            .limit(10)
            .get()
            .then((QuerySnapshot querySnapshot) {

          String sps = '^sps^';
          querySnapshot.docs.forEach((doc) {
            if(doc.id != 'name' && doc['customer_name'].toString().toLowerCase().contains(searchValue.toLowerCase())) {
              setState(() {
                items.add(doc.id + sps + doc['customer_name'] + sps + doc['customer_phone'] + sps + doc['customer_address']);
              });

              // print(doc['prod_name'].toString());
            }
          });

          if(items.length == 0) {
            setState(() {
              noSearchData = true;
            });
          } else {
            setState(() {
              noSearchData = false;
            });
          }


        });


        await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('merchants')
            .where('archive' ,isNotEqualTo: true)
            .where("search_name", arrayContains: searchValue)
            .limit(10)
            .get()
            .then((QuerySnapshot querySnapshot) {

          String sps = '^sps^';
          querySnapshot.docs.forEach((doc) {
            if(doc.id != 'name' && doc['merchant_name'].toString().toLowerCase().contains(searchValue.toLowerCase())) {
              setState(() {
                items1.add(doc.id + sps + doc['merchant_name'] + sps + doc['merchant_phone'] + sps + doc['merchant_address']);
              });

              // print(doc['prod_name'].toString());
            }
          });

          if(items1.length == 0) {
            setState(() {
              noSearchData = true;
            });
          } else {
            setState(() {
              noSearchData = false;
            });
          }


        });

        setState(() {
          var sections = List<ExampleSection>.empty(growable: true);
          // var sections1 = List<ExampleSection>.empty(growable: true);

          var init = ExampleSection()
            ..header = 'Customers^' + items.length.toString()
            ..items = items
            ..expanded = true;

          var init1 = ExampleSection()
            ..header = 'Merchants^' + items1.length.toString()
            ..items = items1
            ..expanded = true;

          // var buyOrders = ExampleSection()
          //   ..header = 'Products'
          //   ..items = ['']
          //   ..expanded = true;
          sections.add(init);
          sections.add(init1);
          // sections.add(buyOrders);
          sectionList1 = sections;
        });


      } else {

        subTabController.animateTo(0, duration: Duration(microseconds: 0), curve: Curves.ease);

        setState(() {
          var sections = List<ExampleSection>.empty(growable: true);

          var init = ExampleSection()
            ..header = ''
            ..items = ['']
            ..expanded = true;

          sections.add(init);
          // sections.add(buyOrders);
          sectionList = sections;
        });
        List<String> items = [];
        String searchtxt = searchValue;
        await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products')
            .where('archive' ,isNotEqualTo: true)
        // .orderBy("prod_name")
        // .startAt([searchtxt,])
        // .endAt([searchtxt+'\uf8ff',])
            .where("search_name", arrayContains: searchValue)
            .limit(10)
            .get()
            .then((QuerySnapshot querySnapshot) async {
          String sps = '^sps^';
          querySnapshot.docs.forEach((doc) {
            setState(() {
              items.add(doc.id + sps +
                  doc['prod_name'] + sps +
                  doc['img_1'] + sps +
                  doc['unit_sell'] + '~' + doc['inStock1'].toString() + '~' + doc['unit_name'] + sps +
                  doc['sub1_sell'] + '~' + doc['inStock2'].toString() + '~' + doc['sub1_name'] + sps +
                  doc['sub2_sell'] + '~' + doc['inStock2'].toString() + '~' + doc['sub2_name']);
            });
            // if(doc['prod_name'].toString().toLowerCase().contains(searchValue.toLowerCase())) {
            //   setState(() {
            //     items.add(doc.id + sps +
            //         doc['prod_name'] + sps +
            //         doc['img_1'] + sps +
            //         doc['unit_sell'] + '~' + doc['inStock1'].toString() + '~' + doc['unit_name'] + sps +
            //         doc['sub1_sell'] + '~' + doc['inStock2'].toString() + '~' + doc['sub1_name'] + sps +
            //         doc['sub2_sell'] + '~' + doc['inStock2'].toString() + '~' + doc['sub2_name']);
            //   });
            //
            //   print(doc['prod_name'].toString());
            // }
          });

          if(items.length == 0) {
            setState(() {
              noSearchData = true;
            });
          } else {
            setState(() {
              noSearchData = false;
            });
          }


        });

        setState(() {
          var sections = List<ExampleSection>.empty(growable: true);

          var init = ExampleSection()
            ..header = 'Products^' + items.length.toString()
            ..items = items
            ..expanded = true;

          // var buyOrders = ExampleSection()
          //   ..header = 'Products'
          //   ..items = ['']
          //   ..expanded = true;
          sections.add(init);
          // sections.add(buyOrders);
          sectionList = sections;
        });


      }
    } else {
      setState(() {
        noSearchData = true;
      });
    }
    Future.delayed(const Duration(milliseconds: 500), () async {

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          searchingOverAll = false;
        });
      });
    });

  }

  Widget _buildHeader4(BuildContext context, int sectionIndex, int index) {
    ExampleSection section = sectionList[sectionIndex];
    // if(sectionIndex == 0) {
    //   return Container(
    //     height: 0.1,
    //   );
    // }
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
                        // "BUY ORDERS",
                        'PRODUCTS',
                        // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                        style: TextStyle(
                            height: 0.8,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: Colors.black
                        ),
                      ),

                      Spacer(),
                      searchValue != '' ?
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: section.header != '' ? Text(
                          section.header.split('^')[1],
                          // '0',
                          // '#' + sectionList[sectionIndex].items.length.toString(),
                          // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                          style: TextStyle(
                            height: 0.8,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.right,
                        ): Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                              child: CupertinoActivityIndicator(radius: 8,)),
                        ),
                      ):
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                              child: CupertinoActivityIndicator(radius: 8,)),
                        ),
                      )
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

  overAllSearch() {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: IgnorePointer(
        ignoring: !loadingSearch,
        child: AnimatedOpacity(
          opacity: loadingSearch ? 1 : 0,
          duration: Duration(milliseconds: 170),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                        color: AppTheme.skBorderColor2,
                        // color: Colors.transparent,
                        width: 1.0),
                  )),
              // child: ProductsBloc(
              //   key: cateScIndex == 0? ValueKey<String>('1'): ValueKey<String>('2'),
              //   header: SliverAppBar(
              //     elevation: 0,
              //     backgroundColor: Colors.white,
              //     // Provide a standard title.
              //     // Allows the user to reveal the app bar if they begin scrolling
              //     // back up the list of items.
              //     floating: true,
              //     flexibleSpace: Padding(
              //       padding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
              //       child: Container(
              //         height: 32,
              //         width: MediaQuery.of(context).size.width,
              //         // color: Colors.yellow,
              //         child: Row(
              //           children: [
              //             Row(
              //               children: [
              //                 FlatButton(
              //                   padding: EdgeInsets.only(left: 10, right: 10),
              //                   color: AppTheme.secButtonColor,
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(8.0),
              //                     side: BorderSide(
              //                       color: AppTheme.skBorderColor2,
              //                     ),
              //                   ),
              //                   onPressed: () async {
              //                   },
              //                   child: Container(
              //                     child: Row(
              //                       // mainAxisAlignment: Main,
              //                       children: [
              //                         Padding(
              //                           padding: const EdgeInsets.only(right: 6.0),
              //                           child: Icon(
              //                             SmartKyat_POS.add_plus,
              //                             size: 17,
              //                           ),
              //                         ),
              //                         Text(
              //                           'textSetNewCus',
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                               fontSize: 14,
              //                               fontWeight: FontWeight.w500,
              //                               color: Colors.black),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //                 SizedBox(width: 12),
              //                 Container(
              //                   color: Colors.grey.withOpacity(0.2),
              //                   width: 1.5,
              //                   height: 30,
              //                 )
              //               ],
              //             ),
              //             Expanded(
              //               child: ListView(
              //                 controller: cateScCtler,
              //                 scrollDirection: Axis.horizontal,
              //                 children: [
              //                   SizedBox(
              //                     width: 4,
              //                   ),
              //                   Padding(
              //                     padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              //                     child: FlatButton(
              //                       minWidth: 0,
              //                       padding: EdgeInsets.only(left: 12, right: 12),
              //                       color: cateScIndex == 0 ? AppTheme.secButtonColor:Colors.white,
              //                       shape: RoundedRectangleBorder(
              //                         borderRadius: BorderRadius.circular(20.0),
              //                         side: BorderSide(
              //                           color: AppTheme.skBorderColor2,
              //                         ),
              //                       ),
              //                       onPressed: () {
              //                         _animateToIndex(0);
              //                         setState(() {
              //                           cateScIndex = 0;
              //                         });
              //                       },
              //                       child: Container(
              //                         child: Text(
              //                           'textSetAll',
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                               fontSize: 14,
              //                               fontWeight: FontWeight.w500,
              //                               color: Colors.black),
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                   Padding(
              //                     padding: const EdgeInsets.only(left: 4.0, right: 6.0),
              //                     child: FlatButton(
              //                       minWidth: 0,
              //                       padding: EdgeInsets.only(left: 12, right: 12),
              //                       color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
              //                       shape: RoundedRectangleBorder(
              //                         borderRadius: BorderRadius.circular(20.0),
              //                         side: BorderSide(
              //                           color: AppTheme.skBorderColor2,
              //                         ),
              //                       ),
              //                       onPressed: () {
              //                         _animateToIndex(5.4);
              //                         setState(() {
              //                           cateScIndex = 1;
              //                         });
              //                       },
              //                       child: Container(
              //                         child: Text(
              //                           'textSetUnpaids',
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                               fontSize: 14,
              //                               fontWeight: FontWeight.w500,
              //                               color: Colors.black),
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     width: 11,
              //                   )
              //                 ],
              //               ),
              //             )
              //           ],
              //         ),
              //
              //       ),
              //     ),),
              //   custom:
              //   SliverToBoxAdapter(
              //       child: StreamBuilder<DocumentSnapshot>(
              //           stream: FirebaseFirestore.instance.collection('shops').doc(shopId).collection('customers').doc('name').snapshots(), //returns a Stream<DocumentSnapshot>
              //           builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              //             if (!snapshot.hasData) {
              //               return GestureDetector(
              //                 onTap: () async {
              //                 },
              //                 child: Container(
              //                   // color: Colors.yellow,
              //                   child: Padding(
              //                     padding:
              //                     EdgeInsets.only(left: 15.0, top: 0.0),
              //                     child: Container(
              //                       width: MediaQuery.of(context).size.width,
              //                       decoration: BoxDecoration(
              //                           border: Border(
              //                               bottom: BorderSide(
              //                                   color: Colors
              //                                       .grey
              //                                       .withOpacity(
              //                                       0.3),
              //                                   width: 1.0)
              //                           )),
              //                       child: Column(
              //                         children: [
              //                           Padding(
              //                             padding: const EdgeInsets
              //                                 .only(
              //                                 bottom: 6.0),
              //                             child: ListTile(
              //                               contentPadding: const EdgeInsets
              //                                   .only(
              //                                   left: 0.0, right: 15) ,
              //                               title: Text(
              //                                 'No customer',
              //                                 maxLines: 1,
              //                                 style: TextStyle(
              //                                     fontSize: 18,
              //                                     fontWeight:
              //                                     FontWeight
              //                                         .w500,
              //                                     height: 1.1,
              //                                     overflow: TextOverflow.ellipsis
              //                                 ),
              //                                 strutStyle: StrutStyle(
              //                                   height: 1.3,
              //                                   // fontSize:,
              //                                   forceStrutHeight: true,
              //                                 ),
              //                               ),
              //                               subtitle: Padding(
              //                                 padding: const EdgeInsets
              //                                     .only(
              //                                     top: 8.0),
              //                                 child: Column(
              //                                   crossAxisAlignment: CrossAxisAlignment
              //                                       .start,
              //                                   children: [
              //                                     Text(
              //                                       'Default sale orders',
              //                                       style: TextStyle(
              //                                           fontSize: 14,
              //                                           fontWeight: FontWeight
              //                                               .w500,
              //                                           color: Colors
              //                                               .grey,
              //                                           height: 1.1,
              //                                           overflow: TextOverflow.ellipsis
              //                                       ),
              //                                       maxLines: 1,
              //                                       strutStyle: StrutStyle(
              //                                         height: 1.2,
              //                                         // fontSize:,
              //                                         forceStrutHeight: true,
              //                                       ),
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                               trailing: Container(
              //                                 child: Row(
              //                                   mainAxisSize: MainAxisSize.min,
              //                                   mainAxisAlignment: MainAxisAlignment.start,
              //                                   crossAxisAlignment: CrossAxisAlignment.start,
              //                                   children: [
              //
              //
              //                                     // Container(
              //                                     //   height: 21,
              //                                     //   decoration: BoxDecoration(
              //                                     //     borderRadius: BorderRadius.circular(20.0),
              //                                     //     color: AppTheme.badgeFgDanger,
              //                                     //   ),
              //                                     //   child: Padding(
              //                                     //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
              //                                     //     child: Text(unpaidCount(index).toString() + ' unpaid',
              //                                     //       style: TextStyle(
              //                                     //           fontSize: 13,
              //                                     //           fontWeight: FontWeight.w500,
              //                                     //           color: Colors.white
              //                                     //       ),
              //                                     //     ),
              //                                     //   ),
              //                                     // ),
              //
              //                                     // Text(orderList.toString()),
              //
              //                                     // Container(
              //                                     //   height: 21,
              //                                     //   decoration: BoxDecoration(
              //                                     //     borderRadius: BorderRadius.circular(20.0),
              //                                     //     color: AppTheme.badgeFgDanger,
              //                                     //   ),
              //                                     //   child: Padding(
              //                                     //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
              //                                     //     child: Text('2 unpaid',
              //                                     //       style: TextStyle(
              //                                     //           fontSize: 13,
              //                                     //           fontWeight: FontWeight.w500,
              //                                     //           color: Colors.white
              //                                     //       ),
              //                                     //     ),
              //                                     //   ),
              //                                     // )
              //
              //                                     // Container(
              //                                     //   height: 21,
              //                                     //   decoration: BoxDecoration(
              //                                     //     borderRadius: BorderRadius.circular(20.0),
              //                                     //     color: AppTheme.badgeFgDanger,
              //                                     //   ),
              //                                     //   child: Padding(
              //                                     //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
              //                                     //     child: Text(unpaidCount(index).toString() + ' unpaid',
              //                                     //       style: TextStyle(
              //                                     //           fontSize: 13,
              //                                     //           fontWeight: FontWeight.w500,
              //                                     //           color: Colors.white
              //                                     //       ),
              //                                     //     ),
              //                                     //   ),
              //                                     // ),
              //                                     SizedBox(
              //                                         width: 12),
              //                                     Padding(
              //                                       padding: const EdgeInsets.only(top: 2.0),
              //                                       child: Icon(
              //                                         Icons
              //                                             .arrow_forward_ios_rounded,
              //                                         size: 16,
              //                                         color: Colors
              //                                             .blueGrey
              //                                             .withOpacity(
              //                                             0.8),
              //                                       ),
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //
              //                             ),
              //                           )
              //
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               );
              //             }
              //             var userDocument = snapshot.data;
              //             return GestureDetector(
              //               onTap: () async {
              //               },
              //               child: Container(
              //                 // color: Colors.yellow,
              //                 child: Padding(
              //                   padding:
              //                   EdgeInsets.only(left: 15.0, top: 0.0),
              //                   child: Container(
              //                     width: MediaQuery.of(context).size.width,
              //                     decoration: BoxDecoration(
              //                         border: Border(
              //                             bottom: BorderSide(
              //                                 color: Colors
              //                                     .grey
              //                                     .withOpacity(
              //                                     0.3),
              //                                 width: 1.0)
              //                         )),
              //                     child: Column(
              //                       children: [
              //                         Padding(
              //                           padding: const EdgeInsets
              //                               .only(
              //                               bottom: 6.0),
              //                           child: ListTile(
              //                             contentPadding: const EdgeInsets
              //                                 .only(
              //                                 left: 0.0, right: 15) ,
              //                             title: Text(
              //                               'No customer',
              //                               maxLines: 1,
              //                               style: TextStyle(
              //                                   fontSize: 18,
              //                                   fontWeight:
              //                                   FontWeight
              //                                       .w500,
              //                                   height: 1.1,
              //                                   overflow: TextOverflow.ellipsis
              //                               ),
              //                               strutStyle: StrutStyle(
              //                                 height: 1.3,
              //                                 // fontSize:,
              //                                 forceStrutHeight: true,
              //                               ),
              //                             ),
              //                             subtitle: Padding(
              //                               padding: const EdgeInsets
              //                                   .only(
              //                                   top: 8.0),
              //                               child: Column(
              //                                 crossAxisAlignment: CrossAxisAlignment
              //                                     .start,
              //                                 children: [
              //                                   Text(
              //                                     'Default sale orders',
              //                                     style: TextStyle(
              //                                         fontSize: 14,
              //                                         fontWeight: FontWeight
              //                                             .w500,
              //                                         color: Colors
              //                                             .grey,
              //                                         height: 1.1,
              //                                         overflow: TextOverflow.ellipsis
              //                                     ),
              //                                     maxLines: 1,
              //                                     strutStyle: StrutStyle(
              //                                       height: 1.2,
              //                                       // fontSize:,
              //                                       forceStrutHeight: true,
              //                                     ),
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                             trailing: Container(
              //                               child: Row(
              //                                 mainAxisSize: MainAxisSize.min,
              //                                 mainAxisAlignment: MainAxisAlignment.start,
              //                                 crossAxisAlignment: CrossAxisAlignment.start,
              //                                 children: [
              //                                   userDocument!['debts'] > 0? Container(
              //                                     height: 21,
              //                                     decoration: BoxDecoration(
              //                                       borderRadius: BorderRadius.circular(20.0),
              //                                       color: AppTheme.badgeFgDanger,
              //                                     ),
              //                                     child: Padding(
              //                                       padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
              //                                       child: Text(userDocument['debts'].round().toString() + ' unpaid',
              //                                         style: TextStyle(
              //                                             fontSize: 13,
              //                                             fontWeight: FontWeight.w500,
              //                                             color: Colors.white
              //                                         ),
              //                                       ),
              //                                     ),
              //                                   ): Container(height: 21,),
              //
              //                                   // Container(
              //                                   //   height: 21,
              //                                   //   decoration: BoxDecoration(
              //                                   //     borderRadius: BorderRadius.circular(20.0),
              //                                   //     color: AppTheme.badgeFgDanger,
              //                                   //   ),
              //                                   //   child: Padding(
              //                                   //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
              //                                   //     child: Text(unpaidCount(index).toString() + ' unpaid',
              //                                   //       style: TextStyle(
              //                                   //           fontSize: 13,
              //                                   //           fontWeight: FontWeight.w500,
              //                                   //           color: Colors.white
              //                                   //       ),
              //                                   //     ),
              //                                   //   ),
              //                                   // ),
              //
              //                                   // Text(orderList.toString()),
              //
              //                                   // Container(
              //                                   //   height: 21,
              //                                   //   decoration: BoxDecoration(
              //                                   //     borderRadius: BorderRadius.circular(20.0),
              //                                   //     color: AppTheme.badgeFgDanger,
              //                                   //   ),
              //                                   //   child: Padding(
              //                                   //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
              //                                   //     child: Text('2 unpaid',
              //                                   //       style: TextStyle(
              //                                   //           fontSize: 13,
              //                                   //           fontWeight: FontWeight.w500,
              //                                   //           color: Colors.white
              //                                   //       ),
              //                                   //     ),
              //                                   //   ),
              //                                   // )
              //
              //                                   // Container(
              //                                   //   height: 21,
              //                                   //   decoration: BoxDecoration(
              //                                   //     borderRadius: BorderRadius.circular(20.0),
              //                                   //     color: AppTheme.badgeFgDanger,
              //                                   //   ),
              //                                   //   child: Padding(
              //                                   //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
              //                                   //     child: Text(unpaidCount(index).toString() + ' unpaid',
              //                                   //       style: TextStyle(
              //                                   //           fontSize: 13,
              //                                   //           fontWeight: FontWeight.w500,
              //                                   //           color: Colors.white
              //                                   //       ),
              //                                   //     ),
              //                                   //   ),
              //                                   // ),
              //                                   SizedBox(
              //                                       width: 12),
              //                                   Padding(
              //                                     padding: const EdgeInsets.only(top: 2.0),
              //                                     child: Icon(
              //                                       Icons
              //                                           .arrow_forward_ios_rounded,
              //                                       size: 16,
              //                                       color: Colors
              //                                           .blueGrey
              //                                           .withOpacity(
              //                                           0.8),
              //                                     ),
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //
              //                           ),
              //                         )
              //
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             );
              //           }
              //       )
              //   ),
              //   footer: SliverToBoxAdapter(child: Padding(
              //     padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
              //     child: Center(child: Text('End of results', strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),)),
              //   )),
              //   initialLoader: Center(child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
              //       child: CupertinoActivityIndicator(radius: 15,))),
              //   bottomLoader: Container(
              //     child: LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
              //   ),
              //   itemBuilderType:
              //   PaginateBuilderType.listView,
              //   itemBuilder: (context1, documentSnapshots, index) {
              //     final data =  documentSnapshots[index].data() as Map<String, dynamic>;
              //     var version = documentSnapshots[index].id;
              //     // WidgetsBinding.instance!.addPostFrameCallback((_) async {
              //     //   setState(() {
              //     //     custsNumber = documentSnapshots.length;
              //     //   });
              //     // });
              //     print('hello ' + cateScIndex.toString());
              //     //String item = zeroToTen(data['date'].toDate().year.toString()) +  zeroToTen(data['date'].toDate().month.toString()) +  zeroToTen(data['date'].toDate().day.toString()) +  zeroToTen(data['date'].toDate().hour.toString()) +  zeroToTen(data['date'].toDate().minute.toString()) + data['deviceId'].split('-')[0] + data['orderId'] +'^' + data['deviceId'] + data['orderId'] + '^' + data['total'].toString() + '^' + widget.merchName + '&'+ data['merchantId'] + '^' + data['refund'] + '^' + data['debt'].toString() + '^' + data['discount'].toString() + '^' + data['date'].toDate().hour.toString() + '^' + data['date'].toDate().minute.toString();
              //     return  GestureDetector(
              //       onTap: () async {
              //       },
              //       child: Padding(
              //         padding:
              //         EdgeInsets.only(left: 15.0,
              //             top: 15.0),
              //         child: Container(
              //           width: MediaQuery
              //               .of(context)
              //               .size
              //               .width,
              //           decoration: BoxDecoration(
              //               border: Border(
              //                   bottom: index == documentSnapshots.length-1 ?
              //                   BorderSide(
              //                       color: Colors
              //                           .transparent,
              //                       width: 1.0)
              //                       :
              //
              //                   BorderSide(
              //                       color: Colors
              //                           .grey
              //                           .withOpacity(
              //                           0.3),
              //                       width: 1.0)
              //               )),
              //           child: Column(
              //             children: [
              //               Padding(
              //                 padding: const EdgeInsets
              //                     .only(
              //                     bottom: 18.0),
              //                 child: ListTile(
              //                   title: Text(
              //                     data['customer_name'].toString(),
              //                     maxLines: 1,
              //                     style: TextStyle(
              //                         fontSize: 18,
              //                         fontWeight:
              //                         FontWeight
              //                             .w500,
              //                         height: 1.1,
              //                         overflow: TextOverflow.ellipsis
              //                     ),
              //                     strutStyle: StrutStyle(
              //                       height: 1.3,
              //                       // fontSize:,
              //                       forceStrutHeight: true,
              //                     ),
              //                   ),
              //                   subtitle: Padding(
              //                     padding: const EdgeInsets
              //                         .only(
              //                         top: 8.0),
              //                     child: Column(
              //                       crossAxisAlignment: CrossAxisAlignment
              //                           .start,
              //                       children: [
              //                         Text(
              //                           data['customer_address'],
              //                           style: TextStyle(
              //                               fontSize: 14,
              //                               fontWeight: FontWeight
              //                                   .w500,
              //                               color: Colors
              //                                   .grey,
              //                               height: 1.1,
              //                               overflow: TextOverflow.ellipsis
              //                           ),
              //                           maxLines: 1,
              //                           strutStyle: StrutStyle(
              //                             height: 1.2,
              //                             // fontSize:,
              //                             forceStrutHeight: true,
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           height: 5,),
              //                         Text(
              //                           data['customer_phone'],
              //                           style: TextStyle(
              //                               fontSize: 14,
              //                               fontWeight: FontWeight
              //                                   .w500,
              //                               color: Colors
              //                                   .grey,
              //                               height: 1.1,
              //                               overflow: TextOverflow.ellipsis
              //                           ),
              //                           maxLines: 1,
              //                           strutStyle: StrutStyle(
              //                             height: 1,
              //                             // fontSize:,
              //                             forceStrutHeight: true,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   trailing: Container(
              //                     child: Row(
              //                       mainAxisSize: MainAxisSize.min,
              //                       mainAxisAlignment: MainAxisAlignment.start,
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: [
              //                         data['debts'] > 0? Container(
              //                           height: 21,
              //                           decoration: BoxDecoration(
              //                             borderRadius: BorderRadius.circular(20.0),
              //                             color: AppTheme.badgeFgDanger,
              //                           ),
              //                           child: Padding(
              //                             padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
              //                             child: Text(data['debts'].round().toString() + ' unpaid',
              //                               style: TextStyle(
              //                                   fontSize: 13,
              //                                   fontWeight: FontWeight.w500,
              //                                   color: Colors.white
              //                               ),
              //                             ),
              //                           ),
              //                         ): Container(height: 21,),
              //
              //                         // Container(
              //                         //   height: 21,
              //                         //   decoration: BoxDecoration(
              //                         //     borderRadius: BorderRadius.circular(20.0),
              //                         //     color: AppTheme.badgeFgDanger,
              //                         //   ),
              //                         //   child: Padding(
              //                         //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
              //                         //     child: Text(unpaidCount(index).toString() + ' unpaid',
              //                         //       style: TextStyle(
              //                         //           fontSize: 13,
              //                         //           fontWeight: FontWeight.w500,
              //                         //           color: Colors.white
              //                         //       ),
              //                         //     ),
              //                         //   ),
              //                         // ),
              //
              //                         // Text(orderList.toString()),
              //
              //                         // Container(
              //                         //   height: 21,
              //                         //   decoration: BoxDecoration(
              //                         //     borderRadius: BorderRadius.circular(20.0),
              //                         //     color: AppTheme.badgeFgDanger,
              //                         //   ),
              //                         //   child: Padding(
              //                         //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
              //                         //     child: Text('2 unpaid',
              //                         //       style: TextStyle(
              //                         //           fontSize: 13,
              //                         //           fontWeight: FontWeight.w500,
              //                         //           color: Colors.white
              //                         //       ),
              //                         //     ),
              //                         //   ),
              //                         // )
              //
              //                         // Container(
              //                         //   height: 21,
              //                         //   decoration: BoxDecoration(
              //                         //     borderRadius: BorderRadius.circular(20.0),
              //                         //     color: AppTheme.badgeFgDanger,
              //                         //   ),
              //                         //   child: Padding(
              //                         //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
              //                         //     child: Text(unpaidCount(index).toString() + ' unpaid',
              //                         //       style: TextStyle(
              //                         //           fontSize: 13,
              //                         //           fontWeight: FontWeight.w500,
              //                         //           color: Colors.white
              //                         //       ),
              //                         //     ),
              //                         //   ),
              //                         // ),
              //                         SizedBox(
              //                             width: 12),
              //                         Padding(
              //                           padding: const EdgeInsets.only(top: 2.0),
              //                           child: Icon(
              //                             Icons
              //                                 .arrow_forward_ios_rounded,
              //                             size: 16,
              //                             color: Colors
              //                                 .blueGrey
              //                                 .withOpacity(
              //                                 0.8),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   contentPadding: const EdgeInsets
              //                       .only(
              //                       left: 0.0, right: 15) ,
              //                 ),
              //               )
              //
              //             ],
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              //   // orderBy is compulsory to enable pagination
              //   // query: cateScIndex == 0 ? FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('customers').where('archive' , isEqualTo: false).where('no_default', isEqualTo: true): FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('customers').where('archive', isEqualTo: false).where('no_default', isEqualTo: true).where('debts', isGreaterThan: 0).orderBy('debts', descending: true),
              //   query: cateScIndex == 0 ? FirebaseFirestore.instance.collection('shops').doc('QZEXoquzNqEIKV0uMMvr').collection('customers').where('archive' , isEqualTo: false): FirebaseFirestore.instance.collection('shops').doc('QZEXoquzNqEIKV0uMMvr').collection('customers').where('archive', isEqualTo: false).where('debts', isGreaterThan: 0).orderBy('debts', descending: true),
              //   // to fetch real-time data
              //   isLive: true,
              // )
              child: ProductsBloc(
                key: ValueKey<String>(searchValue.toLowerCase()),
                header:SliverAppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  // Provide a standard title.
                  // Allows the user to reveal the app bar if they begin scrolling
                  // back up the list of items.
                  floating: true,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 12.0, bottom: 12.0),
                    child: Container(
                      height: 32,
                      width: MediaQuery.of(context).size.width,
                      // color: Colors.yellow,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView(
                              controller: cateScCtler,
                              scrollDirection: Axis.horizontal,
                              children: [
                                SizedBox(
                                  width: 11,
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
                                      cateChangeSearch(0);
                                    },
                                    child: Container(
                                      child: Text(
                                        'Products',
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
                                    color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                        color: AppTheme.skBorderColor2,
                                      ),
                                    ),
                                    onPressed: () {
                                      // _animateToIndex(5.4);
                                      cateChangeSearch(1);
                                    },
                                    child: Container(
                                      child: Text(
                                        'Customers',
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
                                    color: cateScIndex == 2 ? AppTheme.secButtonColor:Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                        color: AppTheme.skBorderColor2,
                                      ),
                                    ),
                                    onPressed: () {
                                      // _animateToIndex(2);
                                      cateChangeSearch(2);
                                    },
                                    child: Container(
                                      child: Text(
                                        'Merchants',
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
                                      // _animateToIndex(0);
                                      cateChangeSearch(3);
                                    },
                                    child: Container(
                                      child: Text(
                                        'Sale orders',
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
                                    color: cateScIndex == 4 ? AppTheme.secButtonColor:Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                        color: AppTheme.skBorderColor2,
                                      ),
                                    ),
                                    onPressed: () {
                                      // _animateToIndex(0);
                                      cateChangeSearch(4);
                                    },
                                    child: Container(
                                      child: Text(
                                        'Buy orders',
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
                  ),),
                // header: SliverAppBar(
                //   elevation: 0,
                //   backgroundColor: Colors.white,
                //
                //   // Provide a standard title.
                //
                //   // Allows the user to reveal the app bar if they begin scrolling
                //   // back up the list of items.
                //   floating: true,
                //   bottom: PreferredSize(                       // Add this code
                //     preferredSize: Size.fromHeight(-1),      // Add this code
                //     child: Container(),                           // Add this code
                //   ),
                //   flexibleSpace: Padding(
                //     padding: const EdgeInsets.only(left: 0.0, top: 0.5, bottom: 0.0),
                //     child: Container(
                //       height: 58,
                //       width: MediaQuery.of(context).size.width,
                //       // color: Colors.yellow,
                //       child: Container(
                //         decoration: BoxDecoration(
                //             color: Colors.white,
                //             border: Border(
                //               bottom: BorderSide(
                //                 // color: AppTheme.skBorderColor2,
                //                   color: Colors.white,
                //                   width: 1.0),
                //             )),
                //         child: Container(
                //           decoration: BoxDecoration(
                //               color: Colors.white,
                //               border: Border(
                //                 bottom: BorderSide(
                //                   // color: AppTheme.skBorderColor2,
                //                     color: Colors.white,
                //                     width: 1.0),
                //               )),
                //           child: Padding(
                //             padding: const EdgeInsets.only(top: 12.0, bottom: 8.5, left: 15.0, right: 15.0),
                //             child: SizedBox(
                //               width: double.infinity,
                //               child: CupertinoSlidingSegmentedControl(
                //                   children: {
                //                     0: Text('Products'),
                //                     1: Text('Buy/sellers'),
                //                     2: Text('Orders'),
                //                   },
                //                   groupValue: slidingSearch,
                //                   onValueChanged: (newValue) {
                //                     setState(() {
                //                       slidingSearch = int.parse(newValue.toString());
                //                       cateScIndex = int.parse(newValue.toString());
                //                     });
                //                     FocusScope.of(context).unfocus();
                //                     searchValue = _searchController.text.toLowerCase();
                //                     searchKeyChanged();
                //                     // searchKeyChanged();
                //                   }),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                //   // Display a placeholder widget to visualize the shrinking size.
                //   // Make the initial height of the SliverAppBar larger than normal.
                //   expandedHeight: 20,
                // ),
                footer: SliverToBoxAdapter(child: Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                  child: Center(child: Text('End of results', strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),)),
                )),
                initialLoader: Center(child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                    child: CupertinoActivityIndicator(radius: 15,))),
                bottomLoader: Container(
                  child: LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
                ),
                itemBuilderType:
                PaginateBuilderType.listView,
                itemBuilder: (context1, documentSnapshots, index) {
                  final data =  documentSnapshots[index].data() as Map<String, dynamic>;
                  var version = documentSnapshots[index].id;
                  //String item = zeroToTen(data['date'].toDate().year.toString()) +  zeroToTen(data['date'].toDate().month.toString()) +  zeroToTen(data['date'].toDate().day.toString()) +  zeroToTen(data['date'].toDate().hour.toString()) +  zeroToTen(data['date'].toDate().minute.toString()) + data['deviceId'].split('-')[0] + data['orderId'] +'^' + data['deviceId'] + data['orderId'] + '^' + data['total'].toString() + '^' + widget.merchName + '&'+ data['merchantId'] + '^' + data['refund'] + '^' + data['debt'].toString() + '^' + data['discount'].toString() + '^' + data['date'].toDate().hour.toString() + '^' + data['date'].toDate().minute.toString();
                  return GestureDetector(
                    onTap: () async {
                      closeDrawerFrom();
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ProductDetailsView2(idString: version, prodName: data['prod_name'], mainSell: data['unit_sell'], toggleCoinCallback: addProduct1, toggleCoinCallback3: addProduct3, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom,)),);
                      openDrawerFrom();
                    },
                    child: Padding(
                      padding:
                      EdgeInsets.only(top: index == 0? 1.0: 6.0, left: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: index == documentSnapshots.length-1 ?
                                BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0) :

                                BorderSide(
                                    color: AppTheme.skBorderColor2,
                                    width: 0.5)
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: ClipRRect(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                5.0),
                                            child: data['img_1'] != ""
                                                ? CachedNetworkImage(
                                              imageUrl:
                                              'https://riftplus.me/smartkyat_pos/api/uploads/' +
                                                  data['img_1'],
                                              width: 75,
                                              height: 75,
                                              errorWidget: (context, url, error) => Image.asset('assets/system/default-product.png', height: 75, width: 75, fit: BoxFit.cover,),
                                              placeholder: (context, url) => Image(image: AssetImage('assets/system/default-product.png'), height: 75, width: 75, fit: BoxFit.cover,),
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
                                                : Image.asset('assets/system/default-product.png', height: 75, width: 75, fit: BoxFit.cover,)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 0,
                                        ),
                                        Container(
                                          // color: Colors.yellow,
                                          child: Text(
                                            data['prod_name'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight:
                                                FontWeight.w500,
                                                overflow: TextOverflow.ellipsis
                                            ),
                                            strutStyle: StrutStyle(
                                              height: 2.2,
                                              // fontSize:,
                                              forceStrutHeight: true,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '$currencyUnit ' + data['unit_sell'],
                                                style: TextStyle(
                                                    height: 1.3,
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    overflow: TextOverflow.ellipsis
                                                ),
                                              ),
                                            ),
                                            Text(
                                              // 'lafsjfel jaljfli jalejf liajelfjeajl jfliaj jfelsaijf lajl jf',
                                              data['sub1_name'] != '' && data['sub2_name'] == '' ? ' - ' + data['sub1_sell'] : data['sub1_name'] != '' && data['sub2_name'] != '' ? ' - ' + data['sub2_sell'] : '',
                                              style: TextStyle(
                                                  height: 1.3,
                                                  fontSize: 15,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  overflow: TextOverflow.ellipsis
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0),
                                              child: Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
                                            ),
                                            Flexible(
                                              child: Text(
                                                  ' ' + data['inStock1'].round().toString() + ' '  + data['unit_name'] + ' ',
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      height: 1.3,
                                                      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                                                      overflow: TextOverflow.ellipsis
                                                  )),
                                            ),
                                            data['sub1_name'] != '' && data['sub2_name'] == ''?
                                            Text(
                                                '(+1 Sub item)',
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    height: 1.3,
                                                    fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                                                    overflow: TextOverflow.ellipsis
                                                )) : data['sub1_name'] != '' && data['sub2_name'] != '' ?
                                            Text(
                                                '(+2 Sub items)',
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    height: 1.3,
                                                    fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                                                    overflow: TextOverflow.ellipsis
                                                )): Container(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        bottom: 6.0),
                                    child: Icon(
                                      Icons
                                          .arrow_forward_ios_rounded,
                                      size: 16,
                                      color: Colors.blueGrey
                                          .withOpacity(0.8),
                                    ),),
                                ],
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                // orderBy is compulsory to enable pagination
                // query: cateScIndex == 0 ? FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('customers').where('archive' , isEqualTo: false).where('no_default', isEqualTo: true): FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('customers').where('archive', isEqualTo: false).where('no_default', isEqualTo: true).where('debts', isGreaterThan: 0).orderBy('debts', descending: true),
                query: FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').where('archive' , isEqualTo: false).where("search_name", arrayContains: searchValue),
                // to fetch real-time data
                isLive: true,
              )
            ),
          ),
        ),
      ),
    );
    //       }
    //       return Container();
    //     }
    // );
  }

  covertToDayNum(String input) {
    if(input[0]=='0') {
      return input[1];
    } else {
      return input;
    }
  }

  convertToAMPM(String input){
    switch (input) {
      case '0':
        return 'AM';
        break;
      case '1':
        return 'AM';
        break;
      case '2':
        return 'AM';
        break;
      case '3':
        return 'AM';
        break;
      case '4':
        return 'AM';
        break;
      case '5':
        return 'AM';
        break;
      case '6':
        return 'AM';
        break;
      case '7':
        return 'AM';
        break;
      case '8':
        return 'AM';
        break;
      case '9':
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
    switch (input) {
      case '0':
        return '00';
        break;
      case '1':
        return '01';
        break;
      case '2':
        return '02';
        break;
      case '3':
        return '03';
        break;
      case '4':
        return '04';
        break;
      case '5':
        return '05';
        break;
      case '6':
        return '06';
        break;
      case '7':
        return '07';
        break;
      case '8':
        return '08';
        break;
      case '9':
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


  String slidedTextFun() {
    if(slidingSearch == 1) {
      return 'Buy/Sells';
    } else if(slidingSearch == 2) {
      return 'Buy orders';
    }
    return 'SOmething';
  }

  buySellOrderHeaders(String header) {

    if(header.contains('GG')) {
      return Text(
        '0',
        // '0',
        // '#' + sectionList[sectionIndex].items.length.toString(),
        // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
        style: TextStyle(
          height: 0.8,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: Colors.black,
        ),
        textAlign: TextAlign.right,
      );
    } else {
      return header != '' ? Text(
        header.split('^')[1],
        // '0',
        // '#' + sectionList[sectionIndex].items.length.toString(),
        // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
        style: TextStyle(
          height: 0.8,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: Colors.black,
        ),
        textAlign: TextAlign.right,
      ):
      Padding(
        padding: const EdgeInsets.only(bottom: 1.0),
        child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
            child: CupertinoActivityIndicator(radius: 8,)),
      );
    }
  }

  // Future<String> countDocuments(myDoc) async {
  //   QuerySnapshot _myDoc = await myDoc.get(GetOptions(source: Source.cache));
  //   List<DocumentSnapshot> _myDocCount = _myDoc.docs;
  //   return _myDocCount.length.toString();
  // }

  final cateScCtler = ScrollController();
  final _width = 10.0;
  int cateScIndex = 0;

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
        onTapDown: (TapDownDetails tapDownDetails) {
          FocusScope.of(context).unfocus();
          print('Hello World');
        },
        child: Container(
          color: Colors.white,
          child: SafeArea(
            top: true,
            bottom: true,
            child: Stack(
              children: [
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
                          FocusScope.of(context).requestFocus(nodeFirst);
                          setState(() {
                            loadingSearch = true;
                          });
                          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                        },
                        child: Stack(
                          children: [
                            Container(
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
                                    Container(width: 38),
                                    Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: !loadingSearch? 8.0: 4,
                                              right: 8.0,
                                              top: 0.2),
                                          child: TextField(
                                            textInputAction: TextInputAction.search,
                                            focusNode: nodeFirst,
                                            controller: _searchController,
                                            onSubmitted: (value) async {
                                            },
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            // style: TextStyle(
                                            //     fontSize: 18,
                                            //     fontWeight: FontWeight.w500,
                                            //     color: Colors.black
                                            // ),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black
                                            ),
                                            strutStyle: StrutStyle(
                                                forceStrutHeight: true,
                                                height: 1.3
                                            ),

                                            decoration: InputDecoration(
                                              hintText:textSetSearch,
                                              // hintText: 'Search',
                                              isDense: true,
                                              // contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                                              enabledBorder: const OutlineInputBorder(
                                                // width: 0.0 produces a thin "hairline" border
                                                  borderSide: const BorderSide(
                                                      color: Colors.transparent, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),

                                              focusedBorder: const OutlineInputBorder(
                                                // width: 0.0 produces a thin "hairline" border
                                                  borderSide: const BorderSide(
                                                      color: Colors.transparent, width: 2.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                              contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                                              //filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              hintStyle: textSetSearch == 'Search' ?
                                              TextStyle(
                                                  color: Colors.black.withOpacity(0.55)
                                              ):
                                              TextStyle(
                                                  color: Colors.black.withOpacity(0.55),
                                                  height: 1.38
                                              )
                                              ,
                                            ),
                                            keyboardType: TextInputType.text,
                                            onChanged: (value) {
                                              // setState(() {
                                              //   quantity = int.parse(value);
                                              // });
                                            },
                                            // controller: myController,
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
                                if( (loadingSearch && _searchController.text == '' ) || !loadingSearch) {
                                  widget._chgIndex(0);
                                  FocusScope.of(context).unfocus();
                                } else {
                                  _searchController.clear();
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 38,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Container(
                                    child: Stack(
                                      alignment: AlignmentDirectional.centerStart,
                                      children: [
                                        !loadingSearch? Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child: Icon(
                                            SmartKyat_POS.search,
                                            size: 17,
                                          ),
                                        ): loadingSearch && _searchController.text == '' ?
                                        Padding(
                                            padding: const EdgeInsets.only(left: 2, bottom: 1.5, right: 3),
                                            child: Icon(
                                              Icons.arrow_back_ios_rounded,
                                              size: 21,
                                            )
                                        ) : Padding(
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                overAllSearch(),


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

  unpaidCount(int index) {
    return orderList;
  }

  testingWidget() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return Container();
        },
        semanticIndexCallback: (widget, localIndex) {
          if (localIndex.isEven) {
            return localIndex ~/ 2;
          }
          // ignore: avoid_returning_null
          return null;
        },
        childCount: 0,
      ),
    );
  }

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }

  void cateChangeSearch(int i) {
    setState(() {
      cateScIndex = i;
    });
  }
}

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

setStoreId(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // return(prefs.getString('store'));

  prefs.setString('store', id);
}

zeroToTen(String string) {
  if (int.parse(string) > 9) {
    return string;
  } else {
    return '0' + string;
  }
}