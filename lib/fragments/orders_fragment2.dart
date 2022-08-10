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
import 'package:smartkyat_pos/pages2/home_page5.dart';
import 'package:smartkyat_pos/widgets/product_details_view2.dart';
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
        required this.shopId,
        required this.isEnglish,
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
  final BlueDevice? selectedDev;
  final bool isEnglish;

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

  String textSetSearch = 'Search';

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
      if(widget.isEnglish == true)
      {
        setState(() {
          textSetSearch = 'Search';

        });
      }
      else {
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
                          child: BlocFirestore(
                            isEnglish: widget.isEnglish,
                            key: valueKeyTog(),
                            footer: SliverToBoxAdapter(child: Padding(
                              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                              child: Center(child: Text('End of results', textScaleFactor: 1, strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),)),
                            )),
                            bottomLoader: Container(
                              child: LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
                            ),
                            itemBuilder: (context1, documentSnapshots, index) {
                              Map<String, dynamic> data = documentSnapshots[index].data() as Map<String, dynamic>;

                              String item = zeroToTen(data['date'].toDate().year.toString()) + ' ' + zeroToTen(data['date'].toDate().month.toString()) + ' ' + zeroToTen(data['date'].toDate().day.toString()) + ' ' + zeroToTen(data['date'].toDate().hour.toString()) + ' ' + zeroToTen(data['date'].toDate().minute.toString());
                              return Container(child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text('items ' + item.toString(), textScaleFactor: 1,),
                              ));
                            },
                            itemBuilderType:
                            PaginateBuilderType.listView,
                            // cateScIndex
                            // orderBy is compulsory to enable pagination
                            // query: FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('order').where('debt', isGreaterThan: 0),
                            query: ordersQuery()
                            // query: FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders')
                            //     .where('date', isGreaterThan: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.subtract(Duration(days: 6)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 6)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 6)).day.toString()) + ' 00:00:00'))
                            // .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(today.add(Duration(days: 1)).day.toString()) + ' 00:00:00'))
                            ,
                            // to fetch real-time data
                            isLive: true,
                            shopId: widget.shopId,
                            resetState: resetState,
                            dateTime: today,
                            openDrawerBtn: openDrawerFrom,
                            openCartBtn: openCartFrom,
                            closeCartBtn: closeCartFrom,
                            printFromOrders: printFromOrdersFun,
                            closeDrawerBtn: closeDrawerFrom,
                          )
                      ),
                    ),
                  ),
                // if(searchOpeningR)
                //   Container(
                //     height: MediaQuery.of(context).size.height,
                //     color: Colors.white,
                //     child: Center(
                //       child: Padding(
                //         padding: const EdgeInsets.only(top: 30.0),
                //         child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                //             child: CupertinoActivityIndicator(radius: 15,)),
                //       ),
                //     ),
                //   ),
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
                // Padding(
                //   padding: const EdgeInsets.only(top: 150.0),
                //   child: Container(
                //     color: Colors.white,
                //     height: 200,
                //     child: BlocFirestore(
                //       // Use SliverAppBar in header to make it sticky
                //       // key: cateScIndex == 0? ValueKey<String>('00'): cateScIndex == 1? (togIndOne? ValueKey<String>('11'): ValueKey<String>('12')): cateScIndex == 2? ValueKey<String>('22'): ValueKey<String>('33'),
                //       // header: SliverAppBar(
                //       //   leading: Container(),
                //       //   elevation: 0,
                //       //   backgroundColor: Colors.white,
                //       //   // Provide a standard title.
                //       //   // Allows the user to reveal the app bar if they begin scrolling
                //       //   // back up the list of items.
                //       //   floating: true,
                //       //   flexibleSpace: Padding(
                //       //     padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
                //       //     child: Container(
                //       //       height: 32,
                //       //       width: MediaQuery.of(context).size.width,
                //       //       // color: Colors.yellow,
                //       //       child: Row(
                //       //         children: [
                //       //           Expanded(
                //       //             child:  ListView(
                //       //               controller: cateScCtler,
                //       //               scrollDirection: Axis.horizontal,
                //       //               children: [
                //       //                 SizedBox(
                //       //                   width: 0,
                //       //                 ),
                //       //                 Padding(
                //       //                   padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                //       //                   child: FlatButton(
                //       //                     minWidth: 0,
                //       //                     padding: EdgeInsets.only(left: 12, right: 12),
                //       //                     color: cateScIndex == 0 ? AppTheme.secButtonColor:Colors.white,
                //       //                     shape: RoundedRectangleBorder(
                //       //                       borderRadius: BorderRadius.circular(20.0),
                //       //                       side: BorderSide(
                //       //                         color: AppTheme.skBorderColor2,
                //       //                       ),
                //       //                     ),
                //       //                     onPressed: () {
                //       //                       _animateToIndex(0);
                //       //                       setState(() {
                //       //                         cateScIndex = 0;
                //       //                       });
                //       //                     },
                //       //                     child: Container(
                //       //                       child: Text(
                //       //                         textSetAll,
                //       //                         textAlign: TextAlign.center,
                //       //                         style: TextStyle(
                //       //                             fontSize: 14,
                //       //                             fontWeight: FontWeight.w500,
                //       //                             color: Colors.black),
                //       //                       ),
                //       //                     ),
                //       //                   ),
                //       //                 ),
                //       //                 Padding(
                //       //                   padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                //       //                   child: FlatButton(
                //       //                     minWidth: 0,
                //       //                     padding: EdgeInsets.only(left: 12, right: 12),
                //       //                     color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
                //       //                     shape: RoundedRectangleBorder(
                //       //                       borderRadius: BorderRadius.circular(20.0),
                //       //                       side: BorderSide(
                //       //                         color: AppTheme.skBorderColor2,
                //       //                       ),
                //       //                     ),
                //       //                     onPressed: () {
                //       //                       _animateToIndex(5.4);
                //       //                       setState(() {
                //       //                         cateScIndex = 1;
                //       //                       });
                //       //                       toggleIndexOne();
                //       //                     },
                //       //                     child: Container(
                //       //                       child: Text(
                //       //                         textSetTUnpaid,
                //       //                         textAlign: TextAlign.center,
                //       //                         style: TextStyle(
                //       //                             fontSize: 14,
                //       //                             fontWeight: FontWeight.w500,
                //       //                             color: Colors.black),
                //       //                       ),
                //       //                     ),
                //       //                   ),
                //       //                 ),
                //       //                 Padding(
                //       //                   padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                //       //                   child: FlatButton(
                //       //                     minWidth: 0,
                //       //                     padding: EdgeInsets.only(left: 12, right: 12),
                //       //                     color: cateScIndex == 2 ? AppTheme.secButtonColor:Colors.white,
                //       //                     shape: RoundedRectangleBorder(
                //       //                       borderRadius: BorderRadius.circular(20.0),
                //       //                       side: BorderSide(
                //       //                         color: AppTheme.skBorderColor2,
                //       //                       ),
                //       //                     ),
                //       //                     onPressed: () {
                //       //                       _animateToIndex(16.4);
                //       //                       setState(() {
                //       //                         cateScIndex = 2;
                //       //                       });
                //       //                     },
                //       //                     child: Container(
                //       //                       child: Text(
                //       //                         textSetTRefunds,
                //       //                         textAlign: TextAlign.center,
                //       //                         style: TextStyle(
                //       //                             fontSize: 14,
                //       //                             fontWeight: FontWeight.w500,
                //       //                             color: Colors.black),
                //       //                       ),
                //       //                     ),
                //       //                   ),
                //       //                 ),
                //       //                 // Padding(
                //       //                 //   padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                //       //                 //   child: FlatButton(
                //       //                 //     minWidth: 0,
                //       //                 //     padding: EdgeInsets.only(left: 12, right: 12),
                //       //                 //     color: cateScIndex == 3 ? AppTheme.secButtonColor:Colors.white,
                //       //                 //     shape: RoundedRectangleBorder(
                //       //                 //       borderRadius: BorderRadius.circular(20.0),
                //       //                 //       side: BorderSide(
                //       //                 //         color: AppTheme.skBorderColor2,
                //       //                 //       ),
                //       //                 //     ),
                //       //                 //     onPressed: () {
                //       //                 //       _animateToIndex(20);
                //       //                 //       setState(() {
                //       //                 //         cateScIndex = 3;
                //       //                 //       });
                //       //                 //     },
                //       //                 //     child: Container(
                //       //                 //       child: Text(
                //       //                 //         textSetTPaid,
                //       //                 //         textAlign: TextAlign.center,
                //       //                 //         style: TextStyle(
                //       //                 //             fontSize: 14,
                //       //                 //             fontWeight: FontWeight.w500,
                //       //                 //             color: Colors.black),
                //       //                 //       ),
                //       //                 //     ),
                //       //                 //   ),
                //       //                 // ),
                //       //                 SizedBox(
                //       //                   width: 11,
                //       //                 )
                //       //               ],
                //       //             ),
                //       //           )
                //       //         ],
                //       //       ),
                //       //
                //       //     ),
                //       //   ),),
                //       header: SliverAppBar(
                //         elevation: 0,
                //         backgroundColor: Colors.white,
                //
                //         // Provide a standard title.
                //
                //         // Allows the user to reveal the app bar if they begin scrolling
                //         // back up the list of items.
                //         floating: true,
                //         bottom: PreferredSize(                       // Add this code
                //           preferredSize: Size.fromHeight(-2.0),      // Add this code
                //           child: Container(),                           // Add this code
                //         ),
                //         flexibleSpace: Padding(
                //           padding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 0.0),
                //           child: Container(
                //             height: 32,
                //             width: MediaQuery.of(context).size.width,
                //             // color: Colors.yellow,
                //             child: Row(
                //               children: [
                //                 Row(
                //                   children: [
                //                     FlatButton(
                //                       padding: EdgeInsets.only(left: 10, right: 10),
                //                       color: AppTheme.secButtonColor,
                //                       shape: RoundedRectangleBorder(
                //                         borderRadius: BorderRadius.circular(8.0),
                //                         side: BorderSide(
                //                           color: AppTheme.skBorderColor2,
                //                         ),
                //                       ),
                //                       onPressed: () {
                //                         // widget._callback();
                //                         _showDatePicker(OneContext().context);
                //                       },
                //                       child: Container(
                //                         child: Row(
                //                           // mainAxisAlignment: Main,
                //                           children: [
                //                             Padding(
                //                               padding: const EdgeInsets.only(right: 3.0),
                //                               child: Icon(
                //                                 Icons.calendar_view_day_rounded,
                //                                 size: 18,
                //                               ),
                //                             ),
                //                             Text(
                //                               selectDaysCast() + ' (7D)',
                //                               textAlign: TextAlign.center,
                //                               style: TextStyle(
                //                                   fontSize: 14,
                //                                   fontWeight: FontWeight.w500,
                //                                   color: Colors.black),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                     SizedBox(width: 12),
                //                     Container(
                //                       color: Colors.grey.withOpacity(0.2),
                //                       width: 1.5,
                //                       height: 30,
                //                     )
                //                   ],
                //                 ),
                //                 Expanded(
                //                   child: ListView(
                //                     controller: cateScCtler,
                //                     scrollDirection: Axis.horizontal,
                //                     children: [
                //                       SizedBox(
                //                         width: 4,
                //                       ),
                //                       Padding(
                //                         padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                //                         child: FlatButton(
                //                           minWidth: 0,
                //                           padding: EdgeInsets.only(left: 12, right: 12),
                //                           color: cateScIndex == 0 ? AppTheme.secButtonColor:Colors.white,
                //                           shape: RoundedRectangleBorder(
                //                             borderRadius: BorderRadius.circular(20.0),
                //                             side: BorderSide(
                //                               color: AppTheme.skBorderColor2,
                //                             ),
                //                           ),
                //                           onPressed: () {
                //                             _animateToIndex(0);
                //                             setState(() {
                //                               cateScIndex = 0;
                //                             });
                //                           },
                //                           child: Container(
                //                             child: Text(
                //                               textSetAll,
                //                               textAlign: TextAlign.center,
                //                               style: TextStyle(
                //                                   fontSize: 14,
                //                                   fontWeight: FontWeight.w500,
                //                                   color: Colors.black),
                //                             ),
                //                           ),
                //                         ),
                //                       ),
                //                       Padding(
                //                         padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                //                         child: FlatButton(
                //                           minWidth: 0,
                //                           padding: EdgeInsets.only(left: 12, right: 12),
                //                           color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
                //                           shape: RoundedRectangleBorder(
                //                             borderRadius: BorderRadius.circular(20.0),
                //                             side: BorderSide(
                //                               color: AppTheme.skBorderColor2,
                //                             ),
                //                           ),
                //                           onPressed: () {
                //                             _animateToIndex(5.4);
                //                             setState(() {
                //                               cateScIndex = 1;
                //                             });
                //                           },
                //                           child: Container(
                //                             child: Text(
                //                               textSetTUnpaid,
                //                               textAlign: TextAlign.center,
                //                               style: TextStyle(
                //                                   fontSize: 14,
                //                                   fontWeight: FontWeight.w500,
                //                                   color: Colors.black),
                //                             ),
                //                           ),
                //                         ),
                //                       ),
                //                       Padding(
                //                         padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                //                         child: FlatButton(
                //                           minWidth: 0,
                //                           padding: EdgeInsets.only(left: 12, right: 12),
                //                           color: cateScIndex == 2 ? AppTheme.secButtonColor:Colors.white,
                //                           shape: RoundedRectangleBorder(
                //                             borderRadius: BorderRadius.circular(20.0),
                //                             side: BorderSide(
                //                               color: AppTheme.skBorderColor2,
                //                             ),
                //                           ),
                //                           onPressed: () {
                //                             _animateToIndex(16.4);
                //                             setState(() {
                //                               cateScIndex = 2;
                //                             });
                //                           },
                //                           child: Container(
                //                             child: Text(
                //                               textSetTRefunds,
                //                               textAlign: TextAlign.center,
                //                               style: TextStyle(
                //                                   fontSize: 14,
                //                                   fontWeight: FontWeight.w500,
                //                                   color: Colors.black),
                //                             ),
                //                           ),
                //                         ),
                //                       ),
                //                       Padding(
                //                         padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                //                         child: FlatButton(
                //                           minWidth: 0,
                //                           padding: EdgeInsets.only(left: 12, right: 12),
                //                           color: cateScIndex == 3 ? AppTheme.secButtonColor:Colors.white,
                //                           shape: RoundedRectangleBorder(
                //                             borderRadius: BorderRadius.circular(20.0),
                //                             side: BorderSide(
                //                               color: AppTheme.skBorderColor2,
                //                             ),
                //                           ),
                //                           onPressed: () {
                //                             _animateToIndex(20);
                //                             setState(() {
                //                               cateScIndex = 3;
                //                             });
                //                           },
                //                           child: Container(
                //                             child: Text(
                //                               textSetTPaid,
                //                               textAlign: TextAlign.center,
                //                               style: TextStyle(
                //                                   fontSize: 14,
                //                                   fontWeight: FontWeight.w500,
                //                                   color: Colors.black),
                //                             ),
                //                           ),
                //                         ),
                //                       ),
                //                       SizedBox(
                //                         width: 11,
                //                       )
                //                     ],
                //                   ),
                //                 )
                //               ],
                //             ),
                //
                //           ),
                //         ),
                //         // Display a placeholder widget to visualize the shrinking size.
                //         // Make the initial height of the SliverAppBar larger than normal.
                //         expandedHeight: 20,
                //       ),
                //       key: valueKeyTog(),
                //       footer: SliverToBoxAdapter(child: Padding(
                //         padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                //         child: Center(child: Text('End of results')),
                //       )),
                //       bottomLoader: Container(
                //         child: LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
                //       ),
                //       itemBuilder: (context1, documentSnapshots, index) {
                //         Map<String, dynamic> data = documentSnapshots[index].data() as Map<String, dynamic>;
                //
                //         String item = zeroToTen(data['date'].toDate().year.toString()) + ' ' + zeroToTen(data['date'].toDate().month.toString()) + ' ' + zeroToTen(data['date'].toDate().day.toString()) + ' ' + zeroToTen(data['date'].toDate().hour.toString()) + ' ' + zeroToTen(data['date'].toDate().minute.toString());
                //         return Container(child: Padding(
                //           padding: const EdgeInsets.all(20.0),
                //           child: Text('items ' + item.toString()),
                //         ));
                //       },
                //       itemBuilderType:
                //       PaginateBuilderType.listView,
                //       // cateScIndex
                //       // orderBy is compulsory to enable pagination
                //       // query: FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('order').where('debt', isGreaterThan: 0),
                //       query: ordersQuery()
                //       // query: FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders')
                //       //     .where('date', isGreaterThan: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.subtract(Duration(days: 6)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 6)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 6)).day.toString()) + ' 00:00:00'))
                //           // .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(today.add(Duration(days: 1)).day.toString()) + ' 00:00:00'))
                //       ,
                //       // to fetch real-time data
                //       isLive: true,
                //     ),
                //   ),
                // )
                //overAllSearch()
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

  resetState(DateTime resetD) {
    setState(() {
      today = resetD;
    });
  }



  covertToDayNum(String input) {
    if(input[0]=='0') {
      return input[1];
    } else {
      return input;
    }
  }

  checkTest(String input) {
    debugPrint("CHECK TEST " + input);
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

    // debugPrint('changeData ' + snpsht.da);
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
      // debugPrint('changeData ' + document['customer_name'].toString() + list[0].toString());
    }).toList();

    // debugPrint('changeData ' + snpsht.da);
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
      // debugPrint('changeData ' + document['customer_name'].toString() + list[0].toString());
    }).toList();

    // debugPrint('changeData ' + snpsht.da);
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
    // debugPrint('section check '+ sectionList3[sectionIndex].items.length.toString());
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
                        textScaleFactor: 1, style: TextStyle(
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
                            '#' + sectionList3[sectionIndex].items.length.toString(), textScaleFactor: 1,
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
  //   //   // debugPrint('here ' + temp.toString());
  //   //   //return temp;
  //   //   // return gloTemp;
  //   // });
  //   // debugPrint('here2 ' + temp.toString());
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
                                        "New Expense", textScaleFactor: 1,
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
                                          debugPrint('clicked');
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
        confirm: Text('Done', textScaleFactor: 1, style: TextStyle(color: Colors.blue)),
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
          debugPrint('closed 1 ' + today.toString());
          // debugPrint('closed 2 ' + td.toString());
        });
        // fetchOrders();
      },
      onCancel: () => debugPrint('onCancel'),
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
    // DateTime tempDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
    // today.
    String endDateOfMonth = '31';
    if(today.month.toString() == '9' || today.month.toString() == '4' || today.month.toString() == '6' || today.month.toString() == '11') {
      endDateOfMonth = '30';
    } else if(today.month.toString() == '2') {
      endDateOfMonth = '29';
    } else {
      endDateOfMonth = '31';
    }
    DateTime yearStart = DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + endDateOfMonth + ' 23:59:59');
    debugPrint('DDDDD ' + yearStart.toString());
    return yearStart;
  }

  DateTime lossDayEnd() {
    // DateTime today = DateTime.now();
    // DateTime yearStart = DateTime.now();
    // DateTime tempDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
    // today.
    DateTime notTday = today;
    notTday = today;
    DateTime yearStart = DateFormat("yyyy-MM-dd HH:mm:ss").parse(notTday.year.toString() + '-' + zeroToTen(notTday.month.toString()) + '-00 23:59:59');
    debugPrint('DDDDDD ' + yearStart.toString());
    return yearStart;

  }

  String selectDaysCast() {
    debugPrint("TTT " + today.year.toString().length.toString());
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

  calMonth(month) {
    var calMonth = 0;
    if(month == 1) {
      calMonth = 12;
    }
    else
      calMonth = month - 1;

    return calMonth;

  }

  calYear(month, year) {
    var  calYear = 0;
    if(month == 1) {
      calYear = year -1;
    }
    else
      calYear = year;

    return calYear;
  }

  ordersQuery() {
    // DateTime greaterThan = DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.subtract(Duration(days: 6)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 6)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 6)).day.toString()) + ' 00:00:00');


    // return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders')
    //     .where('date', isGreaterThan: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.subtract(Duration(days: 6)).year.toString() + '-' + zeroToTen(today.subtract(Duration(days: 6)).month.toString()) + '-' + zeroToTen(today.subtract(Duration(days: 6)).day.toString()) + ' 00:00:00'))
    //     .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + zeroToTen(today.day.toString()) + ' 23:59:59'))
    //     .orderBy('date', descending: true);

    debugPrint('date checkkki ' + DateTime(today.year, today.month + 1, 0).toString());

    return FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders')
        .where('date', isLessThan: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + (DateTime(today.year, today.month + 1, 0).day).toString() + ' 23:59:59'))
        .where('date', isGreaterThan: DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-00' + ' 23:59:59'))
        .orderBy('date', descending: true);
  }

  String valKTog = '0';

  valueKeyTog() {
    valKTog = today.year.toString() + zeroToTen(today.month.toString()) + zeroToTen(today.day.toString());
    return ValueKey<String>(valKTog.toString());
    // if(valKTog == 0) {
    //   valKTog = 1;
    //   return ValueKey<String>(valKTog.toString());
    // } else {
    //   valKTog = 0;
    //   return ValueKey<String>(valKTog.toString());
    // }

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

// debugPrint(item.split('^')[0].substring(0,8));
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
// debugPrint('array removed');
//
// FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId)
//
//     .update({
// 'daily_order': FieldValue.arrayUnion([item.split('^')[0]+'^'+item.split('^')[1]+'^total^name^fp'])
// })
//     .then((value) {
// debugPrint('array updated');
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
// //   debugPrint('array updated');
// // });
// // 2021081601575511001^1-1001^total^name^pf
//
// });
// });
// });
