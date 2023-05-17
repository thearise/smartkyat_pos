import 'dart:io';

import 'package:blue_print_pos/models/blue_device.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';
import 'bloc_buylist.dart';
import 'bloc_firestore.dart';

class BuyListFragment2 extends StatefulWidget {
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

  BuyListFragment2(
      {
        required void closeDrawerBtn(String str),
        required void openDrawerBtn(String str),
        required this.shopId,
        this.selectedDev,
        required this.isEnglish,
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
  final BlueDevice? selectedDev;
  final bool isEnglish;

  @override
  BuyListFragment2State createState() => BuyListFragment2State();
}

class BuyListFragment2State extends State<BuyListFragment2>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<BuyListFragment2> {

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

  String textSetSearch = 'Search';

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


    if(widget.isEnglish == true) {
      setState(() {
        textSetSearch = 'Search';
      });
    } else {
      setState(() {
        textSetSearch = 'ရှာဖွေရန်';

      });
    }


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
    debugPrint(index);
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
      debugPrint('gg0');
      subTabController.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);
      setState(() {
      });
    } else if(slidingSearch == 1) {
      debugPrint('gg1');
      subTabController.animateTo(1, duration: Duration(milliseconds: 0), curve: Curves.ease);
      setState(() {
      });
    } else if(slidingSearch == 2) {
      debugPrint('gg2');
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
        // brightness: Brightness.light,
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
                          debugPrint('clicked saerch');
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  resetState(DateTime resetD) {
    setState(() {
      today = resetD;
    });
  }


  checkTest(String input) {
    debugPrint("CHECK TEST " + input);
  }


  List<String> gloTemp = [];

  DateTime today = DateTime.now();


  ordersQuery() {
    // DateTime greaterThan = DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.subtract(Duration(days: 6)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 6)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 6)).day.toString()) + ' 00:00:00');
    return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrders')
        .where('date', isLessThan: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + (DateTime(today.year, today.month + 1, 0).day).toString() + ' 23:59:59'))
        .where('date', isGreaterThan: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-00' + ' 23:59:59'))
        .orderBy('date', descending: true);
  }

  String valKTog = '0';

  valueKeyTog() {
    valKTog = today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(today.day.toString());
    return ValueKey<String>(valKTog.toString());

  }
}
