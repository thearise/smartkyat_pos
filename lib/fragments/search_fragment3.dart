import 'dart:async';
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
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
// import 'package:paginate_firestore/paginate_firestore.dart';
// import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/products_fragment2.dart';
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
import '../pages2/home_page5.dart';
import 'bloc_buylist.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  @override
  bool get opaque => false;
  FadeRoute({required this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
    transitionDuration: Duration(milliseconds: 100),
    reverseTransitionDuration: Duration(milliseconds: 150),
  );
}

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
    required this.isEnglish,
    Key? key,
    required Function(dynamic index) chgIndexFromSearch, this.deviceId,}
      ) : _closeCartBtn = closeCartBtn,
        _openCartBtn = openCartBtn,
        _chgIndex = chgIndexFromSearch,
        _barcodeBtn = barcodeBtn,
        _callback3 = toggleCoinCallback3, _callback = toggleCoinCallback, _callback2 = toggleCoinCallback2,_callback4 = toggleCoinCallback4, _openDrawerBtn = openDrawerBtn, _closeDrawerBtn = closeDrawerBtn, _printFromOrders = printFromOrders, super(key: key);
  final productsSnapshot;
  final BlueDevice? selectedDev;
  final String shopId;
  final String? deviceId;
  final bool isEnglish;

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

  ScrollController _scrollController = ScrollController();

  bool i0Clicked = true;
  bool i1Clicked = true;
  bool i2Clicked = true;

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

  int itemPerPage = 10;
  bool endOfResult = false;
  bool noResult = false;
  bool noFind = true;

  var prodsSnap;
  var prodsEvent;
  var prodsImgEvent;
  var prodsImg;

  var custsEvent;
  var mercsEvent;

  Timer? _debounce;
  String query = "";
  int _debouncetime = 500;

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      // setState(() {
      gloSearchText = _searchController.text;
      searchValue = _searchController.text.toLowerCase();
      itemPerPage = 10;
      // });
      searchKeyChanged();
      setState(() {

      });
      // if (_searchController.text != "") {
      //   ///here you perform your search
      //
      // }
    });



  }

  @override
  initState() {
    final docRef = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr2').doc('prodsArr');
    docRef.snapshots().listen(
          (event) {
        debugPrint("current data: ${event.data()}");
        prodsEvent = event.data();
        debugPrint('current worked ');
        setState(() {
          searchKeyChanged();
        });
      },
      onError: (error) => debugPrint("Listen failed: $error"),
    );

    final prodImgRef = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('imgArr').doc('prodsArr');
    prodImgRef.snapshots().listen(
          (event) {
        debugPrint("current data img: ${event.data()}");
        prodsImgEvent = event.data();
        prodsImg = prodsImgEvent?['prods'];
        debugPrint('current worked img');
        setState(() {
          searchKeyChanged();
        });
      },
      onError: (error) => debugPrint("Listen failed: $error"),
    );

    final custsRef = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr2').doc('cusArr');
    custsRef.snapshots().listen(
          (event) {
        debugPrint("current data cus: ${event.data()}");
        custsEvent = event.data();
        debugPrint('current worked cus');
        setState(() {
          searchKeyChanged();
        });
      },
      onError: (error) => debugPrint("Listen failed: $error"),
    );

    final mercsRef = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr2').doc('merArr');
    mercsRef.snapshots().listen(
          (event) {
        debugPrint("current data mer: ${event.data()}");
        mercsEvent = event.data();
        debugPrint('current worked mer');
        setState(() {
          searchKeyChanged();
        });
      },
      onError: (error) => debugPrint("Listen failed: $error"),
    );


    debugPrint("inittttt2");
    prodsSnap =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr2').doc('prodsArr').snapshots();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        debugPrint('maxxed');
        Future.delayed(const Duration(milliseconds: 500), () {
          itemPerPage = itemPerPage + 10;
          searchKeyChanged();
          setState(() {});
        });

      }
    });

    productsSnapshot = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr2').doc('prodsArr').snapshots();
    prodsImgSnap =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('imgArr').doc('prodsArr').snapshots();

    customersSnapshot =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr2').doc('cusArr').snapshots();
    merchantsSnapshot =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr2').doc('merArr').snapshots();




    // debugPrint('initializing ');
    // FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('cacheArr').doc('prodsArr')
    //     .get().then((value) async {
    //   var array = value.data()!['array'];
    //   List<String> needToFetchs = [];
    //
    //   // FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products')
    //   //     .where('archive', isEqualTo: false)
    //   // // .limit(20)
    //   //     .get(GetOptions(source: Source.cache))
    //   // // .get()
    //   //     .then((QuerySnapshot querySnapshot)  async {
    //   //   prodDocs = querySnapshot.docs;
    //   //   workCacheProds = querySnapshot.docs;
    //   //
    //   //
    //   //
    //   //   querySnapshot.docs.forEach((doc) {
    //   //     DocumentSnapshot doc2 = doc;
    //   //     debugPrint('cache data s ' + doc['prod_name']);
    //   //
    //   //     // Stream<DocumentSnapshot<Map<String, dynamic>>> docSnap =  FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').doc(doc.id).snapshots();
    //   //     // // docSnap.
    //   //     //
    //   //     // // Stream<QuerySnapshot>? emailSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('users').where('email', isEqualTo: auth.currentUser!.email.toString()).limit(1).snapshots();
    //   //     // // emailSnapshot.sn;
    //   //     //
    //   //     // // CollectionReference reference = FirebaseFirestore.instance.collection('planets');
    //   //     // docSnap.listen((querySnapshot) {
    //   //     //   debugPrint('query snap changes ' + querySnapshot.toString());
    //   //     //   // querySnapshot..forEach((change) {
    //   //     //   //   // Do something with change
    //   //     //   // });
    //   //     // });
    //   //
    //   //     CollectionReference prodsFetchServer = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_monthly');
    //   //
    //   //     if(!array.contains(doc.id)) {
    //   //       debugPrint('cache data s not equaling');
    //   //       // var docSnapNeed = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products')
    //   //       //     .doc(doc.id)
    //   //       //     .get();
    //   //       FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products')
    //   //           .doc(doc.id)
    //   //           .get()
    //   //           .then((value) {
    //   //         workSerProds.add(value);
    //   //       });
    //   //
    //   //     }
    //   //   });
    //   //
    //   // });
    //
    // });

    // FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products')
    //     .orderBy('update_time')
    //     .where('archive', isEqualTo: false)
    //     .get(GetOptions(source: Source.cache))
    //     .then((QuerySnapshot querySnapshot)  async {
    //   prodDocs = querySnapshot.docs;
    //   debugPrint('cache sd data ' + querySnapshot.docs.length.toString() + ' ---> ' + querySnapshot.metadata.isFromCache.toString());
    //   querySnapshot.docs.forEach((doc) {
    //     debugPrint('cache s data doc ' + doc['inStock1'].toString() + doc['prod_name'].toString());
    //   });
    //
    //   debugPrint('gg moda ' + querySnapshot.docs.last['update_time'].toString());
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
    //       debugPrint('server sd data ' + querySnapshotS.docs.length.toString() + ' ---> ' + querySnapshotS.metadata.isFromCache.toString());
    //       querySnapshotS.docs.forEach((doc) {
    //         debugPrint('server s data doc ' + doc['inStock1'].toString() + doc['prod_name'].toString());
    //       });
    //     });
    //   }
    // });
    //
    // debugPrint('final sd data ' + prodDocs.length.toString());
    // int i = 0;
    // prodDocs.forEach((doc) {
    //   i = i + 1;
    //   debugPrint('final s data doc ' + i.toString() + ' --> ' + doc['inStock1'].toString() + ' ' + doc['prod_name'].toString() + ' ' + doc.metadata.isFromCache.toString());
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
    _searchController.addListener(_onSearchChanged);
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
    WidgetsBinding.instance!
        .addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(nodeFirst);

    });


  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  focusSearch() {
    FocusScope.of(context).requestFocus(nodeFirst);
  }

  addProduct3(data) {
    widget._callback2(data);
  }

  addProduct1(data) {
    widget._callback(data);
  }

  slidingSearchCont() {

    if(slidingSearch == 0) {
      subTabController.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);
      setState(() {
      });
    } else if(slidingSearch == 1) {
      subTabController.animateTo(1, duration: Duration(milliseconds: 0), curve: Curves.ease);
      setState(() {
      });
    } else if(slidingSearch == 2) {
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

  // void closeSearch() {
  //   _searchController.clear();
  //   FocusScope.of(context).unfocus();
  //   setState(() {
  //     loadingSearch = true;
  //   });
  // }

  void unfocusSearch() {
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

  Map sortMapByImS(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => ((map[k1]['im'].compareTo(map[k2]['im']))));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  Map sortMapByDeS(Map map) {
    final sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => ((map[k2]['de'].compareTo(map[k1]['de']))));

    return Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => map[k]);
  }

  // overAllSearch() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 80.0),
  //     child: IgnorePointer(
  //       ignoring: !loadingSearch,
  //       child: AnimatedOpacity(
  //         opacity: loadingSearch ? 1 : 0,
  //         duration: Duration(milliseconds: 170),
  //         child: ProductsBloc(
  //           options: GetOptions(source: Source.cache),
  //           key: ValueKey<String>(cateScIndex.toString() + searchValue.toLowerCase()),
  //           selectedIntVal: selectedIntVal,
  //           header: SliverAppBar(
  //             elevation: 0,
  //             backgroundColor: Colors.white,
  //             // Provide a standard title.
  //             // Allows the user to reveal the app bar if they begin scrolling
  //             // back up the list of items.
  //             floating: true,
  //             flexibleSpace: Padding(
  //               padding: const EdgeInsets.only(left: 0.0, top: 12.0, bottom: 12.0),
  //               child: Container(
  //                 height: 32,
  //                 width: MediaQuery.of(context).size.width,
  //                 // color: Colors.yellow,
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                       child: ListView(
  //                         controller: cateScCtler,
  //                         scrollDirection: Axis.horizontal,
  //                         children: [
  //                           SizedBox(
  //                             width: 11,
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 4.0, right: 4.0),
  //                             child: FlatButton(
  //                               minWidth: 0,
  //                               padding: EdgeInsets.only(left: 12, right: 12),
  //                               color: cateScIndex == 0 ? AppTheme.secButtonColor:Colors.white,
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(20.0),
  //                                 side: BorderSide(
  //                                   color: AppTheme.skBorderColor2,
  //                                 ),
  //                               ),
  //                               onPressed: () {
  //                                 // _animateToIndex(0);
  //                                 selectedIntVal(0);
  //                               },
  //                               child: Container(
  //                                 child: Text(
  //                                   'Products',
  //                                   textAlign: TextAlign.center,
  //                                   style: TextStyle(
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w500,
  //                                       color: Colors.black),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 4.0, right: 4.0),
  //                             child: FlatButton(
  //                               minWidth: 0,
  //                               padding: EdgeInsets.only(left: 12, right: 12),
  //                               color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(20.0),
  //                                 side: BorderSide(
  //                                   color: AppTheme.skBorderColor2,
  //                                 ),
  //                               ),
  //                               onPressed: () {
  //                                 // _animateToIndex(20);
  //                                 selectedIntVal(1);
  //                               },
  //                               child: Container(
  //                                 child: Text(
  //                                   'Customers',
  //                                   textAlign: TextAlign.center,
  //                                   style: TextStyle(
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w500,
  //                                       color: Colors.black),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 4.0, right: 4.0),
  //                             child: FlatButton(
  //                               minWidth: 0,
  //                               padding: EdgeInsets.only(left: 12, right: 12),
  //                               color: cateScIndex == 2 ? AppTheme.secButtonColor:Colors.white,
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(20.0),
  //                                 side: BorderSide(
  //                                   color: AppTheme.skBorderColor2,
  //                                 ),
  //                               ),
  //                               onPressed: () {
  //                                 // _animateToIndex(2);
  //                                 selectedIntVal(2);
  //                               },
  //                               child: Container(
  //                                 child: Text(
  //                                   'Merchants',
  //                                   textAlign: TextAlign.center,
  //                                   style: TextStyle(
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w500,
  //                                       color: Colors.black),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 4.0, right: 4.0),
  //                             child: FlatButton(
  //                               minWidth: 0,
  //                               padding: EdgeInsets.only(left: 12, right: 12),
  //                               color: cateScIndex == 3 ? AppTheme.secButtonColor:Colors.white,
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(20.0),
  //                                 side: BorderSide(
  //                                   color: AppTheme.skBorderColor2,
  //                                 ),
  //                               ),
  //                               onPressed: () {
  //                                 // _animateToIndex(0);
  //                                 selectedIntVal(3);
  //                               },
  //                               child: Container(
  //                                 child: Text(
  //                                   'Sale orders',
  //                                   textAlign: TextAlign.center,
  //                                   style: TextStyle(
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w500,
  //                                       color: Colors.black),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 4.0, right: 4.0),
  //                             child: FlatButton(
  //                               minWidth: 0,
  //                               padding: EdgeInsets.only(left: 12, right: 12),
  //                               color: cateScIndex == 4 ? AppTheme.secButtonColor:Colors.white,
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(20.0),
  //                                 side: BorderSide(
  //                                   color: AppTheme.skBorderColor2,
  //                                 ),
  //                               ),
  //                               onPressed: () {
  //                                 // _animateToIndex(0);
  //                                 selectedIntVal(4);
  //                               },
  //                               child: Container(
  //                                 child: Text(
  //                                   'Buy orders',
  //                                   textAlign: TextAlign.center,
  //                                   style: TextStyle(
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w500,
  //                                       color: Colors.black),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             width: 11,
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //
  //               ),
  //             ),),
  //           onEmpty: Align(
  //             alignment: Alignment.topCenter,
  //             child: Column(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 0.0, top: 12.0, bottom: 12.0),
  //                   child: Container(
  //                     height: 32,
  //                     width: MediaQuery.of(context).size.width,
  //                     // color: Colors.yellow,
  //                     child: Row(
  //                       children: [
  //                         Expanded(
  //                           child: ListView(
  //                             controller: cateScCtler,
  //                             scrollDirection: Axis.horizontal,
  //                             children: [
  //                               SizedBox(
  //                                 width: 11,
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(left: 4.0, right: 4.0),
  //                                 child: FlatButton(
  //                                   minWidth: 0,
  //                                   padding: EdgeInsets.only(left: 12, right: 12),
  //                                   color: cateScIndex == 0 ? AppTheme.secButtonColor:Colors.white,
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(20.0),
  //                                     side: BorderSide(
  //                                       color: AppTheme.skBorderColor2,
  //                                     ),
  //                                   ),
  //                                   onPressed: () {
  //                                     _animateToIndex(0);
  //                                     selectedIntVal(0);
  //                                   },
  //                                   child: Container(
  //                                     child: Text(
  //                                       'Products',
  //                                       textAlign: TextAlign.center,
  //                                       style: TextStyle(
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.w500,
  //                                           color: Colors.black),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(left: 4.0, right: 4.0),
  //                                 child: FlatButton(
  //                                   minWidth: 0,
  //                                   padding: EdgeInsets.only(left: 12, right: 12),
  //                                   color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(20.0),
  //                                     side: BorderSide(
  //                                       color: AppTheme.skBorderColor2,
  //                                     ),
  //                                   ),
  //                                   onPressed: () {
  //                                     _animateToIndex(9.2);
  //                                     selectedIntVal(1);
  //                                   },
  //                                   child: Container(
  //                                     child: Text(
  //                                       'Customers',
  //                                       textAlign: TextAlign.center,
  //                                       style: TextStyle(
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.w500,
  //                                           color: Colors.black),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(left: 4.0, right: 4.0),
  //                                 child: FlatButton(
  //                                   minWidth: 0,
  //                                   padding: EdgeInsets.only(left: 12, right: 12),
  //                                   color: cateScIndex == 2 ? AppTheme.secButtonColor:Colors.white,
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(20.0),
  //                                     side: BorderSide(
  //                                       color: AppTheme.skBorderColor2,
  //                                     ),
  //                                   ),
  //                                   onPressed: () {
  //                                     _animateToIndex(19.9);
  //                                     selectedIntVal(2);
  //                                   },
  //                                   child: Container(
  //                                     child: Text(
  //                                       'Merchants',
  //                                       textAlign: TextAlign.center,
  //                                       style: TextStyle(
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.w500,
  //                                           color: Colors.black),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(left: 4.0, right: 4.0),
  //                                 child: FlatButton(
  //                                   minWidth: 0,
  //                                   padding: EdgeInsets.only(left: 12, right: 12),
  //                                   color: cateScIndex == 3 ? AppTheme.secButtonColor:Colors.white,
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(20.0),
  //                                     side: BorderSide(
  //                                       color: AppTheme.skBorderColor2,
  //                                     ),
  //                                   ),
  //                                   onPressed: () {
  //                                     _animateToIndex(30.1);
  //                                     selectedIntVal(3);
  //                                   },
  //                                   child: Container(
  //                                     child: Text(
  //                                       'Sale orders',
  //                                       textAlign: TextAlign.center,
  //                                       style: TextStyle(
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.w500,
  //                                           color: Colors.black),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(left: 4.0, right: 4.0),
  //                                 child: FlatButton(
  //                                   minWidth: 0,
  //                                   padding: EdgeInsets.only(left: 12, right: 12),
  //                                   color: cateScIndex == 4 ? AppTheme.secButtonColor:Colors.white,
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(20.0),
  //                                     side: BorderSide(
  //                                       color: AppTheme.skBorderColor2,
  //                                     ),
  //                                   ),
  //                                   onPressed: () {
  //                                     _animateToIndex(41);
  //                                     selectedIntVal(4);
  //                                   },
  //                                   child: Container(
  //                                     child: Text(
  //                                       'Buy orders',
  //                                       textAlign: TextAlign.center,
  //                                       style: TextStyle(
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.w500,
  //                                           color: Colors.black),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               SizedBox(
  //                                 width: 11,
  //                               ),
  //                             ],
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Container(
  //                     // color: AppTheme.lightBgColor,
  //                     color: Colors.white,
  //                     child: Center(child: Text('No data found', style: TextStyle(fontSize: 15),)),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //           footer: SliverToBoxAdapter(child: Padding(
  //             padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
  //             child: Center(child: Text('End of results', strutStyle: StrutStyle(forceStrutHeight: true, height: 1.4),)),
  //           )),
  //           initialLoader: Center(child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
  //               child: CupertinoActivityIndicator(radius: 15,))),
  //           bottomLoader: Container(
  //             child: LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
  //           ),
  //           itemBuilderType:
  //           PaginateBuilderType.listView,
  //           itemBuilder: (context1, documentSnapshots, index) {
  //             final data =  documentSnapshots[index].data() as Map<String, dynamic>;
  //             var version = documentSnapshots[index].id;
  //             //String item = zeroToTen(data['date'].toDate().year.toString()) +  zeroToTen(data['date'].toDate().month.toString()) +  zeroToTen(data['date'].toDate().day.toString()) +  zeroToTen(data['date'].toDate().hour.toString()) +  zeroToTen(data['date'].toDate().minute.toString()) + data['deviceId'].split('-')[0] + data['orderId'] +'^' + data['deviceId'] + data['orderId'] + '^' + data['total'].toString() + '^' + widget.merchName + '&'+ data['merchantId'] + '^' + data['refund'] + '^' + data['debt'].toString() + '^' + data['discount'].toString() + '^' + data['date'].toDate().hour.toString() + '^' + data['date'].toDate().minute.toString();
  //             if(cateScIndex == 0) {
  //               return Container(
  //                 color: AppTheme.lightBgColor,
  //                 child: GestureDetector(
  //                   onTap: () async {
  //                     closeDrawerFrom();
  //                     await Navigator.of(context).push(
  //                       MaterialPageRoute(
  //                           builder: (context) => ProductDetailsView2(idString: version, prodName: data['prod_name'],
  //                             mainSell: data['unit_sell'],
  //                             toggleCoinCallback: addProduct1,
  //                             toggleCoinCallback3: addProduct3,
  //                             shopId: widget.shopId.toString(),
  //                             closeCartBtn: closeCartFrom,
  //                             openCartBtn: openCartFrom,
  //                             mainQty: 10, mainName: '',
  //                             sub1Qty: 100,
  //                             barcode: '',
  //                             sub2Qty: 10,
  //                             sub1Price: 10,
  //                             buyPrice1: 10,
  //                             sub2Unit: 10,
  //                             imgUrl: '',
  //                             buyPrice2: 10,
  //                             mainLoss: 10,
  //                             sub1Name: '',
  //                             sub2Price: 10, sub2Loss: 10, buyPrice3: 10, sub2Name: '', sub1Unit: 10, subExist: 0, sub1Loss: 10,)),);
  //                     openDrawerFrom();
  //                   },
  //                   child: Padding(
  //                     padding:
  //                     EdgeInsets.only(top: 6.0, left: 15),
  //                     child: Container(
  //                       width: MediaQuery.of(context).size.width,
  //                       decoration: BoxDecoration(
  //                           border: Border(
  //                               bottom: index == documentSnapshots.length-1 ?
  //                               BorderSide(
  //                                   color: Colors.transparent,
  //                                   width: 1.0) :
  //
  //                               BorderSide(
  //                                   color: AppTheme.skBorderColor2,
  //                                   width: 1)
  //                           )),
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(right: 15.0),
  //                         child: Column(
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 Column(
  //                                   children: [
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(top: 8.0),
  //                                       child: ClipRRect(
  //                                           borderRadius:
  //                                           BorderRadius
  //                                               .circular(
  //                                               5.0),
  //                                           child: data['img_1'] != ""
  //                                               ? CachedNetworkImage(
  //                                             imageUrl:
  //                                             'https://htoomedia.info/smartkyat_pos/api/uploads/' +
  //                                                 data['img_1'],
  //                                             width: 75,
  //                                             height: 75,
  //                                             errorWidget: (context, url, error) => Image.asset('assets/system/default-product.png', height: 75, width: 75, fit: BoxFit.cover,),
  //                                             placeholder: (context, url) => Image(image: AssetImage('assets/system/default-product.png'), height: 75, width: 75, fit: BoxFit.cover,),
  //                                             fadeInDuration:
  //                                             Duration(
  //                                                 milliseconds:
  //                                                 100),
  //                                             fadeOutDuration:
  //                                             Duration(
  //                                                 milliseconds:
  //                                                 10),
  //                                             fadeInCurve:
  //                                             Curves
  //                                                 .bounceIn,
  //                                             fit: BoxFit
  //                                                 .cover,
  //                                           )
  //                                               : Image.asset('assets/system/default-product.png', height: 75, width: 75, fit: BoxFit.cover,)),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 SizedBox(
  //                                   width: 15,
  //                                 ),
  //                                 Expanded(
  //                                   child: Column(
  //                                     crossAxisAlignment:
  //                                     CrossAxisAlignment
  //                                         .start,
  //                                     mainAxisAlignment: MainAxisAlignment.start,
  //                                     children: [
  //                                       SizedBox(
  //                                         height: 0,
  //                                       ),
  //                                       Container(
  //                                         // color: Colors.yellow,
  //                                         child: Text(
  //                                           data['prod_name'],
  //                                           style: TextStyle(
  //                                               fontSize: 18,
  //                                               fontWeight:
  //                                               FontWeight.w500,
  //                                               overflow: TextOverflow.ellipsis
  //                                           ),
  //                                           strutStyle: StrutStyle(
  //                                             height: 2.2,
  //                                             // fontSize:,
  //                                             forceStrutHeight: true,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       SizedBox(
  //                                         height: 8,
  //                                       ),
  //                                       Row(
  //                                         children: [
  //                                           Flexible(
  //                                             child: Text(
  //                                               '$currencyUnit ' + data['unit_sell'],
  //                                               style: TextStyle(
  //                                                   height: 1.3,
  //                                                   fontSize: 15,
  //                                                   fontWeight:
  //                                                   FontWeight.w500,
  //                                                   overflow: TextOverflow.ellipsis
  //                                               ),
  //                                             ),
  //                                           ),
  //                                           Text(
  //                                             // 'lafsjfel jaljfli jalejf liajelfjeajl jfliaj jfelsaijf lajl jf',
  //                                             data['sub1_name'] != '' && data['sub2_name'] == '' ? ' - ' + data['sub1_sell'] : data['sub1_name'] != '' && data['sub2_name'] != '' ? ' - ' + data['sub2_sell'] : '',
  //                                             style: TextStyle(
  //                                                 height: 1.3,
  //                                                 fontSize: 15,
  //                                                 fontWeight:
  //                                                 FontWeight.w500,
  //                                                 overflow: TextOverflow.ellipsis
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       SizedBox(
  //                                         height: 2,
  //                                       ),
  //                                       Row(
  //                                         crossAxisAlignment: CrossAxisAlignment.start,
  //                                         mainAxisAlignment: MainAxisAlignment.start,
  //                                         children: [
  //                                           Padding(
  //                                             padding: const EdgeInsets.only(top: 2.0),
  //                                             child: Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
  //                                           ),
  //                                           Flexible(
  //                                             child: Text(
  //                                                 ' ' + data['inStock1'].round().toString() + ' '  + data['unit_name'] + ' ',
  //                                                 textScaleFactor: 1.0,
  //                                                 style: TextStyle(
  //                                                     height: 1.3,
  //                                                     fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
  //                                                     overflow: TextOverflow.ellipsis
  //                                                 )),
  //                                           ),
  //                                           data['sub1_name'] != '' && data['sub2_name'] == ''?
  //                                           Text(
  //                                               '(+1 Sub item)',
  //                                               textScaleFactor: 1.0,
  //                                               style: TextStyle(
  //                                                   height: 1.3,
  //                                                   fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
  //                                                   overflow: TextOverflow.ellipsis
  //                                               )) : data['sub1_name'] != '' && data['sub2_name'] != '' ?
  //                                           Text(
  //                                               '(+2 Sub items)',
  //                                               textScaleFactor: 1.0,
  //                                               style: TextStyle(
  //                                                   height: 1.3,
  //                                                   fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
  //                                                   overflow: TextOverflow.ellipsis
  //                                               )): Container(),
  //                                         ],
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding:
  //                                   const EdgeInsets.only(
  //                                       bottom: 6.0),
  //                                   child: Icon(
  //                                     Icons
  //                                         .arrow_forward_ios_rounded,
  //                                     size: 16,
  //                                     color: Colors.blueGrey
  //                                         .withOpacity(0.8),
  //                                   ),),
  //                               ],
  //                             ),
  //                             SizedBox(height: 15),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             } else if(cateScIndex == 1) {
  //               return Container(
  //                 color: AppTheme.lightBgColor,
  //                 child: GestureDetector(
  //                   onTap: () async {
  //                     closeDrawerFrom();
  //                     await Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (
  //                               context) =>
  //                               CustomerInfoSubs(
  //                                 id: version, custName: data['customer_name'], custAddress: data['customer_address'],
  //                                 toggleCoinCallback: addCustomer2Cart1, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
  //                     );
  //                     openDrawerFrom();
  //                   },
  //                   child: Padding(
  //                     padding:
  //                     EdgeInsets.only(left: 15.0,
  //                         top: 15.0),
  //                     child: Container(
  //                       width: MediaQuery
  //                           .of(context)
  //                           .size
  //                           .width,
  //                       decoration: BoxDecoration(
  //                           border: Border(
  //                               bottom: index == documentSnapshots.length-1 ?
  //                               BorderSide(
  //                                   color: Colors
  //                                       .transparent,
  //                                   width: 1.0)
  //                                   :
  //
  //                               BorderSide(
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
  //                                 bottom: 18.0),
  //                             child: ListTile(
  //                               title: Text(
  //                                 data['customer_name'].toString(),
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
  //                                       data['customer_address'],
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
  //                                     SizedBox(
  //                                       height: 5,),
  //                                     Text(
  //                                       data['customer_phone'],
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
  //                                         height: 1,
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
  //                                     data['debts'] > 0? Container(
  //                                       height: 21,
  //                                       decoration: BoxDecoration(
  //                                         borderRadius: BorderRadius.circular(20.0),
  //                                         color: AppTheme.badgeFgDanger,
  //                                       ),
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
  //                                         child: Text(data['debts'].round().toString() + ' unpaid',
  //                                           style: TextStyle(
  //                                               fontSize: 13,
  //                                               fontWeight: FontWeight.w500,
  //                                               color: Colors.white
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ): Container(height: 21,),
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
  //                               contentPadding: const EdgeInsets
  //                                   .only(
  //                                   left: 0.0, right: 15) ,
  //                             ),
  //                           )
  //
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             } else if(cateScIndex == 2) {
  //               return Container(
  //                 color: AppTheme.lightBgColor,
  //                 child: GestureDetector(
  //                   onTap: () async {
  //                     closeDrawerFrom();
  //                     await Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (
  //                               context) =>
  //                               MerchantInfoSubs(
  //                                 id: version, mercAddress: data['merchant_address'], mercName: data['merchant_name'],
  //                                 toggleCoinCallback: addMerchant2Cart, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
  //                     );
  //                     openDrawerFrom();
  //                   },
  //                   child: Padding(
  //                     padding:
  //                     EdgeInsets.only(left: 15.0,
  //                         top: 15.0),
  //                     child: Container(
  //                       width: MediaQuery
  //                           .of(context)
  //                           .size
  //                           .width,
  //                       decoration: BoxDecoration(
  //                           border: Border(
  //                               bottom: index == documentSnapshots.length-1 ?
  //                               BorderSide(
  //                                   color: Colors
  //                                       .transparent,
  //                                   width: 1.0)
  //                                   :
  //
  //                               BorderSide(
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
  //                                 bottom: 18.0),
  //                             child: ListTile(
  //                               contentPadding: const EdgeInsets
  //                                   .only(
  //                                   left: 0.0, right: 15),
  //                               title: Text(
  //                                 data['merchant_name'].toString(),
  //                                 style: TextStyle(
  //                                     fontSize: 18,
  //                                     fontWeight:
  //                                     FontWeight
  //                                         .w500,
  //                                     height: 1.1,
  //                                     overflow: TextOverflow.ellipsis
  //                                 ),
  //                                 maxLines: 1,
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
  //                                       data['merchant_address'],
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
  //                                     SizedBox(
  //                                       height: 5,),
  //                                     Text(
  //                                       data['merchant_phone'],
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
  //                                         height: 1,
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
  //                                     data['debts'] > 0? Container(
  //                                       height: 21,
  //                                       decoration: BoxDecoration(
  //                                         borderRadius: BorderRadius.circular(20.0),
  //                                         color: AppTheme.badgeFgDanger,
  //                                       ),
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
  //                                         child: Text(data['debts'].round().toString() + ' unpaid',
  //                                           style: TextStyle(
  //                                               fontSize: 13,
  //                                               fontWeight: FontWeight.w500,
  //                                               color: Colors.white
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ): Container(height: 21,),
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
  //             } else if(cateScIndex == 3) {
  //               String item = data['dateTime'].substring(0,4) + data['dateTime'].substring(4,6) +  data['dateTime'].substring(6,8) +  data['dateTime'].substring(8,10) +  data['dateTime'].substring(10,12) + '^' + data['deviceId'] + data['orderId'] + '^' + data['total'].toString() + '^' + data['customerId'] + '^' + data['refund'] + '^' + data['debt'].toString() + '^' + data['discount'].toString() + '^' + data['date'].toDate().hour.toString() + '^' + data['date'].toDate().minute.toString();
  //               return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  //                   stream: FirebaseFirestore.instance.collection('shops').doc(shopId).collection('customers').doc(item.split('^')[3].split('&')[0]).snapshots(),
  //                   builder: (BuildContext context, snapshotCust) {
  //                     if(snapshotCust.hasData) {
  //                       var output = snapshotCust.data != null? snapshotCust.data!.data(): null;
  //                       String custName = output?['customer_name'];
  //                       item = item.split('^')[0] + '^' + item.split('^')[1] + '^' + item.split('^')[2] + '^' + custName + '&' + item.split('^')[3] + '^' + item.split('^')[4] + '^' + item.split('^')[5] + '^' + item.split('^')[6] + '^' + item.split('^')[7] + '^' + item.split('^')[8] + '^' + 's';
  //                       return GestureDetector(
  //                         onTap: () async {
  //                           closeDrawerFrom();
  //                           await Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {}, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
  //                           );
  //                           openDrawerFrom();
  //                         },
  //                         child: Stack(
  //                           alignment: Alignment.center,
  //                           children: [
  //                             Container(
  //                               color: AppTheme.lightBgColor,
  //                               child: Column(
  //                                 children: [
  //                                   Padding(
  //                                     padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
  //                                     child: Column(
  //                                       mainAxisAlignment: MainAxisAlignment.start,
  //                                       crossAxisAlignment: CrossAxisAlignment.start,
  //                                       children: [
  //                                         Padding(
  //                                           padding: const EdgeInsets.only(left: 1.0),
  //                                           child: Column(
  //                                             mainAxisAlignment: MainAxisAlignment.start,
  //                                             crossAxisAlignment: CrossAxisAlignment.start,
  //                                             children: [
  //                                               Row(
  //                                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                                 children: [
  //                                                   // '#' + item!='' ? item.split('^')[1]: ''
  //                                                   Text(
  //                                                     // '#',
  //                                                     '#' + item.split('^')[1],
  //                                                     style: TextStyle(
  //                                                         fontSize: 16,
  //                                                         fontWeight: FontWeight.w500
  //                                                     ),
  //                                                   ),
  //                                                   SizedBox(width: 8),
  //                                                   Padding(
  //                                                     padding: const EdgeInsets.only(bottom: 1.0),
  //                                                     child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
  //                                                   ),
  //                                                   SizedBox(width: 4),
  //                                                   Text(
  //                                                     // '',
  //                                                     covertToDayNum(item.split('^')[0].substring(6,8)) + '/' + item.split('^')[0].substring(4,6) + ' ' + convertToHour(item.split('^')[7]) + ':' + zeroToTen(item.split('^')[8]) + ' ' + convertToAMPM(item.split('^')[7]),
  //                                                     style: TextStyle(
  //                                                       fontSize: 14,
  //                                                       fontWeight: FontWeight.w500,
  //                                                       color: Colors.grey,
  //                                                     ),
  //                                                   ),
  //                                                   // Text(item.split('^')[7] + ':' + item.split('^')[8] ,
  //                                                   //   style: TextStyle(
  //                                                   //     fontSize: 14,
  //                                                   //     fontWeight: FontWeight.w500,
  //                                                   //     color: Colors.grey,
  //                                                   //   ),
  //                                                   // ),
  //                                                 ],
  //                                               ),
  //                                               SizedBox(
  //                                                 height: 6,
  //                                               ),
  //                                               Row(
  //                                                 children: [
  //                                                   Text(
  //                                                     // '',
  //                                                     custName,
  //                                                     style: TextStyle(
  //                                                       fontSize: 15,
  //                                                       fontWeight: FontWeight.w500,
  //                                                       color: Colors.grey,
  //                                                     ),
  //                                                     strutStyle: StrutStyle(
  //                                                       height: 1.3,
  //                                                       // fontSize:,
  //                                                       forceStrutHeight: true,
  //                                                     ),
  //                                                   ),
  //
  //                                                 ],
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         SizedBox(
  //                                           height: 8,
  //                                         ),
  //                                         Row(
  //                                           children: [
  //                                             if(item.split('^')[5] == '0.0')
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(left: 0.0),
  //                                                 child: Container(
  //                                                   height: 21,
  //                                                   decoration: BoxDecoration(
  //                                                     borderRadius: BorderRadius.circular(20.0),
  //                                                     color: AppTheme.badgeBgSuccess,
  //                                                   ),
  //                                                   child: Padding(
  //                                                     padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                     child: Text('Paid',
  //                                                       style: TextStyle(
  //                                                           fontSize: 13,
  //                                                           fontWeight: FontWeight.w500,
  //                                                           color: Colors.white
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //
  //                                             if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(left: 0.0),
  //                                                 child: Container(
  //                                                   height: 21,
  //                                                   decoration: BoxDecoration(
  //                                                     borderRadius: BorderRadius.circular(20.0),
  //                                                     color: AppTheme.badgeFgDangerLight,
  //                                                   ),
  //                                                   child: Padding(
  //                                                     padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                     child: Text('Partially paid',
  //                                                       style: TextStyle(
  //                                                           fontSize: 13,
  //                                                           fontWeight: FontWeight.w500,
  //                                                           color: AppTheme.badgeFgDanger
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(left: 0.0),
  //                                                 child: Container(
  //                                                   height: 21,
  //                                                   decoration: BoxDecoration(
  //                                                     borderRadius: BorderRadius.circular(20.0),
  //                                                     color: AppTheme.badgeFgDanger,
  //                                                   ),
  //                                                   child: Padding(
  //                                                     padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                     child: Text('Unpaid',
  //                                                       style: TextStyle(
  //                                                           fontSize: 13,
  //                                                           fontWeight: FontWeight.w500,
  //                                                           color: Colors.white
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             if(item.split('^')[4] == 'TRUE')
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(left: 6.0),
  //                                                 child: Container(
  //                                                   height: 21,
  //                                                   decoration: BoxDecoration(
  //                                                     borderRadius: BorderRadius.circular(20.0),
  //                                                     color: AppTheme.badgeBgSecond,
  //                                                   ),
  //                                                   child: Padding(
  //                                                     padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                     child: Text('Refunded',
  //                                                       style: TextStyle(
  //                                                           fontSize: 13,
  //                                                           fontWeight: FontWeight.w500,
  //                                                           color: Colors.white
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //
  //                                             if(item.split('^')[4] == 'PART')
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(left: 6.0),
  //                                                 child: Container(
  //                                                   height: 21,
  //                                                   decoration: BoxDecoration(
  //                                                     borderRadius: BorderRadius.circular(20.0),
  //                                                     color: AppTheme.badgeBgSecondLight,
  //                                                   ),
  //                                                   child: Padding(
  //                                                     padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
  //                                                     child: Text('Partially refunded',
  //                                                       style: TextStyle(
  //                                                           fontSize: 13,
  //                                                           fontWeight: FontWeight.w500,
  //                                                           color: AppTheme.badgeBgSecond
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //
  //                                           ],
  //                                         )
  //                                       ],
  //                                     ),
  //                                   ),
  //                                   Padding(
  //                                     padding: const EdgeInsets.only(left: 15.0),
  //                                     child: Container(
  //                                       decoration: BoxDecoration(
  //                                           color: AppTheme.lightBgColor,
  //                                           border: Border(
  //                                             bottom: BorderSide(
  //                                                 color: AppTheme.skBorderColor2,
  //                                                 width: documentSnapshots.length-1 == index? 0.0: 1.0),
  //                                           )),
  //                                     ),
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(right: 15.0, bottom: 5),
  //                               child: Align(
  //                                 alignment: Alignment.centerRight,
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.end,
  //                                   children: [
  //                                     Text(
  //                                       // 'MMK ',
  //                                         'MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2),
  //                                         style: TextStyle(
  //                                           fontSize: 15,
  //                                           fontWeight: FontWeight.w500,
  //                                         )),
  //                                     SizedBox(width: 10),
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(bottom: 2.0),
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
  //                             )
  //                           ],
  //                         ),
  //                       );
  //                     }
  //                     item = item.split('^')[0] + '^' + item.split('^')[1] + '^' + item.split('^')[2] + '^' + 'No customer' + '&' + item.split('^')[3] + '^' + item.split('^')[4] + '^' + item.split('^')[5] + '^' + item.split('^')[6] + '^' + item.split('^')[7] + '^' + item.split('^')[8] + '^' + 's';
  //                     return GestureDetector(
  //                       onTap: () async {
  //                         debugPrint('clicked order list 1 ' + item);
  //                         closeDrawerFrom();
  //                         await Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {}, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
  //                         );
  //                         openDrawerFrom();
  //                       },
  //                       child: Stack(
  //                         alignment: Alignment.center,
  //                         children: [
  //                           Container(
  //                             color: AppTheme.lightBgColor,
  //                             child: Column(
  //                               children: [
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
  //                                   child: Column(
  //                                     mainAxisAlignment: MainAxisAlignment.start,
  //                                     crossAxisAlignment: CrossAxisAlignment.start,
  //                                     children: [
  //                                       Padding(
  //                                         padding: const EdgeInsets.only(left: 1.0),
  //                                         child: Column(
  //                                           mainAxisAlignment: MainAxisAlignment.start,
  //                                           crossAxisAlignment: CrossAxisAlignment.start,
  //                                           children: [
  //                                             Row(
  //                                               mainAxisAlignment: MainAxisAlignment.start,
  //                                               children: [
  //                                                 // '#' + item!='' ? item.split('^')[1]: ''
  //                                                 Text(
  //                                                   // '#',
  //                                                   '#' + item.split('^')[1],
  //                                                   style: TextStyle(
  //                                                       fontSize: 16,
  //                                                       fontWeight: FontWeight.w500
  //                                                   ),
  //                                                 ),
  //                                                 SizedBox(width: 8),
  //                                                 Padding(
  //                                                   padding: const EdgeInsets.only(bottom: 1.0),
  //                                                   child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
  //                                                 ),
  //                                                 SizedBox(width: 4),
  //                                                 Text(
  //                                                   // '',
  //                                                   covertToDayNum(item.split('^')[0].substring(6,8)) + '/' + item.split('^')[0].substring(4,6) + ' ' + convertToHour(item.split('^')[7]) + ':' + zeroToTen(item.split('^')[8]) + ' ' + convertToAMPM(item.split('^')[7]),
  //                                                   style: TextStyle(
  //                                                     fontSize: 14,
  //                                                     fontWeight: FontWeight.w500,
  //                                                     color: Colors.grey,
  //                                                   ),
  //                                                 ),
  //                                                 // Text(item.split('^')[7] + ':' + item.split('^')[8] ,
  //                                                 //   style: TextStyle(
  //                                                 //     fontSize: 14,
  //                                                 //     fontWeight: FontWeight.w500,
  //                                                 //     color: Colors.grey,
  //                                                 //   ),
  //                                                 // ),
  //                                               ],
  //                                             ),
  //                                             SizedBox(
  //                                               height: 6,
  //                                             ),
  //                                             Row(
  //                                               children: [
  //                                                 Text(
  //                                                   // '',
  //                                                   'Loading',
  //                                                   style: TextStyle(
  //                                                     fontSize: 15,
  //                                                     fontWeight: FontWeight.w500,
  //                                                     color: Colors.grey,
  //                                                   ),
  //                                                   strutStyle: StrutStyle(
  //                                                     height: 1.3,
  //                                                     // fontSize:,
  //                                                     forceStrutHeight: true,
  //                                                   ),
  //                                                 ),
  //
  //                                               ],
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                       SizedBox(
  //                                         height: 8,
  //                                       ),
  //                                       Row(
  //                                         children: [
  //                                           if(item.split('^')[5] == '0.0')
  //                                             Padding(
  //                                               padding: const EdgeInsets.only(left: 0.0),
  //                                               child: Container(
  //                                                 height: 21,
  //                                                 decoration: BoxDecoration(
  //                                                   borderRadius: BorderRadius.circular(20.0),
  //                                                   color: AppTheme.badgeBgSuccess,
  //                                                 ),
  //                                                 child: Padding(
  //                                                   padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                   child: Text('Paid',
  //                                                     style: TextStyle(
  //                                                         fontSize: 13,
  //                                                         fontWeight: FontWeight.w500,
  //                                                         color: Colors.white
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //
  //                                           if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
  //                                             Padding(
  //                                               padding: const EdgeInsets.only(left: 0.0),
  //                                               child: Container(
  //                                                 height: 21,
  //                                                 decoration: BoxDecoration(
  //                                                   borderRadius: BorderRadius.circular(20.0),
  //                                                   color: AppTheme.badgeFgDangerLight,
  //                                                 ),
  //                                                 child: Padding(
  //                                                   padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                   child: Text('Partially paid',
  //                                                     style: TextStyle(
  //                                                         fontSize: 13,
  //                                                         fontWeight: FontWeight.w500,
  //                                                         color: AppTheme.badgeFgDanger
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
  //                                             Padding(
  //                                               padding: const EdgeInsets.only(left: 0.0),
  //                                               child: Container(
  //                                                 height: 21,
  //                                                 decoration: BoxDecoration(
  //                                                   borderRadius: BorderRadius.circular(20.0),
  //                                                   color: AppTheme.badgeFgDanger,
  //                                                 ),
  //                                                 child: Padding(
  //                                                   padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                   child: Text('Unpaid',
  //                                                     style: TextStyle(
  //                                                         fontSize: 13,
  //                                                         fontWeight: FontWeight.w500,
  //                                                         color: Colors.white
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           if(item.split('^')[4] == 'TRUE')
  //                                             Padding(
  //                                               padding: const EdgeInsets.only(left: 6.0),
  //                                               child: Container(
  //                                                 height: 21,
  //                                                 decoration: BoxDecoration(
  //                                                   borderRadius: BorderRadius.circular(20.0),
  //                                                   color: AppTheme.badgeBgSecond,
  //                                                 ),
  //                                                 child: Padding(
  //                                                   padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                   child: Text('Refunded',
  //                                                     style: TextStyle(
  //                                                         fontSize: 13,
  //                                                         fontWeight: FontWeight.w500,
  //                                                         color: Colors.white
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //
  //                                           if(item.split('^')[4] == 'PART')
  //                                             Padding(
  //                                               padding: const EdgeInsets.only(left: 6.0),
  //                                               child: Container(
  //                                                 height: 21,
  //                                                 decoration: BoxDecoration(
  //                                                   borderRadius: BorderRadius.circular(20.0),
  //                                                   color: AppTheme.badgeBgSecondLight,
  //                                                 ),
  //                                                 child: Padding(
  //                                                   padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
  //                                                   child: Text('Partially refunded',
  //                                                     style: TextStyle(
  //                                                         fontSize: 13,
  //                                                         fontWeight: FontWeight.w500,
  //                                                         color: AppTheme.badgeBgSecond
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //
  //                                         ],
  //                                       )
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(left: 15.0),
  //                                   child: Container(
  //                                     decoration: BoxDecoration(
  //                                         color: AppTheme.lightBgColor,
  //                                         border: Border(
  //                                           bottom: BorderSide(
  //                                               color: AppTheme.skBorderColor2,
  //                                               width: documentSnapshots.length-1 == index? 0.0: 1.0),
  //                                         )),
  //                                   ),
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(right: 15.0, bottom: 5),
  //                             child: Align(
  //                               alignment: Alignment.centerRight,
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                 children: [
  //                                   Text(
  //                                     // 'MMK ',
  //                                       'MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2),
  //                                       style: TextStyle(
  //                                         fontSize: 15,
  //                                         fontWeight: FontWeight.w500,
  //                                       )),
  //                                   SizedBox(width: 10),
  //                                   Padding(
  //                                     padding: const EdgeInsets.only(bottom: 2.0),
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
  //                           )
  //                         ],
  //                       ),
  //                     );
  //                   }
  //               );
  //             } else {
  //               String item = data['dateTime'].substring(0,4) + data['dateTime'].substring(4,6) +  data['dateTime'].substring(6,8) +  data['dateTime'].substring(8,10) +  data['dateTime'].substring(10,12) + '^' + data['deviceId'] + data['orderId'] + '^' + data['total'].toString() + '^' + data['merchantId'] + '^' + data['refund'] + '^' + data['debt'].toString() + '^' + data['discount'].toString() + '^' + data['date'].toDate().hour.toString() + '^' + data['date'].toDate().minute.toString();
  //               return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  //                   stream: FirebaseFirestore.instance.collection('shops').doc(shopId).collection('merchants').doc(item.split('^')[3].split('&')[0]).snapshots(),
  //                   builder: (BuildContext context, snapshotCust) {
  //                     if(snapshotCust.hasData) {
  //                       var output = snapshotCust.data != null? snapshotCust.data!.data(): null;
  //                       String custName = output?['merchant_name'];
  //                       item = item.split('^')[0] + '^' + item.split('^')[1] + '^' + item.split('^')[2] + '^' + custName + '&' + item.split('^')[3] + '^' + item.split('^')[4] + '^' + item.split('^')[5] + '^' + item.split('^')[6] + '^' + item.split('^')[7] + '^' + item.split('^')[8] + '^' + 's';
  //                       return GestureDetector(
  //                         onTap: () async {
  //                           closeDrawerFrom();
  //                           await Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => BuyListInfo(data: item, toggleCoinCallback: () {}, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
  //                           );
  //                           openDrawerFrom();
  //                         },
  //                         child: Stack(
  //                           alignment: Alignment.center,
  //                           children: [
  //                             Container(
  //                               color: AppTheme.lightBgColor,
  //                               child: Column(
  //                                 children: [
  //                                   Padding(
  //                                     padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
  //                                     child: Column(
  //                                       mainAxisAlignment: MainAxisAlignment.start,
  //                                       crossAxisAlignment: CrossAxisAlignment.start,
  //                                       children: [
  //                                         Padding(
  //                                           padding: const EdgeInsets.only(left: 1.0),
  //                                           child: Column(
  //                                             mainAxisAlignment: MainAxisAlignment.start,
  //                                             crossAxisAlignment: CrossAxisAlignment.start,
  //                                             children: [
  //                                               Row(
  //                                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                                 children: [
  //                                                   // '#' + item!='' ? item.split('^')[1]: ''
  //                                                   Text(
  //                                                     // '#',
  //                                                     '#' + item.split('^')[1],
  //                                                     style: TextStyle(
  //                                                         fontSize: 16,
  //                                                         fontWeight: FontWeight.w500
  //                                                     ),
  //                                                   ),
  //                                                   SizedBox(width: 8),
  //                                                   Padding(
  //                                                     padding: const EdgeInsets.only(bottom: 1.0),
  //                                                     child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
  //                                                   ),
  //                                                   SizedBox(width: 4),
  //                                                   Text(
  //                                                     // '',
  //                                                     covertToDayNum(item.split('^')[0].substring(6,8)) + '/' + item.split('^')[0].substring(4,6) + ' ' + convertToHour(item.split('^')[7]) + ':' + zeroToTen(item.split('^')[8]) + ' ' + convertToAMPM(item.split('^')[7]),
  //                                                     style: TextStyle(
  //                                                       fontSize: 14,
  //                                                       fontWeight: FontWeight.w500,
  //                                                       color: Colors.grey,
  //                                                     ),
  //                                                   ),
  //                                                   // Text(item.split('^')[7] + ':' + item.split('^')[8] ,
  //                                                   //   style: TextStyle(
  //                                                   //     fontSize: 14,
  //                                                   //     fontWeight: FontWeight.w500,
  //                                                   //     color: Colors.grey,
  //                                                   //   ),
  //                                                   // ),
  //                                                 ],
  //                                               ),
  //                                               SizedBox(
  //                                                 height: 6,
  //                                               ),
  //                                               Row(
  //                                                 children: [
  //                                                   Text(
  //                                                     // '',
  //                                                     custName,
  //                                                     style: TextStyle(
  //                                                       fontSize: 15,
  //                                                       fontWeight: FontWeight.w500,
  //                                                       color: Colors.grey,
  //                                                     ),
  //                                                     strutStyle: StrutStyle(
  //                                                       height: 1.3,
  //                                                       // fontSize:,
  //                                                       forceStrutHeight: true,
  //                                                     ),
  //                                                   ),
  //
  //                                                 ],
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         SizedBox(
  //                                           height: 8,
  //                                         ),
  //                                         Row(
  //                                           children: [
  //                                             if(item.split('^')[5] == '0.0')
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(left: 0.0),
  //                                                 child: Container(
  //                                                   height: 21,
  //                                                   decoration: BoxDecoration(
  //                                                     borderRadius: BorderRadius.circular(20.0),
  //                                                     color: AppTheme.badgeBgSuccess,
  //                                                   ),
  //                                                   child: Padding(
  //                                                     padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                     child: Text('Paid',
  //                                                       style: TextStyle(
  //                                                           fontSize: 13,
  //                                                           fontWeight: FontWeight.w500,
  //                                                           color: Colors.white
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //
  //                                             if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(left: 0.0),
  //                                                 child: Container(
  //                                                   height: 21,
  //                                                   decoration: BoxDecoration(
  //                                                     borderRadius: BorderRadius.circular(20.0),
  //                                                     color: AppTheme.badgeFgDangerLight,
  //                                                   ),
  //                                                   child: Padding(
  //                                                     padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                     child: Text('Partially paid',
  //                                                       style: TextStyle(
  //                                                           fontSize: 13,
  //                                                           fontWeight: FontWeight.w500,
  //                                                           color: AppTheme.badgeFgDanger
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(left: 0.0),
  //                                                 child: Container(
  //                                                   height: 21,
  //                                                   decoration: BoxDecoration(
  //                                                     borderRadius: BorderRadius.circular(20.0),
  //                                                     color: AppTheme.badgeFgDanger,
  //                                                   ),
  //                                                   child: Padding(
  //                                                     padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                     child: Text('Unpaid',
  //                                                       style: TextStyle(
  //                                                           fontSize: 13,
  //                                                           fontWeight: FontWeight.w500,
  //                                                           color: Colors.white
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             if(item.split('^')[4] == 'TRUE')
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(left: 6.0),
  //                                                 child: Container(
  //                                                   height: 21,
  //                                                   decoration: BoxDecoration(
  //                                                     borderRadius: BorderRadius.circular(20.0),
  //                                                     color: AppTheme.badgeBgSecond,
  //                                                   ),
  //                                                   child: Padding(
  //                                                     padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                     child: Text('Refunded',
  //                                                       style: TextStyle(
  //                                                           fontSize: 13,
  //                                                           fontWeight: FontWeight.w500,
  //                                                           color: Colors.white
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //
  //                                             if(item.split('^')[4] == 'PART')
  //                                               Padding(
  //                                                 padding: const EdgeInsets.only(left: 6.0),
  //                                                 child: Container(
  //                                                   height: 21,
  //                                                   decoration: BoxDecoration(
  //                                                     borderRadius: BorderRadius.circular(20.0),
  //                                                     color: AppTheme.badgeBgSecondLight,
  //                                                   ),
  //                                                   child: Padding(
  //                                                     padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
  //                                                     child: Text('Partially refunded',
  //                                                       style: TextStyle(
  //                                                           fontSize: 13,
  //                                                           fontWeight: FontWeight.w500,
  //                                                           color: AppTheme.badgeBgSecond
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //
  //                                           ],
  //                                         )
  //                                       ],
  //                                     ),
  //                                   ),
  //                                   Padding(
  //                                     padding: const EdgeInsets.only(left: 15.0),
  //                                     child: Container(
  //                                       decoration: BoxDecoration(
  //                                           color: AppTheme.lightBgColor,
  //                                           border: Border(
  //                                             bottom: BorderSide(
  //                                                 color: AppTheme.skBorderColor2,
  //                                                 width: documentSnapshots.length-1 == index? 0.0: 1.0),
  //                                           )),
  //                                     ),
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(right: 15.0, bottom: 5),
  //                               child: Align(
  //                                 alignment: Alignment.centerRight,
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.end,
  //                                   children: [
  //                                     Text(
  //                                       // 'MMK ',
  //                                         'MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2),
  //                                         style: TextStyle(
  //                                           fontSize: 15,
  //                                           fontWeight: FontWeight.w500,
  //                                         )),
  //                                     SizedBox(width: 10),
  //                                     Padding(
  //                                       padding: const EdgeInsets.only(bottom: 2.0),
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
  //                             )
  //                           ],
  //                         ),
  //                       );
  //                     }
  //                     item = item.split('^')[0] + '^' + item.split('^')[1] + '^' + item.split('^')[2] + '^' + 'No customer' + '&' + item.split('^')[3] + '^' + item.split('^')[4] + '^' + item.split('^')[5] + '^' + item.split('^')[6] + '^' + item.split('^')[7] + '^' + item.split('^')[8] + '^' + 's';
  //                     return GestureDetector(
  //                       onTap: () async {
  //                         debugPrint('clicked order list 1 ' + item);
  //                         closeDrawerFrom();
  //                         await Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) => BuyListInfo(data: item, toggleCoinCallback: () {}, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
  //                         );
  //                         openDrawerFrom();
  //                       },
  //                       child: Stack(
  //                         alignment: Alignment.center,
  //                         children: [
  //                           Container(
  //                             color: AppTheme.lightBgColor,
  //                             child: Column(
  //                               children: [
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
  //                                   child: Column(
  //                                     mainAxisAlignment: MainAxisAlignment.start,
  //                                     crossAxisAlignment: CrossAxisAlignment.start,
  //                                     children: [
  //                                       Padding(
  //                                         padding: const EdgeInsets.only(left: 1.0),
  //                                         child: Column(
  //                                           mainAxisAlignment: MainAxisAlignment.start,
  //                                           crossAxisAlignment: CrossAxisAlignment.start,
  //                                           children: [
  //                                             Row(
  //                                               mainAxisAlignment: MainAxisAlignment.start,
  //                                               children: [
  //                                                 // '#' + item!='' ? item.split('^')[1]: ''
  //                                                 Text(
  //                                                   // '#',
  //                                                   '#' + item.split('^')[1],
  //                                                   style: TextStyle(
  //                                                       fontSize: 16,
  //                                                       fontWeight: FontWeight.w500
  //                                                   ),
  //                                                 ),
  //                                                 SizedBox(width: 8),
  //                                                 Padding(
  //                                                   padding: const EdgeInsets.only(bottom: 1.0),
  //                                                   child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
  //                                                 ),
  //                                                 SizedBox(width: 4),
  //                                                 Text(
  //                                                   // '',
  //                                                   covertToDayNum(item.split('^')[0].substring(6,8)) + '/' + item.split('^')[0].substring(4,6) + ' ' + convertToHour(item.split('^')[7]) + ':' + zeroToTen(item.split('^')[8]) + ' ' + convertToAMPM(item.split('^')[7]),
  //                                                   style: TextStyle(
  //                                                     fontSize: 14,
  //                                                     fontWeight: FontWeight.w500,
  //                                                     color: Colors.grey,
  //                                                   ),
  //                                                 ),
  //                                                 // Text(item.split('^')[7] + ':' + item.split('^')[8] ,
  //                                                 //   style: TextStyle(
  //                                                 //     fontSize: 14,
  //                                                 //     fontWeight: FontWeight.w500,
  //                                                 //     color: Colors.grey,
  //                                                 //   ),
  //                                                 // ),
  //                                               ],
  //                                             ),
  //                                             SizedBox(
  //                                               height: 6,
  //                                             ),
  //                                             Row(
  //                                               children: [
  //                                                 Text(
  //                                                   // '',
  //                                                   'Loading',
  //                                                   style: TextStyle(
  //                                                     fontSize: 15,
  //                                                     fontWeight: FontWeight.w500,
  //                                                     color: Colors.grey,
  //                                                   ),
  //                                                   strutStyle: StrutStyle(
  //                                                     height: 1.3,
  //                                                     // fontSize:,
  //                                                     forceStrutHeight: true,
  //                                                   ),
  //                                                 ),
  //
  //                                               ],
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                       SizedBox(
  //                                         height: 8,
  //                                       ),
  //                                       Row(
  //                                         children: [
  //                                           if(item.split('^')[5] == '0.0')
  //                                             Padding(
  //                                               padding: const EdgeInsets.only(left: 0.0),
  //                                               child: Container(
  //                                                 height: 21,
  //                                                 decoration: BoxDecoration(
  //                                                   borderRadius: BorderRadius.circular(20.0),
  //                                                   color: AppTheme.badgeBgSuccess,
  //                                                 ),
  //                                                 child: Padding(
  //                                                   padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                   child: Text('Paid',
  //                                                     style: TextStyle(
  //                                                         fontSize: 13,
  //                                                         fontWeight: FontWeight.w500,
  //                                                         color: Colors.white
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //
  //                                           if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
  //                                             Padding(
  //                                               padding: const EdgeInsets.only(left: 0.0),
  //                                               child: Container(
  //                                                 height: 21,
  //                                                 decoration: BoxDecoration(
  //                                                   borderRadius: BorderRadius.circular(20.0),
  //                                                   color: AppTheme.badgeFgDangerLight,
  //                                                 ),
  //                                                 child: Padding(
  //                                                   padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                   child: Text('Partially paid',
  //                                                     style: TextStyle(
  //                                                         fontSize: 13,
  //                                                         fontWeight: FontWeight.w500,
  //                                                         color: AppTheme.badgeFgDanger
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
  //                                             Padding(
  //                                               padding: const EdgeInsets.only(left: 0.0),
  //                                               child: Container(
  //                                                 height: 21,
  //                                                 decoration: BoxDecoration(
  //                                                   borderRadius: BorderRadius.circular(20.0),
  //                                                   color: AppTheme.badgeFgDanger,
  //                                                 ),
  //                                                 child: Padding(
  //                                                   padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                   child: Text('Unpaid',
  //                                                     style: TextStyle(
  //                                                         fontSize: 13,
  //                                                         fontWeight: FontWeight.w500,
  //                                                         color: Colors.white
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           if(item.split('^')[4] == 'TRUE')
  //                                             Padding(
  //                                               padding: const EdgeInsets.only(left: 6.0),
  //                                               child: Container(
  //                                                 height: 21,
  //                                                 decoration: BoxDecoration(
  //                                                   borderRadius: BorderRadius.circular(20.0),
  //                                                   color: AppTheme.badgeBgSecond,
  //                                                 ),
  //                                                 child: Padding(
  //                                                   padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
  //                                                   child: Text('Refunded',
  //                                                     style: TextStyle(
  //                                                         fontSize: 13,
  //                                                         fontWeight: FontWeight.w500,
  //                                                         color: Colors.white
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //
  //                                           if(item.split('^')[4] == 'PART')
  //                                             Padding(
  //                                               padding: const EdgeInsets.only(left: 6.0),
  //                                               child: Container(
  //                                                 height: 21,
  //                                                 decoration: BoxDecoration(
  //                                                   borderRadius: BorderRadius.circular(20.0),
  //                                                   color: AppTheme.badgeBgSecondLight,
  //                                                 ),
  //                                                 child: Padding(
  //                                                   padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
  //                                                   child: Text('Partially refunded',
  //                                                     style: TextStyle(
  //                                                         fontSize: 13,
  //                                                         fontWeight: FontWeight.w500,
  //                                                         color: AppTheme.badgeBgSecond
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ),
  //
  //                                         ],
  //                                       )
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(left: 15.0),
  //                                   child: Container(
  //                                     decoration: BoxDecoration(
  //                                         color: AppTheme.lightBgColor,
  //                                         border: Border(
  //                                           bottom: BorderSide(
  //                                               color: AppTheme.skBorderColor2,
  //                                               width: documentSnapshots.length-1 == index? 0.0: 1.0),
  //                                         )),
  //                                   ),
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(right: 15.0, bottom: 5),
  //                             child: Align(
  //                               alignment: Alignment.centerRight,
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                 children: [
  //                                   Text(
  //                                     // 'MMK ',
  //                                       'MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2),
  //                                       style: TextStyle(
  //                                         fontSize: 15,
  //                                         fontWeight: FontWeight.w500,
  //                                       )),
  //                                   SizedBox(width: 10),
  //                                   Padding(
  //                                     padding: const EdgeInsets.only(bottom: 2.0),
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
  //                           )
  //                         ],
  //                       ),
  //                     );
  //                   }
  //               );
  //             }
  //           },
  //           // orderBy is compulsory to enable pagination
  //           // query: cateScIndex == 0 ? FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('customers').where('archive' , isEqualTo: false).where('no_default', isEqualTo: true): FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('customers').where('archive', isEqualTo: false).where('no_default', isEqualTo: true).where('debts', isGreaterThan: 0).orderBy('debts', descending: true),
  //           query:
  //           cateScIndex == 0? FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('products').where('archive' , isEqualTo: false).where("search_name", arrayContains: searchValue):
  //           cateScIndex == 1? FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('customers').where('archive' , isEqualTo: false).where("search_name", arrayContains: searchValue):
  //           cateScIndex == 2? FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('merchants').where('archive' , isEqualTo: false).where("search_name", arrayContains: searchValue):
  //           cateScIndex == 3? FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('order').where("search_name", arrayContains: searchValue):
  //           FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('buyOrder').where("search_name", arrayContains: searchValue),
  //           // to fetch real-time data
  //           isLive: true,
  //           intValIni: cateScIndex,
  //         ),
  //       ),
  //     ),
  //   );
  //   //       }
  //   //       return Container();
  //   //     }
  //   // );
  // }

  // overAllSearch() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 80.0),
  //     child: IgnorePointer(
  //       ignoring: !loadingSearch,
  //       child: AnimatedOpacity(
  //         opacity: loadingSearch ? 1 : 0,
  //         duration: Duration(milliseconds: 170),
  //         child: Align(
  //           alignment: Alignment.topCenter,
  //           child: ProductsFragment(toggleCoinCallback4: (String str) {  },
  //             openCartBtn: (String str) {  }, openDrawerBtn: (String str) {  },
  //             toggleCoinCallback2: (String str) {  }, toggleCoinCallback: () {  },
  //             closeDrawerBtn: (String str) {  },
  //             lowStockSnapshot: null, closeCartBtn: (String str) {  }, productsSnapshot: null, barcodeBtn: () {  }, shopId: 'CSvwPYk2ayFDo9Ou5VXg', toggleCoinCallback5: (String str) {  }, toggleCoinCallback3: (String str) {  }, searchBtn: () {  },),
  //         ),
  //       ),
  //     ),
  //   );
  //   //       }
  //   //       return Container();
  //   //     }
  //   // );
  // }

  function2() {

  }

  // overAllSearch() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 80.0),
  //     child: IgnorePointer(
  //       ignoring: !loadingSearch,
  //       child: AnimatedOpacity(
  //         opacity: loadingSearch ? 1 : 0,
  //         duration: Duration(milliseconds: 170),
  //         child: Align(
  //           alignment: Alignment.topCenter,
  //           child: Container(
  //               decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   border: Border(
  //                     top: BorderSide(
  //                         color: AppTheme.skBorderColor2,
  //                         // color: Colors.transparent,
  //                         width: 1.0),
  //                   )),
  //               child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  //                 stream: prodsSnap,
  //                 builder: (context, prodsSB) {
  //                   if(prodsSB.hasData) {
  //                     var prodsSnapOut = prodsSB.data != null ? prodsSB.data!
  //                         .data() : null;
  //                     var prods = prodsSnapOut ? ['prods'];
  //                     return BlocProvider(
  //                       create: (context) => WeatherBloc(FakeWeatherRepository()),
  //                       child: WeatherSearchPage(title: '', key: null, onPressed: () {  },),
  //                     );
  //                   }
  //                   return Container();
  //                 }
  //               )
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  //   //       }
  //   //       return Container();
  //   //     }
  //   // );
  // }

  functionA() {

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
                    )),//stoppppppp
                child: Padding(
                  padding: EdgeInsets.only(bottom: 141),
                  child: sliverBodyWidget(),
                )
            ),
          ),
          // child: Align(
          //   alignment: Alignment.topCenter,
          //   child: Container(
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           border: Border(
          //             top: BorderSide(
          //                 color: AppTheme.skBorderColor2,
          //                 // color: Colors.transparent,
          //                 width: 1.0),
          //           )),//stoppppppp
          //       child: CustomScrollView(
          //         controller: _scrollController,
          //         slivers: [
          //           SliverAppBar(
          //             elevation: 0,
          //             backgroundColor: Colors.white,
          //             // Provide a standard title.
          //             // Allows the user to reveal the app bar if they begin scrolling
          //             // back up the list of items.
          //             floating: true,
          //             flexibleSpace: Padding(
          //               padding: const EdgeInsets.only(left: 0.0, top: 12.0, bottom: 12.0),
          //               child: Container(
          //                 height: 32,
          //                 width: MediaQuery.of(context).size.width,
          //                 // color: Colors.yellow,
          //                 child: Row(
          //                   children: [
          //                     Expanded(
          //                       child: ListView(
          //                         controller: cateScCtler,
          //                         scrollDirection: Axis.horizontal,
          //                         children: [
          //                           SizedBox(
          //                             width: 11,
          //                           ),
          //                           Padding(
          //                             padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          //                             child: FlatButton(
          //                               minWidth: 0,
          //                               padding: EdgeInsets.only(left: 12, right: 12),
          //                               color: cateScIndex == 0 ? AppTheme.secButtonColor:Colors.white,
          //                               shape: RoundedRectangleBorder(
          //                                 borderRadius: BorderRadius.circular(20.0),
          //                                 side: BorderSide(
          //                                   color: AppTheme.skBorderColor2,
          //                                 ),
          //                               ),
          //                               onPressed: () {
          //                                 // _animateToIndex(0);
          //                                 if(cateScIndex != 0) {
          //                                   i0Clicked = true;
          //                                 } else {
          //                                   if(i0Clicked) {
          //                                     i0Clicked = false;
          //                                   } else {
          //                                     i0Clicked = true;
          //                                   }
          //                                 }
          //
          //                                 selectedIntVal(0);
          //                                 itemPerPage = 10;
          //                                 endOfResult = false;
          //                               },
          //                               child: Container(
          //                                 child: Text(
          //                                   'Products',
          //                                   textAlign: TextAlign.center,
          //                                   style: TextStyle(
          //                                       fontSize: 14,
          //                                       fontWeight: FontWeight.w500,
          //                                       color: Colors.black),
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                           Padding(
          //                             padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          //                             child: FlatButton(
          //                               minWidth: 0,
          //                               padding: EdgeInsets.only(left: 12, right: 12),
          //                               color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
          //                               shape: RoundedRectangleBorder(
          //                                 borderRadius: BorderRadius.circular(20.0),
          //                                 side: BorderSide(
          //                                   color: AppTheme.skBorderColor2,
          //                                 ),
          //                               ),
          //                               onPressed: () {
          //                                 // _animateToIndex(20);
          //                                 if(cateScIndex != 1) {
          //                                   i1Clicked = true;
          //                                 } else {
          //                                   if(i1Clicked) {
          //                                     i1Clicked = false;
          //                                   } else {
          //                                     i1Clicked = true;
          //                                   }
          //                                 }
          //
          //                                 selectedIntVal(1);
          //                                 itemPerPage = 10;
          //                                 endOfResult = false;
          //
          //                               },
          //                               child: Container(
          //                                 child: Text(
          //                                   'Customers',
          //                                   textAlign: TextAlign.center,
          //                                   style: TextStyle(
          //                                       fontSize: 14,
          //                                       fontWeight: FontWeight.w500,
          //                                       color: Colors.black),
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                           Padding(
          //                             padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          //                             child: FlatButton(
          //                               minWidth: 0,
          //                               padding: EdgeInsets.only(left: 12, right: 12),
          //                               color: cateScIndex == 2 ? AppTheme.secButtonColor:Colors.white,
          //                               shape: RoundedRectangleBorder(
          //                                 borderRadius: BorderRadius.circular(20.0),
          //                                 side: BorderSide(
          //                                   color: AppTheme.skBorderColor2,
          //                                 ),
          //                               ),
          //                               onPressed: () {
          //                                 // _animateToIndex(2);
          //                                 if(cateScIndex != 2) {
          //                                   i2Clicked = true;
          //                                 } else {
          //                                   if(i2Clicked) {
          //                                     i2Clicked = false;
          //                                   } else {
          //                                     i2Clicked = true;
          //                                   }
          //                                 }
          //
          //                                 selectedIntVal(2);
          //                                 itemPerPage = 10;
          //                                 endOfResult = false;
          //                               },
          //                               child: Container(
          //                                 child: Text(
          //                                   'Merchants',
          //                                   textAlign: TextAlign.center,
          //                                   style: TextStyle(
          //                                       fontSize: 14,
          //                                       fontWeight: FontWeight.w500,
          //                                       color: Colors.black),
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                           Padding(
          //                             padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          //                             child: FlatButton(
          //                               minWidth: 0,
          //                               padding: EdgeInsets.only(left: 12, right: 12),
          //                               color: cateScIndex == 3 ? AppTheme.secButtonColor:Colors.white,
          //                               shape: RoundedRectangleBorder(
          //                                 borderRadius: BorderRadius.circular(20.0),
          //                                 side: BorderSide(
          //                                   color: AppTheme.skBorderColor2,
          //                                 ),
          //                               ),
          //                               onPressed: () {
          //                                 // _animateToIndex(0);
          //                                 selectedIntVal(3);
          //                               },
          //                               child: Container(
          //                                 child: Text(
          //                                   'Sale orders',
          //                                   textAlign: TextAlign.center,
          //                                   style: TextStyle(
          //                                       fontSize: 14,
          //                                       fontWeight: FontWeight.w500,
          //                                       color: Colors.black),
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                           Padding(
          //                             padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          //                             child: FlatButton(
          //                               minWidth: 0,
          //                               padding: EdgeInsets.only(left: 12, right: 12),
          //                               color: cateScIndex == 4 ? AppTheme.secButtonColor:Colors.white,
          //                               shape: RoundedRectangleBorder(
          //                                 borderRadius: BorderRadius.circular(20.0),
          //                                 side: BorderSide(
          //                                   color: AppTheme.skBorderColor2,
          //                                 ),
          //                               ),
          //                               onPressed: () {
          //                                 // _animateToIndex(0);
          //                                 selectedIntVal(4);
          //                               },
          //                               child: Container(
          //                                 child: Text(
          //                                   'Buy orders',
          //                                   textAlign: TextAlign.center,
          //                                   style: TextStyle(
          //                                       fontSize: 14,
          //                                       fontWeight: FontWeight.w500,
          //                                       color: Colors.black),
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                           SizedBox(
          //                             width: 11,
          //                           ),
          //                         ],
          //                       ),
          //                     )
          //                   ],
          //                 ),
          //
          //               ),
          //             ),),
          //           sliverBodyWidget(),
          //           sliverBotBar(),
          //         ],
          //       )
          //   ),
          // ),
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
                    textAlign: TextAlign.center, textScaleFactor: 1,
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
    switch (input) {
      case '00':
        return '00';
        break;
      case '01':
        return '01';
        break;
      case '02':
        return '02';
        break;
      case '03':
        return '03';
        break;
      case '04':
        return '04';
        break;
      case '05':
        return '05';
        break;
      case '06':
        return '06';
        break;
      case '07':
        return '07';
        break;
      case '08':
        return '08';
        break;
      case '09':
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
        '0', textScaleFactor: 1,
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
        header.split('^')[1], textScaleFactor: 1,
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
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
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
      body: Container(
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
                                            textInputAction: TextInputAction.done,
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
                                                fontSize: 18/scaleFactor,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black
                                            ),
                                            strutStyle: StrutStyle(
                                                forceStrutHeight: true,
                                                height: 1.3
                                            ),

                                            decoration: InputDecoration(
                                              hintText: widget.isEnglish? 'Search': 'ရှာဖွေရန်',
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
                                              hintStyle: widget.isEnglish ?
                                              TextStyle(
                                                  color: Colors.black.withOpacity(0.55), fontSize: 18/scaleFactor,
                                              ):
                                              TextStyle(
                                                  color: Colors.black.withOpacity(0.55), fontSize: 18/scaleFactor,
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
                                debugPrint('stfu ');
                                widget._chgIndex(0);
                                FocusScope.of(context).unfocus();
                                // Navigator.of(context).pushReplacement(
                                //     FadeRoute(page: HomePage(deviceId: widget.deviceId))
                                // );

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

  var prods;
  Map<dynamic, dynamic> searchProds = {};

  void searchKeyChanged() {
    // prodResults = [];
    // int i = 0;
    // workCacheProds.forEach((element) {
    //   if(i == workCacheProds.length-1) {
    //     setState(() {});
    //   }
    //   if(element['prod_name'].toLowerCase().contains(searchValue)) {
    //     prodResults.add(element['prod_name'] + ' ' + element.id);
    //   }
    //   i += 1;
    // });

    debugPrint('setting state ');
    prods = {};
    searchProds = {};



    if(cateScIndex == 0) {
      if(searchValue != '' && searchValue != ' ') {
        var prodsSnapOut = prodsEvent != null? prodsEvent: null;
        prods = prodsSnapOut?['prods'];
        noFind = false;
        if(i0Clicked) {
          prods = sortMapByNaS(prods);
        } else {
          prods = sortMapByImS(prods);
        }
        int actualLen = 0;
        for(int i = 0; i < prods.length; i++) {
          var eachMap = prods.entries.elementAt(i);
          if(eachMap.value['na'] != null) {
            if(eachMap.value['na'].toLowerCase().contains(searchValue)) {
              actualLen++;
            }
          }
        }

        for(int i = 0; i < prods.length; i++) {
          var eachMap = prods.entries.elementAt(i);
          if(eachMap.value['na'] != null) {
            if(eachMap.value['na'].toLowerCase().contains(searchValue)) {
              debugPrint('each map ' + eachMap.value['na'].toString());
              searchProds[eachMap.key] = eachMap.value;
              noResult = false;
              if(searchProds.length >= itemPerPage) {
                break;
              }
            }
          }

          if(searchProds.length >= actualLen) {
            trulyEnd();
          } else {
            endOfResult = false;
          }
        }
        if(searchProds.length == 0) {
          noResult = true;
        }
        // searchProds = sortMapByNaS(searchProds);
      }
    } else if(cateScIndex == 1) {
      if(searchValue != '' && searchValue != ' ') {
        var prodsSnapOut = custsEvent != null? custsEvent: null;
        prods = prodsSnapOut?['cus'];
        noFind = false;
        if(i1Clicked) {
          prods = sortMapByNaS(prods);
        } else {
          prods = sortMapByDeS(prods);
        }
        int actualLen = 0;
        for(int i = 0; i < prods.length; i++) {
          var eachMap = prods.entries.elementAt(i);
          if(eachMap.value['na'] != null) {
            if(eachMap.value['na'].toLowerCase().contains(searchValue)) {
              actualLen++;
            }
          }
        }


        for(int i = 0; i < prods.length; i++) {
          var eachMap = prods.entries.elementAt(i);
          if(eachMap.value['na'] != null) {
            if(eachMap.value['na'].toLowerCase().contains(searchValue)) {
              searchProds[eachMap.key] = eachMap.value;
              noResult = false;
              if(searchProds.length >= itemPerPage) {
                break;
              }
            }
          }
          // ayinLength = searchProds.length;
          if(searchProds.length >= actualLen) {
            trulyEnd();
          } else {
            endOfResult = false;
          }
        }
        if(searchProds.length == 0) {
          noResult = true;
        }
      }
    } else if(cateScIndex == 2) {
      if(searchValue != '' && searchValue != ' ') {
        var prodsSnapOut = mercsEvent != null? mercsEvent: null;
        prods = prodsSnapOut?['mer'];
        noFind = false;
        if(i2Clicked) {
          prods = sortMapByNaS(prods);
        } else {
          prods = sortMapByDeS(prods);
        }
        int actualLen = 0;
        for(int i = 0; i < prods.length; i++) {
          var eachMap = prods.entries.elementAt(i);
          if(eachMap.value['na'] != null) {
            if(eachMap.value['na'].toLowerCase().contains(searchValue)) {
              actualLen++;
            }
          }
        }


        for(int i = 0; i < prods.length; i++) {
          var eachMap = prods.entries.elementAt(i);
          if(eachMap.value['na'] != null) {
            if(eachMap.value['na'].toLowerCase().contains(searchValue)) {
              searchProds[eachMap.key] = eachMap.value;
              noResult = false;
              if(searchProds.length >= itemPerPage) {
                break;
              }
            }
          }
          // ayinLength = searchProds.length;
          if(searchProds.length >= actualLen) {
            trulyEnd();
          } else {
            endOfResult = false;
          }
        }
        if(searchProds.length == 0) {
          noResult = true;
        }
      }
    }




    if(searchValue == '') {
      noFind = true;
    }
  }

  // Map<dynamic, dynamic> searchProds = {};

  sliverBodyWidget() {
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
                              if(cateScIndex != 0) {
                                i0Clicked = true;
                              } else {
                                if(i0Clicked) {
                                  i0Clicked = false;
                                } else {
                                  i0Clicked = true;
                                }
                              }

                              selectedIntVal(0);
                              itemPerPage = 10;
                              endOfResult = false;
                              debugPrint('products clicked');
                              searchKeyChanged();
                            },
                            child: Container(
                              child: Text(
                                widget.isEnglish? 'Products': 'ကုန်ပစ္စည်း', textScaleFactor: 1,
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
                              if(cateScIndex != 1) {
                                i1Clicked = true;
                              } else {
                                if(i1Clicked) {
                                  i1Clicked = false;
                                } else {
                                  i1Clicked = true;
                                }
                              }

                              selectedIntVal(1);
                              itemPerPage = 10;
                              endOfResult = false;
                              debugPrint('customers clicked');
                              searchKeyChanged();

                            },
                            child: Container(
                              child: Text(
                                widget.isEnglish? 'Customers': 'ဖောက်သည်', textScaleFactor: 1,
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
                              if(cateScIndex != 2) {
                                i2Clicked = true;
                              } else {
                                if(i2Clicked) {
                                  i2Clicked = false;
                                } else {
                                  i2Clicked = true;
                                }
                              }

                              selectedIntVal(2);
                              itemPerPage = 10;
                              endOfResult = false;
                              debugPrint('merchants clicked');
                              searchKeyChanged();
                            },
                            child: Container(
                              child: Text(
                                widget.isEnglish? 'Merchants': 'ကုန်သည်', textScaleFactor: 1,
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
                              debugPrint('sale orders clicked');
                              searchKeyChanged();
                            },
                            child: Container(
                              child: Text(
                                widget.isEnglish? 'Sale orders': 'အရောင်းစာရင်း', textScaleFactor: 1,
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
                              debugPrint('buy orders clicked');
                              searchKeyChanged();
                            },
                            child: Container(
                              child: Text(
                                widget.isEnglish? 'Buy orders': 'အဝယ်စာရင်း', textScaleFactor: 1,
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
        cateScIndex == 0?
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              var prodMap = searchProds.entries.elementAt(index);
              var prodVal = prodMap.value;
              var prodKey = prodMap.key;
              String imgUrl = '';
              if(prodsImg[prodKey] != null) {
                imgUrl = prodsImg[prodKey]['img'].toString();
              }
              String buyPrice1 = '';
              if(prodVal['b1'].toString() == '') {
                buyPrice1 = '0';
              } else buyPrice1 = prodVal['b1'].toString();

              String buyPrice2 = '';
              if(prodVal['b2'].toString() == '') {
                buyPrice2 = '0';
              } else buyPrice2 = prodVal['b2'].toString();
              return GestureDetector(
                onTap: () async {
                  // FocusScope.of(context).unfocus();
                  // await Navigator.of(context).push(
                  //   PageRouteBuilder(
                  //     opaque: true,
                  //       maintainState: false,
                  //       pageBuilder: (context, _, __) => ProductDetailsView2(idString: prodKey.toString(), prodName: prodVal['na'], mainSell: prodVal['sm'],
                  //           mainName: prodVal['nm'], sub1Name: prodVal['n1'].toString(),
                  //           sub2Name: prodVal['n2'], barcode: prodVal['co'].toString(),
                  //           sub1Price: double.parse(prodVal['s1'].toString()), sub2Price:  double.parse(prodVal['s2'].toString()),
                  //           sub1Unit:  double.parse(prodVal['c1'].toString()), sub2Unit:  double.parse(prodVal['c2'].toString()),
                  //           subExist: prodVal['se'], mainLoss:  double.parse(prodVal['lm'].toString()), sub1Loss: double.parse(prodVal['l1'].toString()), sub2Loss:  double.parse(prodVal['l2'].toString()),
                  //           mainQty: prodVal['im'], sub1Qty: prodVal['i1'],
                  //           sub2Qty: prodVal['i2'], buyPrice1:  double.parse(prodVal['bm'].toString()),
                  //           buyPrice2: double.parse(buyPrice1), buyPrice3:  double.parse(buyPrice2),
                  //           toggleCoinCallback: addProduct1, toggleCoinCallback3: addProduct3, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, imgUrl: imgUrl)),);

                  // debugPrint('keyboard ' + MediaQuery.of(context).viewInsets.bottom.toString());



                  // if(MediaQuery.of(context).viewInsets.bottom <= 0) {
                  //   closeDrawerFrom();
                  //   await Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //         maintainState: false,
                  //         builder: (context) => ProductDetailsView2(idString: prodKey.toString(), prodName: prodVal['na'], mainSell: prodVal['sm'],
                  //             mainName: prodVal['nm'], sub1Name: prodVal['n1'].toString(),
                  //             sub2Name: prodVal['n2'], barcode: prodVal['co'].toString(),
                  //             sub1Price: double.parse(prodVal['s1'].toString()), sub2Price:  double.parse(prodVal['s2'].toString()),
                  //             sub1Unit:  double.parse(prodVal['c1'].toString()), sub2Unit:  double.parse(prodVal['c2'].toString()),
                  //             subExist: prodVal['se'], mainLoss:  double.parse(prodVal['lm'].toString()), sub1Loss: double.parse(prodVal['l1'].toString()), sub2Loss:  double.parse(prodVal['l2'].toString()),
                  //             mainQty: prodVal['im'], sub1Qty: prodVal['i1'],
                  //             sub2Qty: prodVal['i2'], buyPrice1:  double.parse(prodVal['bm'].toString()),
                  //             buyPrice2: double.parse(buyPrice1), buyPrice3:  double.parse(buyPrice2),
                  //             toggleCoinCallback: addProduct1, toggleCoinCallback3: addProduct3, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, imgUrl: imgUrl)),);
                  //   openDrawerFrom();
                  // } else {
                  //   FocusScope.of(context).unfocus();
                  // }
                  FocusScope.of(context).unfocus();
                  closeDrawerFrom();
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                        maintainState: false,
                        builder: (context) => ProductDetailsView2(isEnglish : widget.isEnglish, idString: prodKey.toString(), prodName: prodVal['na'], mainSell: prodVal['sm'],
                            mainName: prodVal['nm'], sub1Name: prodVal['n1'].toString(),
                            sub2Name: prodVal['n2'], barcode: prodVal['co'].toString(),
                            sub1Price: double.parse(prodVal['s1'].toString()), sub2Price:  double.parse(prodVal['s2'].toString()),
                            sub1Unit:  double.parse(prodVal['c1'].toString()), sub2Unit:  double.parse(prodVal['c2'].toString()),
                            subExist: prodVal['se'], mainLoss:  double.parse(prodVal['lm'].toString()), sub1Loss: double.parse(prodVal['l1'].toString()), sub2Loss:  double.parse(prodVal['l2'].toString()),
                            mainQty: prodVal['im'], sub1Qty: prodVal['i1'],
                            sub2Qty: prodVal['i2'], buyPrice1:  double.parse(prodVal['bm'].toString()),
                            buyPrice2: double.parse(buyPrice1), buyPrice3:  double.parse(buyPrice2),
                            toggleCoinCallback: addProduct1, toggleCoinCallback3: addProduct3, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, imgUrl: imgUrl, fromSearch: true,)),);
                  openDrawerFrom();
                  debugPrint('working here5');

                  // Future.delayed(const Duration(milliseconds: 1000), () {
                  //   setState(() {
                  //     searchKeyChanged();
                  //   });
                  // });




                },
                child: Padding(
                  padding:
                  EdgeInsets.only(
                      top: index == 0? 0.0: 6.0,
                      // top: 6,
                      left: 15),
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
                                          'https://htoomedia.info/smartkyat_pos/api/uploads/' +
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
                                        prodVal['na'], textScaleFactor: 1,
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
                                            '$currencyUnit ' + prodVal['sm'].toString(), textScaleFactor: 1,
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
                                          textScaleFactor: 1, style: TextStyle(
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
          // itemExtent: 104.5,
        ): cateScIndex == 1?
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              var prodMap = searchProds.entries.elementAt(index);
              var prodVal = prodMap.value;
              var prodKey = prodMap.key;
              return GestureDetector(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  closeDrawerFrom();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (
                            context) =>
                            CustomerInfoSubs(fromSearch: true, isEnglish : widget.isEnglish,
                              id: prodKey.toString(), custName: prodVal['na'], custAddress: prodVal['ad'],
                              toggleCoinCallback: addCustomer2Cart1, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                  );
                  openDrawerFrom();
                  setState(() {});
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
                              maxLines: 1, textScaleFactor: 1,
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
                                    prodVal['ad'].toString(), textScaleFactor: 1,
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
                                    prodVal['ph'].toString(), textScaleFactor: 1,
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
                                  prodVal['de'] == null? Container(height: 21,): prodVal['de'] > 0? Container(
                                    height: 21,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: AppTheme.badgeFgDanger,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                      child: Text(prodVal['de'].round().toString() + ' unpaid',
                                        textScaleFactor: 1, style: TextStyle(
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
        ): cateScIndex == 2?
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              var prodMap = searchProds.entries.elementAt(index);
              var prodVal = prodMap.value;
              var prodKey = prodMap.key;
              return GestureDetector(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  closeDrawerFrom();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (
                            context) =>
                            MerchantInfoSubs(fromSearch: true,isEnglish : widget.isEnglish,
                              id: prodKey.toString(), mercName: prodVal['na'], mercAddress: prodVal['ad'],
                              toggleCoinCallback: addMerchant2Cart, shopId: widget.shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                  );
                  openDrawerFrom();
                  setState(() {});
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
                              prodVal['na'].toString(), textScaleFactor: 1,
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
                                    prodVal['ad'], textScaleFactor: 1,
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
                                    prodVal['ph'].toString(), textScaleFactor: 1,
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
                                        textScaleFactor: 1, style: TextStyle(
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
        ): cateScIndex == 3?
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('shops')
                .doc(widget.shopId)
                .collection('order')
                .where('orderId', isEqualTo: searchValue)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
              String info = 'sm';
              if(snapshot1.hasData) {
                debugPrint('snapping ' + snapshot1.data!.docs.toString());
                if(snapshot1.data!.docs.length == 0 && searchValue != ''){
                  info = 'no';
                } else if(snapshot1.data!.docs.length > 0 && searchValue != '') {
                  info = 'er';
                } else {
                  info = 'sm';
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      if(index == snapshot1.data!.docs.length) {
                        if(info == 'no') {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      'No result found', textScaleFactor: 1,
                                      strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),),
                                  )
                              ),
                            ],
                          );
                        } else if(info == 'er') {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      'End of results', textScaleFactor: 1,
                                      strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),),
                                  )
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      'Search order (eg. 1001)', textScaleFactor: 1,
                                      strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),),
                                  )
                              ),
                            ],
                          );
                        }

                      }
                      DateTime chgDate = DateFormat("yyyy-MM-dd HH:mm").parse(snapshot1.data!.docs[index]['dateTime'].substring(0,4) + '-' +snapshot1.data!.docs[index]['dateTime'].substring(4,6)  + '-' + snapshot1.data!.docs[index]['dateTime'].substring(6,8) + ' ' + snapshot1.data!.docs[index]['dateTime'].substring(8,10)  + ':' +snapshot1.data!.docs[index]['dateTime'].substring(10,12));
                      debugPrint('chgDate' + chgDate.toString());
                      chgDate = chgDate.add(Duration(minutes: calHourFromTZ(chgDate)));
                      String modDateTime = chgDate.year.toString() + zeroToTen(chgDate.month.toString()) + zeroToTen(chgDate.day.toString()) + zeroToTen(chgDate.hour.toString()) + zeroToTen(chgDate.minute.toString());
                      debugPrint('modDateTime' + modDateTime.toString());
                      return GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          closeDrawerFrom();
                          await Navigator.push(
                            context,
                            MaterialPageRoute(

                                builder: (context) => OrderInfoSub(isEnglish : widget.isEnglish, fromSearch: true, data: modDateTime + '^' + snapshot1.data!.docs[index]['deviceId'] + snapshot1.data!.docs[index]['orderId'] + '^' + snapshot1.data!.docs[index]['total'].toString() + '^' + snapshot1.data!.docs[index]['cusName'] + '&' + snapshot1.data!.docs[index]['customerId'] + '^' +  snapshot1.data!.docs[index]['refund'] + '^' + snapshot1.data!.docs[index]['debt'].toString() + '^' +  snapshot1.data!.docs[index]['discount'].toString(), toggleCoinCallback: () {}, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                          );
                          openDrawerFrom();
                          setState(() {});
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
                                                    '#' + snapshot1.data!.docs[index]['deviceId'] + snapshot1.data!.docs[index]['orderId'],
                                                    textScaleFactor: 1, style: TextStyle(
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
                                                    covertToDayNum(modDateTime.substring(6,8).toString()) + '/' + modDateTime.substring(4,6).toString() + '/' + modDateTime.substring(0,4).toString() + ' ' + convertToHour(modDateTime.substring(8,10).toString()) + ':' + (modDateTime.substring(10,12).toString()) + ' ' + convertToAMPM(modDateTime.substring(8,10).toString()),
                                                    textScaleFactor: 1, style: TextStyle(
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
                                                    snapshot1.data!.docs[index]['cusName'],
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.grey,
                                                    ), textScaleFactor: 1,
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
                                            if(snapshot1.data!.docs[index]['debt'] == 0)
                                              Padding(
                                                padding: const EdgeInsets.only(left: 0.0),
                                                child: Container(
                                                  height: 21,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    color: AppTheme.badgeBgSuccess,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                                    child: Text(widget.isEnglish? 'Paid': 'ရှင်းပြီး',
                                                      strutStyle: StrutStyle(
                                                        height: 1.25,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                          fontSize: widget.isEnglish? 13: 12,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            if(snapshot1.data!.docs[index]['debt'] != 0 && double.parse(snapshot1.data!.docs[index]['total']) > snapshot1.data!.docs[index]['debt'])
                                              Padding(
                                                padding: const EdgeInsets.only(left: 0.0),
                                                child: Container(
                                                  height: 21,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    color: AppTheme.badgeFgDangerLight,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                                    child: Text(widget.isEnglish? 'Partially paid': 'တချို့တဝက် ရှင်းပြီး',
                                                      textScaleFactor: 1,
                                                      strutStyle: StrutStyle(
                                                        height: 1.25,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                      style: TextStyle(
                                                          fontSize: widget.isEnglish? 13: 12,
                                                          fontWeight: FontWeight.w500,
                                                          color: AppTheme.badgeFgDanger
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if(snapshot1.data!.docs[index]['debt'] != 0  && double.parse(snapshot1.data!.docs[index]['total']) == snapshot1.data!.docs[index]['debt'])
                                              Padding(
                                                padding: const EdgeInsets.only(left: 0.0),
                                                child: Container(
                                                  height: 21,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    color: AppTheme.badgeFgDanger,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                                    child: Text(widget.isEnglish? 'Unpaid': 'မရှင်းသေး',
                                                      textScaleFactor: 1,
                                                      strutStyle: StrutStyle(
                                                        height: 1.25,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                      style: TextStyle(
                                                          fontSize: widget.isEnglish? 13: 12,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if(snapshot1.data!.docs[index]['refund'] == 'T')
                                              Padding(
                                                padding: const EdgeInsets.only(left: 6.0),
                                                child: Container(
                                                  height: 21,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    color: AppTheme.badgeBgSecond,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                                    child: Text(widget.isEnglish? 'Refunded': 'ပြန်ပေး',
                                                      textScaleFactor: 1,
                                                      strutStyle: StrutStyle(
                                                        height: 1.25,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                      style: TextStyle(
                                                          fontSize: widget.isEnglish? 13: 12,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                            if(snapshot1.data!.docs[index]['refund'] == 'P')
                                              Padding(
                                                padding: const EdgeInsets.only(left: 6.0),
                                                child: Container(
                                                  height: 21,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    color: AppTheme.badgeBgSecondLight,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 0, left: 13.0, right: 13.0),
                                                    child: Text(widget.isEnglish? 'Partially refunded': 'တချို့တဝက် ပြန်ပေး',
                                                      textScaleFactor: 1,
                                                      strutStyle: StrutStyle(
                                                        height: 1.25,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                      style: TextStyle(
                                                          fontSize: widget.isEnglish? 13: 12,
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
                                                width: snapshot1.data!.docs.length-1 == index? 0.0: 1.0),
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
                                        'MMK ' + double.parse(snapshot1.data!.docs[index]['total'],).toStringAsFixed(2),
                                        textScaleFactor: 1,
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
                    childCount: snapshot1.data!.docs == null? 1: snapshot1.data!.docs.length + 1,
                    // childCount: 1,
                  ),
                );
              }
              return SliverList(delegate: SliverChildBuilderDelegate((context, index) {return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          'Order has no data', textScaleFactor: 1,
                          strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),),
                      )
                  ),
                ],
              );}, childCount: 1,),);
            }
        ): StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('shops')
                .doc(widget.shopId)
                .collection('buyOrder')
                .where('orderId', isEqualTo: searchValue)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
              String info = 'sm';
              if(snapshot2.hasData) {

                debugPrint('snapping ' + snapshot2.data!.docs.toString());
                if(snapshot2.data!.docs.length == 0 && searchValue != ''){
                  info = 'no';
                } else if(snapshot2.data!.docs.length > 0 && searchValue != '') {
                  info = 'er';
                } else {
                  info = 'sm';
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      if(index == snapshot2.data!.docs.length) {
                        if(info == 'no') {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      'No result found', textScaleFactor: 1,
                                      strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),),
                                  )
                              ),
                            ],
                          );
                        } else if(info == 'er') {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      'End of results', textScaleFactor: 1,
                                      strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),),
                                  )
                              ),
                            ],
                          );
                        } else {

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      'Search order (eg. 1001)', textScaleFactor: 1,
                                      strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),),
                                  )
                              ),
                            ],
                          );
                        }

                      }
                      DateTime chgDate = DateFormat("yyyy-MM-dd HH:mm").parse(snapshot2.data!.docs[index]['dateTime'].substring(0,4) + '-' +snapshot2.data!.docs[index]['dateTime'].substring(4,6)  + '-' +snapshot2.data!.docs[index]['dateTime'].substring(6,8) + ' ' +snapshot2.data!.docs[index]['dateTime'].substring(8,10)  + ':' +snapshot2.data!.docs[index]['dateTime'].substring(10,12));
                      debugPrint('chgDate' + chgDate.toString());
                      chgDate = chgDate.add(Duration(minutes: calHourFromTZ(chgDate)));
                      String modDateTime = chgDate.year.toString() + zeroToTen(chgDate.month.toString()) + zeroToTen(chgDate.day.toString()) + zeroToTen(chgDate.hour.toString()) + zeroToTen(chgDate.minute.toString());
                      debugPrint('modDateTime' + modDateTime.toString());
                      return GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          closeDrawerFrom();
                          await Navigator.push(
                            context,
                            MaterialPageRoute(

                                builder: (context) => BuyListInfo(isEnglish : widget.isEnglish, fromSearch: true, data: modDateTime + '^' + snapshot2.data!.docs[index]['deviceId'] + snapshot2.data!.docs[index]['orderId'] + '^' + snapshot2.data!.docs[index]['total'].toString() + '^' + snapshot2.data!.docs[index]['merName'] + '&' +snapshot2.data!.docs[index]['merchantId'] + '^' +  snapshot2.data!.docs[index]['refund'] + '^' + snapshot2.data!.docs[index]['debt'].toString() + '^' +  snapshot2.data!.docs[index]['discount'].toString(), toggleCoinCallback: () {}, shopId: shopId.toString(), closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, printFromOrders: printFromOrdersFun, selectedDev: widget.selectedDev,)),
                          );
                          openDrawerFrom();
                          setState(() {});
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
                                                    textScaleFactor: 1, style: TextStyle(
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
                                                    covertToDayNum(modDateTime.substring(6,8)) + '/' + modDateTime.substring(4,6) + '/' + modDateTime.substring(0,4) + ' ' + convertToHour(modDateTime.substring(8,10)) + ':' + (modDateTime.substring(10,12)) + ' ' + convertToAMPM(modDateTime.substring(8,10).toString()),
                                                    textScaleFactor: 1, style: TextStyle(
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
                                                    snapshot2.data!.docs[index]['merName'], textScaleFactor: 1,
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
                                                    padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                                    child: Text(widget.isEnglish? 'Paid': 'ရှင်းပြီး',
                                                      textScaleFactor: 1, strutStyle: StrutStyle(
                                                        height: 1.25,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                      style: TextStyle(
                                                          fontSize: widget.isEnglish? 13: 12,
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
                                                    padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                                    child: Text(widget.isEnglish? 'Partially paid': 'တချို့တဝက် ရှင်းပြီး',
                                                      textScaleFactor: 1, strutStyle: StrutStyle(
                                                        height: 1.25,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                      style: TextStyle(
                                                          fontSize: widget.isEnglish? 13: 12,
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
                                                    padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                                    child: Text(widget.isEnglish? 'Unpaid': 'မရှင်းသေး',
                                                      textScaleFactor: 1, strutStyle: StrutStyle(
                                                        height: 1.25,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                      style: TextStyle(
                                                          fontSize: widget.isEnglish? 13: 12,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if(snapshot2.data!.docs[index]['refund'] == 'T')
                                              Padding(
                                                padding: const EdgeInsets.only(left: 6.0),
                                                child: Container(
                                                  height: 21,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    color: AppTheme.badgeBgSecond,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 0, left: 12.0, right: 12.0),
                                                    child: Text(widget.isEnglish? 'Refunded': 'ပြန်ပေး',
                                                      textScaleFactor: 1, strutStyle: StrutStyle(
                                                        height: 1.25,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                      style: TextStyle(
                                                          fontSize: widget.isEnglish? 13: 12,
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
                                                    padding: const EdgeInsets.only(top: 0.0, left: 12.0, right: 12.0),
                                                    child: Text(widget.isEnglish? 'Partially refunded': 'တချို့တဝက် ပြန်ပေး',
                                                      textScaleFactor: 1, strutStyle: StrutStyle(
                                                        height: 1.25,
                                                        // fontSize:,
                                                        forceStrutHeight: true,
                                                      ),
                                                      style: TextStyle(
                                                          fontSize: widget.isEnglish? 13: 12,
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
                                        textScaleFactor: 1, style: TextStyle(
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
                    childCount: snapshot2.data!.docs == null? 1: snapshot2.data!.docs.length + 1,
                    // childCount: 1,
                  ),
                );
              }
              return SliverList(delegate: SliverChildBuilderDelegate((context, index) {return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          'Order has no data', textScaleFactor: 1,
                          strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),),
                      )
                  ),
                ],
              );}, childCount: 1,),);
            }
        ),
        if(cateScIndex != 3 && cateScIndex != 4)
          sliverBotBar()
      ],
    );
  }

  sliverBotBar() {
    return SliverAppBar(
      toolbarHeight: 30,
      elevation: 0,
      backgroundColor: Colors.white,
      // Provide a standard title.
      // Allows the user to reveal the app bar if they begin scrolling
      // back up the list of items.
      floating: true,
      flexibleSpace: noFind? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  'Search something', textScaleFactor: 1,
                  strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),),
              )
          ),
        ],
      ): noResult? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  'No result found', textScaleFactor: 1,
                  strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),),
              )
          ),
        ],
      ): !endOfResult?
      Container(
        child: LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
      ):
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              child: Text(
                // searchProds.length == 0? 'sps': 'End of results',
                'End of results', textScaleFactor: 1,
                strutStyle: StrutStyle(forceStrutHeight: true, height: 1.2),)
          ),
        ],
      ),
    );
  }

  void trulyEnd() {
    endOfResult = true;
  }


}

Future<String> getStoreId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // return(prefs.getString('store'));

  var index = prefs.getString('store');
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

calHourFromTZ(DateTime dateTime) {
  return dateTime.timeZoneOffset.inMinutes;
}

zeroToTen(String string) {
  if (int.parse(string) > 9) {
    return string;
  } else {
    return '0' + string;
  }
}