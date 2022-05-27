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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/bloc_customers.dart';
import 'package:smartkyat_pos/fragments/subs/customer_info.dart';
import 'package:smartkyat_pos/fragments/subs/language_settings.dart';
import 'package:smartkyat_pos/fragments/subs/merchant_info.dart';
import 'package:smartkyat_pos/widgets/add_new_merchant.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
import 'package:smartkyat_pos/fragments/orders_fragment.dart';
import 'package:smartkyat_pos/fragments/subs/buy_list_info.dart';
import 'package:smartkyat_pos/fragments/subs/order_info.dart';
import 'package:smartkyat_pos/widgets/product_details_view2.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import '../app_theme.dart';

class MerchantsFragment extends StatefulWidget {
  final _callback3;
  final _callback;
  final _callback2;
  final _callback4;
  final _barcodeBtn;
  final _searchBtn;
  final addMerch;
  final _closeDrawerBtn;
  final _openDrawerBtn;
  final _closeCartBtn;
  final _openCartBtn;
  final _printFromOrders;

  MerchantsFragment( {this.selectedDev, required void printFromOrders(File file, var prodListPR),required void closeCartBtn(String str), required void openCartBtn(String str), required void closeDrawerBtn(String str), required void openDrawerBtn(String str),required void toggleCoinCallback6(), required void searchBtn(), required this.merchantsSnapshot, required this.shopId, required void barcodeBtn(), required void toggleCoinCallback3(String str), required void toggleCoinCallback(String str),required void toggleCoinCallback2(String str),required void toggleCoinCallback4(String str), Key? key,} ) :
        _printFromOrders = printFromOrders, _openDrawerBtn = openDrawerBtn, _closeDrawerBtn = closeDrawerBtn, addMerch = toggleCoinCallback6 ,_searchBtn = searchBtn, _barcodeBtn = barcodeBtn, _callback3 = toggleCoinCallback3, _callback = toggleCoinCallback, _callback2 = toggleCoinCallback2,_callback4 = toggleCoinCallback4, _closeCartBtn = closeCartBtn, _openCartBtn = openCartBtn,super(key: key);
  final String shopId;
  final merchantsSnapshot;
  final BlueDevice? selectedDev;

  @override
  MerchantsFragmentState createState() => MerchantsFragmentState();
}


class MerchantsFragmentState extends State<MerchantsFragment> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<MerchantsFragment>{

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

  List<List> orderList = [];
  var orders;
  var docId;
  var innerId;

  String textSetNewMerch = 'Merchant';
  String textSetAll = 'All';
  String textSetDebts = 'Debts';
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

  void closeCartFrom() {
    widget._closeCartBtn('merchants');
  }

  void openCartFrom() {
    widget._openCartBtn('merchants');
  }

  void closeDrawerFrom() {
    widget._closeDrawerBtn('merchants');
  }

  void openDrawerFrom() {
    widget._openDrawerBtn('merchants');
  }

  var prodsSnap;

  bool i0Clicked = true;
  bool i1Clicked = true;

  bool endOfResult = false;

  ScrollController _scrollController = ScrollController();
  int itemPerPage = 10;


  @override
  initState() {
    prodsSnap =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('merArr').snapshots();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels && !endOfResult) {
        print('maxxed ');
        Future.delayed(const Duration(milliseconds: 500), () {
          itemPerPage = itemPerPage + 10;
          setState(() {});
        });

      }
    });

    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetNewMerch = 'ကုန်သည်';
          textSetAll = 'အားလုံး';
          textSetDebts = 'မရှင်းသေး';
          textSetSearch = 'ရှာဖွေရန်';
        });
      }
      else if(value=='english') {
        setState(() {
          textSetNewMerch = 'Merchant';
          textSetAll = 'All';
          textSetDebts = 'Unpaids';
          textSetSearch = 'Search';
        });
      }
    });
    super.initState();
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
      loadingSearch = false;
    });
  }
  void unfocusSearch() {
    print('clicked testing 2');
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
      ..sort((k1, k2) => ((map[k1]['de'].compareTo(map[k2]['de']))));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }
  Map sortMapByImR(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => ((map[k2]['de'].compareTo(map[k1]['de']))));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }


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
                      child:  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: prodsSnap,
                          builder: (BuildContext context, prodsSB) {
                            var prods;
                            Map<dynamic, dynamic> resProds = {};

                            if(prodsSB.hasData) {
                              var prodsSnapOut = prodsSB.data != null? prodsSB.data!.data(): null;
                              prods = prodsSnapOut?['mer'];
                              if(itemPerPage >= prods.length) {
                                endOfResult = true;
                              }
                              if(cateScIndex == 0) {
                                if(i0Clicked) {
                                  prods = sortMapByNaS(prods);
                                } else {
                                  prods = sortMapByNaR(prods);
                                }
                              } else if(cateScIndex == 1) {
                                if(i1Clicked) {
                                  prods = sortMapByImS(prods);
                                } else {
                                  prods = sortMapByImR(prods);
                                }
                              }

                              if(prods != null && prods.length > 0) {
                                print('llll ' + prods.length.toString() + ' ' + itemPerPage.toString());
                                for(int i = 0; i < itemPerPage; i++) {
                                  if (i >= prods.length) {
                                    break;
                                  }

                                var eachMap = prods.entries.elementAt(i);
                                if(eachMap.value['na'] == null) {
                                  print('prods entri ' + eachMap.toString());
                                  List<dynamic> deleteExpenseData = [];
                                  deleteExpenseData.add(eachMap);

                                  FirebaseFirestore.instance
                                      .collection('shops')
                                      .doc(widget.shopId)
                                      .collection('collArr')
                                      .doc('merArr')
                                      .update(
                                    {
                                      'mer.' + eachMap.key.toString(): FieldValue.delete()
                                    },
                                  );

                                  print('prods entri');
                                }
                                else {
                                  resProds[eachMap.key] = eachMap.value;
                                }
                              }

                              if(cateScIndex == 0) {
                                if(i0Clicked) {
                                  resProds = sortMapByNaS(resProds);
                                } else {
                                  resProds = sortMapByNaR(resProds);
                                }
                              } else if(cateScIndex == 1) {
                                if(i1Clicked) {
                                  resProds = sortMapByImS(resProds);
                                } else {
                                  resProds = sortMapByImR(resProds);
                                }
                              } }
                              return CustomScrollView(
                                controller: _scrollController,
                                slivers: [
                                  SliverAppBar(
                                    elevation: 0,
                                    backgroundColor: Colors.white,
                                    // Provide a standard title.
                                    // Allows the user to reveal the app bar if they begin scrolling
                                    // back up the list of items.
                                    floating: true,
                                    flexibleSpace: Padding(
                                      padding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
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
                                                  onPressed: () async {
                                                    widget.addMerch();
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      // mainAxisAlignment: Main,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 6.0),
                                                          child: Icon(
                                                            SmartKyat_POS.add_plus,
                                                            size: 17,
                                                          ),
                                                        ),
                                                        Text(
                                                          textSetNewMerch,
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
                                                          if(cateScIndex != 0) {
                                                            i0Clicked = true;
                                                          } else {
                                                            if(i0Clicked) {
                                                              i0Clicked = false;
                                                            } else {
                                                              i0Clicked = true;
                                                            }
                                                          }

                                                          cateScIndex = 0;
                                                          itemPerPage = 10;
                                                          endOfResult = false;
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
                                                          if(cateScIndex != 1) {
                                                            i1Clicked = true;
                                                          } else {
                                                            if(i1Clicked) {
                                                              i1Clicked = false;
                                                            } else {
                                                              i1Clicked = true;
                                                            }
                                                          }

                                                          cateScIndex = 1;
                                                          itemPerPage = 10;
                                                          endOfResult = false;
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Text(
                                                          textSetDebts,
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
                                  SliverToBoxAdapter(
                                      child: StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('merchants').doc('name').snapshots(), //returns a Stream<DocumentSnapshot>
                                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                            if (!snapshot.hasData) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  closeDrawerFrom();
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (
                                                            context) =>
                                                            MerchantInfoSubs(
                                                              id: 'name', mercName: 'No merchant', mercAddress: 'Default buy orders',
                                                              toggleCoinCallback: addMerchant2Cart, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                                                  );
                                                  openDrawerFrom();
                                                },
                                                child: Container(
                                                  // color: Colors.yellow,
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsets.only(left: 15.0, top: 0.0),
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                      0.3),
                                                                  width: 1.0)
                                                          )),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .only(
                                                                bottom: 6.0),
                                                            child: ListTile(
                                                              contentPadding: const EdgeInsets
                                                                  .only(
                                                                  left: 0.0, right: 15) ,
                                                              title: Text(
                                                                'No merchant',
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                    height: 1.1,
                                                                    overflow: TextOverflow.ellipsis
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
                                                                      'Default buy orders',
                                                                      style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color: Colors
                                                                              .grey,
                                                                          height: 1.1,
                                                                          overflow: TextOverflow.ellipsis
                                                                      ),
                                                                      maxLines: 1,
                                                                      strutStyle: StrutStyle(
                                                                        height: 1.2,
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
                                                                    SizedBox(
                                                                        width: 12),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 2.0),
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

                                                            ),
                                                          )

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            var userDocument = snapshot.data;
                                            return GestureDetector(
                                              onTap: () async {
                                                closeDrawerFrom();
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (
                                                          context) =>
                                                          MerchantInfoSubs(
                                                            id: 'name', mercName: 'No merchant', mercAddress: 'Default buy orders',
                                                            toggleCoinCallback: addMerchant2Cart, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                                                );
                                                openDrawerFrom();
                                              },
                                              child: Container(
                                                // color: Colors.yellow,
                                                child: Padding(
                                                  padding:
                                                  EdgeInsets.only(left: 15.0, top: 0.0),
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                    0.3),
                                                                width: 1.0)
                                                        )),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              bottom: 6.0),
                                                          child: ListTile(
                                                            contentPadding: const EdgeInsets
                                                                .only(
                                                                left: 0.0, right: 15) ,
                                                            title: Text(
                                                              'No merchant',
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                                  height: 1.1,
                                                                  overflow: TextOverflow.ellipsis
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
                                                                    'Default buy orders',
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        color: Colors
                                                                            .grey,
                                                                        height: 1.1,
                                                                        overflow: TextOverflow.ellipsis
                                                                    ),
                                                                    maxLines: 1,
                                                                    strutStyle: StrutStyle(
                                                                      height: 1.2,
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
                                                                  userDocument!['debts'] > 0? Container(
                                                                    height: 21,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                      color: AppTheme.badgeFgDanger,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                                                      child: Text(userDocument['debts'].round().toString() + ' unpaid',
                                                                        style: TextStyle(
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: Colors.white
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ): Container(height: 21,),
                                                                  SizedBox(
                                                                      width: 12),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 2.0),
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

                                                          ),
                                                        )

                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                      )
                                  ),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                        var prodMap = resProds.entries.elementAt(index);
                                        print('Prod map ' + prodMap.key.toString());
                                        var prodVal = prodMap.value;
                                        var prodKey = prodMap.key;
                                        return  GestureDetector(
                                          onTap: () async {
                                            closeDrawerFrom();
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (
                                                      context) =>
                                                      MerchantInfoSubs(
                                                        id: prodKey.toString(), mercName: prodVal['na'], mercAddress:  prodVal['ad'],
                                                        toggleCoinCallback: addMerchant2Cart, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                                            );
                                            openDrawerFrom();
                                          },
                                          child: Padding(
                                            padding:
                                            EdgeInsets.only(left: 15.0,
                                                top: 15.0),
                                            child: Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: index == resProds.length-1 ?
                                                      BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.0)
                                                          :

                                                      BorderSide(
                                                          color: Colors
                                                              .grey
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
                                                        prodVal['na'].toString(),
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                            height: 1.1,
                                                            overflow: TextOverflow.ellipsis
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
                                                              prodVal['ad'],
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight
                                                                      .w500,
                                                                  color: Colors
                                                                      .grey,
                                                                  height: 1.1,
                                                                  overflow: TextOverflow.ellipsis
                                                              ),
                                                              maxLines: 1,
                                                              strutStyle: StrutStyle(
                                                                height: 1.2,
                                                                // fontSize:,
                                                                forceStrutHeight: true,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,),
                                                            Text(
                                                              prodVal['ph'].toString(),
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight
                                                                      .w500,
                                                                  color: Colors
                                                                      .grey,
                                                                  height: 1.1,
                                                                  overflow: TextOverflow.ellipsis
                                                              ),
                                                              maxLines: 1,
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
                                                            prodVal['de'] > 0? Container(
                                                              height: 21,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(20.0),
                                                                color: AppTheme.badgeFgDanger,
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                                                child: Text(prodVal['de'].round().toString() + ' unpaid',
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.white
                                                                  ),
                                                                ),
                                                              ),
                                                            ): Container(height: 21,),

                                                            SizedBox(
                                                                width: 12),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 2.0),
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
                                                      contentPadding: const EdgeInsets
                                                          .only(
                                                          left: 0.0, right: 15) ,
                                                    ),
                                                  )

                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      childCount: resProds == null? 0: resProds.length,
                                    ),
                                  ),
                                  SliverAppBar(
                                    toolbarHeight: 30,
                                    elevation: 0,
                                    backgroundColor: Colors.white,
                                    // Provide a standard title.
                                    // Allows the user to reveal the app bar if they begin scrolling
                                    // back up the list of items.
                                    floating: true,
                                    flexibleSpace: !endOfResult?
                                    Container(
                                      child: LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
                                    ):
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            child: Text(
                                              resProds.length == 0? '': 'End of results',
                                              strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),)
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );

                            }

                            return Container();





                          }
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
                                        textSetSearch,
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
