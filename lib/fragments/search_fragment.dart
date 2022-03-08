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
    Key? key,
    required Function(dynamic index) chgIndexFromSearch,}
      ) : _closeCartBtn = closeCartBtn,
        _openCartBtn = openCartBtn,
        _chgIndex = chgIndexFromSearch,
        _barcodeBtn = barcodeBtn,
        _callback3 = toggleCoinCallback3, _callback = toggleCoinCallback, _callback2 = toggleCoinCallback2,_callback4 = toggleCoinCallback4, _openDrawerBtn = openDrawerBtn, _closeDrawerBtn = closeDrawerBtn, _printFromOrders = printFromOrders, super(key: key);
  final productsSnapshot;
  final BlueDevice? selectedDev;

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
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,

                    // Provide a standard title.

                    // Allows the user to reveal the app bar if they begin scrolling
                    // back up the list of items.
                    floating: true,
                    bottom: PreferredSize(                       // Add this code
                      preferredSize: Size.fromHeight(-1),      // Add this code
                      child: Container(),                           // Add this code
                    ),
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.only(left: 0.0, top: 0.5, bottom: 0.0),
                      child: Container(
                        height: 58,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.yellow,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  // color: AppTheme.skBorderColor2,
                                    color: Colors.white,
                                    width: 1.0),
                              )),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    // color: AppTheme.skBorderColor2,
                                      color: Colors.white,
                                      width: 1.0),
                                )),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0, bottom: 8.5, left: 15.0, right: 15.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: CupertinoSlidingSegmentedControl(
                                    children: {
                                      0: Text('Products'),
                                      1: Text('Buy/sellers'),
                                      2: Text('Orders'),
                                    },
                                    groupValue: slidingSearch,
                                    onValueChanged: (newValue) {
                                      setState(() {
                                        slidingSearch = int.parse(newValue.toString());
                                      });
                                      FocusScope.of(context).unfocus();
                                      searchValue = _searchController.text.toLowerCase();
                                      searchKeyChanged();
                                      // searchKeyChanged();
                                    }),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Display a placeholder widget to visualize the shrinking size.
                    // Make the initial height of the SliverAppBar larger than normal.
                    expandedHeight: 20,
                  ),
                  if(slidingSearch == 0)
                    SliverExpandableList(
                      builder: SliverExpandableChildDelegate(
                        sectionList: sectionList,
                        headerBuilder: _buildHeader4,
                        itemBuilder: (context, sectionIndex, itemIndex, index) {
                          String item = sectionList[sectionIndex].items[itemIndex];
                          int length = sectionList[sectionIndex].items.length;

                          // if(sectionIndex == 0) {
                          //   return Container(
                          //     height: 0.1,
                          //   );
                          //   // return SliverFillRemaining(
                          //   //   child: new Container(
                          //   //     color: Colors.red,
                          //   //   ),
                          //   // );
                          // }

                          if(searchValue != '' && slidingSearch == 0 && item.contains('^sps^')) {
                            return GestureDetector(
                              onTap: () async {
                                closeDrawerFrom();
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetailsView2(
                                        idString: item.split('^sps^')[0], toggleCoinCallback:
                                      addProduct1, toggleCoinCallback3: addProduct3, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom,)),);
                                openDrawerFrom();
                              },
                              child: Container(
                                color: AppTheme.lightBgColor,
                                child: Padding(
                                  padding:
                                  EdgeInsets.only(top: index == 0? 10.0: 20.0),
                                  child: Container(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: index == length-1 ?
                                            BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                width: 1.0) :

                                            BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                width: 1.0)
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          5.0),
                                                      child: item.split('^sps^')[2] != ""
                                                          ? CachedNetworkImage(
                                                        imageUrl:
                                                        'https://riftplus.me/smartkyat_pos/api/uploads/' +
                                                            item.split('^sps^')[2],
                                                        width: 75,
                                                        height: 75,
                                                        placeholder: (context, url) => Image(image: AssetImage('assets/system/default-product.png'), height: 75, width: 75, fit: BoxFit.cover,),
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
                                                ],
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    item.split('^sps^')[1],
                                                    style: TextStyle(
                                                      height: 1,
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'MMK ' + item.split('^sps^')[3].split('~')[0],
                                                        style: TextStyle(
                                                          height: 1.3,
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        item.split('^sps^')[4].split('~')[2] != '' && item.split('^sps^')[5].split('~')[2] == '' ? ' - ' + item.split('^sps^')[4].split('~')[0] : item.split('^sps^')[4].split('~')[2] != '' && item.split('^sps^')[5].split('~')[2] != '' ? ' - ' + item.split('^sps^')[5].split('~')[0] : '',
                                                        style: TextStyle(
                                                          height: 1.3,
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight.w500,
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
                                                      Text(
                                                          double.parse(item.split('^sps^')[3].split('~')[1]).round().toString() + ' '  + item.split('^sps^')[3].split('~')[2] + ' ', style: TextStyle(
                                                        height: 1.3,
                                                        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                                                      )),
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 2.0),
                                                        child: Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
                                                      ),

                                                      item.split('^sps^')[4].split('~')[2] != '' && item.split('^sps^')[5].split('~')[2] == ''?
                                                      Text(
                                                          '  +1 Sub item', style: TextStyle(
                                                        height: 1.3,
                                                        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                                                      )) : item.split('^sps^')[4].split('~')[2] != '' && item.split('^sps^')[5].split('~')[2] != '' ? Text(
                                                          '  +2 Sub items', style: TextStyle(
                                                        height: 1.3,
                                                        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                                                      )): Container(),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
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
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          else if(slidingSearch == 1 && item.contains('^sps^')) {
                            return GestureDetector(
                              onTap: () async {
                                closeDrawerFrom();
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (
                                          context) =>
                                          CustomerInfoSubs(
                                            id: item.split('^sps^')[0],
                                            toggleCoinCallback: addCustomer2Cart1, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom,printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                                );
                                openDrawerFrom();
                              },
                              child: Padding(
                                padding:
                                EdgeInsets.only(
                                    top: index == 0
                                        ? 10.0
                                        : 15.0),
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: index ==
                                              length -
                                                  1 ?
                                          BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.3),
                                              width: 1.0)
                                              :
                                          BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(
                                                  0.3),
                                              width: 1.0)
                                      )),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets
                                            .only(
                                            bottom: 18.0),
                                        child: ListTile(
                                          title: Text(
                                            item.split('^sps^')[1].toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight:
                                                FontWeight
                                                    .w500,
                                                height: 1.1
                                            ),
                                            strutStyle: StrutStyle(
                                              height: 1.3,
                                              // fontSize:,
                                              forceStrutHeight: true,
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets
                                                .only(
                                                top: 8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  item.split('^sps^')[2].toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.grey,
                                                      height: 1.1
                                                  ),
                                                  strutStyle: StrutStyle(
                                                    height: 1.2,
                                                    // fontSize:,
                                                    forceStrutHeight: true,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,),
                                                Text(
                                                  item.split('^sps^')[3].toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.grey,
                                                      height: 1.1
                                                  ),
                                                  strutStyle: StrutStyle(
                                                    height: 1,
                                                    // fontSize:,
                                                    forceStrutHeight: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                                                      stream: FirebaseFirestore.instance
                                                          .collection('shops')
                                                          .doc(shopId)
                                                          .collection('customers')
                                                          .doc(item.split('^sps^')[0].toString())
                                                          .snapshots(),
                                                      builder: (BuildContext context, snapshot5) {
                                                        if(snapshot5.hasData){
                                                          var output3 = snapshot5.data!.data();
                                                          var debts = output3?['debts'].toInt();
                                                          return debts !=0 ? Container(
                                                            height: 21,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(20.0),
                                                              color: AppTheme.badgeFgDanger,
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                                              child: Text(debts.toString() + ' unpaid',
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.white
                                                                ),
                                                              ),
                                                            ),
                                                          ) : Container(height: 21);
                                                          // int quantity = 0;
                                                          // snapshot2.data!.docs.map((DocumentSnapshot document2) {
                                                          //   Map<String, dynamic> data2 = document2.data()! as Map<String, dynamic>;
                                                          //   orders = data2['daily_order'];
                                                          //   quantity += int.parse(orders.length.toString());
                                                          //
                                                          //   return Text(snapshot2.data!.docs[index].id);
                                                          // }).toList();
                                                        }
                                                        return Container();
                                                      }
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: 12),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2.0),
                                                  child: Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 16,
                                                    color: Colors.blueGrey
                                                        .withOpacity(
                                                        0.8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.blue,
                                        height: MediaQuery.of(context).viewInsets.bottom - 80 < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          else if(searchValue == '') {
                            return Container();
                          }
                          return Container(
                            // child: Text('Loading...')
                          );
                        },
                      ),
                    ),


                  if(slidingSearch == 1)
                    SliverExpandableList(
                      builder: SliverExpandableChildDelegate(
                        sectionList: sectionList1,
                        headerBuilder: _buildHeader1,
                        itemBuilder: (context, sectionIndex, itemIndex, index) {
                          String item = sectionList1[sectionIndex].items[itemIndex];
                          int length = sectionList1[sectionIndex].items.length;
                          // if(sectionIndex == 0) {
                          //   return Container(
                          //     height: 0.1,
                          //   );
                          //   // return SliverFillRemaining(
                          //   //   child: new Container(
                          //   //     color: Colors.red,
                          //   //   ),
                          //   // );
                          // }

                          if(searchValue == '') {
                            return Container();
                          }
                          if(item == '') {
                            return Container();
                          } else {
                            if(sectionIndex == 0) {
                              return GestureDetector(
                                onTap: () async {
                                  closeDrawerFrom();
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (
                                            context) =>
                                            CustomerInfoSubs(
                                              id: item.split('^sps^')[0],
                                              toggleCoinCallback: addCustomer2Cart1, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                                  );
                                  openDrawerFrom();
                                },
                                child: Container(
                                  color: AppTheme.lightBgColor,
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(
                                        top: 15.0),
                                    child: Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: index ==
                                                  length
                                                  ?
                                              BorderSide(
                                                  color: Colors.grey
                                                      .withOpacity(
                                                      0.3),
                                                  width: 1.0)
                                                  :

                                              BorderSide(
                                                  color: Colors.grey
                                                      .withOpacity(
                                                      0.3),
                                                  width: 1.0)
                                          )),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets
                                                .only(
                                                bottom: 18.0),
                                            child: ListTile(
                                              title: Text(
                                                item.split('^sps^')[1].toString(),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    height: 1.1
                                                ),
                                                strutStyle: StrutStyle(
                                                  height: 1.3,
                                                  // fontSize:,
                                                  forceStrutHeight: true,
                                                ),
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets
                                                    .only(
                                                    top: 8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      item.split('^sps^')[2].toString(),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          color: Colors.grey,
                                                          height: 1.1
                                                      ),
                                                      strutStyle: StrutStyle(
                                                        height: 1.2,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,),
                                                    Text(
                                                      item.split('^sps^')[3].toString(),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          color: Colors.grey,
                                                          height: 1.1
                                                      ),
                                                      strutStyle: StrutStyle(
                                                        height: 1,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              trailing: Container(
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                                                          stream: FirebaseFirestore.instance
                                                              .collection('shops')
                                                              .doc(shopId)
                                                              .collection('customers')
                                                              .doc(item.split('^sps^')[0].toString())
                                                              .snapshots(),
                                                          builder: (BuildContext context, snapshot5) {
                                                            if(snapshot5.hasData){
                                                              var output3 = snapshot5.data!.data();
                                                              var debts = output3?['debts'].toInt();
                                                              return debts !=0 ? Container(
                                                                height: 21,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                  color: AppTheme.badgeFgDanger,
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                                                  child: Text(debts.toString() + ' unpaid',
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.white
                                                                    ),
                                                                  ),
                                                                ),
                                                              ) : Container(height: 21);
                                                              // int quantity = 0;
                                                              // snapshot2.data!.docs.map((DocumentSnapshot document2) {
                                                              //   Map<String, dynamic> data2 = document2.data()! as Map<String, dynamic>;
                                                              //   orders = data2['daily_order'];
                                                              //   quantity += int.parse(orders.length.toString());
                                                              //
                                                              //   return Text(snapshot2.data!.docs[index].id);
                                                              // }).toList();
                                                            }
                                                            return Container();
                                                          }
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: 12),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 2.0),
                                                      child: Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                        size: 16,
                                                        color: Colors.blueGrey
                                                            .withOpacity(
                                                            0.8),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                          return GestureDetector(
                            onTap: () async {
                              closeDrawerFrom();
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (
                                        context) =>
                                        MerchantInfoSubs(
                                          id: item.split('^sps^')[0],
                                          toggleCoinCallback: addMerchant2Cart, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                              );
                              openDrawerFrom();
                            },
                            child: Container(
                              color: AppTheme.lightBgColor,
                              child: Padding(
                                padding:
                                EdgeInsets.only(
                                    top: 15.0),
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: index ==
                                              length
                                              ?
                                          BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(
                                                  0.3),
                                              width: 1.0)
                                              :

                                          BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(
                                                  0.3),
                                              width: 1.0)
                                      )),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets
                                            .only(
                                            bottom: 18.0),
                                        child: ListTile(
                                          title: Text(
                                            item.split('^sps^')[1].toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight:
                                                FontWeight
                                                    .w500,
                                                height: 1.1
                                            ),
                                            strutStyle: StrutStyle(
                                              height: 1.3,
                                              // fontSize:,
                                              forceStrutHeight: true,
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets
                                                .only(
                                                top: 8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  item.split('^sps^')[2].toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.grey,
                                                      height: 1.1
                                                  ),
                                                  strutStyle: StrutStyle(
                                                    height: 1.2,
                                                    // fontSize:,
                                                    forceStrutHeight: true,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,),
                                                Text(
                                                  item.split('^sps^')[3].toString(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Colors.grey,
                                                      height: 1.1
                                                  ),
                                                  strutStyle: StrutStyle(
                                                    height: 1,
                                                    // fontSize:,
                                                    forceStrutHeight: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                                                      stream: FirebaseFirestore.instance
                                                          .collection('shops')
                                                          .doc(shopId)
                                                          .collection('merchants')
                                                          .doc(item.split('^sps^')[0].toString())
                                                          .snapshots(),
                                                      builder: (BuildContext context, snapshot5) {
                                                        if(snapshot5.hasData){
                                                          var output3 = snapshot5.data!.data();
                                                          var debts = output3?['debts'].toInt();
                                                          return debts !=0 ? Container(
                                                            height: 21,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(20.0),
                                                              color: AppTheme.badgeFgDanger,
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                                              child: Text(debts.toString() + ' unpaid',
                                                                style: TextStyle(
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.white
                                                                ),
                                                              ),
                                                            ),
                                                          ) : Container(height: 21);
                                                          // int quantity = 0;
                                                          // snapshot2.data!.docs.map((DocumentSnapshot document2) {
                                                          //   Map<String, dynamic> data2 = document2.data()! as Map<String, dynamic>;
                                                          //   orders = data2['daily_order'];
                                                          //   quantity += int.parse(orders.length.toString());
                                                          //
                                                          //   return Text(snapshot2.data!.docs[index].id);
                                                          // }).toList();
                                                        }
                                                        return Container();
                                                      }
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: 12),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2.0),
                                                  child: Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 16,
                                                    color: Colors.blueGrey
                                                        .withOpacity(
                                                        0.8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  if(slidingSearch == 2)
                    SliverExpandableList(
                      builder: SliverExpandableChildDelegate(
                        sectionList: sectionList2,
                        headerBuilder: _buildHeader2,
                        itemBuilder: (context, sectionIndex, itemIndex, index) {
                          String item = sectionList2[sectionIndex].items[itemIndex];
                          int length = sectionList2[sectionIndex].items.length;
                          print('checkkk ' + item.toString());
                          if(searchValue == '') {
                            return Container();
                          }

                          if(item!='') {
                            if(searchValue.toLowerCase().contains('b')) {
                              return GestureDetector(
                                onTap: () async {
                                  print('clicked buy list');
                                  closeDrawerFrom();
                                  // print(item.split('^')[1]);
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BuyListInfo(printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev, data: item, toggleCoinCallback: () {}, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom,)),
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
                                                        Text(
                                                          covertToDayNum(item.split('^')[0].substring(6,8)) + '/' + item.split('^')[0].substring(4,6) + ' ',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        Text(convertToHour(item.split('^')[7]) + ':' + item.split('^')[8] + ' ' + convertToAMPM(item.split('^')[7]),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        // Text(item.split('^')[7] + ':' + item.split('^')[8] ,
                                                        //   style: TextStyle(
                                                        //     fontSize: 14,
                                                        //     fontWeight: FontWeight.w500,
                                                        //     color: Colors.grey,
                                                        //   ),
                                                        // ),
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
                                            Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
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
                            } else {
                              print('orderinfosub ' + searchValue.toString());
                              return GestureDetector(
                                onTap: () async {
                                  closeDrawerFrom();
                                  print('clicked order list');
                                  // print(item.split('^')[1]);
                                  if(_searchController.text.toLowerCase().contains('b')) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BuyListInfo(printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev, data: item, toggleCoinCallback: () {}, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom,)),
                                    );
                                  } else {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {}, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                                    );
                                  }
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
                                                        // '#' + item!='' ? item.split('^')[1]: ''
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
                                                        Text(
                                                          covertToDayNum(item.split('^')[0].substring(6,8)) + '/' + item.split('^')[0].substring(4,6) + ' ',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        Text(convertToHour(item.split('^')[7]) + ':' + item.split('^')[8] + ' ' + convertToAMPM(item.split('^')[7]),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        // Text(item.split('^')[7] + ':' + item.split('^')[8] ,
                                                        //   style: TextStyle(
                                                        //     fontSize: 14,
                                                        //     fontWeight: FontWeight.w500,
                                                        //     color: Colors.grey,
                                                        //   ),
                                                        // ),
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
                                            Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
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
                            }

                          }
                          return Container();
                          // if(item == '') {
                          //   return Container();
                          // } else {
                          //   if(item.split('^')[9] == 'b') {
                          //     return GestureDetector(
                          //       onTap: () async {
                          //         closeDrawerFrom();
                          //         // print(item.split('^')[1]);
                          //         await Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) => BuyListInfo(printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev, data: item, toggleCoinCallback: () {}, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom,)),
                          //         );
                          //         openDrawerFrom();
                          //       },
                          //       child: Stack(
                          //         alignment: Alignment.center,
                          //         children: [
                          //           Padding(
                          //             padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                          //             child: Container(
                          //               decoration: BoxDecoration(
                          //                   color: AppTheme.lightBgColor,
                          //                   border: Border(
                          //                     bottom: BorderSide(
                          //                         color: AppTheme.skBorderColor2,
                          //                         width: 1.0),
                          //                   )),
                          //               child: Padding(
                          //                 padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
                          //                 child: Column(
                          //                   mainAxisAlignment: MainAxisAlignment.start,
                          //                   crossAxisAlignment: CrossAxisAlignment.start,
                          //                   children: [
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(left: 1.0),
                          //                       child: Column(
                          //                         mainAxisAlignment: MainAxisAlignment.start,
                          //                         crossAxisAlignment: CrossAxisAlignment.start,
                          //                         children: [
                          //                           Row(
                          //                             mainAxisAlignment: MainAxisAlignment.start,
                          //                             children: [
                          //                               Text('#' + item.split('^')[1],
                          //                                 style: TextStyle(
                          //                                     fontSize: 16,
                          //                                     fontWeight: FontWeight.w500
                          //                                 ),
                          //                               ),
                          //                               SizedBox(width: 8),
                          //                               Padding(
                          //                                 padding: const EdgeInsets.only(bottom: 1.0),
                          //                                 child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
                          //                               ),
                          //                               SizedBox(width: 4),
                          //                               Text(convertToHour(item.split('^')[7]) + ':' + item.split('^')[8] + ' ' + convertToAMPM(item.split('^')[7]),
                          //                                 style: TextStyle(
                          //                                   fontSize: 14,
                          //                                   fontWeight: FontWeight.w500,
                          //                                   color: Colors.grey,
                          //                                 ),
                          //                               ),
                          //                               // Text(item.split('^')[7] + ':' + item.split('^')[8] ,
                          //                               //   style: TextStyle(
                          //                               //     fontSize: 14,
                          //                               //     fontWeight: FontWeight.w500,
                          //                               //     color: Colors.grey,
                          //                               //   ),
                          //                               // ),
                          //                             ],
                          //                           ),
                          //                           SizedBox(
                          //                             height: 6,
                          //                           ),
                          //                           Row(
                          //                             children: [
                          //                               Text(item.split('^')[3].split('&')[0], style: TextStyle(
                          //                                 fontSize: 15,
                          //                                 fontWeight: FontWeight.w500,
                          //                                 color: Colors.grey,
                          //                               )),
                          //
                          //                             ],
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                     SizedBox(
                          //                       height: 8,
                          //                     ),
                          //                     Row(
                          //                       children: [
                          //                         if(item.split('^')[5] == '0.0')
                          //                           Padding(
                          //                             padding: const EdgeInsets.only(left: 0.0),
                          //                             child: Container(
                          //                               height: 21,
                          //                               decoration: BoxDecoration(
                          //                                 borderRadius: BorderRadius.circular(20.0),
                          //                                 color: AppTheme.badgeBgSuccess,
                          //                               ),
                          //                               child: Padding(
                          //                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                          //                                 child: Text('Paid',
                          //                                   style: TextStyle(
                          //                                       fontSize: 13,
                          //                                       fontWeight: FontWeight.w500,
                          //                                       color: Colors.white
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //
                          //                         if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
                          //                           Padding(
                          //                             padding: const EdgeInsets.only(left: 0.0),
                          //                             child: Container(
                          //                               height: 21,
                          //                               decoration: BoxDecoration(
                          //                                 borderRadius: BorderRadius.circular(20.0),
                          //                                 color: AppTheme.badgeFgDangerLight,
                          //                               ),
                          //                               child: Padding(
                          //                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                          //                                 child: Text('Partially paid',
                          //                                   style: TextStyle(
                          //                                       fontSize: 13,
                          //                                       fontWeight: FontWeight.w500,
                          //                                       color: AppTheme.badgeFgDanger
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
                          //                           Padding(
                          //                             padding: const EdgeInsets.only(left: 0.0),
                          //                             child: Container(
                          //                               height: 21,
                          //                               decoration: BoxDecoration(
                          //                                 borderRadius: BorderRadius.circular(20.0),
                          //                                 color: AppTheme.badgeFgDanger,
                          //                               ),
                          //                               child: Padding(
                          //                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                          //                                 child: Text('Unpaid',
                          //                                   style: TextStyle(
                          //                                       fontSize: 13,
                          //                                       fontWeight: FontWeight.w500,
                          //                                       color: Colors.white
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         if(item.split('^')[4] == 'TRUE')
                          //                           Padding(
                          //                             padding: const EdgeInsets.only(left: 6.0),
                          //                             child: Container(
                          //                               height: 21,
                          //                               decoration: BoxDecoration(
                          //                                 borderRadius: BorderRadius.circular(20.0),
                          //                                 color: AppTheme.badgeBgSecond,
                          //                               ),
                          //                               child: Padding(
                          //                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                          //                                 child: Text('Refunded',
                          //                                   style: TextStyle(
                          //                                       fontSize: 13,
                          //                                       fontWeight: FontWeight.w500,
                          //                                       color: Colors.white
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //
                          //                         if(item.split('^')[4] == 'PART')
                          //                           Padding(
                          //                             padding: const EdgeInsets.only(left: 6.0),
                          //                             child: Container(
                          //                               height: 21,
                          //                               decoration: BoxDecoration(
                          //                                 borderRadius: BorderRadius.circular(20.0),
                          //                                 color: AppTheme.badgeBgSecondLight,
                          //                               ),
                          //                               child: Padding(
                          //                                 padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
                          //                                 child: Text('Partially refunded',
                          //                                   style: TextStyle(
                          //                                       fontSize: 13,
                          //                                       fontWeight: FontWeight.w500,
                          //                                       color: AppTheme.badgeBgSecond
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //
                          //                       ],
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //           Padding(
                          //             padding: const EdgeInsets.only(right: 15.0, bottom: 5),
                          //             child: Align(
                          //               alignment: Alignment.centerRight,
                          //               child: Row(
                          //                 mainAxisAlignment: MainAxisAlignment.end,
                          //                 children: [
                          //                   Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
                          //                     fontSize: 15,
                          //                     fontWeight: FontWeight.w500,
                          //                   )),
                          //                   SizedBox(width: 10),
                          //                   Padding(
                          //                     padding: const EdgeInsets.only(bottom: 2.0),
                          //                     child: Icon(
                          //                       Icons
                          //                           .arrow_forward_ios_rounded,
                          //                       size: 16,
                          //                       color: Colors
                          //                           .blueGrey
                          //                           .withOpacity(
                          //                           0.8),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //     );
                          //   } else {
                          //     return GestureDetector(
                          //       onTap: () async {
                          //         closeDrawerFrom();
                          //         // print(item.split('^')[1]);
                          //         await Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {}, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                          //         );
                          //         openDrawerFrom();
                          //       },
                          //       child: Stack(
                          //         alignment: Alignment.center,
                          //         children: [
                          //           Padding(
                          //             padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                          //             child: Container(
                          //               decoration: BoxDecoration(
                          //                   color: AppTheme.lightBgColor,
                          //                   border: Border(
                          //                     bottom: BorderSide(
                          //                         color: AppTheme.skBorderColor2,
                          //                         width: 1.0),
                          //                   )),
                          //               child: Padding(
                          //                 padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
                          //                 child: Column(
                          //                   mainAxisAlignment: MainAxisAlignment.start,
                          //                   crossAxisAlignment: CrossAxisAlignment.start,
                          //                   children: [
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(left: 1.0),
                          //                       child: Column(
                          //                         mainAxisAlignment: MainAxisAlignment.start,
                          //                         crossAxisAlignment: CrossAxisAlignment.start,
                          //                         children: [
                          //                           Row(
                          //                             mainAxisAlignment: MainAxisAlignment.start,
                          //                             children: [
                          //                               Text('#' + item.split('^')[1],
                          //                                 style: TextStyle(
                          //                                     fontSize: 16,
                          //                                     fontWeight: FontWeight.w500
                          //                                 ),
                          //                               ),
                          //                               SizedBox(width: 8),
                          //                               Padding(
                          //                                 padding: const EdgeInsets.only(bottom: 1.0),
                          //                                 child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
                          //                               ),
                          //                               SizedBox(width: 4),
                          //                               Text(convertToHour(item.split('^')[7]) + ':' + item.split('^')[8] + ' ' + convertToAMPM(item.split('^')[7]),
                          //                                 style: TextStyle(
                          //                                   fontSize: 14,
                          //                                   fontWeight: FontWeight.w500,
                          //                                   color: Colors.grey,
                          //                                 ),
                          //                               ),
                          //                               // Text(item.split('^')[7] + ':' + item.split('^')[8] ,
                          //                               //   style: TextStyle(
                          //                               //     fontSize: 14,
                          //                               //     fontWeight: FontWeight.w500,
                          //                               //     color: Colors.grey,
                          //                               //   ),
                          //                               // ),
                          //                             ],
                          //                           ),
                          //                           SizedBox(
                          //                             height: 6,
                          //                           ),
                          //                           Row(
                          //                             children: [
                          //                               Text(item.split('^')[3].split('&')[0], style: TextStyle(
                          //                                 fontSize: 15,
                          //                                 fontWeight: FontWeight.w500,
                          //                                 color: Colors.grey,
                          //                               )),
                          //
                          //                             ],
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                     SizedBox(
                          //                       height: 8,
                          //                     ),
                          //                     Row(
                          //                       children: [
                          //                         if(item.split('^')[5] == '0.0')
                          //                           Padding(
                          //                             padding: const EdgeInsets.only(left: 0.0),
                          //                             child: Container(
                          //                               height: 21,
                          //                               decoration: BoxDecoration(
                          //                                 borderRadius: BorderRadius.circular(20.0),
                          //                                 color: AppTheme.badgeBgSuccess,
                          //                               ),
                          //                               child: Padding(
                          //                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                          //                                 child: Text('Paid',
                          //                                   style: TextStyle(
                          //                                       fontSize: 13,
                          //                                       fontWeight: FontWeight.w500,
                          //                                       color: Colors.white
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //
                          //                         if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
                          //                           Padding(
                          //                             padding: const EdgeInsets.only(left: 0.0),
                          //                             child: Container(
                          //                               height: 21,
                          //                               decoration: BoxDecoration(
                          //                                 borderRadius: BorderRadius.circular(20.0),
                          //                                 color: AppTheme.badgeFgDangerLight,
                          //                               ),
                          //                               child: Padding(
                          //                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                          //                                 child: Text('Partially paid',
                          //                                   style: TextStyle(
                          //                                       fontSize: 13,
                          //                                       fontWeight: FontWeight.w500,
                          //                                       color: AppTheme.badgeFgDanger
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
                          //                           Padding(
                          //                             padding: const EdgeInsets.only(left: 0.0),
                          //                             child: Container(
                          //                               height: 21,
                          //                               decoration: BoxDecoration(
                          //                                 borderRadius: BorderRadius.circular(20.0),
                          //                                 color: AppTheme.badgeFgDanger,
                          //                               ),
                          //                               child: Padding(
                          //                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                          //                                 child: Text('Unpaid',
                          //                                   style: TextStyle(
                          //                                       fontSize: 13,
                          //                                       fontWeight: FontWeight.w500,
                          //                                       color: Colors.white
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         if(item.split('^')[4] == 'TRUE')
                          //                           Padding(
                          //                             padding: const EdgeInsets.only(left: 6.0),
                          //                             child: Container(
                          //                               height: 21,
                          //                               decoration: BoxDecoration(
                          //                                 borderRadius: BorderRadius.circular(20.0),
                          //                                 color: AppTheme.badgeBgSecond,
                          //                               ),
                          //                               child: Padding(
                          //                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                          //                                 child: Text('Refunded',
                          //                                   style: TextStyle(
                          //                                       fontSize: 13,
                          //                                       fontWeight: FontWeight.w500,
                          //                                       color: Colors.white
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //
                          //                         if(item.split('^')[4] == 'PART')
                          //                           Padding(
                          //                             padding: const EdgeInsets.only(left: 6.0),
                          //                             child: Container(
                          //                               height: 21,
                          //                               decoration: BoxDecoration(
                          //                                 borderRadius: BorderRadius.circular(20.0),
                          //                                 color: AppTheme.badgeBgSecondLight,
                          //                               ),
                          //                               child: Padding(
                          //                                 padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
                          //                                 child: Text('Partially refunded',
                          //                                   style: TextStyle(
                          //                                       fontSize: 13,
                          //                                       fontWeight: FontWeight.w500,
                          //                                       color: AppTheme.badgeBgSecond
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //
                          //                       ],
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //           Padding(
                          //             padding: const EdgeInsets.only(right: 15.0, bottom: 5),
                          //             child: Align(
                          //               alignment: Alignment.centerRight,
                          //               child: Row(
                          //                 mainAxisAlignment: MainAxisAlignment.end,
                          //                 children: [
                          //                   Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
                          //                     fontSize: 15,
                          //                     fontWeight: FontWeight.w500,
                          //                   )),
                          //                   SizedBox(width: 10),
                          //                   Padding(
                          //                     padding: const EdgeInsets.only(bottom: 2.0),
                          //                     child: Icon(
                          //                       Icons
                          //                           .arrow_forward_ios_rounded,
                          //                       size: 16,
                          //                       color: Colors
                          //                           .blueGrey
                          //                           .withOpacity(
                          //                           0.8),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           )
                          //         ],
                          //       ),
                          //     );
                          //   }
                          // }

                        },
                      ),
                    ),
                ],
              ),
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
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black
                                            ),

                                            decoration: InputDecoration(
                                              hintText:textSetSearch,
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