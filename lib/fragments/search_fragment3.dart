import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:blue_print_pos/models/blue_device.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firestore_cache/firestore_cache.dart';
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
import 'package:smartkyat_pos/widgets/product_details_view2.dart';
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

  var prodsArrSnaps;

  List<QueryDocumentSnapshot<Object?>> workCacheProds = [];

  var workSerProds = [];

  int intGer = 0;

  var productsSnapshot;
  var prodsImgSnap;

  var customersSnapshot;
  var merchantsSnapshot;

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

  var prodDocs = [];

  @override
  initState() {
    productsSnapshot = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr').snapshots();
    prodsImgSnap =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('imgArr').doc('prodsArr').snapshots();

    customersSnapshot =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('cusArr').snapshots();
    merchantsSnapshot =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('merArr').snapshots();




    print('initializing ');
    FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('cacheArr').doc('prodsArr')
        .get().then((value) async {
      var array = value.data()!['array'];
      List<String> needToFetchs = [];

      // FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products')
      //     .where('archive', isEqualTo: false)
      // // .limit(20)
      //     .get(GetOptions(source: Source.cache))
      // // .get()
      //     .then((QuerySnapshot querySnapshot)  async {
      //   prodDocs = querySnapshot.docs;
      //   workCacheProds = querySnapshot.docs;
      //
      //
      //
      //   querySnapshot.docs.forEach((doc) {
      //     DocumentSnapshot doc2 = doc;
      //     print('cache data s ' + doc['prod_name']);
      //
      //     // Stream<DocumentSnapshot<Map<String, dynamic>>> docSnap =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(doc.id).snapshots();
      //     // // docSnap.
      //     //
      //     // // Stream<QuerySnapshot>? emailSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('users').where('email', isEqualTo: auth.currentUser!.email.toString()).limit(1).snapshots();
      //     // // emailSnapshot.sn;
      //     //
      //     // // CollectionReference reference = FirebaseFirestore.instance.collection('planets');
      //     // docSnap.listen((querySnapshot) {
      //     //   print('query snap changes ' + querySnapshot.toString());
      //     //   // querySnapshot..forEach((change) {
      //     //   //   // Do something with change
      //     //   // });
      //     // });
      //
      //     CollectionReference prodsFetchServer = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_monthly');
      //
      //     if(!array.contains(doc.id)) {
      //       print('cache data s not equaling');
      //       // var docSnapNeed = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products')
      //       //     .doc(doc.id)
      //       //     .get();
      //       FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products')
      //           .doc(doc.id)
      //           .get()
      //           .then((value) {
      //         workSerProds.add(value);
      //       });
      //
      //     }
      //   });
      //
      // });

    });

    // FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products')
    //     .orderBy('update_time')
    //     .where('archive', isEqualTo: false)
    //     .get(GetOptions(source: Source.cache))
    //     .then((QuerySnapshot querySnapshot)  async {
    //   prodDocs = querySnapshot.docs;
    //   print('cache sd data ' + querySnapshot.docs.length.toString() + ' ---> ' + querySnapshot.metadata.isFromCache.toString());
    //   querySnapshot.docs.forEach((doc) {
    //     print('cache s data doc ' + doc['inStock1'].toString() + doc['prod_name'].toString());
    //   });
    //
    //   print('gg moda ' + querySnapshot.docs.last['update_time'].toString());
    //
    //   if(querySnapshot.docs.length == 0) {
    //     FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products')
    //         .orderBy('update_time')
    //         .where('archive', isEqualTo: false)
    //         .get()
    //         .then((QuerySnapshot querySnapshotS)  async {
    //       prodDocs += querySnapshotS.docs;
    //     });
    //   } else {
    //     FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products')
    //         .orderBy('update_time')
    //         .where('archive', isEqualTo: false)
    //     // .startAfter([querySnapshot.docs.last['update_time']])
    //         .startAfterDocument(querySnapshot.docs.last)
    //         .get()
    //         .then((QuerySnapshot querySnapshotS)  async {
    //       prodDocs += querySnapshotS.docs;
    //       print('server sd data ' + querySnapshotS.docs.length.toString() + ' ---> ' + querySnapshotS.metadata.isFromCache.toString());
    //       querySnapshotS.docs.forEach((doc) {
    //         print('server s data doc ' + doc['inStock1'].toString() + doc['prod_name'].toString());
    //       });
    //     });
    //   }
    // });
    //
    // print('final sd data ' + prodDocs.length.toString());
    // int i = 0;
    // prodDocs.forEach((doc) {
    //   i = i + 1;
    //   print('final s data doc ' + i.toString() + ' --> ' + doc['inStock1'].toString() + ' ' + doc['prod_name'].toString() + ' ' + doc.metadata.isFromCache.toString());
    // });











    // _futureSnapshot = _getDocs();
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
      setState(() {

      });
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

  Map sortMapByNaS(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => ((map[k1]['na'].compareTo(map[k2]['na']))));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
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
                // child: CustomScrollView(
                //   slivers: [
                //     SliverAppBar(
                //       elevation: 0,
                //       backgroundColor: Colors.white,
                //       // Provide a standard title.
                //       // Allows the user to reveal the app bar if they begin scrolling
                //       // back up the list of items.
                //       floating: true,
                //       flexibleSpace: Padding(
                //         padding: const EdgeInsets.only(left: 0.0, top: 12.0, bottom: 12.0),
                //         child: Container(
                //           height: 32,
                //           width: MediaQuery.of(context).size.width,
                //           // color: Colors.yellow,
                //           child: Row(
                //             children: [
                //               Expanded(
                //                 child: ListView(
                //                   controller: cateScCtler,
                //                   scrollDirection: Axis.horizontal,
                //                   children: [
                //                     SizedBox(
                //                       width: 11,
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                //                       child: FlatButton(
                //                         minWidth: 0,
                //                         padding: EdgeInsets.only(left: 12, right: 12),
                //                         color: cateScIndex == 0 ? AppTheme.secButtonColor:Colors.white,
                //                         shape: RoundedRectangleBorder(
                //                           borderRadius: BorderRadius.circular(20.0),
                //                           side: BorderSide(
                //                             color: AppTheme.skBorderColor2,
                //                           ),
                //                         ),
                //                         onPressed: () {
                //                           // _animateToIndex(0);
                //                           selectedIntVal(0);
                //                         },
                //                         child: Container(
                //                           child: Text(
                //                             'Products',
                //                             textAlign: TextAlign.center,
                //                             style: TextStyle(
                //                                 fontSize: 14,
                //                                 fontWeight: FontWeight.w500,
                //                                 color: Colors.black),
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                //                       child: FlatButton(
                //                         minWidth: 0,
                //                         padding: EdgeInsets.only(left: 12, right: 12),
                //                         color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
                //                         shape: RoundedRectangleBorder(
                //                           borderRadius: BorderRadius.circular(20.0),
                //                           side: BorderSide(
                //                             color: AppTheme.skBorderColor2,
                //                           ),
                //                         ),
                //                         onPressed: () {
                //                           // _animateToIndex(20);
                //                           selectedIntVal(1);
                //                         },
                //                         child: Container(
                //                           child: Text(
                //                             'Customers',
                //                             textAlign: TextAlign.center,
                //                             style: TextStyle(
                //                                 fontSize: 14,
                //                                 fontWeight: FontWeight.w500,
                //                                 color: Colors.black),
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                //                       child: FlatButton(
                //                         minWidth: 0,
                //                         padding: EdgeInsets.only(left: 12, right: 12),
                //                         color: cateScIndex == 2 ? AppTheme.secButtonColor:Colors.white,
                //                         shape: RoundedRectangleBorder(
                //                           borderRadius: BorderRadius.circular(20.0),
                //                           side: BorderSide(
                //                             color: AppTheme.skBorderColor2,
                //                           ),
                //                         ),
                //                         onPressed: () {
                //                           // _animateToIndex(2);
                //                           selectedIntVal(2);
                //                         },
                //                         child: Container(
                //                           child: Text(
                //                             'Merchants',
                //                             textAlign: TextAlign.center,
                //                             style: TextStyle(
                //                                 fontSize: 14,
                //                                 fontWeight: FontWeight.w500,
                //                                 color: Colors.black),
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                //                       child: FlatButton(
                //                         minWidth: 0,
                //                         padding: EdgeInsets.only(left: 12, right: 12),
                //                         color: cateScIndex == 3 ? AppTheme.secButtonColor:Colors.white,
                //                         shape: RoundedRectangleBorder(
                //                           borderRadius: BorderRadius.circular(20.0),
                //                           side: BorderSide(
                //                             color: AppTheme.skBorderColor2,
                //                           ),
                //                         ),
                //                         onPressed: () {
                //                           // _animateToIndex(0);
                //                           selectedIntVal(3);
                //                         },
                //                         child: Container(
                //                           child: Text(
                //                             'Sale orders',
                //                             textAlign: TextAlign.center,
                //                             style: TextStyle(
                //                                 fontSize: 14,
                //                                 fontWeight: FontWeight.w500,
                //                                 color: Colors.black),
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                //                       child: FlatButton(
                //                         minWidth: 0,
                //                         padding: EdgeInsets.only(left: 12, right: 12),
                //                         color: cateScIndex == 4 ? AppTheme.secButtonColor:Colors.white,
                //                         shape: RoundedRectangleBorder(
                //                           borderRadius: BorderRadius.circular(20.0),
                //                           side: BorderSide(
                //                             color: AppTheme.skBorderColor2,
                //                           ),
                //                         ),
                //                         onPressed: () {
                //                           // _animateToIndex(0);
                //                           selectedIntVal(4);
                //                         },
                //                         child: Container(
                //                           child: Text(
                //                             'Buy orders',
                //                             textAlign: TextAlign.center,
                //                             style: TextStyle(
                //                                 fontSize: 14,
                //                                 fontWeight: FontWeight.w500,
                //                                 color: Colors.black),
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                     SizedBox(
                //                       width: 11,
                //                     ),
                //                   ],
                //                 ),
                //               )
                //             ],
                //           ),
                //
                //         ),
                //       ),),
                //     SliverList(
                //       delegate: SliverChildBuilderDelegate(
                //             (context, index) {
                //           return GestureDetector(
                //             onTap: () async {
                //             },
                //             child: Padding(
                //               padding:
                //               EdgeInsets.only(top: index == 0? 0.0: 6.0, left: 15),
                //               child: Container(
                //                 width: MediaQuery.of(context).size.width,
                //                 decoration: BoxDecoration(
                //                     border: Border(
                //                         bottom:
                //                         BorderSide(
                //                             color: AppTheme.skBorderColor2,
                //                             width: 0.5)
                //                     )),
                //                 child: Padding(
                //                   padding: const EdgeInsets.only(right: 15.0),
                //                   child: Column(
                //                     children: [
                //                       Row(
                //                         children: [
                //                           Column(
                //                             children: [
                //                               Padding(
                //                                 padding: const EdgeInsets.only(top: 8.0),
                //                                 child: ClipRRect(
                //                                     borderRadius:
                //                                     BorderRadius
                //                                         .circular(
                //                                         5.0),
                //                                     child: Image.asset('assets/system/default-product.png', height: 75, width: 75, fit: BoxFit.cover,)),
                //                               ),
                //                             ],
                //                           ),
                //                           SizedBox(
                //                             width: 15,
                //                           ),
                //                           Expanded(
                //                             child: Column(
                //                               crossAxisAlignment:
                //                               CrossAxisAlignment
                //                                   .start,
                //                               mainAxisAlignment: MainAxisAlignment.start,
                //                               children: [
                //                                 SizedBox(
                //                                   height: 0,
                //                                 ),
                //                                 Container(
                //                                   // color: Colors.yellow,
                //                                   child: Text(
                //                                     'dasf',
                //                                     style: TextStyle(
                //                                         fontSize: 18,
                //                                         fontWeight:
                //                                         FontWeight.w500,
                //                                         overflow: TextOverflow.ellipsis
                //                                     ),
                //                                     strutStyle: StrutStyle(
                //                                       height: 2.2,
                //                                       // fontSize:,
                //                                       forceStrutHeight: true,
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 SizedBox(
                //                                   height: 8,
                //                                 ),
                //                                 Row(
                //                                   children: [
                //                                     Flexible(
                //                                       child: Text(
                //                                         '$currencyUnit ',
                //                                         style: TextStyle(
                //                                             height: 1.3,
                //                                             fontSize: 15,
                //                                             fontWeight:
                //                                             FontWeight.w500,
                //                                             overflow: TextOverflow.ellipsis
                //                                         ),
                //                                       ),
                //                                     ),
                //                                     Text(
                //                                       'lafsjfel jaljfli jalejf liajelfjeajl jfliaj jfelsaijf lajl jf',
                //                                       style: TextStyle(
                //                                           height: 1.3,
                //                                           fontSize: 15,
                //                                           fontWeight:
                //                                           FontWeight.w500,
                //                                           overflow: TextOverflow.ellipsis
                //                                       ),
                //                                     ),
                //                                   ],
                //                                 ),
                //                                 SizedBox(
                //                                   height: 2,
                //                                 ),
                //                                 Row(
                //                                   crossAxisAlignment: CrossAxisAlignment.start,
                //                                   mainAxisAlignment: MainAxisAlignment.start,
                //                                   children: [
                //                                     Padding(
                //                                       padding: const EdgeInsets.only(top: 2.0),
                //                                       child: Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
                //                                     ),
                //                                     Flexible(
                //                                       child: Text(
                //                                           ' sldfja ',
                //                                           textScaleFactor: 1.0,
                //                                           style: TextStyle(
                //                                               height: 1.3,
                //                                               fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                //                                               overflow: TextOverflow.ellipsis
                //                                           )),
                //                                     ),
                //                                   ],
                //                                 ),
                //                               ],
                //                             ),
                //                           ),
                //                           Padding(
                //                             padding:
                //                             const EdgeInsets.only(
                //                                 bottom: 6.0),
                //                             child: Icon(
                //                               Icons
                //                                   .arrow_forward_ios_rounded,
                //                               size: 16,
                //                               color: Colors.blueGrey
                //                                   .withOpacity(0.8),
                //                             ),),
                //                         ],
                //                       ),
                //                       SizedBox(height: 15),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           );
                //           // var prodMap = searchProds.entries.elementAt(index);
                //           // print('Prod map ' + prodMap.key.toString());
                //           // var prodVal = prodMap.value;
                //           // var prodKey = prodMap.key;
                //           // return GestureDetector(
                //           //   onTap: () async {
                //           //     closeDrawerFrom();
                //           //     await Navigator.of(context).push(
                //           //       MaterialPageRoute(
                //           //           builder: (context) => ProductDetailsView2(idString: prodKey.toString(), prodName: prodVal['na'], mainSell: prodVal['sm'].toString(), toggleCoinCallback: addProduct1, toggleCoinCallback3: addProduct3, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom,)),);
                //           //     openDrawerFrom();
                //           //   },
                //           //   child: Padding(
                //           //     padding:
                //           //     EdgeInsets.only(top: index == 0? 0.0: 6.0, left: 15),
                //           //     child: Container(
                //           //       width: MediaQuery.of(context).size.width,
                //           //       decoration: BoxDecoration(
                //           //           border: Border(
                //           //               bottom: index == searchProds.length-1 ?
                //           //               BorderSide(
                //           //                   color: Colors.transparent,
                //           //                   width: 1.0) :
                //           //
                //           //               BorderSide(
                //           //                   color: AppTheme.skBorderColor2,
                //           //                   width: 0.5)
                //           //           )),
                //           //       child: Padding(
                //           //         padding: const EdgeInsets.only(right: 15.0),
                //           //         child: Column(
                //           //           children: [
                //           //             Row(
                //           //               children: [
                //           //                 Column(
                //           //                   children: [
                //           //                     Padding(
                //           //                       padding: const EdgeInsets.only(top: 8.0),
                //           //                       child: ClipRRect(
                //           //                           borderRadius:
                //           //                           BorderRadius
                //           //                               .circular(
                //           //                               5.0),
                //           //                           child: Image.asset('assets/system/default-product.png', height: 75, width: 75, fit: BoxFit.cover,)),
                //           //                     ),
                //           //                   ],
                //           //                 ),
                //           //                 SizedBox(
                //           //                   width: 15,
                //           //                 ),
                //           //                 Expanded(
                //           //                   child: Column(
                //           //                     crossAxisAlignment:
                //           //                     CrossAxisAlignment
                //           //                         .start,
                //           //                     mainAxisAlignment: MainAxisAlignment.start,
                //           //                     children: [
                //           //                       SizedBox(
                //           //                         height: 0,
                //           //                       ),
                //           //                       Container(
                //           //                         // color: Colors.yellow,
                //           //                         child: Text(
                //           //                           prodVal['na'],
                //           //                           style: TextStyle(
                //           //                               fontSize: 18,
                //           //                               fontWeight:
                //           //                               FontWeight.w500,
                //           //                               overflow: TextOverflow.ellipsis
                //           //                           ),
                //           //                           strutStyle: StrutStyle(
                //           //                             height: 2.2,
                //           //                             // fontSize:,
                //           //                             forceStrutHeight: true,
                //           //                           ),
                //           //                         ),
                //           //                       ),
                //           //                       SizedBox(
                //           //                         height: 8,
                //           //                       ),
                //           //                       Row(
                //           //                         children: [
                //           //                           Flexible(
                //           //                             child: Text(
                //           //                               '$currencyUnit ' + prodVal['sm'].toString(),
                //           //                               style: TextStyle(
                //           //                                   height: 1.3,
                //           //                                   fontSize: 15,
                //           //                                   fontWeight:
                //           //                                   FontWeight.w500,
                //           //                                   overflow: TextOverflow.ellipsis
                //           //                               ),
                //           //                             ),
                //           //                           ),
                //           //                           Text(
                //           //                             // 'lafsjfel jaljfli jalejf liajelfjeajl jfliaj jfelsaijf lajl jf',
                //           //                             prodVal['n1'] != '' && prodVal['n2'] == '' ? ' - ' + prodVal['s1'] : prodVal['n1'] != '' && prodVal['n2'] != '' ? ' - ' + prodVal['s2'].toString() : '',
                //           //                             style: TextStyle(
                //           //                                 height: 1.3,
                //           //                                 fontSize: 15,
                //           //                                 fontWeight:
                //           //                                 FontWeight.w500,
                //           //                                 overflow: TextOverflow.ellipsis
                //           //                             ),
                //           //                           ),
                //           //                         ],
                //           //                       ),
                //           //                       SizedBox(
                //           //                         height: 2,
                //           //                       ),
                //           //                       Row(
                //           //                         crossAxisAlignment: CrossAxisAlignment.start,
                //           //                         mainAxisAlignment: MainAxisAlignment.start,
                //           //                         children: [
                //           //                           Padding(
                //           //                             padding: const EdgeInsets.only(top: 2.0),
                //           //                             child: Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
                //           //                           ),
                //           //                           Flexible(
                //           //                             child: Text(
                //           //                                 ' ' + prodVal['im'].round().toString() + ' '  + prodVal['nm'] + ' ',
                //           //                                 textScaleFactor: 1.0,
                //           //                                 style: TextStyle(
                //           //                                     height: 1.3,
                //           //                                     fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                //           //                                     overflow: TextOverflow.ellipsis
                //           //                                 )),
                //           //                           ),
                //           //                           prodVal['n1'] != '' && prodVal['n2'] == ''?
                //           //                           Text(
                //           //                               '(+1 Sub item)',
                //           //                               textScaleFactor: 1.0,
                //           //                               style: TextStyle(
                //           //                                   height: 1.3,
                //           //                                   fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                //           //                                   overflow: TextOverflow.ellipsis
                //           //                               )) : prodVal['n1'] != '' && prodVal['n2'] != '' ?
                //           //                           Text(
                //           //                               '(+2 Sub items)',
                //           //                               textScaleFactor: 1.0,
                //           //                               style: TextStyle(
                //           //                                   height: 1.3,
                //           //                                   fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                //           //                                   overflow: TextOverflow.ellipsis
                //           //                               )): Container(),
                //           //                         ],
                //           //                       ),
                //           //                     ],
                //           //                   ),
                //           //                 ),
                //           //                 Padding(
                //           //                   padding:
                //           //                   const EdgeInsets.only(
                //           //                       bottom: 6.0),
                //           //                   child: Icon(
                //           //                     Icons
                //           //                         .arrow_forward_ios_rounded,
                //           //                     size: 16,
                //           //                     color: Colors.blueGrey
                //           //                         .withOpacity(0.8),
                //           //                   ),),
                //           //               ],
                //           //             ),
                //           //             SizedBox(height: 15),
                //           //           ],
                //           //         ),
                //           //       ),
                //           //     ),
                //           //   ),
                //           // );
                //         },
                //         // childCount: searchProds == null? 0: searchProds.length,
                //         childCount: 1,
                //       ),
                //     )
                //   ],
                // ),
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
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
                                          // _animateToIndex(0);
                                          selectedIntVal(0);
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
                                          // _animateToIndex(20);
                                          selectedIntVal(1);


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
                                          selectedIntVal(2);
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
                                          selectedIntVal(3);
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
                                          selectedIntVal(4);
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
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),

                        ),
                      ),),
                    sliverBodyWidget(),
                  ],
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

  final _firestore = FirebaseFirestore.instance;
  late Future<QuerySnapshot<Map<String, dynamic>>> _futureSnapshot;

  Widget _buildDocs() {
    return FutureBuilder<QuerySnapshot>(
      future: _futureSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          final docs = snapshot.data?.docs;
          return Expanded(
            child: ListView(
              children: docs!.map((DocumentSnapshot doc) {
                final data = doc.data() as Map?;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    '${data!['postId']} isFromCache: ${doc.metadata.isFromCache}',
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            ),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }

  // Future<QuerySnapshot<Map<String, dynamic>>> _getDocs() async {
  //   const cacheField = 'updatedAt';
  //   final cacheDocRef = _firestore.collection('shops').doc(widget.shopId).collection('status').doc('/status');
  //   final query = _firestore.collection('shops').doc(widget.shopId).collection('products').limit(10);
  //   final snapshot = await FirestoreCache.getDocuments(
  //     query: query,
  //     cacheDocRef: cacheDocRef,
  //     firestoreCacheField: cacheField,
  //   );
  //
  //   return snapshot;
  // }

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

  bool firstTime = true;
  double homeBotPadding = 0;

  @override
  Widget build(BuildContext context) {
    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
      firstTime = false;
    }
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
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: homeBotPadding),
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
                                          if(searchValue == '') {
                                            widget._barcodeBtn();
                                          } else {
                                            _searchController.clear();
                                          }
                                        },
                                        child: Stack(
                                          children: [
                                            searchValue == '' ? Padding(
                                              padding: const EdgeInsets.only(
                                                right: 15.0,
                                              ),
                                              child: Container(
                                                  child: Image.asset('assets/system/barcode.png', height: 28,)
                                              ),
                                            ) : Padding(
                                              padding: const EdgeInsets.only( right: 15.0),
                                              child: Icon(
                                                Icons.close_rounded,
                                                size: 24,
                                              ),),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget._chgIndex(0);
                                  FocusScope.of(context).unfocus();
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
                                          ):
                                          Padding(
                                              padding: const EdgeInsets.only(left: 2, bottom: 1.5, right: 3),
                                              child: Icon(
                                                Icons.arrow_back_ios_rounded,
                                                size: 21,
                                              )
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     if((loadingSearch && _searchController.text == '' ) || !loadingSearch) {
                              //       widget._chgIndex(0);
                              //       FocusScope.of(context).unfocus();
                              //     } else {
                              //       _searchController.clear();
                              //     }
                              //   },
                              //   child: Container(
                              //     height: 50,
                              //     width: 38,
                              //     color: Colors.transparent,
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(left: 12.0),
                              //       child: Container(
                              //         child: Stack(
                              //           alignment: AlignmentDirectional.centerStart,
                              //           children: [
                              //             !loadingSearch? Padding(
                              //               padding: const EdgeInsets.only(left: 5.0),
                              //               child: Icon(
                              //                 SmartKyat_POS.search,
                              //                 size: 17,
                              //               ),
                              //             ): loadingSearch && _searchController.text == '' ?
                              //             Padding(
                              //                 padding: const EdgeInsets.only(left: 2, bottom: 1.5, right: 3),
                              //                 child: Icon(
                              //                   Icons.arrow_back_ios_rounded,
                              //                   size: 21,
                              //                 )
                              //             ) : Padding(
                              //               padding: const EdgeInsets.only(left: 2, bottom: 1.0),
                              //               child: Icon(
                              //                 Icons.close_rounded,
                              //                 size: 24,
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
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

  void selectedIntVal(int i) {
    setState(() {
      cateScIndex = i;
    });
  }

  List<String> prodResults = [];

  void searchKeyChanged() {
    print('search chainging ' + searchValue);
    prodResults = [];
    int i = 0;
    workCacheProds.forEach((element) {
      if(i == workCacheProds.length-1) {
        setState(() {});
      }
      if(element['prod_name'].toLowerCase().contains(searchValue)) {
        prodResults.add(element['prod_name'] + ' ' + element.id);
      }
      i += 1;
    });
  }

  sliverBodyWidget() {
    if(cateScIndex == 0) {
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: productsSnapshot,
          builder: (BuildContext context, prodsSB) {
            var prods;
            Map<dynamic, dynamic> searchProds = {};

            if(prodsSB.hasData) {
              var prodsSnapOut = prodsSB.data != null? prodsSB.data!.data(): null;
              prods = prodsSnapOut?['prods'];

              // prods.forEach((key, value) {
              //   print(value['na']);
              // });
              if(prods == null) {
                return SliverList(delegate: SliverChildBuilderDelegate((context, index) {return Container();}, childCount: 1,),);
              }


              if(searchValue != '' && searchValue != ' ') {
                for(int i = 0; i < prods.length; i++) {
                  var eachMap = prods.entries.elementAt(i);
                  if(eachMap.value['na'] != null) {
                    if(eachMap.value['na'].toLowerCase().contains(searchValue)) {
                      searchProds[eachMap.key] = eachMap.value;
                    }
                  }
                }
                searchProds = sortMapByNaS(searchProds);
              }






              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: prodsImgSnap,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      var imgSnap = snapshot.data != null? snapshot.data!.data(): null;
                      var imgArr = imgSnap?['prods'];
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            var prodMap = searchProds.entries.elementAt(index);
                            print('Prod map ' + prodMap.key.toString());
                            var prodVal = prodMap.value;
                            var prodKey = prodMap.key;
                            String imgUrl = '';
                            if(imgArr[prodKey] != null) {
                              imgUrl = imgArr[prodKey]['img'].toString();
                            }
                            print('Prod image ' + imgUrl.toString());
                            return GestureDetector(
                              onTap: () async {
                                closeDrawerFrom();
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetailsView2(idString: prodKey.toString(), prodName: prodVal['na'], mainSell: prodVal['sm'].toString(), toggleCoinCallback: addProduct1, toggleCoinCallback3: addProduct3, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, imgUrl: imgUrl)),);
                                openDrawerFrom();
                              },
                              child: Padding(
                                padding:
                                EdgeInsets.only(top: index == 0? 0.0: 6.0, left: 15),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: index == searchProds.length-1 ?
                                          BorderSide(
                                              color: Colors.transparent,
                                              width: 0.5) :

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
                                                      child: imgUrl != ""
                                                          ? CachedNetworkImage(
                                                        imageUrl:
                                                        'https://riftplus.me/smartkyat_pos/api/uploads/' +
                                                            imgUrl,
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
                                                      prodVal['na'],
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
                                                          '$currencyUnit ' + prodVal['sm'].toString(),
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
                                                        prodVal['n1'] != '' && prodVal['n2'] == '' ? ' - ' + prodVal['s1'].toString() : prodVal['n1'] != '' && prodVal['n2'] != '' ? ' - ' + prodVal['s2'].toString() : '',
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
                                                            ' ' + prodVal['im'].round().toString() + ' '  + prodVal['nm'] + ' ',
                                                            textScaleFactor: 1.0,
                                                            style: TextStyle(
                                                                height: 1.3,
                                                                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                                                                overflow: TextOverflow.ellipsis
                                                            )),
                                                      ),
                                                      prodVal['n1'] != '' && prodVal['n2'] == ''?
                                                      Text(
                                                          '(+1 Sub item)',
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              height: 1.3,
                                                              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                                                              overflow: TextOverflow.ellipsis
                                                          )) : prodVal['n1'] != '' && prodVal['n2'] != '' ?
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
                          childCount: searchProds == null? 0: searchProds.length,
                          // childCount: 1,
                        ),
                      );
                    }
                    return SliverList(delegate: SliverChildBuilderDelegate((context, index) {return Container();}, childCount: 1,),);
                  }
              );
            }

            return SliverList(delegate: SliverChildBuilderDelegate((context, index) {return Container();}, childCount: 1,),);


          }
      );
    } else if(cateScIndex == 1) {
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: customersSnapshot,
          builder: (BuildContext context, custsSB) {
            var custs;
            Map<dynamic, dynamic> searchProds = {};

            if(custsSB.hasData) {
              var custsSnapOut = custsSB.data != null? custsSB.data!.data(): null;
              custs = custsSnapOut?['cus'];

              // prods.forEach((key, value) {
              //   print(value['na']);
              // });
              if(custs == null) {
                return SliverList(delegate: SliverChildBuilderDelegate((context, index) {return Container();}, childCount: 1,),);
              }


              if(searchValue != '' && searchValue != ' ') {
                for(int i = 0; i < custs.length; i++) {
                  var eachMap = custs.entries.elementAt(i);
                  if(eachMap.value['na'] != null) {
                    if(eachMap.value['na'].toLowerCase().contains(searchValue)) {
                      searchProds[eachMap.key] = eachMap.value;
                    }
                  }
                }
                searchProds = sortMapByNaS(searchProds);
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    var prodMap = searchProds.entries.elementAt(index);
                    print('Prod map ' + prodMap.key.toString());
                    var prodVal = prodMap.value;
                    var prodKey = prodMap.key;
                    return GestureDetector(
                      onTap: () async {
                        // closeDrawerFrom();
                        // await Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (
                        //           context) =>
                        //           CustomerInfoSubs(
                        //             id: version, custName: data['customer_name'], custAddress: data['customer_address'],
                        //             toggleCoinCallback: addCustomer2Cart1, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                        // );
                        // openDrawerFrom();
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
                                  bottom: index == searchProds.length-1 ?
                                  BorderSide(
                                      color: Colors
                                          .transparent,
                                      width: 0.5)
                                      :

                                  BorderSide(
                                      color: AppTheme.skBorderColor2,
                                      width: 0.5)
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

                                        // Container(
                                        //   height: 21,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(20.0),
                                        //     color: AppTheme.badgeFgDanger,
                                        //   ),
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                        //     child: Text(unpaidCount(index).toString() + ' unpaid',
                                        //       style: TextStyle(
                                        //           fontSize: 13,
                                        //           fontWeight: FontWeight.w500,
                                        //           color: Colors.white
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),

                                        // Text(orderList.toString()),

                                        // Container(
                                        //   height: 21,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(20.0),
                                        //     color: AppTheme.badgeFgDanger,
                                        //   ),
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                        //     child: Text('2 unpaid',
                                        //       style: TextStyle(
                                        //           fontSize: 13,
                                        //           fontWeight: FontWeight.w500,
                                        //           color: Colors.white
                                        //       ),
                                        //     ),
                                        //   ),
                                        // )

                                        // Container(
                                        //   height: 21,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(20.0),
                                        //     color: AppTheme.badgeFgDanger,
                                        //   ),
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                        //     child: Text(unpaidCount(index).toString() + ' unpaid',
                                        //       style: TextStyle(
                                        //           fontSize: 13,
                                        //           fontWeight: FontWeight.w500,
                                        //           color: Colors.white
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
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
                  childCount: searchProds == null? 0: searchProds.length,
                  // childCount: 1,
                ),
              );
            }

            return SliverList(delegate: SliverChildBuilderDelegate((context, index) {return Container();}, childCount: 1,),);


          }
      );
    } else if(cateScIndex == 2) {
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: merchantsSnapshot,
          builder: (BuildContext context, mercsSB) {
            var mercs;
            Map<dynamic, dynamic> searchProds = {};

            if(mercsSB.hasData) {
              var custsSnapOut = mercsSB.data != null? mercsSB.data!.data(): null;
              mercs = custsSnapOut?['mer'];

              // prods.forEach((key, value) {
              //   print(value['na']);
              // });
              if(mercs == null) {
                return SliverList(delegate: SliverChildBuilderDelegate((context, index) {return Container();}, childCount: 1,),);
              }


              if(searchValue != '' && searchValue != ' ') {
                for(int i = 0; i < mercs.length; i++) {
                  var eachMap = mercs.entries.elementAt(i);
                  if(eachMap.value['na'] != null) {
                    if(eachMap.value['na'].toLowerCase().contains(searchValue)) {
                      searchProds[eachMap.key] = eachMap.value;
                    }
                  }
                }
                searchProds = sortMapByNaS(searchProds);
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    var prodMap = searchProds.entries.elementAt(index);
                    print('Prod map ' + prodMap.key.toString());
                    var prodVal = prodMap.value;
                    var prodKey = prodMap.key;
                    return GestureDetector(
                      onTap: () async {
                        // closeDrawerFrom();
                        // await Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (
                        //           context) =>
                        //           CustomerInfoSubs(
                        //             id: version, custName: data['customer_name'], custAddress: data['customer_address'],
                        //             toggleCoinCallback: addCustomer2Cart1, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                        // );
                        // openDrawerFrom();
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
                                  bottom: index == searchProds.length-1 ?
                                  BorderSide(
                                      color: Colors
                                          .transparent,
                                      width: 0.5)
                                      :

                                  BorderSide(
                                      color: AppTheme.skBorderColor2,
                                      width: 0.5)
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

                                        // Container(
                                        //   height: 21,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(20.0),
                                        //     color: AppTheme.badgeFgDanger,
                                        //   ),
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                        //     child: Text(unpaidCount(index).toString() + ' unpaid',
                                        //       style: TextStyle(
                                        //           fontSize: 13,
                                        //           fontWeight: FontWeight.w500,
                                        //           color: Colors.white
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),

                                        // Text(orderList.toString()),

                                        // Container(
                                        //   height: 21,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(20.0),
                                        //     color: AppTheme.badgeFgDanger,
                                        //   ),
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                        //     child: Text('2 unpaid',
                                        //       style: TextStyle(
                                        //           fontSize: 13,
                                        //           fontWeight: FontWeight.w500,
                                        //           color: Colors.white
                                        //       ),
                                        //     ),
                                        //   ),
                                        // )

                                        // Container(
                                        //   height: 21,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(20.0),
                                        //     color: AppTheme.badgeFgDanger,
                                        //   ),
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                        //     child: Text(unpaidCount(index).toString() + ' unpaid',
                                        //       style: TextStyle(
                                        //           fontSize: 13,
                                        //           fontWeight: FontWeight.w500,
                                        //           color: Colors.white
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
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
                  childCount: searchProds == null? 0: searchProds.length,
                  // childCount: 1,
                ),
              );
            }

            return SliverList(delegate: SliverChildBuilderDelegate((context, index) {return Container();}, childCount: 1,),);


          }
      );
    } else if(cateScIndex == 3) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('shops')
              .doc(widget.shopId)
              .collection('order')
              .where('orderId', isEqualTo: searchValue)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
            if(snapshot2.hasData) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return GestureDetector(
                          onTap: () async {
                            // closeDrawerFrom();
                            // await Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {}, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                            // );
                            // openDrawerFrom();
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                color: AppTheme.lightBgColor,
                                child: Column(
                                  children: [
                                    Padding(
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
                                                    Text(
                                                      // '#',
                                                      '#' + snapshot2.data!.docs[index]['deviceId'] + snapshot2.data!.docs[index]['orderId'],
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
                                                      // '',
                                                      covertToDayNum(snapshot2.data!.docs[index]['dateTime'].substring(6,8)) + '/' + snapshot2.data!.docs[index]['dateTime'].substring(4,6) + '/' + snapshot2.data!.docs[index]['dateTime'].substring(0,4) + ' ' + convertToHour(snapshot2.data!.docs[index]['dateTime'].substring(8,10)) + ':' + zeroToTen(snapshot2.data!.docs[index]['dateTime'].substring(10,12)) + ' ',
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
                                                    Text(
                                                      // '',
                                                      snapshot2.data!.docs[index]['customerId'],
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
                                              if(snapshot2.data!.docs[index]['debt'] == 0)
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

                                              if(snapshot2.data!.docs[index]['debt'] != 0 && double.parse(snapshot2.data!.docs[index]['total']) > snapshot2.data!.docs[index]['debt'])
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
                                              if(snapshot2.data!.docs[index]['debt'] != 0  && double.parse(snapshot2.data!.docs[index]['total']) == snapshot2.data!.docs[index]['debt'])
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
                                              if(snapshot2.data!.docs[index]['refund'] == 'F')
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

                                              if(snapshot2.data!.docs[index]['refund'] == 'P')
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
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppTheme.lightBgColor,
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: AppTheme.skBorderColor2,
                                                  width: snapshot2.data!.docs.length-1 == index? 0.0: 1.0),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0, bottom: 5),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        // 'MMK ',
                                          'MMK ' + double.parse(snapshot2.data!.docs[index]['total'],).toStringAsFixed(2),
                                          style: TextStyle(
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
                  childCount: snapshot2.data!.docs == null? 0: snapshot2.data!.docs.length,
                  // childCount: 1,
                ),
              );
            }
            return SliverList(delegate: SliverChildBuilderDelegate((context, index) {return Container();}, childCount: 1,),);
          }
      );
    }

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