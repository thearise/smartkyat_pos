
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartkyat_pos/app_theme.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/pages2/TabItem.dart';

import '../fragments/home_fragment_off.dart';
import '../fragments/orders_fragment_off.dart';
import '../fragments/products_fragment_off.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageOff extends StatefulWidget {
  @override
  _HomePageOffState createState() => _HomePageOffState();
}

class _HomePageOffState extends State<HomePageOff> {
  var role = 'admin';

  getStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('store');
  }

  GlobalKey<OverviewPageState> homeGlobalKey = GlobalKey();
  GlobalKey<ProductsFragmentState> prodGlobalKey = GlobalKey();
  GlobalKey<OrdersFragmentState> sordGlobalKey = GlobalKey();

  @override
  initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      WidgetsFlutterBinding.ensureInitialized();
      setState(() {
        tabs = [
          // TabItem(
          //   tabName: "Champions",
          //   icon: Icon(
          //     Icons.add,
          //   ),
          //   page: OverviewPage(key: homeGlobalKey, barcodeBtn: openBarcodeSearch, searchBtn: openSearchFromFrag, premiumCart: premiumCart, howToCart: howToCart,
          //     toggleCoinCallback:addMerchant2Cart, toggleCoinCallback2: addCustomer2Cart, toggleCoinCallback3: addProduct, toggleCoinCallback4: addProduct3, shopId: 'shopId', openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom, isEnglish: true,
          //   ),
          // ),
          // TabItem(
          //   tabName: "Settings",
          //   icon: Icon(
          //     Icons.add,
          //   ),
          //   page: ProductsFragment(
          //     key: prodGlobalKey,
          //     isEnglish: true,
          //     // checkDOpen: checkDrawerOpen,
          //     toggleCoinCallback: addNewProd2,
          //     toggleCoinCallback2: addProduct,
          //     toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart, barcodeBtn: openBarcodeSearch, shopId: 'shopId'.toString(), searchBtn: openSearchFromFrag, closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,),
          // ),
          // TabItem(
          //   tabName: "Items",
          //   icon: Icon(
          //     Icons.add,
          //   ),
          //   page: OrdersFragment(key: sordGlobalKey, searchBtn: openSearchFromFrag, printFromOrders: printFromOrders, isEnglish: false,
          //     toggleCoinCallback2: addProduct,
          //     toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart, barcodeBtn: openBarcodeSearch, shopId: 'shopId'.toString(),  closeCartBtn: closeCartFrom, openCartBtn: openCartFrom,openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,),
          // ),
        ];
      });

      tabs.asMap().forEach((index, details) {
        details.setIndex(index);
      });
    });
    getStoreId().then((value0) {

    });
    super.initState();
  }

  int firstTime = 0;
  @override
  Widget build(BuildContext context) {
    if(firstTime <= 2) {
      tabs = [
        // TabItem(
        //   tabName: "Champions",
        //   icon: Icon(
        //     Icons.add,
        //   ),
        //   page: OverviewPage(key: homeGlobalKey, barcodeBtn: openBarcodeSearch, searchBtn: openSearchFromFrag, premiumCart: premiumCart, howToCart: howToCart,
        //     toggleCoinCallback:addMerchant2Cart, toggleCoinCallback2: addCustomer2Cart, toggleCoinCallback3: addProduct, toggleCoinCallback4: addProduct3, shopId: 'shopId', openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom, isEnglish: true,
        //   ),
        // ),
        // TabItem(
        //   tabName: "Settings",
        //   icon: Icon(
        //     Icons.add,
        //   ),
        //   page: ProductsFragment(
        //     key: prodGlobalKey,
        //     isEnglish: true,
        //     // checkDOpen: checkDrawerOpen,
        //     toggleCoinCallback: addNewProd2,
        //     toggleCoinCallback2: addProduct,
        //     toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart, barcodeBtn: openBarcodeSearch, shopId: 'shopId'.toString(), searchBtn: openSearchFromFrag, closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,),
        // ),
        // TabItem(
        //   tabName: "Items",
        //   icon: Icon(
        //     Icons.add,
        //   ),
        //   page: OrdersFragment(key: sordGlobalKey, searchBtn: openSearchFromFrag, printFromOrders: printFromOrders, isEnglish: false,
        //     toggleCoinCallback2: addProduct,
        //     toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart, barcodeBtn: openBarcodeSearch, shopId: 'shopId'.toString(),  closeCartBtn: closeCartFrom, openCartBtn: openCartFrom,openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,),
        // ),
      ];
      setState(() {

      });
      firstTime += 1;
    }

    return Scaffold(
      onEndDrawerChanged: (isOpened) {
        if(isOpened) {
          debugPrint('opening 2');
          // searchGlobalKey.currentState!.unfocusSearch();
        }
      },
      onDrawerChanged: (isOpened) {
        if(isOpened) {
        }
      },
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      // key: _scaffoldKey,
      // drawerEdgeDragWidth: drawerDrag? 0: 20,
      //drawerEdgeDragWidth: 0,
      drawer: new Drawer(
        child: Container(
          color: Colors.white,
          child: SafeArea(
            top: true,
            bottom: true,
            child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 81,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1.0))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                          child: GestureDetector(
                            onTap: () async {
                              // Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  'shopName'.toString(),overflow: TextOverflow.ellipsis, textScaleFactor: 1,
                                  style: TextStyle(
                                      height: 2, fontSize: 18, fontWeight: FontWeight.w500),
                                  strutStyle: StrutStyle(
                                    height: 2,
                                    // fontSize:,
                                    forceStrutHeight: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 0,
                                ),
                                Transform.translate(
                                  offset: Offset(0, -5),
                                  child: Text(
                                    'shopAddress'.toString(),textScaleFactor: 1,overflow: TextOverflow.ellipsis,
                                    style: TextStyle(height: 2, fontSize: 14),
                                    strutStyle: StrutStyle(
                                      height: 2,
                                      // fontSize:,
                                      forceStrutHeight: true,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],),
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          // child: new Column(children: drawerOptions),
                          child: Stack(
                            children: [
                              new Column(children: [
                                if (role == 'admin' || role == 'owner')
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectTab(0);
                                        _selectIndex = 0;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                      child: new Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: _selectIndex == 0? AppTheme.secButtonColor: Colors.transparent),
                                        height: 50,
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 18.0, right: 15.0, bottom: 2.0),
                                              child: Icon(
                                                // Icons.home_filled,
                                                SmartKyat_POS.home,
                                                size: 20,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 1.0),
                                              child: Text(
                                                'textSetHome', textScaleFactor: 1,
                                                style: TextStyle(
                                                    fontSize: 17, fontWeight: FontWeight.w500),
                                                strutStyle: StrutStyle(
                                                    forceStrutHeight: true,
                                                    height: 1.3
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                GestureDetector(
                                  onTap: () {
                                    // homeGlobalKey.currentState!.closeSearch();
                                    // prodGlobalKey.currentState!.closeSearch();
                                    // custGlobalKey.currentState!.closeSearch();
                                    // mercGlobalKey.currentState!.closeSearch();
                                    // sordGlobalKey.currentState!.closeSearch();
                                    // bordGlobalKey.currentState!.closeSearch();

                                    // Future.delayed(const Duration(milliseconds: 500), () {
                                    setState(() {
                                      _selectTab(1);
                                      _selectIndex = 1;
                                    });

                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: new Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: _selectIndex == 1? AppTheme.secButtonColor: Colors.transparent),
                                      height: 50,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 18.0, right: 15.0, bottom: 1),
                                            child: Icon(
                                              SmartKyat_POS.product,
                                              size: 21,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 1.0),
                                            child: Text(
                                              'textSetProd', textScaleFactor: 1,
                                              style: TextStyle(
                                                  fontSize: 17, fontWeight: FontWeight.w500),
                                              strutStyle: StrutStyle(
                                                  forceStrutHeight: true,
                                                  height: 1.3
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                    child: new Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.transparent),
                                      height: 50,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 18.0, right: 14.0, bottom: 2),
                                            child: Icon(
                                              SmartKyat_POS.order,
                                              size: 23,
                                            ),
                                          ),
                                          Text(
                                            'textSetOrd', textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 17, fontWeight: FontWeight.w500),
                                            strutStyle: StrutStyle(
                                                forceStrutHeight: true,
                                                height: 1.3
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              (role == 'admin' || role == 'owner') ? Padding(
                                padding: const EdgeInsets.only(left: 10.0, top: 150.0),
                                child: Icon(
                                  SmartKyat_POS.merge_arrow,
                                  size: 80,
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ): Padding(
                                padding: const EdgeInsets.only(left: 10.0, top: 100.0),
                                child: Icon(
                                  SmartKyat_POS.merge_arrow2,
                                  size: 80,
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
      body: Stack(
        children: [
          WillPopScope(
            onWillPop: () async {
              final isFirstRouteInCurrentTab = !await tabs[currentTab].key.currentState!.maybePop();
              if (isFirstRouteInCurrentTab) {
                // if not on the 'main' tab
                if (currentTab != 0) {
                  // select 'main' tab
                  // _selectTab(0);
                  // back button handled by app
                  return false;
                }
              }
              // let system handle back button if we're on the first route
              return isFirstRouteInCurrentTab;
            },

            // onWillPop: () async => true,

            // onWillPop: () async => false,


            // this is the base scaffold
            // don't put appbar in here otherwise you might end up
            // with multiple appbars on one screen
            // eventually breaking the app

            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width > 900
                          ? MediaQuery.of(context).size.width * (2 / 3.5)
                          : MediaQuery.of(context).size.width,
                      child: AnimatedPadding(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width > 900 ? homeBotPadding + 41.0: !closeGoToCart? 61 + 80 : 61.0),
                        child: IndexedStack(
                          index: currentTab,
                          children: tabs.map((e) => e.page).toList(),
                          // children: [
                          //   OverviewPage(key: homeGlobalKey, barcodeBtn: openBarcodeSearch, searchBtn: openSearchFromFrag, premiumCart: premiumCart, howToCart: howToCart,
                          //     toggleCoinCallback:addMerchant2Cart, toggleCoinCallback2: addCustomer2Cart, toggleCoinCallback3: addProduct, toggleCoinCallback4: addProduct3, shopId: 'shopId', openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom, isEnglish: true,
                          //   ),
                          //   ProductsFragment(
                          //     key: prodGlobalKey,
                          //     isEnglish: true,
                          //     // checkDOpen: checkDrawerOpen,
                          //     toggleCoinCallback: addNewProd2,
                          //     toggleCoinCallback2: addProduct,
                          //     toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart, barcodeBtn: openBarcodeSearch, shopId: 'shopId'.toString(), searchBtn: openSearchFromFrag, closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,),
                          //   OrdersFragment(key: sordGlobalKey, searchBtn: openSearchFromFrag, printFromOrders: printFromOrders, isEnglish: false,
                          //     toggleCoinCallback2: addProduct,
                          //     toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart, barcodeBtn: openBarcodeSearch, shopId: 'shopId'.toString(),  closeCartBtn: closeCartFrom, openCartBtn: openCartFrom,openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,)
                          // ]
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: ,
                    // )
                  ],
                ),
                Padding(

                  padding: const EdgeInsets.only(top: 200.0),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.green,
                  ),
                )

              ],
            ),
          )
        ],
      ),
    );
  }

  List<TabItem> tabs = [];
  double homeBotPadding = 0;
  bool closeGoToCart = false;

  static int currentTab = 0;
  int _selectIndex = 0;
  void _selectTab(int index) {
    if (index == currentTab && tabs[index].key.currentState != null) {
      tabs[index].key.currentState!.popUntil((route) => route.isFirst);
    } else {
      // update the state
      // in order to repaint
      setState(() => currentTab = index);
      debugPrint('current tab ' + currentTab.toString());
    }
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   // homeGlobalKey.currentState!.changeSearchOpening(false);
    //   homeGlobalKey.currentState!.changeSearchOpening(false);
    //   prodGlobalKey.currentState!.changeSearchOpening(false);
    //   sordGlobalKey.currentState!.changeSearchOpening(false);
    //   bordGlobalKey.currentState!.changeSearchOpening(false);
    //   custGlobalKey.currentState!.changeSearchOpening(false);
    //   mercGlobalKey.currentState!.changeSearchOpening(false);
    //   settGlobalKey.currentState!.changeSearchOpening(false);
    // });

    // chgIndexFromSearch(0);
    // Future.delayed(const Duration(milliseconds: 10), () {
    //   if(_selectIndex == 0) {
    //     homeGlobalKey.currentState!.changeSearchOpening(false);
    //     prodGlobalKey.currentState!.changeSearchOpening(true);
    //     sordGlobalKey.currentState!.changeSearchOpening(true);
    //     bordGlobalKey.currentState!.changeSearchOpening(true);
    //     custGlobalKey.currentState!.changeSearchOpening(true);
    //     mercGlobalKey.currentState!.changeSearchOpening(true);
    //     settGlobalKey.currentState!.changeSearchOpening(true);
    //   } else if(_selectIndex == 1) {
    //     homeGlobalKey.currentState!.changeSearchOpening(true);
    //     prodGlobalKey.currentState!.changeSearchOpening(false);
    //     sordGlobalKey.currentState!.changeSearchOpening(true);
    //     bordGlobalKey.currentState!.changeSearchOpening(true);
    //     custGlobalKey.currentState!.changeSearchOpening(true);
    //     mercGlobalKey.currentState!.changeSearchOpening(true);
    //     settGlobalKey.currentState!.changeSearchOpening(true);
    //   } else if(_selectIndex == 2) {
    //     homeGlobalKey.currentState!.changeSearchOpening(true);
    //     prodGlobalKey.currentState!.changeSearchOpening(true);
    //     sordGlobalKey.currentState!.changeSearchOpening(false);
    //     bordGlobalKey.currentState!.changeSearchOpening(true);
    //     custGlobalKey.currentState!.changeSearchOpening(true);
    //     mercGlobalKey.currentState!.changeSearchOpening(true);
    //     settGlobalKey.currentState!.changeSearchOpening(true);
    //   }
    // });
  }

  void openSearchFromFrag() {
  }

  void openBarcodeSearch() {
  }

  void premiumCart() {
  }

  void howToCart() {
  }

  void addMerchant2Cart(String str) {

  }

  void addCustomer2Cart(str) {

  }

  void addNewProd2() {
  }

  void addProduct(str) {
  }
  void addProduct3(str) {
  }

  openDrawerFrom(String from) {
    debugPrint('FROM open' + from);
  }

  openCartFrom(String from) {
    debugPrint('FROM open' + from);
  }

  closeCartFrom(String from) {
    debugPrint('FROM open' + from);
  }

  void printFromOrders(File file, prodListPR) {
  }

  void closeDrawerFrom(str ) {

  }
}

