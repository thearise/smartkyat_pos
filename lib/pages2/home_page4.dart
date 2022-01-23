import 'dart:async';
import 'dart:convert' show base64, latin1, utf8;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:blue_print_pos/blue_print_pos.dart';
import 'package:blue_print_pos/models/blue_device.dart';
import 'package:blue_print_pos/models/connection_status.dart';
import 'package:blue_print_pos/receipt/receipt_section_text.dart';
import 'package:blue_print_pos/receipt/receipt_text_size_type.dart';
import 'package:blue_print_pos/receipt/receipt_text_style_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fraction/fraction.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/api/pdf_api.dart';
import 'package:smartkyat_pos/api/pdf_invoice_api.dart';
import 'package:smartkyat_pos/fragments/buy_list_fragment.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/fragments/customers_fragment.dart';
// import 'package:smartkyat_pos/fragments/home_fragment.dart';
import 'package:smartkyat_pos/fragments/home_fragment3.dart';
import 'package:smartkyat_pos/fragments/merchant_cart2.dart';
import 'package:smartkyat_pos/fragments/merchants_fragment.dart';
import 'package:smartkyat_pos/fragments/orders_fragment.dart';
import 'package:smartkyat_pos/fragments/products_fragment.dart';
import 'package:smartkyat_pos/fragments/settings_fragment.dart';
import 'package:smartkyat_pos/fragments/support_fragment.dart';
import 'package:smartkyat_pos/fragments/test.dart';
import 'package:smartkyat_pos/fragments/welcome_fragment.dart';
import 'package:smartkyat_pos/model/customer.dart';
import 'package:smartkyat_pos/model/invoice.dart';
import 'package:smartkyat_pos/model/supplier.dart';
import 'package:smartkyat_pos/pages2/single_assets_page.dart';
import 'package:smartkyat_pos/src/screens/loading.dart';
import 'package:smartkyat_pos/widgets/add_new_customer.dart';
import 'package:smartkyat_pos/widgets/add_new_merchant.dart';
import 'package:smartkyat_pos/widgets/barcode_search.dart';
import 'package:smartkyat_pos/widgets/end_of_pro_service.dart';
import '../app_theme.dart';
import '../fragments/search_fragment.dart';
import 'TabItem.dart';
// import 'package:cool_dropdown/cool_dropdown.dart';


import 'package:image_save/image_save.dart';
import 'package:pdf/pdf.dart' as PDF;
import 'package:pdf_render/pdf_render_widgets.dart';
// import 'package:printing/printing.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:image/image.dart' as imglib;
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as nativePDF;
import 'package:esc_pos_utils_plus/esc_pos_utils.dart' as posUtils;

import 'first_launch_page.dart';
import 'transparent.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomePage> {
  int ayinIndex = 0;

  bool globalSearching = false;

  bool globalCart = false;

  bool orderCreating = false;

  bool closeGoToCart = false;

  double _goToCartHeight = 142;

  bool drawerDrag = false;

  @override
  bool get wantKeepAlive => true;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static int currentTab = 0;
  var deviceIdNum;
  String? shopId;
  String merchantId = 'name^name';
  List<TabItem> tabs = [];

  Animation<double>? _rotationAnimation;
  Color _fabColor = Colors.blue;

  bool onChangeAmountTab = false;

  double homeBotPadding = 0;

  String shopGloName = '';
  String shopGloAddress = '';
  String shopGloPhone = '';
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  void handleSlideAnimationChanged(Animation<double>? slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool? isOpen) {
    setState(() {
      _fabColor = isOpen! ? Colors.green : Colors.blue;
    });
  }

  List<String> subList = [];
  List<String> subList2 = [];
//bool saleLoadingState = false;
  testFunc() async {
    print('hi');
    CollectionReference users = FirebaseFirestore.instance.collection('test');

    print('gg ');

    users
        .doc('TtWFXrDF1feBVlUTPyQr')
        .update({'double': FieldValue.increment(1)})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  testLoopData() {
    for(int i=0; i<1; i++) {
      testFunc();
    }
  }

  late TabController _controller;
  late TabController _controllerTablet;
  late TabController _controller2;
  late TabController _controllerTabBarCode;
  int _sliding = 0;


  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldControllerTablet = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();


  double paidAmount = 0;
  double refund = 0;
  double debt =0;
  double quantity = 0;

  double discount =0.0;
  double discountAmount =0.0;
  String disText ='';
  String isDiscount = '';
  double totalAmount = 0.0;
  double price2 = 0;

  double paidAmount2 = 0;
  double refund2 = 0;
  double debt2 =0;

  double discount2 =0.0;
  double discountAmount2 =0.0;
  String disText2 = '';
  String isDiscount2 = '';
  double totalAmount2 = 0.0;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _textFieldController.dispose();
    _textFieldControllerTablet.dispose();
    _textFieldController2.dispose();
    myController.dispose();
    sellPriceController.dispose();
    buyPriceController.dispose();
    barcodeCtrl.dispose();
    super.dispose();
  }

  GlobalKey<HomeFragmentState> homeGlobalKey = GlobalKey();
  GlobalKey<ProductsFragmentState> prodGlobalKey = GlobalKey();
  GlobalKey<BuyListFragmentState> bordGlobalKey = GlobalKey();
  GlobalKey<OrdersFragmentState> sordGlobalKey = GlobalKey();
  GlobalKey<CustomersFragmentState> custGlobalKey = GlobalKey();
  GlobalKey<MerchantsFragmentState> mercGlobalKey = GlobalKey();
  GlobalKey<SettingsFragmentState> settGlobalKey = GlobalKey();
  GlobalKey<SearchFragmentState> searchGlobalKey = GlobalKey();
  GlobalKey<TransparentState> tranGlobalKey = GlobalKey();

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  // List dropdownItemList = [];
  //
  // List<String> fruits = [
  //   'apple',
  //   'banana',
  //   'grapes',
  // ];

  List _testList =  [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];

  Stream<QuerySnapshot>? orderSnapshot;
  Stream<QuerySnapshot>? productSnapshot;
  Stream<QuerySnapshot>? productSnapshot2;
  Stream<QuerySnapshot>? merchantSnapshot;
  Stream<QuerySnapshot>? buyOrderSnapshot;
  //Stream<QuerySnapshot>? buyOrderSnapshot2;
  Stream<QuerySnapshot>? customerSnapshot;
  Stream<QuerySnapshot>? customerSnapshot2;
  Stream<QuerySnapshot>? merchantSnapshot2;
  Stream<QuerySnapshot>? homeOrderSnapshot;
  Stream<QuerySnapshot>? homeBuyOrderSnapshot;
  Stream<QuerySnapshot>? homeLossSnapshot;
  Stream<QuerySnapshot>? emailSnapshot;
  var shopSnapshot;
  Stream<QuerySnapshot>? userSnapshot;
  Stream<QuerySnapshot>? userSnapshot2;
  Stream<QuerySnapshot>? shopFoundSnapshot;
  Stream<QuerySnapshot>? lowStockSnapshot;

  bool _connectionStatus = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
            setState(() {
              _connectionStatus = true;
            });
          }
        } on SocketException catch (_) {
          setState(() {
            _connectionStatus = false;
          });
        }
        break;
      default:
        setState(() {
          // _connectionStatus = 'Failed to get connectivity.')
          _connectionStatus = false;
        });
        break;
    }
  }

  @override
  void initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((_) async {
    //   premiumCart();
    // });
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white
    ));
    _textFieldControllerTablet.addListener((){
      print("value: ${_textFieldControllerTablet.text}");
      setState(() {
        totalAmount = double.parse(TtlProdListPrice());
        _textFieldControllerTablet.text != '' ? paidAmount = double.parse(_textFieldControllerTablet.text) : paidAmount = 0.0;
        if((totalAmount - paidAmount).isNegative){
          debt = 0;
        } else { debt = (totalAmount - paidAmount);
        }
        if((paidAmount - totalAmount).isNegative){
          refund = 0;
        } else { refund = (paidAmount - totalAmount);
        }
      });
    });

    myControllerTablet.addListener((){
      setState(() {
        // mystate((){
        (myControllerTablet.text != '' && sellPriceControllerTablet.text != '') ? totalFixAmount =double.parse(myControllerTablet.text) * double.parse(sellPriceControllerTablet.text) : totalFixAmount = 0.0;
        // });
      });
    });

    sellPriceControllerTablet.addListener((){
      setState(() {
        (myControllerTablet.text != '' && sellPriceControllerTablet.text != '') ? totalFixAmount =double.parse(myControllerTablet.text) * double.parse(sellPriceControllerTablet.text) : totalFixAmount = 0.0;
        if( sellPriceControllerTablet.text != '') {
          titlePrice = double.parse(sellPriceControllerTablet.text);
          price2 = double.parse(sellPriceControllerTablet.text); } else {
          titlePrice = 0.0;
          price2 = 0;
        }
      });
    });



    // for (var i = 0; i < fruits.length; i++) {
    //   dropdownItemList.add(
    //     {
    //       'label': fruits[i] == 'melon' ? 'melon sugar high' : '${fruits[i]}',
    //       // 'label': '${fruits[i]}',
    //       'value': '${fruits[i]}',
    //       'icon': Container(
    //         key: UniqueKey(),
    //         height: 20,
    //         width: 20,
    //         child: Text('SVG'),
    //       ),
    //       'selectedIcon': Container(
    //         key: UniqueKey(),
    //         width: 20,
    //         height: 20,
    //         child: Text('SVG', style: TextStyle(color: Colors.blue),),
    //       ),
    //     },
    //   );
    // }
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    getDeviceId().then((value) {
      deviceIdNum = value;
    });


    _controller = new TabController(length: 5, vsync: this);
    _controllerTablet = new TabController(length: 5, vsync: this);
    _controller2 = new TabController(length: 3, vsync: this);
    _controllerTabBarCode = new TabController(length: 1, vsync: this);
    print('home_page' + 'sub1'.substring(3,4));

    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    slidableController1 = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    getStoreId().then((value0) {
      setState(() {
        shopId = value0;
      });
      userSnapshot2 = FirebaseFirestore.instance.collection('users').where('email', isEqualTo: auth.currentUser!.email.toString()).snapshots();
      userSnapshot = FirebaseFirestore.instance.collection('users').where('email', isEqualTo: auth.currentUser!.email.toString()).snapshots();
      emailSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('users').where('email', isEqualTo: auth.currentUser!.email.toString()).limit(1).snapshots();
      shopSnapshot =  FirebaseFirestore.instance.collection('shops').doc(shopId).snapshots();
      shopFoundSnapshot = FirebaseFirestore.instance.collection('shops').where('users', arrayContains: FirebaseAuth.instance.currentUser == null? '': FirebaseAuth.instance.currentUser!.email.toString()).snapshots();

      lowStockSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('products').orderBy('inStock1', descending: false).snapshots();
      productSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('products').snapshots();
      productSnapshot2 = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('products').snapshots();

      orderSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('orders').orderBy('date', descending: true).snapshots();
      buyOrderSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('buyOrders').orderBy('date', descending: true).snapshots();
      //buyOrderSnapshot2 = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('buyOrders').orderBy('date', descending: true).snapshots();
      customerSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('customers').where('customer_name', isNotEqualTo: 'Unknown').snapshots();
      merchantSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('merchants').where('merchant_name', isNotEqualTo: 'Unknown').snapshots();
      merchantSnapshot2 = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('merchants').snapshots();
      customerSnapshot2 = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('customers').snapshots();
      //homeOrderSnapshot =   FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('orders').orderBy('date', descending: true).snapshots();
      //homeBuyOrderSnapshot =  FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('buyOrder').where('date', isLessThanOrEqualTo: lossDayStartByDate(DateTime.now())).where('date', isGreaterThanOrEqualTo: lossDayEndByDate(DateTime.now())).orderBy('date', descending: true).snapshots();
      homeLossSnapshot =  FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('loss').where('date', isLessThanOrEqualTo: lossDayStartByDate(DateTime.now())).where('date', isGreaterThanOrEqualTo: lossDayEndByDate(DateTime.now())).orderBy('date', descending: true).snapshots();
      WidgetsFlutterBinding.ensureInitialized();
      setState(() {
        // tabs = [
        //   TabItem(
        //     tabName: "Champions",
        //     icon: Icon(
        //       Icons.add,
        //     ),
        //     page: HomeFragment(barcodeBtn: openBarcodeSearch, searchBtn: openSearchFromFrag,
        //       toggleCoinCallback:addMerchant2Cart, toggleCoinCallback2: addCustomer2Cart, toggleCoinCallback3: addProduct, toggleCoinCallback4: addProduct3, shopId: shopId, ordersSnapshot: homeOrderSnapshot, buyOrdersSnapshot: homeBuyOrderSnapshot, lossSnapshot: homeLossSnapshot
        //     ),
        //   ),
        //   TabItem(
        //     tabName: "Items",
        //     icon: Icon(
        //       Icons.add,
        //     ),
        //     page: OrdersFragment(
        //       toggleCoinCallback2: addProduct,
        //       toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart, barcodeBtn: openBarcodeSearch, shopId: shopId.toString(), ordersSnapshot: homeOrderSnapshot, customersSnapshot: customerSnapshot2,),
        //   ),
        //   TabItem(
        //     tabName: "Settings",
        //     icon: Icon(
        //       Icons.add,
        //     ),
        //     page: CustomersFragment(toggleCoinCallback2: addCustomer2Cart, toggleCoinCallback3: addMerchant2Cart, toggleCoinCallback4: addProduct, toggleCoinCallback: addProduct3, barcodeBtn: openBarcodeSearch, shopId: shopId.toString(), customersSnapshot: customerSnapshot),
        //   ),
        //   TabItem(
        //     tabName: "Settings",
        //     icon: Icon(
        //       Icons.add,
        //     ),
        //     page: ProductsFragment(
        //       toggleCoinCallback: addNewProd2,
        //       toggleCoinCallback2: addProduct,
        //       toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart, barcodeBtn: openBarcodeSearch, shopId: shopId.toString(), productsSnapshot: productSnapshot,),
        //   ),
        //   TabItem(
        //     tabName: "Settings",
        //     icon: Icon(
        //       Icons.add,
        //     ),
        //     page: MerchantsFragment(toggleCoinCallback3: addMerchant2Cart, toggleCoinCallback2: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback: addProduct, barcodeBtn: openBarcodeSearch, shopId: shopId.toString(), merchantsSnapshot: merchantSnapshot,),
        //   ),
        //   TabItem(
        //     tabName: "Settings",
        //     icon: Icon(
        //       Icons.add,
        //     ),
        //     // page: BuyListFragment(),
        //     page: SettingsFragment(changeShopCallback: chgShopIdFromSetting),
        //   ),
        //   TabItem(
        //     tabName: "Settings",
        //     icon: Icon(
        //       Icons.add,
        //     ),
        //     // page: BuyListFragment(),
        //     page: SettingsFragment(changeShopCallback: chgShopIdFromSetting),
        //   ),
        //   TabItem(
        //     tabName: "Settings",
        //     icon: Icon(
        //       Icons.add,
        //     ),
        //     // page: BuyListFragment(),
        //     page: BuyListFragment(
        //       toggleCoinCallback2: addProduct,
        //       toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart, barcodeBtn: openBarcodeSearch, shopId: shopId.toString(), buyOrdersSnapshot: homeBuyOrderSnapshot, merchantsSnapshot: merchantSnapshot2),
        //   ),
        //   TabItem(
        //     tabName: "Champions",
        //     icon: Icon(
        //       Icons.add,
        //     ),
        //     page: SearchFragment(toggleCoinCallback3: addMerchant2Cart, toggleCoinCallback2: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback: addProduct, barcodeBtn: openBarcodeSearch, chgIndexFromSearch: chgIndexFromSearch),
        //   ),
        // ];
        tabs = [
          TabItem(
            tabName: "Champions",
            icon: Icon(
              Icons.add,
            ),
            page: HomeFragment(key: homeGlobalKey, barcodeBtn: openBarcodeSearch, searchBtn: openSearchFromFrag,
              toggleCoinCallback:addMerchant2Cart, toggleCoinCallback2: addCustomer2Cart, toggleCoinCallback3: addProduct, toggleCoinCallback4: addProduct3, shopId: shopId, ordersSnapshot: orderSnapshot, buyOrdersSnapshot: buyOrderSnapshot, lossSnapshot: homeLossSnapshot, openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,
            ),
          ),
          TabItem(
            tabName: "Items",
            icon: Icon(
              Icons.add,
            ),
            page: OrdersFragment(key: sordGlobalKey, searchBtn: openSearchFromFrag, selectedDev: _selectedDevice, printFromOrders: printFromOrders,
              toggleCoinCallback2: addProduct,
              toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart, barcodeBtn: openBarcodeSearch, ordersSnapshot: orderSnapshot, customersSnapshot: customerSnapshot2, shopId: shopId.toString(),  closeCartBtn: closeCartFrom, openCartBtn: openCartFrom,openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,),
          ),
          TabItem(
            tabName: "Settings",
            icon: Icon(
              Icons.add,
            ),
            page: CustomersFragment(selectedDev: _selectedDevice, printFromOrders: printFromOrders, searchBtn: openSearchFromFrag, key: custGlobalKey, toggleCoinCallback2: addCustomer2Cart, toggleCoinCallback3: addMerchant2Cart, toggleCoinCallback4: addProduct, toggleCoinCallback: addProduct3, barcodeBtn: openBarcodeSearch, shopId: shopId.toString(), customersSnapshot: customerSnapshot, toggleCoinCallback6: addCust, closeCartBtn: closeCartFrom, openCartBtn: openCartFrom,openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,),
          ),
          TabItem(
            tabName: "Settings",
            icon: Icon(
              Icons.add,
            ),
            page: ProductsFragment(
              key: prodGlobalKey,
              // checkDOpen: checkDrawerOpen,
              toggleCoinCallback: addNewProd2,
              toggleCoinCallback2: addProduct,
              toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart, barcodeBtn: openBarcodeSearch, shopId: shopId.toString(), productsSnapshot: productSnapshot, searchBtn: openSearchFromFrag, lowStockSnapshot: lowStockSnapshot, closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,),
          ),
          TabItem(
            tabName: "Settings",
            icon: Icon(
              Icons.add,
            ),
            page: MerchantsFragment(selectedDev: _selectedDevice, printFromOrders: printFromOrders,searchBtn: openSearchFromFrag, key: mercGlobalKey, toggleCoinCallback3: addMerchant2Cart, toggleCoinCallback2: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback: addProduct, barcodeBtn: openBarcodeSearch, shopId: shopId.toString(), merchantsSnapshot: merchantSnapshot, toggleCoinCallback6: addMerch, closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, closeDrawerBtn: closeDrawerFrom, openDrawerBtn: openDrawerFrom),
          ),
          TabItem(
            tabName: "Settings",
            icon: Icon(
              Icons.add,
            ),
            // page: BuyListFragment(),
            page: SupportFragment(),
          ),
          TabItem(
            tabName: "Settings",
            icon: Icon(
              Icons.add,
            ),
            // page: BuyListFragment(),
            page: SettingsFragment(key: settGlobalKey, premiumCart: premiumCart, changeShopCallback: chgShopIdFromSetting, usersSnapshot: userSnapshot2, openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,),
          ),
          TabItem(
            tabName: "Settings",
            icon: Icon(
              Icons.add,
            ),
            // page: BuyListFragment(),
            page: BuyListFragment( selectedDev: _selectedDevice, printFromOrders: printFromOrders,
              key: bordGlobalKey, searchBtn: openSearchFromFrag,
              toggleCoinCallback2: addProduct,
              toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart, barcodeBtn: openBarcodeSearch, shopId: shopId.toString(), buyOrdersSnapshot: buyOrderSnapshot, merchantsSnapshot: merchantSnapshot2, closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,),
          ),
          TabItem(
            tabName: "Champions",
            icon: Icon(
              Icons.add,
            ),
            page: SearchFragment( openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom, selectedDev: _selectedDevice, printFromOrders: printFromOrders, key: searchGlobalKey, toggleCoinCallback3: addMerchant2Cart, toggleCoinCallback2: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback: addProduct, barcodeBtn: openBarcodeSearch, chgIndexFromSearch: chgIndexFromSearch, productsSnapshot: productSnapshot2, openCartBtn: openCartFrom, closeCartBtn: closeCartFrom,),
          ),
        ];
      });

      tabs.asMap().forEach((index, details) {
        details.setIndex(index);
      });
    });
    super.initState();
  }
  DateTime today = DateTime.now();

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

  DateTime lossDayStartByDate(DateTime date) {
    // DateTime today = DateTime.now();
    // DateTime yearStart = DateTime.now();
    // DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
    // today.
    String endDateOfMonth = '31';
    if(date.month.toString() == '9' || date.month.toString() == '4' || date.month.toString() == '6' || date.month.toString() == '11') {
      endDateOfMonth = '30';
    } else if(date.month.toString() == '2') {
      endDateOfMonth = '29';
    } else {
      endDateOfMonth = '31';
    }
    DateTime yearStart = DateFormat("yyyy-MM-dd hh:mm:ss").parse(date.year.toString() + '-' + zeroToTen(date.month.toString()) + '-' + endDateOfMonth + ' 23:59:59');
    print('DDDD ' + yearStart.toString());
    return yearStart;
  }

  DateTime lossDayEndByDate(DateTime date) {
    // DateTime today = DateTime.now();
    // DateTime yearStart = DateTime.now();
    // DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
    // today.
    DateTime notTday = date;
    notTday = date;
    int month = notTday.month;
    int ayinMonth = 0;
    if(month == 1) {
      ayinMonth = 12;
    } else {
      ayinMonth = month - 1;
    }
    DateTime yearStart = DateFormat("yyyy-MM-dd hh:mm:ss").parse(notTday.year.toString() + '-' + zeroToTen(ayinMonth.toString()) + '-00 00:00:00');
    print('DDDD ' + yearStart.toString());
    return yearStart;
  }

  List<DropdownMenuItem<Object?>> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem<Object?>> items = [];
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(i['keyword']),
        ),
      );
    }
    return items;
  }


  chgShopIdFromSetting() {
    setState(() {
      _selectTab(0);
      _selectIndex = 0;
    });
  }

  chgIndexFromSearch(index) {
    setState(() {
      int chgIndex = 0;
      if(ayinIndex == 1) {
        chgIndex = 3;
      } else if(ayinIndex == 2) {
        chgIndex = 1;
      } else if(ayinIndex == 3) {
        chgIndex = 7;
      } else if(ayinIndex == 4) {
        chgIndex = 2;
      } else if(ayinIndex == 5) {
        chgIndex = 4;
      } else {
        if(ayinIndex == 0) {

        }

        chgIndex = ayinIndex;
      }
      _selectTab(chgIndex);
      globalSearching = false;
      Future.delayed(const Duration(milliseconds: 500), () {
        // homeGlobalKey.currentState!.changeSearchOpening(false);
        homeGlobalKey.currentState!.changeSearchOpening(false);
        prodGlobalKey.currentState!.changeSearchOpening(false);
        sordGlobalKey.currentState!.changeSearchOpening(false);
        bordGlobalKey.currentState!.changeSearchOpening(false);
        custGlobalKey.currentState!.changeSearchOpening(false);
        mercGlobalKey.currentState!.changeSearchOpening(false);
        settGlobalKey.currentState!.changeSearchOpening(false);
      });
      // _selectIndex = 0;
    });
  }

  openSearchFromFrag() async {
    ayinIndex = _selectIndex;
    _selectTab(8);
    tabs[8].key.currentState!.popUntil((route) => route.isFirst);
    globalSearching = true;
    searchGlobalKey.currentState!.focusSearch();
    homeGlobalKey.currentState!.changeSearchOpening(true);
    prodGlobalKey.currentState!.changeSearchOpening(true);
    sordGlobalKey.currentState!.changeSearchOpening(true);
    bordGlobalKey.currentState!.changeSearchOpening(true);
    custGlobalKey.currentState!.changeSearchOpening(true);
    mercGlobalKey.currentState!.changeSearchOpening(true);
    settGlobalKey.currentState!.changeSearchOpening(true);
  }

  closeNewProduct() {
    Navigator.pop(context);
  }

  clearProd2(){
    setState(() {
      prodList2 = [];
    });
  }

  clearMerch() {
    setState(() {
      merchantId = 'name^name';
    });
  }

  prodLoadingState() {
    setState(() {
      disableTouch = true;
      Navigator.of(context).push(
          FadeRoute(page: Transparent(key: tranGlobalKey),)
      );
    });
    print('disable' + disableTouch.toString());
  }
  endProdLoadingState() {
    setState(() {
      disableTouch = false;
      tranGlobalKey.currentState!.disLoading();

    });
    print('disable2' + disableTouch.toString());
  }
  // cusLoadingState() {
  //   setState(() {
  //     disableTouch = true;
  //     Navigator.of(context).push(
  //         FadeRoute(page: Transparent(key: tranGlobalKey),)
  //     );
  //   });
  //   print('disable' + disableTouch.toString());
  // }
  // endCusLoadingState() {
  //   setState(() {
  //     disableTouch = false;
  //     tranGlobalKey.currentState!.disLoading();
  //
  //   });
  //   print('disable2' + disableTouch.toString());
  // }
  //
  // merchCartLoadingState() {
  //   setState(() {
  //     disableTouch = true;
  //     Navigator.of(context).push(
  //         FadeRoute(page: Transparent(key: tranGlobalKey),)
  //     );
  //   });
  //   print('disable' + disableTouch.toString());
  // }
  // endMerchCartLoadingState() {
  //   setState(() {
  //     disableTouch = false;
  //     tranGlobalKey.currentState!.disLoading();
  //
  //   });
  //   print('disable2' + disableTouch.toString());
  // }
  //
  // merchLoadingState() {
  //   setState(() {
  //     disableTouch = true;
  //     Navigator.of(context).push(
  //         FadeRoute(page: Transparent(key: tranGlobalKey),)
  //     );
  //   });
  //   print('disable' + disableTouch.toString());
  // }
  // endMerchLoadingState() {
  //   setState(() {
  //     disableTouch = false;
  //     tranGlobalKey.currentState!.disLoading();
  //
  //   });
  //   print('disable2' + disableTouch.toString());
  // }

  premiumCart() {
    final List<String> prodFieldsValue = [];
    // myController.clear();
    showModalBottomSheet(
        isDismissible: !disableTouch,
        enableDrag: !disableTouch,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0),
                        ),
                        color: Colors.white,
                      ),
                      height:
                      MediaQuery.of(context).size.height -
                          45,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height -
                                45,
                            // color: Colors.yellow,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 1.0),
                                  ),
                                  height: (MediaQuery.of(context).size.height -
                                      60)/ 2,
                                ),
                                Container(
                                  color: Color(0xFFF2F1F6),
                                  height: (MediaQuery.of(context).size.height -
                                      60)/ 2,
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          topRight: Radius.circular(15.0),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                              child: Container(
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 55),
                                                    Center(
                                                      child: Text(
                                                          'You are on pro version', style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 26,
                                                          letterSpacing: -0.4
                                                      )),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 20.0),
                                                      child: Text('Your last updated (at 22 April 2022) plan will end at 22 December 2022.', style: TextStyle( fontSize: 14),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15, right: 15, top: 20.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(15.0),
                                                    ),
                                                    color: Color(0xFFF5F5F5),
                                                    border: Border.all(
                                                        color: Colors.grey.withOpacity(0.2),
                                                        width: 1.0),
                                                  ),
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        SizedBox(height: 18),
                                                        Text('1 month pro version', style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 18,
                                                            letterSpacing: -0.3
                                                        )),
                                                        SizedBox(height: 5),
                                                        Text('10,000 Kyats /month', style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                            letterSpacing: -0.3
                                                        )),
                                                        SizedBox(height: 22),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15, right: 15, top: 15.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(15.0),
                                                      ),
                                                      gradient: LinearGradient(
                                                          colors: [Color(0xFFFFE18A), Color(0xFFC2FC1D)],
                                                          begin: Alignment(-1.0, -2.0),
                                                          end: Alignment(1.0, 2.0),
                                                          tileMode: TileMode.clamp)),
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        SizedBox(height: 18),
                                                        Text('3 month pro version (save 20%)', style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 18,
                                                            letterSpacing: -0.3
                                                        )),
                                                        SizedBox(height: 5),
                                                        Text('8,000 Kyats /month', style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                            letterSpacing: -0.3
                                                        )),
                                                        SizedBox(height: 22),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15, right: 15, top: 15.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(15.0),
                                                      ),
                                                      gradient: LinearGradient(
                                                          colors: [Color(0xFFDBFF76), Color(0xFF9FFFD1)],
                                                          begin: Alignment(-1.0, -2.0),
                                                          end: Alignment(1.0, 2.0),
                                                          tileMode: TileMode.clamp)),
                                                  width: MediaQuery.of(context).size.width,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        SizedBox(height: 18),
                                                        Text('5 month pro version (save 30%)', style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 18,
                                                            letterSpacing: -0.3
                                                        )),
                                                        SizedBox(height: 5),
                                                        Text('7,000 Kyats /month', style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                            letterSpacing: -0.3
                                                        )),
                                                        SizedBox(height: 22),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                            SizedBox(height: 20),
                                          ]
                                      ),
                                    ),
                                    Container(
                                      color: Color(0xFFF2F1F6),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 20),
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0),
                                                ),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    width: 1.0),
                                              ),
                                              child: ListTile(
                                                leading: Padding(
                                                  padding: const EdgeInsets.only(left:3.0, top: 3.0),
                                                  child: Image(image: AssetImage('assets/system/call_now.png'), width: 28,),
                                                ),
                                                title: Padding(
                                                  padding: const EdgeInsets.only(top: 10.0),
                                                  child: Text('Contact us via phone', style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18,
                                                      letterSpacing: -0.3
                                                  )),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 6),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors.grey
                                                                      .withOpacity(0.3),
                                                                  width: 1.0))),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom: 10.0),
                                                        child: Text('You can contact us now to purchase above plans.', style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 15, color: Colors.black,
                                                        )),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text('Call now', style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 17, color: Colors.blue,
                                                    )),
                                                    SizedBox(height: 10),
                                                  ],
                                                ),

                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0),
                                                ),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    width: 1.0),
                                              ),
                                              child: ListTile(
                                                leading: Padding(
                                                  padding: const EdgeInsets.only(left:3.0, top: 3.0),
                                                  child: Image(image: AssetImage('assets/system/messenger.png'), width: 28,),
                                                ),
                                                title: Padding(
                                                  padding: const EdgeInsets.only(top: 10.0),
                                                  child: Text('Via messenger', style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18,
                                                      letterSpacing: -0.3
                                                  )),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 6),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: Colors.grey
                                                                      .withOpacity(0.3),
                                                                  width: 1.0))),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom: 10.0),
                                                        child: Text('You can contact us now to purchase above plans (delay response).', style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 15, color: Colors.black,
                                                        )),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text('Messenger', style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 17, color: Colors.blue,
                                                    )),
                                                    SizedBox(height: 10),
                                                  ],
                                                ),

                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15.0, right: 15.0, bottom: 15.0, left: 15.0),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25.0),
                                        ),
                                        color: AppTheme.buttonColor2),
                                    child: Icon(
                                      // Icons.home_filled,
                                      Icons.close_rounded,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 42,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                            color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
          // return SingleAssetPage(toggleCoinCallback: closeNewProduct);
        });
  }

  addMerch() {
    showModalBottomSheet(
        isDismissible: !disableTouch,
        enableDrag: !disableTouch,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Container(
                          color: Colors.white,
                          height:
                          MediaQuery.of(context).size.height -
                              45,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Container(
                                height: 67,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey
                                                .withOpacity(0.3),
                                            width: 1.0))),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 5.0,
                                      bottom: 0.0
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Untitled', style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      )),
                                      SizedBox(height: 2.5),
                                      Text('New merchant creation', style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 19
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 57.0,
                                    left: 0.0,
                                    right: 0.0),
                                child: AddMerchant(toggleCoinCallback3: endProdLoadingState, toggleCoinCallback2: prodLoadingState,),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 42,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                              color: Colors.white.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
          // return SingleAssetPage(toggleCoinCallback: closeNewProduct);
        });
  }

  addCust() {
    showModalBottomSheet(
        isDismissible: !disableTouch,
        enableDrag: !disableTouch,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: IgnorePointer(
              ignoring: disableTouch,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18.0),
                            topRight: Radius.circular(18.0),
                          ),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Container(
                            color: Colors.white,
                            height:
                            MediaQuery.of(context).size.height -
                                45,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Container(
                                  height: 67,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.3),
                                              width: 1.0))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.0,
                                        right: 15.0,
                                        top: 5.0,
                                        bottom: 0.0
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Untitled', style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        )),
                                        SizedBox(height: 2.5),
                                        Text('New customer creation', style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 19
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 57.0, left: 0.0, right: 0.0),
                                  child: AddCustomer(toggleCoinCallback3: endProdLoadingState, toggleCoinCallback2: prodLoadingState,),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 42,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25.0),
                                ),
                                color: Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
          // return SingleAssetPage(toggleCoinCallback: closeNewProduct);
        });
  }

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  addNewProd2() {
    final List<String> prodFieldsValue = [];
    // myController.clear();
    showModalBottomSheet(
        isDismissible: !disableTouch,
        enableDrag: !disableTouch,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: IgnorePointer(
              ignoring: disableTouch,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18.0),
                            topRight: Radius.circular(18.0),
                          ),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Container(
                            color: Colors.white,
                            height:
                            MediaQuery.of(context).size.height -
                                45,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Container(
                                  height: 67,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.3),
                                              width: 1.0))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.0,
                                        right: 15.0,
                                        top: 5.0,
                                        bottom: 0.0
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Untitled', style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        )),
                                        SizedBox(height: 2.5),
                                        Text('New product creation', style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 19
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 57.0,
                                      left: 0.0,
                                      right: 0.0),
                                  child: SingleAssetPage(toggleCoinCallback: closeNewProduct, toggleCoinCallback2: prodLoadingState, toggleCoinCallback3: endProdLoadingState),
                                ),
                                // Align(
                                //   alignment: Alignment.bottomCenter,
                                //   child: Padding(
                                //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                                //     child: Container(
                                //       decoration: BoxDecoration(
                                //           color: Colors.white,
                                //           border: Border(
                                //             top: BorderSide(
                                //                 color:
                                //                 AppTheme.skBorderColor2,
                                //                 width: 1.0),
                                //           )),
                                //       width: double.infinity,
                                //       height: 158,
                                //       child: Container(),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 42,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25.0),
                                ),
                                color: Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
          // return SingleAssetPage(toggleCoinCallback: closeNewProduct);
        });
  }

  int _selectIndex = 0;
  void _selectTab(int index) {
    if (index == currentTab) {
      tabs[index].key.currentState!.popUntil((route) => route.isFirst);
    } else {
      // update the state
      // in order to repaint
      setState(() => currentTab = index);
    }

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

  String pdfText = '';

  File? pdfFile;

  var mergedImage;

  String pageType = 'Roll-57';

  final auth = FirebaseAuth.instance;
  String ayinHar = '';
  bool firstTime = true;
  bool disableTouch = false;

  openOrHideCart() {
    if(_selectIndex != null) {
      print('select index' + _selectIndex.toString());
    }
  }

  drawerOpen() {
    setState((){
      drawerDrag = true;
    });
  }

  drawerClose() {
    setState((){
      drawerDrag = false;
    });
  }
  void isProFreePage() {
    Navigator.of(context).pushReplacement(FadeRoute(page: EndOfProService()),);
  }

  @override
  Widget build(BuildContext context) {
    openOrHideCart();
    if(firstTime) {
      homeBotPadding = MediaQuery.of(context).padding.bottom;
    }
    return Container(
      color: Colors.white,
      child: IgnorePointer(
        ignoring: disableTouch,
        child: StreamBuilder(
            stream: emailSnapshot,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotUser) {
              if(snapshotUser.hasData) {
                Map<String, dynamic> dataUser = snapshotUser.data!.docs[0].data()! as Map<String, dynamic>;
                var role = dataUser['role'];
                if(ayinHar != role) {
                  if(role=='cashier') {
                    currentTab = 3;
                    _selectIndex = 1;
                  } else if(role=='admin') {
                    currentTab = 0;
                    _selectIndex = 0;
                  }
                }
                ayinHar = role;

                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream:  shopSnapshot,
                    builder: (BuildContext context, snapshotShop) {
                      if(snapshotShop.hasData) {
                        var output = snapshotShop.data != null? snapshotShop.data!.data(): null;
                        var shopName = output?['shop_name'];
                        shopGloName = shopName;
                        var shopAddress = output?['shop_address'];
                        shopGloAddress = shopAddress;
                        shopGloPhone = output?['shop_phone'];
                        var isPro = output?['is_pro'];
                        Timestamp isProStart = isPro['start'];
                        Timestamp isProEnd = isPro['end'];
                        print('isPro? ' + isProStart.toDate().toString());
                        DateTime startDate = isProStart.toDate();
                        DateTime endDate = isProEnd.toDate();

                        DateTime nowCheck = DateTime.now();

                        print('now: $nowCheck');
                        print('startDate: $startDate');
                        print('endDate: $endDate');
                        print(startDate.isBefore(nowCheck));
                        print(endDate.isAfter(nowCheck));

                        print('role ' + role.toString());
                        if(firstTime == true) {
                          // role=='cashier'
                          print('first time');
                          currentTab = 3;
                          _selectIndex = 1;
                          firstTime = false;
                        } else if(!firstTime) {
                          print('not first');
                          if(startDate.isBefore(nowCheck) && endDate.isAfter(nowCheck)) {
                            settGlobalKey.currentState!.isProSet('pro');
                          } else {
                            settGlobalKey.currentState!.isProSet('free');
                          }

                        }
                        if(!(startDate.isBefore(nowCheck) && endDate.isAfter(nowCheck))) {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            isProFreePage();
                          });
                        }

                        return Scaffold(
                          // persistentFooterButtons: [
                          //   Container(
                          //       width: 200,
                          //     height: 50,
                          //     color: Colors.green,
                          //   )
                          // ],
                          // appBar: AppBar(
                          //   systemOverlayStyle: SystemUiOverlayStyle(
                          //     statusBarBrightness: Brightness.light,
                          //     statusBarIconBrightness: Brightness.light,
                          //     systemNavigationBarIconBrightness: Brightness.light,
                          //     systemNavigationBarColor: Colors.white, // Navigation bar
                          //     statusBarColor: Colors.white, // Status bar
                          //   ),
                          // ),
                          onEndDrawerChanged: (isOpened) {
                            if(isOpened) {
                              print('opening 2');
                              searchGlobalKey.currentState!.unfocusSearch();
                            }
                          },
                          onDrawerChanged: (isOpened) {
                            searchGlobalKey.currentState!.unfocusSearch();
                            if(isOpened) {
                              // print('opening ');
                              // searchGlobalKey.currentState!.unfocusSearch();
                              // homeGlobalKey.currentState!.unfocusSearch();
                              // prodGlobalKey.currentState!.unfocusSearch();
                              // custGlobalKey.currentState!.unfocusSearch();
                              // mercGlobalKey.currentState!.unfocusSearch();
                              // sordGlobalKey.currentState!.unfocusSearch();
                              // bordGlobalKey.currentState!.unfocusSearch();
                            }
                          },
                          resizeToAvoidBottomInset: false,
                          backgroundColor: Colors.white,
                          key: _scaffoldKey,
                          drawerEdgeDragWidth: drawerDrag? 0: 20,
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
                                                      shopName.toString(),overflow: TextOverflow.ellipsis,
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
                                                        shopAddress.toString(),overflow: TextOverflow.ellipsis,
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
                                                // child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                                //     stream:  shopSnapshot,
                                                //     builder: (BuildContext context, snapshot) {
                                                //       if (snapshot.hasData) {
                                                //         var output = snapshot.data!.data();
                                                //         var shopName = output?['shop_name'];
                                                //         shopGloName = shopName;
                                                //         var shopAddress = output?['shop_address'];
                                                //         shopGloAddress = shopAddress;
                                                //         shopGloPhone = output?['shop_phone'];
                                                //         return Column(
                                                //           mainAxisAlignment: MainAxisAlignment.start,
                                                //           crossAxisAlignment: CrossAxisAlignment.start,
                                                //           children: [
                                                //             SizedBox(
                                                //               height: 1,
                                                //             ),
                                                //             Text(
                                                //               shopName.toString(),overflow: TextOverflow.ellipsis,
                                                //               style: TextStyle(
                                                //                   height: 2, fontSize: 18, fontWeight: FontWeight.w500),
                                                //               strutStyle: StrutStyle(
                                                //                 height: 2,
                                                //                 // fontSize:,
                                                //                 forceStrutHeight: true,
                                                //               ),
                                                //             ),
                                                //             SizedBox(
                                                //               height: 0,
                                                //             ),
                                                //             Transform.translate(
                                                //               offset: Offset(0, -5),
                                                //               child: Text(
                                                //                 shopAddress.toString(),overflow: TextOverflow.ellipsis,
                                                //                 style: TextStyle(height: 2, fontSize: 14),
                                                //                 strutStyle: StrutStyle(
                                                //                   height: 2,
                                                //                   // fontSize:,
                                                //                   forceStrutHeight: true,
                                                //                 ),
                                                //               ),
                                                //             ),
                                                //             SizedBox(
                                                //               height: 3,
                                                //             ),
                                                //           ],
                                                //         );
                                                //       }
                                                //       return Container();
                                                //     }
                                                // ),
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
                                                          closeByClick();
                                                          if(globalSearching) {
                                                            Future.delayed(const Duration(milliseconds: 500), () {
                                                              // homeGlobalKey.currentState!.changeSearchOpening(false);
                                                              homeGlobalKey.currentState!.changeSearchOpening(false);
                                                              prodGlobalKey.currentState!.changeSearchOpening(false);
                                                              sordGlobalKey.currentState!.changeSearchOpening(false);
                                                              bordGlobalKey.currentState!.changeSearchOpening(false);
                                                              custGlobalKey.currentState!.changeSearchOpening(false);
                                                              mercGlobalKey.currentState!.changeSearchOpening(false);
                                                              settGlobalKey.currentState!.changeSearchOpening(false);
                                                            });
                                                          }
                                                          _scaffoldKey.currentState!.openEndDrawer();
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
                                                                    'Home',
                                                                    style: TextStyle(
                                                                        fontSize: 17, fontWeight: FontWeight.w500),
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
                                                          _selectTab(3);
                                                          _selectIndex = 1;
                                                        });
                                                        closeByClick();
                                                        // });

                                                        if(globalSearching) {
                                                          Future.delayed(const Duration(milliseconds: 500), () {
                                                            // homeGlobalKey.currentState!.changeSearchOpening(false);
                                                            homeGlobalKey.currentState!.changeSearchOpening(false);
                                                            prodGlobalKey.currentState!.changeSearchOpening(false);
                                                            sordGlobalKey.currentState!.changeSearchOpening(false);
                                                            bordGlobalKey.currentState!.changeSearchOpening(false);
                                                            custGlobalKey.currentState!.changeSearchOpening(false);
                                                            mercGlobalKey.currentState!.changeSearchOpening(false);
                                                            settGlobalKey.currentState!.changeSearchOpening(false);
                                                          });
                                                        }
                                                        _scaffoldKey.currentState!.openEndDrawer();

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
                                                                  'Products',
                                                                  style: TextStyle(
                                                                      fontSize: 17, fontWeight: FontWeight.w500),
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
                                                                'Orders',
                                                                style: TextStyle(
                                                                    fontSize: 17, fontWeight: FontWeight.w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _selectTab(1);
                                                          _selectIndex = 2;
                                                        });
                                                        closeByClick();
                                                        if(globalSearching) {
                                                          Future.delayed(const Duration(milliseconds: 500), () {
                                                            // homeGlobalKey.currentState!.changeSearchOpening(false);
                                                            homeGlobalKey.currentState!.changeSearchOpening(false);
                                                            prodGlobalKey.currentState!.changeSearchOpening(false);
                                                            sordGlobalKey.currentState!.changeSearchOpening(false);
                                                            bordGlobalKey.currentState!.changeSearchOpening(false);
                                                            custGlobalKey.currentState!.changeSearchOpening(false);
                                                            mercGlobalKey.currentState!.changeSearchOpening(false);
                                                            settGlobalKey.currentState!.changeSearchOpening(false);
                                                          });
                                                        }
                                                        _scaffoldKey.currentState!.openEndDrawer();
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 58.0, right: 15.0),
                                                        child: new Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                              color: _selectIndex == 2? AppTheme.secButtonColor: Colors.transparent),
                                                          height: 50,
                                                          width: double.infinity,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 13.0),
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.only(bottom: 1.0),
                                                                  child: Text(
                                                                    'Sale orders',
                                                                    style: TextStyle(
                                                                        fontSize: 17, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    if (role == 'admin' || role == 'owner')
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _selectTab(7);
                                                            _selectIndex = 3;
                                                          });
                                                          closeByClick();
                                                          if(globalSearching) {
                                                            Future.delayed(const Duration(milliseconds: 500), () {
                                                              // homeGlobalKey.currentState!.changeSearchOpening(false);
                                                              homeGlobalKey.currentState!.changeSearchOpening(false);
                                                              prodGlobalKey.currentState!.changeSearchOpening(false);
                                                              sordGlobalKey.currentState!.changeSearchOpening(false);
                                                              bordGlobalKey.currentState!.changeSearchOpening(false);
                                                              custGlobalKey.currentState!.changeSearchOpening(false);
                                                              mercGlobalKey.currentState!.changeSearchOpening(false);
                                                              settGlobalKey.currentState!.changeSearchOpening(false);
                                                            });
                                                          }
                                                          _scaffoldKey.currentState!.openEndDrawer();
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 58.0, right: 15.0),
                                                          child: new Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                color: _selectIndex == 3? AppTheme.secButtonColor: Colors.transparent),
                                                            height: 50,
                                                            width: double.infinity,
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 13.0),
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(bottom: 1.0),
                                                                    child: Text(
                                                                      'Buy orders',
                                                                      style: TextStyle(
                                                                          fontSize: 17, fontWeight: FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _selectTab(2);
                                                          _selectIndex = 4;
                                                        });
                                                        closeByClick();
                                                        if(globalSearching) {
                                                          Future.delayed(const Duration(milliseconds: 500), () {
                                                            // homeGlobalKey.currentState!.changeSearchOpening(false);
                                                            homeGlobalKey.currentState!.changeSearchOpening(false);
                                                            prodGlobalKey.currentState!.changeSearchOpening(false);
                                                            sordGlobalKey.currentState!.changeSearchOpening(false);
                                                            bordGlobalKey.currentState!.changeSearchOpening(false);
                                                            custGlobalKey.currentState!.changeSearchOpening(false);
                                                            mercGlobalKey.currentState!.changeSearchOpening(false);
                                                            settGlobalKey.currentState!.changeSearchOpening(false);
                                                          });
                                                        }
                                                        _scaffoldKey.currentState!.openEndDrawer();
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                        child: new Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                              color: _selectIndex == 4? AppTheme.secButtonColor: Colors.transparent),
                                                          height: 50,
                                                          width: double.infinity,
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(
                                                                    left: 18.0, right: 15.0, bottom: 1.0),
                                                                child: Stack(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 7.0),
                                                                      child: Icon(
                                                                        SmartKyat_POS.customer1,
                                                                        size: 17.5,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 14.0, top: 11.0),
                                                                      child: Icon(
                                                                        SmartKyat_POS.customer2,
                                                                        size: 9,
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, top: 5),
                                                                      child: Container(
                                                                        width: 8,
                                                                        height: 7.5,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 14.5, top: 7.5),
                                                                      child: Container(
                                                                        width: 5,
                                                                        height: 4.5,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                            color: Colors.black),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(bottom: 1.0),
                                                                child: Text(
                                                                  'Customers',
                                                                  style: TextStyle(
                                                                      fontSize: 17, fontWeight: FontWeight.w500),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    if (role == 'admin' || role == 'owner')
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _selectTab(4);
                                                            _selectIndex = 5;
                                                          });
                                                          closeByClick();
                                                          if(globalSearching) {
                                                            Future.delayed(const Duration(milliseconds: 500), () {
                                                              // homeGlobalKey.currentState!.changeSearchOpening(false);
                                                              homeGlobalKey.currentState!.changeSearchOpening(false);
                                                              prodGlobalKey.currentState!.changeSearchOpening(false);
                                                              sordGlobalKey.currentState!.changeSearchOpening(false);
                                                              bordGlobalKey.currentState!.changeSearchOpening(false);
                                                              custGlobalKey.currentState!.changeSearchOpening(false);
                                                              mercGlobalKey.currentState!.changeSearchOpening(false);
                                                              settGlobalKey.currentState!.changeSearchOpening(false);
                                                            });
                                                          }
                                                          _scaffoldKey.currentState!.openEndDrawer();
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                          child: new Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                color: _selectIndex == 5? AppTheme.secButtonColor: Colors.transparent),
                                                            height: 50,
                                                            width: double.infinity,
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.only(
                                                                      left: 20.0, right: 16.0),
                                                                  child: Icon(
                                                                    SmartKyat_POS.merchant,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(bottom: 1.0),
                                                                  child: Text(
                                                                    'Merchants',
                                                                    style: TextStyle(
                                                                        fontSize: 17, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _selectTab(6);
                                                          _selectIndex = 6;
                                                        });
                                                        closeByClick();
                                                        if(globalSearching) {
                                                          Future.delayed(const Duration(milliseconds: 500), () {
                                                            // homeGlobalKey.currentState!.changeSearchOpening(false);
                                                            homeGlobalKey.currentState!.changeSearchOpening(false);
                                                            prodGlobalKey.currentState!.changeSearchOpening(false);
                                                            sordGlobalKey.currentState!.changeSearchOpening(false);
                                                            bordGlobalKey.currentState!.changeSearchOpening(false);
                                                            custGlobalKey.currentState!.changeSearchOpening(false);
                                                            mercGlobalKey.currentState!.changeSearchOpening(false);
                                                            settGlobalKey.currentState!.changeSearchOpening(false);
                                                          });
                                                        }
                                                        _scaffoldKey.currentState!.openEndDrawer();
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                        child: new Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                              color: _selectIndex == 6? AppTheme.secButtonColor: Colors.transparent),
                                                          height: 50,
                                                          width: double.infinity,
                                                          child: Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(
                                                                    left: 20.0, right: 15.0, top: 0.0),
                                                                child: Icon(
                                                                  SmartKyat_POS.setting,
                                                                  size: 22,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(bottom: 1.0),
                                                                child: Text(
                                                                  'Settings',
                                                                  style: TextStyle(
                                                                      fontSize: 17, fontWeight: FontWeight.w500),
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
                                      Column(
                                        children: [
                                          Container(
                                            height: 61,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(
                                                        color: Colors.grey.withOpacity(0.3),
                                                        width: 1.0))),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0, right: 15, top: 15, bottom: 15),
                                              child: Row(
                                                children: [
                                                  StreamBuilder(
                                                      stream: userSnapshot,
                                                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                        if(snapshot.hasData) {
                                                          return Expanded(
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                print('go to cart 4');
                                                              },
                                                              child: ListView(
                                                                physics: NeverScrollableScrollPhysics(),
                                                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                                                  return  Container(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(top: 3.0),
                                                                      child: Text(data['name'], overflow: TextOverflow.ellipsis, style: TextStyle(
                                                                          fontSize: 17,
                                                                          fontWeight: FontWeight.w500
                                                                      ),),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        return Container();
                                                      }
                                                  ),
                                                  ButtonTheme(
                                                    minWidth: 35,
                                                    splashColor: Colors.transparent,
                                                    height: 35,
                                                    child: FlatButton(
                                                      color: AppTheme.buttonColor2,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(8.0),
                                                        side: BorderSide(
                                                          color: AppTheme.buttonColor2,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        _selectTab(0);
                                                        await FirebaseAuth.instance.signOut();
                                                        setStoreId('');
                                                        Navigator.of(context).pushReplacement(
                                                          FadeRoute(page: Welcome()),
                                                        );
                                                      },
                                                      child: Container(
                                                        child: Text(
                                                          'Logout',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w500
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),

                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          // extendBody: true,
                          // bottomNavigationBar: Container(
                          //   color: Colors.transparent,
                          //   child: Padding(
                          //     padding: EdgeInsets.only(
                          //       bottom: homeBotPadding,
                          //       // bottom: MediaQuery.of(context).viewInsets.bottom
                          //     ),
                          //     child: Stack(
                          //       children: [
                          //         if (MediaQuery.of(context).size.width > 900) Container() else Padding(
                          //           padding: EdgeInsets.only(bottom: 100.0),
                          //           child: Container(
                          //             decoration: BoxDecoration(
                          //                 color: Colors.white,
                          //                 border: Border(
                          //                   top: BorderSide(
                          //                       color: AppTheme.skBorderColor2,
                          //                       width: 1.0),
                          //                 )
                          //             ),
                          //             child: Padding(
                          //               padding:
                          //               const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                          //               child: Container(
                          //                 height: 50,
                          //                 child: GestureDetector(
                          //                   onTap: () {
                          //                     saleCart(context);
                          //                   },
                          //                   child: (prodList.length == 0) ?
                          //                   Container(
                          //                     decoration: BoxDecoration(
                          //                       borderRadius: BorderRadius.circular(10.0),
                          //                       color: customerId == 'name^name' ? AppTheme.buttonColor2 : AppTheme.themeColor,
                          //                       // color: Colors.blue
                          //                     ),
                          //
                          //                     child: Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           top: 13.0, bottom: 15.0),
                          //                       child: Row(
                          //                         mainAxisAlignment:
                          //                         MainAxisAlignment.center,
                          //                         children: [
                          //                           Expanded(
                          //                             child: Padding(
                          //                               padding: const EdgeInsets.only(
                          //                                   left: 8.0,
                          //                                   right: 8.0,
                          //                                   bottom: 2.0),
                          //                               child: Container(
                          //                                 child: Text(
                          //                                   'Go to cart',
                          //                                   textAlign: TextAlign.center,
                          //                                   style: TextStyle(
                          //                                       fontSize: 18,
                          //                                       fontWeight: FontWeight.w500,
                          //                                       color: Colors.black),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ) :
                          //                   Container(
                          //                     decoration: BoxDecoration(
                          //                       borderRadius: BorderRadius.circular(10.0),
                          //                       color: AppTheme.themeColor,
                          //                       // color: Colors.blue
                          //                     ),
                          //
                          //                     child: Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           top: 13.0, bottom: 15.0),
                          //                       child: Row(
                          //                         mainAxisAlignment:
                          //                         MainAxisAlignment.center,
                          //                         children: [
                          //                           Expanded(
                          //                             child: Padding(
                          //                               padding: const EdgeInsets.only(
                          //                                   left: 8.0,
                          //                                   right: 8.0,
                          //                                   bottom: 2.0),
                          //                               child: double.parse(totalItems()) == 1? Container(
                          //                                 child:
                          //                                 Text(
                          //                                   totalItems() + ' item - ' + TtlProdListPrice() + ' MMK',
                          //                                   textAlign: TextAlign.center,
                          //                                   style: TextStyle(
                          //                                       fontSize: 18,
                          //                                       fontWeight: FontWeight.w500,
                          //                                       color: Colors.black),
                          //                                 ),
                          //                               ) : Container(
                          //                                 child:
                          //                                 Text(
                          //                                   totalItems() + ' items - ' + TtlProdListPrice() + ' MMK',
                          //                                   textAlign: TextAlign.center,
                          //                                   style: TextStyle(
                          //                                       fontSize: 18,
                          //                                       fontWeight: FontWeight.w500,
                          //                                       color: Colors.black),
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //         Align(
                          //           alignment: Alignment.bottomCenter,
                          //           child: Padding(
                          //             padding: const EdgeInsets.only(top: 0.0),
                          //             child: Container(
                          //               height: 57,
                          //               decoration: BoxDecoration(
                          //                   color: Colors.white,
                          //                   border: Border(
                          //                     top: BorderSide(
                          //                         color: AppTheme.skBorderColor2, width: 1.0),
                          //                   )),
                          //               child: Padding(
                          //                 padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                          //                 child: Row(
                          //                   mainAxisAlignment: MainAxisAlignment.center,
                          //                   children: [
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           left: 15.0,top:0.0
                          //                       ),
                          //                       child: GestureDetector(
                          //                         onTap: () {
                          //                           _scaffoldKey.currentState!.openDrawer();
                          //                         },
                          //                         child: selectedTab(
                          //
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     Expanded(
                          //                       child: Container(
                          //                           child: Text(
                          //                             '',
                          //                             textAlign: TextAlign.center,
                          //                             style: TextStyle(
                          //                                 fontSize: 16.5,
                          //                                 fontWeight: FontWeight.w600,
                          //                                 color: Colors.black.withOpacity(0.6)),
                          //                           )),
                          //                     ),
                          //                     GestureDetector(
                          //                       onTap: () async {
                          //                         // // smartKyatFlash('Thank for using Smart Kyat POS system.', 'i');
                          //                         // DateTime _myTime;
                          //                         // DateTime _ntpTime;
                          //                         //
                          //                         // /// Or you could get NTP current (It will call DateTime.now() and add NTP offset to it)
                          //                         // _myTime = await NTP.now();
                          //                         //
                          //                         // /// Or get NTP offset (in milliseconds) and add it yourself
                          //                         // final int offset = await NTP.getNtpOffset(localTime: DateTime.now());
                          //                         // _ntpTime = _myTime.add(Duration(milliseconds: offset));
                          //                         //
                          //                         // print('Date time: ' + DateTime.now().toString());
                          //                         // print('My time: $_myTime');
                          //                         // print('NTP time: $_ntpTime');
                          //                         // print('Difference: ${_myTime.difference(_ntpTime).inMilliseconds}ms');
                          //                         Navigator.of(context).push(
                          //                             FadeRoute(page: FirstLaunchPage(),)
                          //                         );
                          //                       },
                          //                       child: Row(
                          //                         children: [
                          //                           Text(startDate.isBefore(nowCheck) && endDate.isAfter(nowCheck)? 'pro': 'free'),
                          //                           Padding(
                          //                             padding: const EdgeInsets.only(
                          //                                 right: 13.0,top:2.0
                          //                             ),
                          //                             child: Container(
                          //                                 child: Image.asset('assets/system/menu.png', height: 33,)
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          body: StreamBuilder(
                              stream: shopFoundSnapshot,
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if(snapshot.hasData) {
                                  List<bool> shopFound = [];
                                  getStoreId().then((value) async {
                                    if(snapshot.data!.docs.length == 0) {
                                      await FirebaseAuth.instance.signOut();
                                      setStoreId('');
                                      // Navigator.pop(context);
                                      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoadingScreen()));
                                      // Navigator.of(context).pushReplacement(FadeRoute(builder: (context) => Welcome()));
                                      Navigator.of(context).pushReplacement(
                                        FadeRoute(page: Welcome()),
                                      );
                                    }
                                  });

                                  for(int loop = 0; loop < snapshot.data!.docs.length; loop++) {
                                    Map<String, dynamic> data = snapshot.data!.docs[loop]
                                        .data()! as Map<String, dynamic>;
                                    var shop_name = data['shop_name'];
                                    getStoreId().then((value) async {
                                      if(snapshot.data!.docs[loop].id == value) {
                                        shopFound.add(true);
                                      } else {
                                        shopFound.add(false);
                                      }
                                      if(loop == snapshot.data!.docs.length-1) {
                                        for(int i = 0; i < shopFound.length; i++) {
                                          if(shopFound[i]) {
                                            break;
                                          } else {
                                            if(i == shopFound.length-1) {
                                              await FirebaseAuth.instance.signOut();
                                              setStoreId('');
                                              // Navigator.pop(context);
                                              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoadingScreen()));
                                              // Navigator.of(context).pushReplacement(FadeRoute(builder: (context) => Welcome()));
                                              Navigator.of(context).pushReplacement(
                                                FadeRoute(page: Welcome()),
                                              );
                                            }
                                          }
                                        }
                                      }
                                    });

                                  }

                                }
                                return Stack(
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
                                                  ),
                                                ),
                                              ),
                                              // Expanded(
                                              //   child: ,
                                              // )
                                            ],
                                          ),
                                          Visibility(
                                            visible: MediaQuery.of(context).size.width > 900,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5)),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        left: BorderSide(
                                                            color: Colors.grey
                                                                .withOpacity(0.3),
                                                            width: 1.0))),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    FocusScope.of(context).unfocus();
                                                  },
                                                  child: Form(
                                                    key: _formKey2,
                                                    child: Stack(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                                                          child: Container(
                                                            child: Padding(
                                                              padding: EdgeInsets.only(top: 14.0, bottom: 61 + homeBotPadding),
                                                              child: TabBarView(
                                                                physics: NeverScrollableScrollPhysics(),
                                                                controller: _controllerTablet,
                                                                children: [
                                                                  Container(
                                                                    color: Colors.white,
                                                                    height:
                                                                    MediaQuery.of(context).size.height -
                                                                        45,
                                                                    width: double.infinity,
                                                                    child: Stack(
                                                                      children: [
                                                                        StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                                                                            stream: FirebaseFirestore.instance
                                                                                .collection('shops')
                                                                                .doc(shopId)
                                                                                .collection('customers')
                                                                                .doc(customerId.split('^')[0].toString())
                                                                                .snapshots(),
                                                                            builder: (BuildContext context, snapshot5) {
                                                                              if(snapshot5.hasData){
                                                                                var output3 = snapshot5.data!.data();
                                                                                var address = output3?['customer_address'];
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.only(
                                                                                      top: 43.0,
                                                                                      left: 0.0,
                                                                                      right: 0.0,
                                                                                      bottom: 118),
                                                                                  child: Container(
                                                                                      child: ListView(
                                                                                        children: [
                                                                                          Stack(
                                                                                            children: [

                                                                                              Padding(
                                                                                                padding: const EdgeInsets.only(top: 19.0),
                                                                                                child: Column(
                                                                                                  children: [
                                                                                                    GestureDetector(
                                                                                                      onTap: () {
                                                                                                        setState(() {
                                                                                                          customerId = 'name^name';
                                                                                                        });
                                                                                                      },
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                                                                        child: Row(
                                                                                                          children: [
                                                                                                            Container(
                                                                                                              height: 58,
                                                                                                              width: 58,
                                                                                                              decoration: BoxDecoration(
                                                                                                                  borderRadius:
                                                                                                                  BorderRadius.circular(
                                                                                                                      5.0),
                                                                                                                  color: Colors.grey
                                                                                                                      .withOpacity(0.5)
                                                                                                              ),
                                                                                                              child: Icon(
                                                                                                                SmartKyat_POS.order,
                                                                                                                size: 25,
                                                                                                              ),
                                                                                                            ),
                                                                                                            SizedBox(width: 15),
                                                                                                            Column(
                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                                              children: [
                                                                                                                Text(customerId.split('^')[1].toString() == 'name' ? 'No customer' : customerId.split('^')[1] , style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, height: 0.9),),
                                                                                                                // Text(customerId.split('^')[1].toString() == 'name' ? 'Unknown' : address,
                                                                                                                //     style: TextStyle(
                                                                                                                //       fontSize: 14,
                                                                                                                //       color: Colors.grey
                                                                                                                //     )),
                                                                                                              ],
                                                                                                            )
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(height: 8,),
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.only(left: 15.0),
                                                                                                      child: Container(height: 12,
                                                                                                        decoration: BoxDecoration(
                                                                                                            border: Border(
                                                                                                              bottom:
                                                                                                              BorderSide(color: AppTheme.skBorderColor2, width: 0.5),
                                                                                                            )),),
                                                                                                    ),

                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              customerId != 'name^name' ? Positioned(
                                                                                                top : 11,
                                                                                                right: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5)) - 80,
                                                                                                child: Container(
                                                                                                  // height: 20,
                                                                                                  // width: 30,
                                                                                                  alignment: Alignment.center,
                                                                                                  decoration: BoxDecoration(
                                                                                                      color: Color(0xffE9625E),
                                                                                                      borderRadius:
                                                                                                      BorderRadius.circular(
                                                                                                          10.0),
                                                                                                      border: Border.all(
                                                                                                        color: Colors.white,
                                                                                                        width: 2,
                                                                                                      )),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 1, bottom: 1),
                                                                                                    child: Icon(
                                                                                                      Icons.close_rounded,
                                                                                                      size: 13,
                                                                                                      color: Colors.white,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ): Container(),
                                                                                            ],
                                                                                          ),
                                                                                          for (int i = 0; i < prodList.length; i++)
                                                                                            StreamBuilder<
                                                                                                DocumentSnapshot<
                                                                                                    Map<String,
                                                                                                        dynamic>>>(
                                                                                              stream: FirebaseFirestore
                                                                                                  .instance
                                                                                                  .collection('shops')
                                                                                                  .doc(
                                                                                                  shopId)
                                                                                                  .collection('products')
                                                                                                  .doc(prodList[i]
                                                                                                  .split('^')[0])
                                                                                                  .snapshots(),
                                                                                              builder:
                                                                                                  (BuildContext context,
                                                                                                  snapshot2) {
                                                                                                if (snapshot2.hasData) {
                                                                                                  var output2 = snapshot2
                                                                                                      .data!
                                                                                                      .data();
                                                                                                  var image = output2?[
                                                                                                  'img_1'];
                                                                                                  prodList[i] = prodList[i].split('^')[0] + '^' + output2?['prod_name'] + '^' +
                                                                                                      prodList[i].split('^')[2] + '^' + prodList[i].split('^')[3] + '^' + prodList[i].split('^')[4] + '^' + prodList[i].split('^')[5];
                                                                                                  return GestureDetector(
                                                                                                    onTap: (){
                                                                                                      print('error prod' + prodList[i].toString());
                                                                                                      setState((){
                                                                                                        quantity = double.parse(prodList[i].split('^')[4]);
                                                                                                        price2 = double.parse(prodList[i].split('^')[2]);
                                                                                                        eachProd = prodList[i];
                                                                                                        unit = prodList[i].split('^')[3];
                                                                                                        mainName =  output2?['unit_name'];
                                                                                                        sub1Name = output2?['sub1_name'];
                                                                                                        sub2Name = output2?['sub2_name'];
                                                                                                        salePrice = prodList[i].split('^')[2];
                                                                                                        mainLoss = output2?['Loss1'].round();
                                                                                                        sub1Loss = output2?['Loss2'].round();
                                                                                                        sub2Loss = output2?['Loss3'].round();
                                                                                                        barcode = output2?['bar_code'];
                                                                                                        mainQty = output2?['inStock1'].round();
                                                                                                        sub1Qty = output2?['inStock2'].round();
                                                                                                        sub2Qty = output2?['inStock3'].round();
                                                                                                        sell1 =output2?['unit_sell'];
                                                                                                        sell2 =output2?['sub1_sell'];
                                                                                                        sell3 =output2?['sub2_sell'];

                                                                                                        productName = output2?['prod_name'];
                                                                                                        myControllerTablet.text = prodList[i].split('^')[4];
                                                                                                        sellPriceControllerTablet.text = prodList[i].split('^')[2];
                                                                                                        // sellDone = false;
                                                                                                        onChangeAmountTab = true;
                                                                                                        _controllerTablet.animateTo(2);
                                                                                                      });
                                                                                                    },
                                                                                                    child: Slidable(
                                                                                                      key: UniqueKey(),
                                                                                                      actionPane:
                                                                                                      SlidableDrawerActionPane(),
                                                                                                      actionExtentRatio:
                                                                                                      0.25,
                                                                                                      child: Stack(
                                                                                                        children: [
                                                                                                          Container(
                                                                                                            color: Colors.white,
                                                                                                            child: Column(
                                                                                                              children: [
                                                                                                                SizedBox(height: 12),
                                                                                                                ListTile(
                                                                                                                  leading: ClipRRect(
                                                                                                                      borderRadius:
                                                                                                                      BorderRadius
                                                                                                                          .circular(
                                                                                                                          5.0),
                                                                                                                      child: image != ""
                                                                                                                          ? CachedNetworkImage(
                                                                                                                        imageUrl:
                                                                                                                        'https://riftplus.me/smartkyat_pos/api/uploads/' +
                                                                                                                            image,
                                                                                                                        width: 58,
                                                                                                                        height: 58,
                                                                                                                        // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                                                        fadeInDuration: Duration(milliseconds: 100),
                                                                                                                        fadeOutDuration: Duration(milliseconds: 10),
                                                                                                                        fadeInCurve: Curves.bounceIn,
                                                                                                                        fit: BoxFit.cover,) : Image.asset('assets/system/default-product.png', height: 58, width: 58)),
                                                                                                                  title: Text(output2?['prod_name'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, height: 0.9),),
                                                                                                                  subtitle: Padding(
                                                                                                                    padding: const EdgeInsets.only(top: 4.0),
                                                                                                                    child: Row(
                                                                                                                      children: [
                                                                                                                        Text(output2?[prodList[i].split('^')[3]] + ' ', style: TextStyle(
                                                                                                                            fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey, height: 0.9
                                                                                                                        )),
                                                                                                                        if (prodList[i].split('^')[3] == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
                                                                                                                        else if(prodList[i].split('^')[3] == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
                                                                                                                        else Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  trailing: Text('MMK ' + (double.parse(
                                                                                                                      prodList[i].split('^')[
                                                                                                                      2]) *
                                                                                                                      double.parse(prodList[
                                                                                                                      i]
                                                                                                                          .split(
                                                                                                                          '^')[4]))
                                                                                                                      .toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                                                                                    style: TextStyle(
                                                                                                                        fontSize: 16,
                                                                                                                        fontWeight: FontWeight.w500
                                                                                                                    ),),
                                                                                                                ),
                                                                                                                Padding(
                                                                                                                  padding: const EdgeInsets.only(left: 15.0),
                                                                                                                  child: Container(height: 12,
                                                                                                                    decoration: BoxDecoration(
                                                                                                                        border: Border(
                                                                                                                          bottom:
                                                                                                                          BorderSide(color: AppTheme.skBorderColor2, width: 0.5),
                                                                                                                        )),),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          Positioned(
                                                                                                            top : 11,
                                                                                                            right: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5)) - 80,
                                                                                                            child: Container(
                                                                                                              // height: 20,
                                                                                                              // width: 30,
                                                                                                              alignment: Alignment.center,
                                                                                                              decoration: BoxDecoration(
                                                                                                                  color: AppTheme.skBorderColor2,
                                                                                                                  borderRadius:
                                                                                                                  BorderRadius.circular(
                                                                                                                      10.0),
                                                                                                                  border: Border.all(
                                                                                                                    color: Colors.white,
                                                                                                                    width: 2,
                                                                                                                  )),
                                                                                                              child: Padding(
                                                                                                                padding: const EdgeInsets.only(left: 8.5, right: 8.5, top: 1, bottom: 1),
                                                                                                                child: Text(prodList[i]
                                                                                                                    .split(
                                                                                                                    '^')[4], style: TextStyle(
                                                                                                                    fontSize: 11, fontWeight: FontWeight.w500
                                                                                                                )),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      dismissal:
                                                                                                      SlidableDismissal(
                                                                                                        child:
                                                                                                        SlidableDrawerDismissal(),
                                                                                                        onDismissed:
                                                                                                            (actionType) {
                                                                                                          setState((){
                                                                                                            // mystate(() {
                                                                                                            prodList
                                                                                                                .removeAt(
                                                                                                                i);
                                                                                                            // });
                                                                                                          });
                                                                                                        },
                                                                                                      ),
                                                                                                      secondaryActions: <
                                                                                                          Widget>[
                                                                                                        IconSlideAction(
                                                                                                          caption: 'Delete',
                                                                                                          color: Colors.red,
                                                                                                          icon:
                                                                                                          Icons.delete,
                                                                                                          onTap: () {
                                                                                                            setState((){
                                                                                                              // mystate(() {
                                                                                                              prodList
                                                                                                                  .removeAt(
                                                                                                                  i);
                                                                                                              // });
                                                                                                            });
                                                                                                          },
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  );
                                                                                                }
                                                                                                return Container();
                                                                                              },
                                                                                            ),
                                                                                          Slidable(
                                                                                            key: UniqueKey(),
                                                                                            actionPane:
                                                                                            SlidableDrawerActionPane(),
                                                                                            actionExtentRatio:
                                                                                            0.25,

                                                                                            child: Container(
                                                                                              color: Colors.white,
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  discount != 0.0 ? Container(
                                                                                                    child: isDiscount == 'percent' ?
                                                                                                    ListTile(
                                                                                                      title: Text('Discount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                                                                      subtitle: Text('Percentage (' +  discountAmount.toString() + '%)', style: TextStyle(
                                                                                                          fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey
                                                                                                      )),
                                                                                                      trailing: Text('- MMK ' + (double.parse(TtlProdListPriceInit()) - double.parse(TtlProdListPrice())).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

                                                                                                    ) :  ListTile (
                                                                                                      title: Text('Discount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                                                                      subtitle: Text('Amount applied', style: TextStyle(
                                                                                                          fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey
                                                                                                      )),
                                                                                                      trailing: Text('- MMK ' + discount.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                                                                    ),
                                                                                                  ) : Container(),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            dismissal:
                                                                                            SlidableDismissal(
                                                                                              child: SlidableDrawerDismissal(),
                                                                                              onDismissed:
                                                                                                  (actionType) {
                                                                                                // mystate(() {
                                                                                                //   discountAmount = 0.0;
                                                                                                //   discount = 0.0;
                                                                                                // });
                                                                                                setState(() {
                                                                                                  discountAmount = 0.0;
                                                                                                  discount = 0.0;
                                                                                                });
                                                                                              },
                                                                                            ),
                                                                                            secondaryActions: <
                                                                                                Widget>[
                                                                                              IconSlideAction(
                                                                                                  caption: 'Delete',
                                                                                                  color: Colors.red,
                                                                                                  icon:
                                                                                                  Icons.delete,
                                                                                                  onTap: () {
                                                                                                    setState(() {
                                                                                                      discountAmount = 0.0;
                                                                                                      discount =0.0;
                                                                                                    });
                                                                                                  }

                                                                                              ),
                                                                                            ],
                                                                                          ),


                                                                                          // orderLoading?Text('Loading'):Text('')
                                                                                        ],
                                                                                      )),
                                                                                );
                                                                              }
                                                                              return Container();
                                                                            }
                                                                        ),
                                                                        Container(
                                                                          height: 67,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              border: Border(
                                                                                  bottom: BorderSide(
                                                                                      color: Colors.grey
                                                                                          .withOpacity(0.3),
                                                                                      width: 1.0))),
                                                                          child: Padding(
                                                                            padding: EdgeInsets.only(
                                                                                left: 15.0,
                                                                                right: 15.0,
                                                                                top: 0.0,
                                                                                bottom: 15.0
                                                                            ),
                                                                            child: Row(
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    setState((){
                                                                                      // mystate(() {
                                                                                      prodList = [];
                                                                                      discount = 0.0;
                                                                                      discountAmount = 0.0;
                                                                                      debt =0;
                                                                                      refund =0;
                                                                                      customerId = 'name^name';
                                                                                      // });
                                                                                    });
                                                                                  },
                                                                                  child: Container(
                                                                                    width: ((MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5))) - 57)/2,
                                                                                    height: 50,
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius:
                                                                                        BorderRadius
                                                                                            .circular(10.0),
                                                                                        color: AppTheme.clearColor),
                                                                                    child: Center(
                                                                                      child: Padding(
                                                                                        padding:
                                                                                        const EdgeInsets
                                                                                            .only(
                                                                                            left:
                                                                                            8.0,
                                                                                            right:
                                                                                            8.0,
                                                                                            bottom:
                                                                                            2.0),
                                                                                        child: Container(
                                                                                            child: Text(
                                                                                              'Clear cart',
                                                                                              textAlign:
                                                                                              TextAlign
                                                                                                  .center,
                                                                                              style: TextStyle(
                                                                                                  fontSize:
                                                                                                  18,
                                                                                                  fontWeight:
                                                                                                  FontWeight
                                                                                                      .w600,
                                                                                                  color: Colors
                                                                                                      .black),
                                                                                            )),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 15.0,
                                                                                ),
                                                                                GestureDetector(
                                                                                  onTap: () async {
                                                                                    final result = await showModalActionSheet<String>(
                                                                                      context: context,
                                                                                      actions: [
                                                                                        SheetAction(
                                                                                          icon: Icons.info,
                                                                                          label: 'Amount',
                                                                                          key: 'amount',
                                                                                        ),
                                                                                        SheetAction(
                                                                                          icon: Icons.info,
                                                                                          label: 'Percent',
                                                                                          key: 'percent',
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                    setState(() {
                                                                                      isDiscount = result.toString();
                                                                                    });

                                                                                    if (result == 'amount') {
                                                                                      final amount = await showTextInputDialog(
                                                                                        context: context,
                                                                                        textFields: [
                                                                                          DialogTextField(
                                                                                            keyboardType: TextInputType.number,
                                                                                            hintText: '0',
                                                                                            suffixText: 'MMK',
                                                                                            // initialText: 'mono0926@gmail.com',
                                                                                          ),
                                                                                        ],
                                                                                        title: 'Discount',
                                                                                        message: 'Add Discount Amount to Cart',
                                                                                      );
                                                                                      setState(() {
                                                                                        discount =double.parse(amount![0].toString());
                                                                                        print('disss ' + discount.toString());
                                                                                      });

                                                                                    } else {
                                                                                      final percentage = await showTextInputDialog(
                                                                                        context: context,
                                                                                        textFields: [
                                                                                          DialogTextField(
                                                                                            keyboardType: TextInputType.number,
                                                                                            hintText: '0.0',
                                                                                            suffixText: '%',
                                                                                            // initialText: 'mono0926@gmail.com',
                                                                                          ),
                                                                                        ],
                                                                                        title: 'Discount',
                                                                                        message: 'Add Discount Percent to Cart',
                                                                                      );
                                                                                      // mystate(() {

                                                                                      // });
                                                                                      setState(() {
                                                                                        discount =double.parse(percentage![0].toString());
                                                                                        print('disss ' + discount.toString());
                                                                                      });
                                                                                    }
                                                                                    print('dis' + result.toString());
                                                                                    setState(() {
                                                                                      print('do something');
                                                                                    });

                                                                                  },
                                                                                  child: Container(
                                                                                    width: ((MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5))) - 57)/2,
                                                                                    height: 50,
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius:
                                                                                        BorderRadius
                                                                                            .circular(10.0),
                                                                                        color: AppTheme.buttonColor2),
                                                                                    child: Center(
                                                                                      child: Padding(
                                                                                        padding:
                                                                                        const EdgeInsets
                                                                                            .only(
                                                                                            left:
                                                                                            8.0,
                                                                                            right:
                                                                                            8.0,
                                                                                            bottom:
                                                                                            2.0),
                                                                                        child: Container(
                                                                                            child: Text(
                                                                                              'Discount',
                                                                                              textAlign:
                                                                                              TextAlign
                                                                                                  .center,
                                                                                              style: TextStyle(
                                                                                                  fontSize:
                                                                                                  18,
                                                                                                  fontWeight:
                                                                                                  FontWeight
                                                                                                      .w600,
                                                                                                  color: Colors
                                                                                                      .black),
                                                                                            )),
                                                                                      ),
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
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                border: Border(
                                                                                  top: BorderSide(
                                                                                      color:
                                                                                      AppTheme.skBorderColor2,
                                                                                      width: 1.0),
                                                                                )),
                                                                            width: double.infinity,
                                                                            height: 138,
                                                                            child: Column(
                                                                              mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                              crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                              children: [
                                                                                ListTile(
                                                                                  title: Text(
                                                                                    'Total sale',
                                                                                    style: TextStyle(
                                                                                        fontSize: 17,
                                                                                        fontWeight:
                                                                                        FontWeight
                                                                                            .w500),
                                                                                  ),
                                                                                  subtitle: double.parse(totalItems()) == 1? Text(totalItems() + ' item set',
                                                                                      style: TextStyle(
                                                                                        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                                                                                      )) : Text(totalItems() + ' item sets',
                                                                                      style: TextStyle(
                                                                                          fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey
                                                                                      )),
                                                                                  trailing: Text('MMK '+
                                                                                      TtlProdListPrice().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                                                    style: TextStyle(
                                                                                        fontSize: 17,
                                                                                        fontWeight:
                                                                                        FontWeight
                                                                                            .w500),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                                                                                    child: GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          totalAmount = double.parse(TtlProdListPrice());
                                                                                        });

                                                                                        int i = 0;
                                                                                        String totalCashCal = totalAmount.toInt().toString();
                                                                                        print('CCC 0--> ' + totalAmount.toInt().toString());

                                                                                        print('CCC 1--> ' + (totalCashCal.length - i).toString());

                                                                                        print('totalAmount '+ totalAmount.toString());
                                                                                        _controllerTablet.animateTo(1);
                                                                                        if(_textFieldControllerTablet.text == '') {
                                                                                          debt = double.parse(TtlProdListPrice().toString());
                                                                                        }
                                                                                        // sellDone = false;
                                                                                      },
                                                                                      child: Container(
                                                                                        width: MediaQuery.of(context).size.width - 30,
                                                                                        height: 50,
                                                                                        decoration: BoxDecoration(
                                                                                            borderRadius:
                                                                                            BorderRadius.circular(10.0),
                                                                                            color: AppTheme.themeColor),
                                                                                        child: Row(
                                                                                          mainAxisAlignment:
                                                                                          MainAxisAlignment
                                                                                              .center,
                                                                                          children: [
                                                                                            Expanded(
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                                                child: Container(
                                                                                                    child: Text(
                                                                                                      'Checkout',
                                                                                                      textAlign: TextAlign.center,
                                                                                                      style: TextStyle(
                                                                                                          fontSize: 17,
                                                                                                          fontWeight: FontWeight.w600,
                                                                                                          color: Colors.black
                                                                                                      ),
                                                                                                    )
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
                                                                    width: double.infinity,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                        topLeft: Radius.circular(20.0),
                                                                        topRight: Radius.circular(20.0),
                                                                      ),
                                                                      color: Colors.white,
                                                                    ),
                                                                    child: Container(
                                                                      width: double.infinity,
                                                                      child: Stack(
                                                                        children: [
                                                                          Container(
                                                                            height: 67,
                                                                            width: double.infinity,
                                                                            decoration: BoxDecoration(
                                                                                border: Border(
                                                                                    bottom: BorderSide(
                                                                                        color: Colors.grey
                                                                                            .withOpacity(0.3),
                                                                                        width: 1.0))),
                                                                            child: Padding(
                                                                              padding: EdgeInsets.only(
                                                                                  left: 15.0,
                                                                                  right: 15.0,
                                                                                  top: 5.5,
                                                                                  bottom: 0.0
                                                                              ),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(customerId.split('^')[1] == 'name'? 'No customer':customerId.split('^')[1], style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.black,
                                                                                    fontSize: 13,
                                                                                  )),
                                                                                  SizedBox(height: 1),
                                                                                  Text('Cash acceptance', style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: 20
                                                                                  )),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 71.0,
                                                                                left: 0.0,
                                                                                right: 0.0),
                                                                            child: Container(
                                                                                child: ListView(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      height: 15,
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                                                      child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            SizedBox(height: 30),
                                                                                            Container(
                                                                                              // decoration: BoxDecoration(
                                                                                              //     // borderRadius: BorderRadius.all(
                                                                                              //     //   Radius.circular(10.0),
                                                                                              //     // ),
                                                                                              //     // border: Border.all(
                                                                                              //     //     color: Colors.grey.withOpacity(0.2),
                                                                                              //     //     width: 1.0),
                                                                                              //     color: AppTheme.lightBgColor),
                                                                                              // height:  100,
                                                                                                width: MediaQuery.of(context).size.width,
                                                                                                child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Text('Total sale - MMK',
                                                                                                        textAlign: TextAlign.center,
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 30, fontWeight: FontWeight.w700
                                                                                                        )),
                                                                                                    SizedBox(height: 3),
                                                                                                    Text(TtlProdListPrice().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                                                                        textAlign: TextAlign.center,
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 30, fontWeight: FontWeight.w700
                                                                                                        )),
                                                                                                  ],
                                                                                                )),
                                                                                            SizedBox(height: 40),
                                                                                            Text('CASH RECEIVED', style: TextStyle(
                                                                                                letterSpacing: 2,
                                                                                                fontWeight: FontWeight.bold,
                                                                                                fontSize: 14,color: Colors.grey
                                                                                            ),),
                                                                                            SizedBox(height: 13),
                                                                                            TextField(
                                                                                              style: TextStyle(
                                                                                                  height: 0.95
                                                                                              ),
                                                                                              decoration: InputDecoration(
                                                                                                enabledBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                                                                    borderSide: const BorderSide(
                                                                                                        color: AppTheme.skBorderColor,
                                                                                                        width: 2.0),
                                                                                                    borderRadius: BorderRadius.all(
                                                                                                        Radius.circular(10.0))),

                                                                                                focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                                                                    borderSide: const BorderSide(
                                                                                                        color: AppTheme.themeColor,
                                                                                                        width: 2.0),
                                                                                                    borderRadius: BorderRadius.all(
                                                                                                        Radius.circular(10.0))),
                                                                                                contentPadding: const EdgeInsets.only(
                                                                                                    left: 15.0,
                                                                                                    right: 15.0,
                                                                                                    top: 20.0,
                                                                                                    bottom: 20.0),
                                                                                                suffixText: 'MMK' ,
                                                                                                // tooltip: 'Increase volume by 10',
                                                                                                suffixStyle: TextStyle(
                                                                                                  color: Colors.grey,
                                                                                                  fontSize: 15,
                                                                                                  fontFamily: 'capsulesans',
                                                                                                ),
                                                                                                errorStyle: TextStyle(
                                                                                                    backgroundColor: Colors.white,
                                                                                                    fontSize: 12,
                                                                                                    fontFamily: 'capsulesans',
                                                                                                    height: 0.1
                                                                                                ),
                                                                                                labelStyle: TextStyle(
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  color: Colors.black,
                                                                                                ),
// errorText: 'Error message',
                                                                                                labelText: 'Custom price',
                                                                                                floatingLabelBehavior:
                                                                                                FloatingLabelBehavior.auto,
//filled: true,
                                                                                                border: OutlineInputBorder(
                                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                                ),
                                                                                              ),
                                                                                              keyboardType: TextInputType.number,
                                                                                              onChanged: (value) {
                                                                                                // mystate(() {
                                                                                                //   totalAmount = double.parse(TtlProdListPrice());
                                                                                                //   value != '' ? paidAmount = double.parse(value) : paidAmount = 0.0;
                                                                                                //   if((totalAmount - paidAmount).isNegative){
                                                                                                //     debt = 0;
                                                                                                //   } else { debt = (totalAmount - paidAmount);
                                                                                                //   }
                                                                                                //   if((paidAmount - totalAmount).isNegative){
                                                                                                //     refund = 0;
                                                                                                //   } else { refund = (paidAmount - totalAmount);
                                                                                                //   }
                                                                                                // });
                                                                                                setState(() {
                                                                                                  totalAmount = double.parse(TtlProdListPrice());
                                                                                                  value != '' ? paidAmount = double.parse(value) : paidAmount = 0.0;
                                                                                                  if((totalAmount - paidAmount).isNegative){
                                                                                                    debt = 0;
                                                                                                  } else { debt = (totalAmount - paidAmount);
                                                                                                  }
                                                                                                  if((paidAmount - totalAmount).isNegative){
                                                                                                    refund = 0;
                                                                                                  } else { refund = (paidAmount - totalAmount);
                                                                                                  }
                                                                                                });
                                                                                              },
                                                                                              controller: _textFieldControllerTablet,
                                                                                            ),
                                                                                            SizedBox(height: 20),

                                                                                            ButtonTheme(
                                                                                              minWidth: double.infinity,
                                                                                              //minWidth: 50,
                                                                                              splashColor: AppTheme.buttonColor2,
                                                                                              height: 50,
                                                                                              child: FlatButton(
                                                                                                color: AppTheme.buttonColor2,
                                                                                                shape: RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(7.0),
                                                                                                ),
                                                                                                onPressed: () async {
                                                                                                  setState(() {
                                                                                                    // mystate(() {
                                                                                                    //   totalAmount =
                                                                                                    //       double
                                                                                                    //           .parse(
                                                                                                    //           TtlProdListPrice());
                                                                                                    //   _textFieldController
                                                                                                    //       .text =
                                                                                                    //       totalAmount
                                                                                                    //           .toString();
                                                                                                    //   paidAmount =
                                                                                                    //       totalAmount;
                                                                                                    //   if ((totalAmount -
                                                                                                    //       paidAmount)
                                                                                                    //       .isNegative) {
                                                                                                    //     debt = 0;
                                                                                                    //   } else {
                                                                                                    //     debt =
                                                                                                    //     (totalAmount -
                                                                                                    //         paidAmount);
                                                                                                    //   }
                                                                                                    //   if ((paidAmount -
                                                                                                    //       totalAmount)
                                                                                                    //       .isNegative) {
                                                                                                    //     refund =
                                                                                                    //     0;
                                                                                                    //   } else {
                                                                                                    //     refund =
                                                                                                    //     (paidAmount -
                                                                                                    //         totalAmount);
                                                                                                    //   }
                                                                                                    // });
                                                                                                    setState(() {
                                                                                                      totalAmount =
                                                                                                          double
                                                                                                              .parse(
                                                                                                              TtlProdListPrice());
                                                                                                      _textFieldControllerTablet
                                                                                                          .text =
                                                                                                          totalAmount
                                                                                                              .toString();

                                                                                                      paidAmount =
                                                                                                          totalAmount;
                                                                                                      if ((totalAmount -
                                                                                                          paidAmount)
                                                                                                          .isNegative) {
                                                                                                        debt = 0;
                                                                                                      } else {
                                                                                                        debt =
                                                                                                        (totalAmount -
                                                                                                            paidAmount);
                                                                                                      }
                                                                                                      if ((paidAmount -
                                                                                                          totalAmount)
                                                                                                          .isNegative) {
                                                                                                        refund =
                                                                                                        0;
                                                                                                      } else {
                                                                                                        refund =
                                                                                                        (paidAmount -
                                                                                                            totalAmount);
                                                                                                      }
                                                                                                    });
                                                                                                  });
                                                                                                },
                                                                                                child: Container(
                                                                                                  child: Text( 'MMK ' +
                                                                                                      TtlProdListPrice().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w600,
                                                                                                        fontSize: 17
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(height: 20),
                                                                                          ]
                                                                                      ),
                                                                                    ),
                                                                                    // orderLoading?Text('Loading'):Text('')
                                                                                  ],
                                                                                )),
                                                                          ),
                                                                          Align(
                                                                            alignment: Alignment.bottomCenter,
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  border: Border(
                                                                                    top: BorderSide(
                                                                                        color:
                                                                                        AppTheme.skBorderColor2,
                                                                                        width: 1.0),
                                                                                  )),
                                                                              width: double.infinity,
                                                                              height: 138,
                                                                              child: Column(
                                                                                mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                                crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                                children: [
                                                                                  debt!= 0 ? ListTile(
                                                                                    title: Text(
                                                                                      'Debt amount',
                                                                                      style: TextStyle(
                                                                                          fontSize: 17,
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .w500),
                                                                                    ),
                                                                                    trailing: Text('- MMK '+
                                                                                        debt.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                                                      style: TextStyle(
                                                                                          fontSize: 17,
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .w500),
                                                                                    ),
                                                                                  ) : ListTile(
                                                                                    title: Text(
                                                                                      'Cash refund',
                                                                                      style: TextStyle(
                                                                                          fontSize: 17,
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .w500),
                                                                                    ),
                                                                                    trailing: Text('MMK '+
                                                                                        refund.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                                                      style: TextStyle(
                                                                                          fontSize: 17,
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .w500),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: 7),
                                                                                  Padding(
                                                                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                                                                                      child: Row(
                                                                                          children: [
                                                                                            GestureDetector(
                                                                                              onTap: () {
                                                                                                setState((){
                                                                                                  // mystate(() {
                                                                                                  _controllerTablet.animateTo(0);
                                                                                                  _textFieldControllerTablet.clear();
                                                                                                  paidAmount = 0;
                                                                                                  debt = 0;
                                                                                                  refund = 0;
                                                                                                  totalAmount = double.parse(TtlProdListPrice());
                                                                                                  // });
                                                                                                });
                                                                                              },
                                                                                              child: Container(
                                                                                                width: ((MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5))) - 52)/2,
                                                                                                height: 50,
                                                                                                decoration: BoxDecoration(
                                                                                                    borderRadius:
                                                                                                    BorderRadius.circular(10.0),
                                                                                                    color: AppTheme.secButtonColor),
                                                                                                child: Row(
                                                                                                  mainAxisAlignment:
                                                                                                  MainAxisAlignment
                                                                                                      .center,
                                                                                                  children: [
                                                                                                    Expanded(
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                                                        child: Container(
                                                                                                            child: Text(
                                                                                                              'Back',
                                                                                                              textAlign: TextAlign.center,
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: 18,
                                                                                                                  fontWeight: FontWeight.w600,
                                                                                                                  color: Colors.black
                                                                                                              ),
                                                                                                            )
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Spacer(),
                                                                                            GestureDetector(
                                                                                              onTap: () async {
                                                                                                discountAmount = discount;
                                                                                                subList = [];
                                                                                                DateTime now = DateTime.now();
                                                                                                //CollectionReference daily_order = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders');
                                                                                                int length = 0;
                                                                                                int totalOrders = 0;
                                                                                                int debts = 0;
                                                                                                var dateExist = false;
                                                                                                var dateId = '';
                                                                                                double debtAmounts = 0 ;
                                                                                                print('order creating');

                                                                                                FirebaseFirestore.instance.collection('shops').doc(shopId)
                                                                                                    .get().then((value) async {
                                                                                                  length = int.parse(value.data()!['orders_length'].toString());
                                                                                                  print('lengthsss' + length.toString());

                                                                                                  length = length + 1;

                                                                                                  print('CHECK POINT 0' + deviceIdNum.toString());
                                                                                                  print('CHECK POINT 1');
                                                                                                  orderLengthIncrease();
                                                                                                  print('productList' + prodList.toString());

                                                                                                  for (String str in prodList) {

                                                                                                    CollectionReference productsFire = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products');

                                                                                                    subList.add(str.split('^')[0] + '-' + 'veriD' + '-' + 'buy0' + '-' + str.split('^')[4] +'-' + str.split('^')[2] + '-' + str.split('^')[3] +'-' + str.split('^')[4] + '-0-' + 'date');
                                                                                                    print('strsplit' + str.split('-')[0].toString());

                                                                                                    productsFire.doc(str.split('^')[0])
                                                                                                        .get().then((val22) async {

                                                                                                      List<String> subLink = [];
                                                                                                      List<String> subName = [];
                                                                                                      List<double> subStock = [];

                                                                                                      var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(str.split('^')[0])
                                                                                                          .get();

                                                                                                      if (docSnapshot10.exists) {
                                                                                                        Map<String, dynamic>? data10 = docSnapshot10.data();

                                                                                                        for(int i = 0; i < double.parse(data10 ? ["sub_exist"]) + 1; i++) {
                                                                                                          subLink.add(data10 ? ['sub' + (i+1).toString() + '_link']);
                                                                                                          subName.add(data10 ? ['sub' + (i+1).toString() + '_name']);
                                                                                                          print('inStock' + (i+1).toString());
                                                                                                          print(' CHECKING ' + (data10 ? ['mainSellUnit']).toString());
                                                                                                          subStock.add(double.parse((data10 ? ['inStock' + (i+1).toString()]).toString()));
                                                                                                        }
                                                                                                      }

                                                                                                      print(subStock.toString());

                                                                                                      if(str.split('^')[3] == 'unit_name') {
                                                                                                        decStockFromInv(str.split('^')[0], 'main', str.split('^')[4]);
                                                                                                        prodSaleData(str.split('^')[0], double.parse(str.split('^')[4].toString()));

                                                                                                      } else if(str.split('^')[3] == 'sub1_name') {
                                                                                                        sub1Execution(subStock, subLink, str.split('^')[0], str.split('^')[4]);
                                                                                                        productsFire.doc(str.split('^')[0]).update({
                                                                                                          'sub1SellUnit' : FieldValue.increment(double.parse(str.split('^')[4].toString())),
                                                                                                        });

                                                                                                      } else if(str.split('^')[3] == 'sub2_name') {
                                                                                                        sub2Execution(subStock, subLink, str.split('^')[0], str.split('^')[4]);
                                                                                                        productsFire.doc(str.split('^')[0]).update({
                                                                                                          'sub2SellUnit' : FieldValue.increment(double.parse(str.split('^')[4].toString())),
                                                                                                        });
                                                                                                      }
                                                                                                    });
                                                                                                  }
                                                                                                  print('subList ' + subList.toString());

                                                                                                  if(customerId.split('^')[0] != 'name' && debt.toString() != '0.0') {
                                                                                                    debts = 1;
                                                                                                    debtAmounts = debt;
                                                                                                  } else {
                                                                                                    debts = 0;
                                                                                                    debtAmounts = 0;
                                                                                                  }

                                                                                                  print('subList2 ' + subList2.toString());

                                                                                                  if(customerId.split('^')[0] != 'name') {
                                                                                                    totalOrders = totalOrders + 1;
                                                                                                    CusOrder(totalOrders, debts, debtAmounts);
                                                                                                  }

                                                                                                  FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders')
                                                                                                      .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 00:00:00'))
                                                                                                      .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 23:59:59'))
                                                                                                      .get()
                                                                                                      .then((QuerySnapshot querySnapshot)  async {
                                                                                                    querySnapshot.docs.forEach((doc) {
                                                                                                      dateExist = true;
                                                                                                      dateId = doc.id;
                                                                                                    });

                                                                                                    if (dateExist) {
                                                                                                      addDateExist(dateId, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString())  + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice() + '^' + customerId.split('^')[0] + '^FALSE' + '^' + debt.toString() + '^' + discountAmount.toString() + disText, length.toString());
                                                                                                      Detail(now, length.toString(),subList, dateId);
                                                                                                      print('adddateexist added');
                                                                                                    }
                                                                                                    else {
                                                                                                      DatenotExist(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString())  + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice() + '^' + customerId.split('^')[0] + '^FALSE' + '^' + debt.toString() + '^' + discountAmount.toString() + disText, now, length.toString());
                                                                                                      Detail(now, length.toString(),subList, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) +  deviceIdNum.toString());
                                                                                                      print('adddateexist not');
                                                                                                    }
                                                                                                  });

                                                                                                  List<String> subNameList = [];
                                                                                                  int subNameListLength = 0;
                                                                                                  for (String str in prodList) {
                                                                                                    subNameListLength = subNameListLength + 1;
                                                                                                    CollectionReference productsFire = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products');
                                                                                                    print('DATA CHECK PROD ' + str.toString());
                                                                                                    var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(str.split('^')[0])
                                                                                                        .get();
                                                                                                    if (docSnapshot10.exists) {
                                                                                                      Map<String, dynamic>? data10 = docSnapshot10.data();
                                                                                                      subNameList.add(data10 ? [str.split('^')[3]]);
                                                                                                      if(prodList.length == subNameListLength) {
                                                                                                        print('fianlize : ' + subNameList.toString());
                                                                                                        final date = now;
                                                                                                        final dueDate = date.add(Duration(days: 7));
                                                                                                        print('CUZMER CHECK ' + customerId.toString());
                                                                                                        final invoice = Invoice(
                                                                                                          supplier: Supplier(
                                                                                                            name: shopGloName,
                                                                                                            address: shopGloAddress,
                                                                                                            phone: shopGloPhone,
                                                                                                            paymentInfo: '',
                                                                                                          ),
                                                                                                          customer: Customer(
                                                                                                            name: customerId.split('^')[1],
                                                                                                            address: '',
                                                                                                          ),
                                                                                                          info: InvoiceInfo(
                                                                                                              date: date,
                                                                                                              dueDate: dueDate,
                                                                                                              description: 'My description...',
                                                                                                              // number: '${DateTime.now().year}-9999',
                                                                                                              number: deviceIdNum.toString() + '^' + length.toString()
                                                                                                          ),
                                                                                                          items: [
                                                                                                            for(int i=0; i<prodList.length; i++)
                                                                                                              InvoiceItem(
                                                                                                                description: prodList[i].split('^')[1],
                                                                                                                // date: prodList[i].split('^')[3] + '^' + subNameList[i].toString(),
                                                                                                                date: subNameList[i].toString(),
                                                                                                                quantity: double.parse(prodList[i].split('^')[4]),
                                                                                                                vat: discountAmount,
                                                                                                                type: disText,
                                                                                                                debt: debt,
                                                                                                                unitPrice: double.parse(prodList[i].split('^')[2]),
                                                                                                              )

                                                                                                          ],
                                                                                                        );


                                                                                                        getPaperId().then((value) async {
                                                                                                          print('VVAALLUUEE ' + value.toString());
                                                                                                          pdfFile = await PdfInvoiceApi.generate(invoice, value);

                                                                                                          Uint8List bytes = pdfFile!.readAsBytesSync();

                                                                                                          // mystate(() {
                                                                                                          //   // setState(() {
                                                                                                          //   pdfText = pdfFile!.path.toString();
                                                                                                          //   // });
                                                                                                          // });
                                                                                                          setState(() {
                                                                                                            pdfText = pdfFile!.path.toString();

                                                                                                            prodList = [];
                                                                                                            discount = 0.0;
                                                                                                            discountAmount =0.0;
                                                                                                            debt =0;
                                                                                                            refund =0;
                                                                                                            customerId = 'name^name';
                                                                                                            disText = '';
                                                                                                            isDiscount = '';
                                                                                                          });


                                                                                                          // mystate(()  {
                                                                                                          //   prodList = [];
                                                                                                          //   discount = 0.0;
                                                                                                          //   debt =0;
                                                                                                          //   refund =0;
                                                                                                          //   //customerId = 'name^name';
                                                                                                          // });


                                                                                                          _controllerTablet.animateTo(3, duration: Duration(milliseconds: 0), curve: Curves.ease);
                                                                                                        });

                                                                                                      }
                                                                                                    }

                                                                                                  }





                                                                                                });

                                                                                              },
                                                                                              child: Container(
                                                                                                width: ((MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5))) - 52)/2,
                                                                                                height: 50,
                                                                                                decoration: BoxDecoration(
                                                                                                    borderRadius:
                                                                                                    BorderRadius.circular(10.0),
                                                                                                    color: AppTheme.themeColor),
                                                                                                child: Row(
                                                                                                  mainAxisAlignment:
                                                                                                  MainAxisAlignment
                                                                                                      .center,
                                                                                                  children: [
                                                                                                    Expanded(
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                                                        child: Container(
                                                                                                            child: Text(
                                                                                                              'Done',
                                                                                                              textAlign: TextAlign.center,
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: 17,
                                                                                                                  fontWeight: FontWeight.w600,
                                                                                                                  color: Colors.black
                                                                                                              ),
                                                                                                            )
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ]
                                                                                      )
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),

                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
                                                                    width: double.infinity,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                        topLeft: Radius.circular(20.0),
                                                                        topRight: Radius.circular(20.0),
                                                                      ),
                                                                      color: Colors.white,
                                                                    ),
                                                                    child: Container(
                                                                      width: double.infinity,
                                                                      child:
                                                                      eachProd.length!=0 ? Stack(
                                                                        children: [
                                                                          Container(
                                                                            width: double.infinity,
                                                                            height: 71,
                                                                            decoration: BoxDecoration(
                                                                                border: Border(
                                                                                    bottom: BorderSide(
                                                                                        color: Colors.blue
                                                                                            .withOpacity(0.1),
                                                                                        width: 1.0))),
                                                                            child:

                                                                            Padding(
                                                                              padding: EdgeInsets.only(
                                                                                  left: 15.0,
                                                                                  right: 15.0,
                                                                                  top: 6),
                                                                              child:
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Text('MMK '+ titlePrice.toString(), style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.grey
                                                                                      )),
                                                                                      SizedBox(width: 5),
                                                                                      // if (unit == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
                                                                                      // else if(unit == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
                                                                                      // else if(unit == 'sub2_name') Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,)
                                                                                      //   else Icon( Icons.check, size: 17, color: Colors.grey,),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(height: 3.5),
                                                                                  Text('productName', style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: 21
                                                                                  )),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 85.0,
                                                                                left: 15.0,
                                                                                right: 15.0),
                                                                            child: Container(
                                                                                child: ListView(
                                                                                  children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text('QUANTITY', style: TextStyle(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 14,
                                                                                            letterSpacing: 2,
                                                                                            color: Colors.grey
                                                                                        ),),
                                                                                        SizedBox(height: 15),
                                                                                        Row(
                                                                                          children: [
                                                                                            GestureDetector(
                                                                                              onTap: () {
                                                                                                // mystate(() {

                                                                                                // });
                                                                                                setState(() {
                                                                                                  quantity = double.parse(myControllerTablet.text) -1;
                                                                                                  myControllerTablet.text = quantity.toString();
                                                                                                  print('qqq' + quantity.toString());
                                                                                                });
                                                                                              },
                                                                                              child: Container(
                                                                                                width: (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5)) - 61)/3,
                                                                                                height: 55,
                                                                                                decoration: BoxDecoration(
                                                                                                    borderRadius:
                                                                                                    BorderRadius.circular(10.0),
                                                                                                    color: AppTheme.themeColor),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.only(
                                                                                                      top: 15.0,
                                                                                                      bottom: 15.0),
                                                                                                  child: Row(
                                                                                                    mainAxisAlignment:
                                                                                                    MainAxisAlignment
                                                                                                        .center,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                                                          child: Container(
                                                                                                              child: Icon(
                                                                                                                Icons.remove, size: 20,
                                                                                                              )
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(width: 15),
                                                                                            Container(
                                                                                              width: (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5)) - 61)/3,
                                                                                              height: 55,
                                                                                              child: TextField(
                                                                                                textAlign: TextAlign.center,
                                                                                                decoration: InputDecoration(
                                                                                                  enabledBorder: const OutlineInputBorder(
                                                                                                    // width: 0.0 produces a thin "hairline" border
                                                                                                      borderSide: const BorderSide(
                                                                                                          color: AppTheme.skBorderColor, width: 2.0),
                                                                                                      borderRadius: BorderRadius.all(Radius.circular(10.0))),

                                                                                                  focusedBorder: const OutlineInputBorder(
                                                                                                    // width: 0.0 produces a thin "hairline" border
                                                                                                      borderSide: const BorderSide(
                                                                                                          color: AppTheme.skThemeColor2, width: 2.0),
                                                                                                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                                                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                                                  //filled: true,
                                                                                                  border: OutlineInputBorder(
                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                  ),
                                                                                                ),
                                                                                                keyboardType: TextInputType.number,
                                                                                                onChanged: (value) {
                                                                                                  setState(() {
                                                                                                    quantity = double.parse(value);
                                                                                                  });
                                                                                                },
                                                                                                controller: myControllerTablet,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(width: 15),
                                                                                            GestureDetector(
                                                                                              onTap: () {
                                                                                                setState(() {
                                                                                                  // mystate(() {

                                                                                                  // });
                                                                                                  setState(() {
                                                                                                    quantity = double.parse(myControllerTablet.text) +1;
                                                                                                    myControllerTablet.text = quantity.toString();
                                                                                                    print('qqq' + quantity.toString());
                                                                                                  });
                                                                                                });
                                                                                              },
                                                                                              child: Container(
                                                                                                width: (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5)) - 61)/3,
                                                                                                height: 55,
                                                                                                decoration: BoxDecoration(
                                                                                                    borderRadius:
                                                                                                    BorderRadius.circular(10.0),
                                                                                                    color: AppTheme.themeColor),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.only(
                                                                                                      top: 15.0,
                                                                                                      bottom: 15.0),
                                                                                                  child: Row(
                                                                                                    mainAxisAlignment:
                                                                                                    MainAxisAlignment
                                                                                                        .center,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                                                          child: Container(
                                                                                                              child: Icon(
                                                                                                                Icons.add, size: 20,
                                                                                                              )
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(height: 15,),
                                                                                        Text('COST PER UNIT', style: TextStyle(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 14,
                                                                                            letterSpacing: 2,
                                                                                            color: Colors.grey
                                                                                        ),),
                                                                                        SizedBox(height: 15,),
                                                                                        TextFormField(
                                                                                          keyboardType: TextInputType.number,
                                                                                          controller: sellPriceControllerTablet,
                                                                                          validator: (value) {
                                                                                            if (value == null || value.isEmpty) {
                                                                                              setState(() {
                                                                                                price2 = 0;
                                                                                              });
                                                                                              // return '';
                                                                                              return ' This field is required ';
                                                                                            }
                                                                                            return null;
                                                                                          },
                                                                                          style: TextStyle(
                                                                                              height: 0.95
                                                                                          ),
                                                                                          maxLines: 1,
                                                                                          decoration: InputDecoration(
                                                                                            enabledBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                                                                borderSide: const BorderSide(
                                                                                                    color: AppTheme.skBorderColor,
                                                                                                    width: 2.0),
                                                                                                borderRadius: BorderRadius.all(
                                                                                                    Radius.circular(10.0))),

                                                                                            focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                                                                borderSide: const BorderSide(
                                                                                                    color: AppTheme.themeColor,
                                                                                                    width: 2.0),
                                                                                                borderRadius: BorderRadius.all(
                                                                                                    Radius.circular(10.0))),
                                                                                            // contentPadding: EdgeInsets.symmetric(vertical: 10), //Change this value to custom as you like
                                                                                            // isDense: true,
                                                                                            contentPadding: const EdgeInsets.only(
                                                                                                left: 15.0,
                                                                                                right: 15.0,
                                                                                                top: 20,
                                                                                                bottom: 20.0),
                                                                                            suffixText: 'MMK',
                                                                                            suffixStyle: TextStyle(
                                                                                              color: Colors.grey,
                                                                                              fontSize: 12,
                                                                                              fontFamily: 'capsulesans',
                                                                                            ),
                                                                                            //errorText: wrongEmail,
                                                                                            errorStyle: TextStyle(
                                                                                                backgroundColor: Colors.white,
                                                                                                fontSize: 12,
                                                                                                fontFamily: 'capsulesans',
                                                                                                height: 0.1
                                                                                            ),
                                                                                            labelStyle: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              color: Colors.black,
                                                                                            ),
// errorText: 'Error message',
                                                                                            labelText: 'Custom Sell Price',
                                                                                            floatingLabelBehavior:
                                                                                            FloatingLabelBehavior.auto,
//filled: true,
                                                                                            border: OutlineInputBorder(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(height: 15,),
                                                                                        Text('UNIT PRICING', style: TextStyle(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontSize: 14,
                                                                                          letterSpacing: 2,
                                                                                          color: Colors.grey,
                                                                                        ),),
                                                                                        Container(
                                                                                          height: 220,
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(20.0),
                                                                                            color: AppTheme.lightBgColor,
                                                                                          ),
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Container(
                                                                                                  height: 55,
                                                                                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(
                                                                                                      color: Colors.grey
                                                                                                          .withOpacity(0.2),
                                                                                                      width: 1.0))),
                                                                                                  child: Row(
                                                                                                    children: [
                                                                                                      Text('Sell price', style:
                                                                                                      TextStyle(
                                                                                                          fontSize: 15,
                                                                                                          fontWeight: FontWeight.w500
                                                                                                      ),),
                                                                                                      Spacer(),
                                                                                                      eachProd.split('^')[3]== 'unit_name' ? Text('MMK ' +  sell1.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                                                                      TextStyle(
                                                                                                        fontSize: 15,
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        color: Colors.grey,
                                                                                                      ),) :
                                                                                                      eachProd.split('^')[3]== 'sub1_name' ? Text('MMK ' +  sell2.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                                                                      TextStyle(
                                                                                                          fontSize: 15,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          color: Colors.grey
                                                                                                      ),) :  Text('MMK ' +  sell3.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                                                                      TextStyle(
                                                                                                          fontSize: 15,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          color: Colors.grey
                                                                                                      ),),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                                Container(
                                                                                                  height: 55,
                                                                                                  decoration: BoxDecoration(
                                                                                                      border: Border(
                                                                                                          bottom: BorderSide(
                                                                                                              color: Colors.grey
                                                                                                                  .withOpacity(0.2),
                                                                                                              width: 1.0))),
                                                                                                  child: Row(
                                                                                                    children: [
                                                                                                      Text('In stock', style:
                                                                                                      TextStyle(
                                                                                                          fontSize: 15,
                                                                                                          fontWeight: FontWeight.w500
                                                                                                      ),),
                                                                                                      Spacer(),
                                                                                                      eachProd.split('^')[3]== 'unit_name' ? Text('mainQty'.toString() + ' ' + 'mainName', style:
                                                                                                      TextStyle(
                                                                                                          fontSize: 15,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          color: Colors.grey
                                                                                                      ),) : eachProd.split('^')[3]== 'sub1_name'? Text( 'sub1Qty'.toString() + ' ' + 'sub1Name', style:
                                                                                                      TextStyle(
                                                                                                          fontSize: 15,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          color: Colors.grey
                                                                                                      ),) : Text('sub2Qty'.toString() + ' ' + 'sub2Name', style:
                                                                                                      TextStyle(
                                                                                                          fontSize: 15,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          color: Colors.grey
                                                                                                      ),),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                                Container(
                                                                                                  height: 55,
                                                                                                  decoration: BoxDecoration(
                                                                                                      border: Border(
                                                                                                          bottom: BorderSide(
                                                                                                              color: Colors.grey
                                                                                                                  .withOpacity(0.2),
                                                                                                              width: 1.0))),
                                                                                                  child: Row(
                                                                                                    children: [
                                                                                                      Text('Loss', style:
                                                                                                      TextStyle(
                                                                                                          fontSize: 15,
                                                                                                          fontWeight: FontWeight.w500
                                                                                                      ),),
                                                                                                      Spacer(),
                                                                                                      eachProd.split('^')[3]== 'unit_name' ? Text(mainLoss.toString() + ' ' + mainName, style:
                                                                                                      TextStyle(
                                                                                                          fontSize: 15,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          color: Colors.grey
                                                                                                      ),) : eachProd.split('^')[3]== 'sub1_name'? Text(sub1Loss.toString() + ' ' + sub1Name, style:
                                                                                                      TextStyle(
                                                                                                          fontSize: 15,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          color: Colors.grey
                                                                                                      ),) : Text(sub2Loss.toString() + ' ' + sub2Name, style:
                                                                                                      TextStyle(
                                                                                                          fontSize: 15,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          color: Colors.grey
                                                                                                      ),),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                                Container(
                                                                                                  height: 55,
                                                                                                  child: Row(
                                                                                                    children: [
                                                                                                      Text('Barcode', style:
                                                                                                      TextStyle(
                                                                                                          fontSize: 15,
                                                                                                          fontWeight: FontWeight.w500
                                                                                                      ),),
                                                                                                      Spacer(),
                                                                                                      Text('barcode', style:
                                                                                                      TextStyle(
                                                                                                          fontSize: 15,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          color: Colors.grey
                                                                                                      ),),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        //     }
                                                                                        //     return Container();
                                                                                        //   },
                                                                                        // ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                )),
                                                                          ),
                                                                          Align(
                                                                            alignment: Alignment.bottomCenter,
                                                                            child: Padding(
                                                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                    border: Border(
                                                                                      top: BorderSide(
                                                                                          color:
                                                                                          AppTheme.skBorderColor2,
                                                                                          width: 1.0),
                                                                                    )),
                                                                                width: double.infinity,
                                                                                height: 158,
                                                                                child: Column(
                                                                                  mainAxisAlignment:
                                                                                  MainAxisAlignment.end,
                                                                                  crossAxisAlignment:
                                                                                  CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    ListTile(
                                                                                      title: Text(
                                                                                        'Total',
                                                                                        style: TextStyle(
                                                                                            fontSize: 17,
                                                                                            fontWeight:
                                                                                            FontWeight
                                                                                                .w500),
                                                                                      ),
                                                                                      trailing: Text('MMK '+
                                                                                          (totalFixAmount).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                                                        style: TextStyle(
                                                                                            fontSize: 17,
                                                                                            fontWeight:
                                                                                            FontWeight
                                                                                                .w500),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 10),
                                                                                    Padding(
                                                                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
                                                                                        child: Row(
                                                                                            children: [
                                                                                              GestureDetector(
                                                                                                onTap: () {
                                                                                                  setState((){
                                                                                                    // mystate(() {
                                                                                                    _controllerTablet.animateTo(0);
                                                                                                    _textFieldControllerTablet.clear();
                                                                                                    paidAmount = 0;
                                                                                                    debt = 0;
                                                                                                    refund = 0;
                                                                                                    totalAmount = double.parse(TtlProdListPrice());
                                                                                                    // });
                                                                                                  });

                                                                                                },
                                                                                                child: Container(
                                                                                                  width: (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5)) - 45)/2,
                                                                                                  height: 55,
                                                                                                  decoration: BoxDecoration(
                                                                                                      borderRadius:
                                                                                                      BorderRadius.circular(10.0),
                                                                                                      color: AppTheme.secButtonColor),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.only(
                                                                                                        top: 15.0,
                                                                                                        bottom: 15.0),
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment:
                                                                                                      MainAxisAlignment
                                                                                                          .center,
                                                                                                      children: [
                                                                                                        Expanded(
                                                                                                          child: Padding(
                                                                                                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                                                            child: Container(
                                                                                                                child: Text(
                                                                                                                  'Back',
                                                                                                                  textAlign: TextAlign.center,
                                                                                                                  style: TextStyle(
                                                                                                                      fontSize: 18,
                                                                                                                      fontWeight: FontWeight.w600,
                                                                                                                      color: Colors.black
                                                                                                                  ),
                                                                                                                )
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Spacer(),
                                                                                              GestureDetector(
                                                                                                onTap: () {
                                                                                                  if (_formKey2.currentState!.validate()) {
                                                                                                    print('eachProduct' +eachProd);
                                                                                                    for (int j = 0; j < prodList.length; j++)
                                                                                                      if( prodList[j].split('^')[0] == eachProd.split('^')[0] && prodList[j].split('^')[3] == eachProd.split('^')[3]){
                                                                                                        setState((){
                                                                                                          eachProd = eachProd.split('^')[0] +'^' + eachProd.split('^')[1]+'^'+ (price2.toString()) +'^'+eachProd.split('^')[3]+ '^'+ (quantity.toString())+'^'+eachProd.split('^')[5];
                                                                                                          prodList[j] = eachProd;
                                                                                                        });
                                                                                                        print('leepae' + prodList[j]);
                                                                                                      } else print('leelar');
                                                                                                    _controllerTablet.animateTo(0);
                                                                                                  }
                                                                                                },
                                                                                                child: Container(
                                                                                                  width: (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5)) - 45)/2,
                                                                                                  height: 50,
                                                                                                  decoration: BoxDecoration(
                                                                                                      borderRadius:
                                                                                                      BorderRadius.circular(10.0),
                                                                                                      color: AppTheme.themeColor),
                                                                                                  child: Row(
                                                                                                    mainAxisAlignment:
                                                                                                    MainAxisAlignment
                                                                                                        .center,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                                                          child: Container(
                                                                                                              child: Text(
                                                                                                                'Done',
                                                                                                                textAlign: TextAlign.center,
                                                                                                                style: TextStyle(
                                                                                                                    fontSize: 17,
                                                                                                                    fontWeight: FontWeight.w600,
                                                                                                                    color: Colors.black
                                                                                                                ),
                                                                                                              )
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ]
                                                                                        )
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),

                                                                        ],
                                                                      ) : Container(),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
                                                                    width: double.infinity,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                        topLeft: Radius.circular(20.0),
                                                                        topRight: Radius.circular(20.0),
                                                                      ),
                                                                      color: Colors.white,
                                                                    ),
                                                                    child: Container(
                                                                      width: double.infinity,
                                                                      child: Stack(
                                                                        children: [
                                                                          Container(
                                                                            height: 67,
                                                                            width: double.infinity,
                                                                            decoration: BoxDecoration(
                                                                                border: Border(
                                                                                    bottom: BorderSide(
                                                                                        color: Colors.grey
                                                                                            .withOpacity(0.3),
                                                                                        width: 1.0))),
                                                                            child: Padding(
                                                                              padding: EdgeInsets.only(
                                                                                  left: 15.0,
                                                                                  right: 15.0,
                                                                                  top: 5.0,
                                                                                  bottom: 0.0
                                                                              ),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(customerId.split('^')[1] == 'name'? 'No customer':customerId.split('^')[1], style: TextStyle(
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Colors.grey
                                                                                  )),
                                                                                  SizedBox(height: 2.5),
                                                                                  Text('Invoice receipt', style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: 19
                                                                                  )),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 71.0,
                                                                                left: 0.0,
                                                                                right: 0.0),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  child: Padding(
                                                                                      padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 12.0),
                                                                                      child: Row(
                                                                                          children: [
                                                                                            GestureDetector(
                                                                                              onTap: () async {
                                                                                                final doc = await PdfDocument.openFile(pdfFile!.path);
                                                                                                final pages = doc.pageCount;
                                                                                                List<imglib.Image> images = [];

// get images from all the pages
                                                                                                for (int i = 1; i <= pages; i++) {
                                                                                                  var page = await doc.getPage(i);
                                                                                                  var imgPDF = await page.render(width: page.width.round()*5, height: page.height.round()*5);
                                                                                                  var img = await imgPDF.createImageDetached();
                                                                                                  var imgBytes = await img.toByteData(format: ImageByteFormat.png);
                                                                                                  var libImage = imglib.decodeImage(imgBytes!.buffer
                                                                                                      .asUint8List(imgBytes.offsetInBytes, imgBytes.lengthInBytes));
                                                                                                  images.add(libImage!);
                                                                                                }

// stitch images
                                                                                                int totalHeight = 0;
                                                                                                images.forEach((e) {
                                                                                                  totalHeight += e.height;
                                                                                                });
                                                                                                int totalWidth = 0;
                                                                                                images.forEach((element) {
                                                                                                  totalWidth = totalWidth < element.width ? element.width : totalWidth;
                                                                                                });
                                                                                                mergedImage = imglib.Image(totalWidth, totalHeight);
                                                                                                int mergedHeight = 0;
                                                                                                images.forEach((element) {
                                                                                                  imglib.copyInto(mergedImage, element, dstX: 0, dstY: mergedHeight, blend: false);
                                                                                                  mergedHeight += element.height;
                                                                                                });

                                                                                                // Save image as a file
                                                                                                // final documentDirectory = await getExternalStorageDirectory();
                                                                                                // Directory appDocDirectory = await getApplicationDocumentsDirectory();
                                                                                                // File imgFile = new File(appDocDirectory.path + 'test.jpg');
                                                                                                // new File(imgFile.path).writeAsBytes(imglib.encodeJpg(mergedImage));

                                                                                                // Save to album.
                                                                                                // bool? success = await ImageSave.saveImage(Uint8List.fromList(imglib.encodeJpg(mergedImage)), "demo.jpg", albumName: "demo");
                                                                                                _saveImage(Uint8List.fromList(imglib.encodeJpg(mergedImage)));
                                                                                              },
                                                                                              child: Container(
                                                                                                width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5)) - 31 - 100,
                                                                                                height: 50,
                                                                                                decoration: BoxDecoration(
                                                                                                  borderRadius:
                                                                                                  BorderRadius.circular(10.0),
                                                                                                  color: AppTheme.secButtonColor,
                                                                                                ),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.only(
                                                                                                      top: 0.0,
                                                                                                      bottom: 0.0),
                                                                                                  child: Row(
                                                                                                    mainAxisAlignment:
                                                                                                    MainAxisAlignment
                                                                                                        .center,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                                                          child: Container(
                                                                                                              child: Text(
                                                                                                                'Save as image',
                                                                                                                textAlign: TextAlign.center,
                                                                                                                style: TextStyle(
                                                                                                                    fontSize: 17,
                                                                                                                    fontWeight: FontWeight.w600,
                                                                                                                    color: Colors.black
                                                                                                                ),
                                                                                                              )
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(width: 15.0),
                                                                                            GestureDetector(
                                                                                              onTap: () async {
                                                                                                _onScanPressed();
                                                                                                setState(() {
                                                                                                  // mystate(()  {
                                                                                                  prodList = [];
                                                                                                  discount = 0.0;
                                                                                                  discountAmount =0.0;
                                                                                                  debt =0;
                                                                                                  refund =0;
                                                                                                  customerId = 'name^name';
                                                                                                  disText = '';
                                                                                                  isDiscount = '';
                                                                                                  // });
                                                                                                });
                                                                                                Future.delayed(const Duration(milliseconds: 1000), () {
                                                                                                  _controllerTablet.animateTo(4);
                                                                                                });
                                                                                              },
                                                                                              child: Container(
                                                                                                // width: (MediaQuery.of(context).size.width - 45)* (1/4),
                                                                                                width: 85,
                                                                                                height: 50,
                                                                                                decoration: BoxDecoration(
                                                                                                    borderRadius:
                                                                                                    BorderRadius.circular(10.0),
                                                                                                    color: AppTheme.themeColor),
                                                                                                child: Padding(
                                                                                                  padding: const EdgeInsets.only(
                                                                                                      top: 0.0,
                                                                                                      bottom: 0.0),
                                                                                                  child: Row(
                                                                                                    mainAxisAlignment:
                                                                                                    MainAxisAlignment
                                                                                                        .center,
                                                                                                    children: [
                                                                                                      Expanded(
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
                                                                                                          child: Container(
                                                                                                              child: Icon(
                                                                                                                Icons.print_rounded,
                                                                                                                size: 25,
                                                                                                                color: Colors.black,
                                                                                                              )
                                                                                                            // child: Text(
                                                                                                            //   '',
                                                                                                            //   textAlign: TextAlign.center,
                                                                                                            //   style: TextStyle(
                                                                                                            //       fontSize: 18,
                                                                                                            //       fontWeight: FontWeight.w600,
                                                                                                            //       color: Colors.black
                                                                                                            //   ),
                                                                                                            // )
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ]
                                                                                      )
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: 5),
                                                                                // Container(
                                                                                //   height: 500,
                                                                                //   width: 200,
                                                                                //   child: GestureDetector(
                                                                                //       onTap: () {
                                                                                //         print('clicked');
                                                                                //         PdfApi.openFile(pdfFile);
                                                                                //       },
                                                                                //       child: PdfViewer.openFile(pdfText)
                                                                                //   ),
                                                                                // )
                                                                                // SizedBox(
                                                                                //   height: 10,
                                                                                // ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                                                  child: Text('RECEIPT VOUCHER',
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: 14,
                                                                                      letterSpacing: 2,
                                                                                      color: Colors.grey,
                                                                                    ),),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                pdfText == '' ? Container(height: 20, width: 20, color: Colors.blue) :
                                                                                Expanded(
                                                                                    child: GestureDetector(
                                                                                        onTap: () {
                                                                                          print('clicked');
                                                                                          PdfApi.openFile(pdfFile!);
                                                                                        },
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                                          child: PdfViewer.openFile(pdfText),
                                                                                        )
                                                                                    )
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 137,
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Align(
                                                                            alignment: Alignment.bottomCenter,
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  border: Border(
                                                                                    top: BorderSide(
                                                                                        color:
                                                                                        AppTheme.skBorderColor2,
                                                                                        width: 1.0),
                                                                                  )),
                                                                              width: double.infinity,
                                                                              height: 138,
                                                                              child: Column(
                                                                                mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                                crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                                children: [
                                                                                  ListTile(
                                                                                    title: Text(
                                                                                      'Total price',
                                                                                      style: TextStyle(
                                                                                          fontSize: 17,
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .w500),
                                                                                    ),
                                                                                    trailing: Text('MMK '+
                                                                                        TtlProdListPrice().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                                                      style: TextStyle(
                                                                                          fontSize: 17,
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .w500),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: 7),
                                                                                  Padding(
                                                                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                                                                                      child: Row(
                                                                                          children: [
                                                                                            GestureDetector(
                                                                                              onTap: () async {
                                                                                                setState(() {
                                                                                                  // mystate(()  {
                                                                                                  prodList = [];
                                                                                                  discount = 0.0;
                                                                                                  discountAmount =0.0;
                                                                                                  debt =0;
                                                                                                  refund =0;
                                                                                                  customerId = 'name^name';
                                                                                                  disText = '';
                                                                                                  isDiscount = '';
                                                                                                  // });
                                                                                                });
                                                                                                // _controller.animateTo(0);
                                                                                                // _controller.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);

                                                                                                _textFieldControllerTablet.clear();
                                                                                                _controllerTablet.animateTo(0);
                                                                                                // Navigator.pop(context);
                                                                                                // sellDone = true;


                                                                                              },
                                                                                              child: Container(
                                                                                                width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5)) - 31,
                                                                                                height: 50,
                                                                                                decoration: BoxDecoration(
                                                                                                    borderRadius:
                                                                                                    BorderRadius.circular(10.0),
                                                                                                    color: AppTheme.themeColor),
                                                                                                child: Row(
                                                                                                  mainAxisAlignment:
                                                                                                  MainAxisAlignment
                                                                                                      .center,
                                                                                                  children: [
                                                                                                    Expanded(
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                                                        child: Container(
                                                                                                            child: Text(
                                                                                                              'Next sale',
                                                                                                              textAlign: TextAlign.center,
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: 17,
                                                                                                                  fontWeight: FontWeight.w600,
                                                                                                                  color: Colors.black
                                                                                                              ),
                                                                                                            )
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ]
                                                                                      )
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),

                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          height: 67,
                                                                          width: double.infinity,
                                                                          decoration: BoxDecoration(
                                                                              border: Border(
                                                                                  bottom: BorderSide(
                                                                                      color: Colors.grey
                                                                                          .withOpacity(0.3),
                                                                                      width: 1.0))),
                                                                          child: Padding(
                                                                            padding: EdgeInsets.only(
                                                                                left: 15.0,
                                                                                right: 15.0,
                                                                                top: 5.0,
                                                                                bottom: 0.0
                                                                            ),
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(customerId.split('^')[1] == 'name'? 'No customer':customerId.split('^')[1], style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Colors.grey,
                                                                                )),
                                                                                SizedBox(height: 2.5),
                                                                                Text('Printing service', style: TextStyle(
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: 19
                                                                                )),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        // GestureDetector(
                                                                        //     onTap: _isLoading ? null : _onScanPressed,
                                                                        //     child: Text('click to scan', style: TextStyle(fontSize: 25),)
                                                                        // ),
                                                                        Expanded(
                                                                          child: _isLoading && _blueDevices.isEmpty
                                                                              ? Center(
                                                                            child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                                                child: CupertinoActivityIndicator(radius: 15,)),
                                                                          )
                                                                              : _blueDevices.isNotEmpty
                                                                              ? SingleChildScrollView(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  SizedBox(height: 5),
                                                                                  Column(
                                                                                    children: List<Widget>.generate(_blueDevices.length,
                                                                                            (int index) {
                                                                                          return Row(
                                                                                            children: <Widget>[
                                                                                              Expanded(
                                                                                                child: GestureDetector(
                                                                                                  onTap: _blueDevices[index].address ==
                                                                                                      (_selectedDevice?.address ?? '')
                                                                                                      ? _onDisconnectDevice
                                                                                                      : () => _onSelectDevice(index),
                                                                                                  child: Container(
                                                                                                    color: Colors.white,
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                      child: Column(
                                                                                                        crossAxisAlignment:
                                                                                                        CrossAxisAlignment.start,
                                                                                                        children: <Widget>[
                                                                                                          Text(
                                                                                                            _blueDevices[index].name,
                                                                                                            style: TextStyle(
                                                                                                                color:
                                                                                                                _selectedDevice?.address ==
                                                                                                                    _blueDevices[index]
                                                                                                                        .address
                                                                                                                    ? AppTheme.themeColor
                                                                                                                    : Colors.black,
                                                                                                                fontWeight: FontWeight.w600,
                                                                                                                fontSize: 19
                                                                                                            ),
                                                                                                          ),
                                                                                                          Text(
                                                                                                            _blueDevices[index].address,
                                                                                                            style: TextStyle(
                                                                                                                color:
                                                                                                                _selectedDevice?.address ==
                                                                                                                    _blueDevices[index]
                                                                                                                        .address
                                                                                                                    ? Colors.blueGrey
                                                                                                                    : Colors.grey,
                                                                                                                fontSize: 14,
                                                                                                                fontWeight: FontWeight.w500
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              if (_loadingAtIndex == index && _isLoading)
                                                                                                Container(
                                                                                                  height: 24.0,
                                                                                                  width: 65.0,
                                                                                                  margin: const EdgeInsets.only(right: 8.0),
                                                                                                  child: Center(
                                                                                                    child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                                                                        child: Padding(
                                                                                                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                                                                                          child: CupertinoActivityIndicator(radius: 10,),
                                                                                                        )
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              if (!_isLoading &&
                                                                                                  _blueDevices[index].address ==
                                                                                                      (_selectedDevice?.address ?? ''))
                                                                                                TextButton(
                                                                                                  onPressed: _onPrintReceipt,
                                                                                                  // child: Container(
                                                                                                  //   color: _selectedDevice == null
                                                                                                  //       ? AppTheme.buttonColor2
                                                                                                  //       : AppTheme.themeColor,
                                                                                                  //   padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10, left: 10),
                                                                                                  //   child: Icon(
                                                                                                  //     Icons.print_rounded,
                                                                                                  //     size: 25,
                                                                                                  //     color: Colors.black,
                                                                                                  //   )
                                                                                                  //   // child: const Text(
                                                                                                  //   //     'Print',
                                                                                                  //   //     style: TextStyle(color: Colors.white)
                                                                                                  //   // ),
                                                                                                  // ),
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.only(top: 3.0, bottom: 3.0, left: 20.0, right: 20.0),
                                                                                                    child: Icon(
                                                                                                      Icons.print_rounded,
                                                                                                      size: 25,
                                                                                                      color: Colors.black,
                                                                                                    ),
                                                                                                  ),
                                                                                                  style: ButtonStyle(
                                                                                                      backgroundColor: MaterialStateProperty
                                                                                                          .resolveWith<Color>(
                                                                                                            (Set<MaterialState> states) {
                                                                                                          if (states.contains(
                                                                                                              MaterialState.pressed)) {
                                                                                                            return AppTheme.themeColor.withOpacity(0.5);
                                                                                                          }
                                                                                                          return AppTheme.themeColor;
                                                                                                        },
                                                                                                      ),
                                                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                                          RoundedRectangleBorder(
                                                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                                                          )
                                                                                                      )
                                                                                                  ),
                                                                                                ),
                                                                                              SizedBox(width: 8.5)
                                                                                            ],
                                                                                          );
                                                                                        }),
                                                                                  ),
                                                                                  SizedBox(height: 5),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )
                                                                              : Center(
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: const <Widget>[
                                                                                Text(
                                                                                  'Scan bluetooth device',
                                                                                  style: TextStyle(fontSize: 24, color: Colors.blue),
                                                                                ),
                                                                                Text(
                                                                                  'Press button scan',
                                                                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          // child: _devices.isEmpty
                                                                          //     ? Center(child: Text(_devicesMsg ?? ''))
                                                                          //     : ListView.builder(
                                                                          //   itemCount: _devices.length,
                                                                          //   itemBuilder: (c, i) {
                                                                          //     return ListTile(
                                                                          //       leading: Icon(Icons.print),
                                                                          //       title: Text(_devices[i].name.toString()),
                                                                          //       subtitle: Text(_devices[i].address.toString()),
                                                                          //       onTap: () {
                                                                          //         // _startPrint(_devices[i]);
                                                                          //       },
                                                                          //     );
                                                                          //   },
                                                                          // )
                                                                        ),
                                                                        Align(
                                                                          alignment: Alignment.bottomCenter,
                                                                          child: Padding(
                                                                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  border: Border(
                                                                                    top: BorderSide(
                                                                                        color:
                                                                                        AppTheme.skBorderColor2,
                                                                                        width: 1.0),
                                                                                  )),
                                                                              width: double.infinity,
                                                                              height: 150,
                                                                              child: Column(
                                                                                mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                                crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                                children: [
                                                                                  ListTile(
                                                                                    title: Text(
                                                                                      'Total price',
                                                                                      style: TextStyle(
                                                                                          fontSize: 17,
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .w500),
                                                                                    ),
                                                                                    trailing: Text('MMK '+
                                                                                        debt.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                                                      style: TextStyle(
                                                                                          fontSize: 17,
                                                                                          fontWeight:
                                                                                          FontWeight
                                                                                              .w500),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: 10),
                                                                                  Padding(
                                                                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 27.0),
                                                                                      child: Row(
                                                                                          children: [
                                                                                            GestureDetector(
                                                                                              onTap: () async {
                                                                                                // setState(() {
                                                                                                //   prodList = [];
                                                                                                //   discount = 0.0;
                                                                                                //   discountAmount =0.0;
                                                                                                //   debt =0;
                                                                                                //   refund =0;
                                                                                                //   customerId = 'name^name';
                                                                                                //   disText = '';
                                                                                                //   isDiscount = '';
                                                                                                // });
                                                                                                // _controller.animateTo(0);
                                                                                                // _controller.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);

                                                                                                _textFieldController.clear();
                                                                                                _textFieldControllerTablet.clear();
                                                                                                _controllerTablet.animateTo(0);


                                                                                              },
                                                                                              child: Container(
                                                                                                width: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5)) - 31,
                                                                                                height: 50,
                                                                                                decoration: BoxDecoration(
                                                                                                    borderRadius:
                                                                                                    BorderRadius.circular(10.0),
                                                                                                    color: AppTheme.themeColor),
                                                                                                child: Row(
                                                                                                  mainAxisAlignment:
                                                                                                  MainAxisAlignment
                                                                                                      .center,
                                                                                                  children: [
                                                                                                    Expanded(
                                                                                                      child: Padding(
                                                                                                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                                                        child: Container(
                                                                                                            child: Text(
                                                                                                              'Next sale',
                                                                                                              textAlign: TextAlign.center,
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: 17,
                                                                                                                  fontWeight: FontWeight.w600,
                                                                                                                  color: Colors.black
                                                                                                              ),
                                                                                                            )
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ]
                                                                                      )
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 42,
                                                          child: Container(
                                                            width: MediaQuery.of(context).size.width,
                                                            child: Align(
                                                              alignment: Alignment.center,
                                                              child: Container(
                                                                width: 50,
                                                                height: 5,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(
                                                                      Radius.circular(25.0),
                                                                    ),
                                                                    color: Colors.white.withOpacity(0.5)),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    (prodList2.length != 0 || merchantId != 'name^name') ?
                                    Positioned(
                                      bottom: 157,
                                      right: 15,
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MerchantCart(deviceId: deviceIdNum, shop: shopId.toString(), merchantId: merchantId, prodList2: prodList2, toggleCoinCallback: clearProd2, toggleCoinCallback2: clearMerch, toggleCoinCallback4:  endProdLoadingState, toggleCoinCallback3: prodLoadingState,)),);
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: 155,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  color:  AppTheme.themeColor,
                                                  borderRadius: BorderRadius.circular(50.0),
                                                  border: Border.all(
                                                    color: Colors.transparent,
                                                    width: 5,
                                                  )
                                              ),
                                            ),
                                            Positioned(
                                              right: 5,
                                              top: 3.5,
                                              child: Container(
                                                width: 42,
                                                height: 42,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(50.0),
                                                    border: Border.all(
                                                      color: Colors.transparent,
                                                      width: 5,
                                                    )
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 15,
                                              top: 13,
                                              child: Container(
                                                child: Icon( SmartKyat_POS.merchant,
                                                  size: 22,),
                                              ),
                                            ),
                                            Positioned(
                                              left: 16,
                                              top: 14,
                                              child: Text(totalItems2() + ' item set', style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w500
                                              )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ) : Container(),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: homeBotPadding,
                                          // bottom: MediaQuery.of(context).viewInsets.bottom
                                        ),
                                        child: Container(
                                          color: Colors.transparent,
                                          // height: MediaQuery.of(context).size.width > 900 ? 61 : 142,
                                          height: MediaQuery.of(context).size.width > 900 ? 61: _goToCartHeight,
                                          child: Stack(
                                            children: [
                                              if (MediaQuery.of(context).size.width > 900) Container() else
                                              // Container(
                                              //     decoration: BoxDecoration(
                                              //         color: Colors.white,
                                              //         border: Border(
                                              //           top: BorderSide(
                                              //               color: AppTheme.skBorderColor2,
                                              //               width: 1.0),
                                              //         )
                                              //     ),
                                              //     child: Padding(
                                              //       padding:
                                              //       const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                                              //       child: Container(
                                              //         height: 50,
                                              //         child: GestureDetector(
                                              //           onTap: () {
                                              //             saleCart(context);
                                              //           },
                                              //           child: (prodList.length == 0) ? Container(
                                              //             decoration: BoxDecoration(
                                              //               borderRadius: BorderRadius.circular(10.0),
                                              //               color: customerId == 'name^name' ? AppTheme.buttonColor2 : AppTheme.themeColor,
                                              //               // color: Colors.blue
                                              //             ),
                                              //
                                              //             child: Padding(
                                              //               padding: const EdgeInsets.only(
                                              //                   top: 13.0, bottom: 15.0),
                                              //               child: Row(
                                              //                 mainAxisAlignment:
                                              //                 MainAxisAlignment.center,
                                              //                 children: [
                                              //                   Expanded(
                                              //                     child: Padding(
                                              //                       padding: const EdgeInsets.only(
                                              //                           left: 8.0,
                                              //                           right: 8.0,
                                              //                           bottom: 2.0),
                                              //                       child: Container(
                                              //                         child: Text(
                                              //                           'Go to cart',
                                              //                           textAlign: TextAlign.center,
                                              //                           style: TextStyle(
                                              //                               fontSize: 18,
                                              //                               fontWeight: FontWeight.w500,
                                              //                               color: Colors.black),
                                              //                         ),
                                              //                       ),
                                              //                     ),
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //           ) : Container(
                                              //             decoration: BoxDecoration(
                                              //               borderRadius: BorderRadius.circular(10.0),
                                              //               color: AppTheme.themeColor,
                                              //               // color: Colors.blue
                                              //             ),
                                              //
                                              //             child: Padding(
                                              //               padding: const EdgeInsets.only(
                                              //                   top: 13.0, bottom: 15.0),
                                              //               child: Row(
                                              //                 mainAxisAlignment:
                                              //                 MainAxisAlignment.center,
                                              //                 children: [
                                              //                   Expanded(
                                              //                     child: Padding(
                                              //                       padding: const EdgeInsets.only(
                                              //                           left: 8.0,
                                              //                           right: 8.0,
                                              //                           bottom: 2.0),
                                              //                       child: double.parse(totalItems()) == 1? Container(
                                              //                         child:
                                              //                         Text(
                                              //                           totalItems() + ' item - ' + TtlProdListPrice() + ' MMK',
                                              //                           textAlign: TextAlign.center,
                                              //                           style: TextStyle(
                                              //                               fontSize: 18,
                                              //                               fontWeight: FontWeight.w500,
                                              //                               color: Colors.black),
                                              //                         ),
                                              //                       ) : Container(
                                              //                         child:
                                              //                         Text(
                                              //                           totalItems() + ' items - ' + TtlProdListPrice() + ' MMK',
                                              //                           textAlign: TextAlign.center,
                                              //                           style: TextStyle(
                                              //                               fontSize: 18,
                                              //                               fontWeight: FontWeight.w500,
                                              //                               color: Colors.black),
                                              //                         ),
                                              //                       ),
                                              //                     ),
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                                AnimatedPadding(
                                                  curve: Curves.easeInCubic,
                                                  duration: const Duration(milliseconds: 200),
                                                  padding: EdgeInsets.only(top: closeGoToCart? 81.0 : 0.0),
                                                  child: _goToCartHeight == 142 ? Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        border: Border(
                                                          top: BorderSide(
                                                              color: AppTheme.skBorderColor2,
                                                              width: 1.0),
                                                        )
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                                                      child: Container(
                                                        height: 50,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            saleCart(context);
                                                          },
                                                          child: (prodList.length == 0) ? Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                              color: customerId == 'name^name' ? AppTheme.buttonColor2 : AppTheme.themeColor,
                                                              // color: Colors.blue
                                                            ),

                                                            child: Padding(
                                                              padding: const EdgeInsets.only(
                                                                  top: 13.0, bottom: 15.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                                children: [
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(
                                                                          left: 8.0,
                                                                          right: 8.0,
                                                                          bottom: 2.0),
                                                                      child: Container(
                                                                        child: Text(
                                                                          'Go to cart',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ) : Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                              color: AppTheme.themeColor,
                                                              // color: Colors.blue
                                                            ),

                                                            child: Padding(
                                                              padding: const EdgeInsets.only(
                                                                  top: 13.0, bottom: 15.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                                children: [
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(
                                                                          left: 8.0,
                                                                          right: 8.0,
                                                                          bottom: 2.0),
                                                                      child: double.parse(totalItems()) == 1? Container(
                                                                        child:
                                                                        Text(
                                                                          totalItems() + ' item - ' + TtlProdListPrice() + ' MMK',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ) : Container(
                                                                        child:
                                                                        Text(
                                                                          totalItems() + ' items - ' + TtlProdListPrice() + ' MMK',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black),
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
                                                    ),
                                                  ): Container(),
                                                ),
                                              Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Container(
                                                  height: 61,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border(
                                                        top: BorderSide(
                                                            color: AppTheme.skBorderColor2, width: 1.0),
                                                      )),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 15.0,top:0.0
                                                          ),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              _scaffoldKey.currentState!.openDrawer();
                                                            },
                                                            child: selectedTab(

                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              print('go to cart 3');
                                                            },
                                                            child: Container(),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            // Text(startDate.isBefore(nowCheck) && endDate.isAfter(nowCheck)? 'Pro': 'Free'),
                                                            //SizedBox(width:15),
                                                            Padding(
                                                                padding: const EdgeInsets.only(
                                                                    right: 15.0, left: 10.0, top: 2.0
                                                                ),
                                                                child: _connectionStatus?
                                                                Center(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(bottom: 2),
                                                                    child: Icon(
                                                                      Icons.wifi_tethering_rounded,
                                                                      size: 24.5,
                                                                      color: Colors.green,
                                                                    ),
                                                                  ),
                                                                ) :
                                                                Center(
                                                                  child: Icon(
                                                                    Icons.portable_wifi_off_rounded,
                                                                    size: 24.5,
                                                                    color: Colors.grey,
                                                                  ),
                                                                )
                                                              // child: StreamBuilder(
                                                              //     stream: Connectivity().onConnectivityChanged,
                                                              //     builder: (BuildContext ctxt,AsyncSnapshot<ConnectivityResult> snapShot) {
                                                              //       if (!snapShot.hasData)
                                                              //         return Center(
                                                              //           child: Icon(
                                                              //             Icons.cloud_off_rounded,
                                                              //             size: 25,
                                                              //             color: Colors.black,
                                                              //           ),
                                                              //         );
                                                              //       var result = snapShot.data;
                                                              //       switch (result) {
                                                              //         case ConnectivityResult.none:
                                                              //
                                                              //           return Center(
                                                              //             child: Icon(
                                                              //               Icons.cloud_off_rounded,
                                                              //               size: 25,
                                                              //               color: Colors.black,
                                                              //             ),
                                                              //           );
                                                              //         case ConnectivityResult.mobile:
                                                              //         case ConnectivityResult.wifi:
                                                              //
                                                              //           return Center(
                                                              //             child: Icon(
                                                              //               Icons.cloud_rounded,
                                                              //               size: 25,
                                                              //               color: Colors.black,
                                                              //             ),
                                                              //           );
                                                              //         default:
                                                              //           return Center(
                                                              //             child: Icon(
                                                              //               Icons.cloud_off_rounded,
                                                              //               size: 25,
                                                              //               color: Colors.black,
                                                              //             ),
                                                              //           );
                                                              //       }
                                                              //
                                                              //     })
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          color: Colors.white,
                                          height: homeBotPadding,
                                        )
                                    )
                                  ],
                                );
                              }
                          ),
                        );
                      }
                      return Container();
                    }
                );
              }
              return Container();
            }
        ),
      ),
    );
  }

  List<String> prodList = [];
  late final SlidableController slidableController;
  addProduct(data) async {
    for (var i = 0; i < prodList.length; i++) {
      if (prodList[i].split('^')[0] == data.split('^')[0] &&
          prodList[i].split('^')[3] == data.split('^')[3]) {
        data = data.split('^')[0] +
            '^' +
            data.split('^')[1] +
            '^' +
            data.split('^')[2] +
            '^' +
            data.split('^')[3] +
            '^' +
            (double.parse(prodList[i].split('^')[4]) +  double.parse(data.split('^')[4])).toString();
        setState((){prodList[i] = data + '^0'; });
        return;
      }
    }
    if (data != 'null') {
      setState((){prodList.add(data + '^0');});
    }
  }

  List<String> prodList2 = [];
  late final SlidableController slidableController1;
  addProduct3(data) {
    if (data != 'null') {
      setState(() {
        prodList2.add(data + '^0^');
      });
    }
  }


  String customerId = 'name^name';

  addCustomer2Cart(data) {
    setState(() {
      customerId = data.toString();
    });
  }

  addMerchant2Cart(data) {
    setState(() {
      merchantId = data.toString();
    });
  }

  openBarcodeSearch() async {
    String result = '';
    result = await Navigator.of(context).push(
      FadeRoute(page: QRSearchExample()),
    );


    if(result != null && result != '') {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(shopId)
          .collection('products')
          .where('bar_code', isEqualTo: result)
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) {
        // print()
        querySnapshot.docs.forEach((doc) {
          print('CHECK ' + doc['prod_name'].toString());
          scannedResult(doc.id + '^' + doc['prod_name'] + '^' + doc['unit_sell'] + '^' + doc['sub1_sell']
              + '^' + doc['sub2_sell'] + '^' + doc['inStock1'].toString() + '^' + doc['inStock2'].toString() + '^' + doc['inStock3'].toString() + '^' + doc['sub_exist'] + '^' +
              doc['unit_name'] + '^' + doc['sub1_name'] + '^' + doc['sub2_name'] + '^' + doc['bar_code']);

          doc['sub1_name'] != ''  && doc['sub2_name'] == '' ? _testList = [{'no': 1, 'keyword': doc['unit_name']}, {'no': 2, 'keyword': doc['sub1_name']}]:
          doc['sub1_name'] != ''  && doc['sub2_name'] != '' ? _testList = [{'no': 1, 'keyword': doc['unit_name']}, {'no': 2, 'keyword': doc['sub1_name']}, {'no': 3, 'keyword': doc['sub2_name']}] :
          _testList = [{'no': 1, 'keyword': doc['unit_name']}];
          qty = 1;
          price4 = 0;
          buyPriceController.text = price4.toString();
          barcodeCtrl.text = qty.toString();
          _dropdownTestItems = buildDropdownTestItems(_testList);
        });
      });

    }
  }

  // addString2Sub(data){
  //
  //   DateTime now =
  //   DateTime.now();
  //   CollectionReference
  //   daily_order =
  //   FirebaseFirestore
  //       .instance
  //       .collection(
  //       'space')
  //       .doc(
  //       '0NHIS0Jbn26wsgCzVBKT')
  //       .collection(
  //       'shops')
  //       .doc(
  //       shopId)
  //       .collection(
  //       'buyOrders');
  //   var length = 0;
  //   setState(() {
  //     orderLoading = true;
  //   });
  //
  //   print('order creating');
  //
  //   FirebaseFirestore
  //       .instance
  //       .collection('space')
  //       .doc(
  //       '0NHIS0Jbn26wsgCzVBKT')
  //       .collection('shops')
  //       .doc(
  //       shopId)
  //       .collection(
  //       'buyOrders')
  //   // FirebaseFirestore.instance.collection('space')
  //       .get()
  //       .then((QuerySnapshot
  //   querySnapshot) async {
  //     querySnapshot.docs
  //         .forEach((doc) {
  //       length += double.parse(
  //           doc['daily_order']
  //               .length
  //               .toString());
  //     });
  //     length =
  //         1000 + length + 1;
  //
  //     //Check new date or not
  //     var dateExist = false;
  //     var dateId = '';
  //
  //     FirebaseFirestore
  //         .instance
  //         .collection(
  //         'space')
  //         .doc(
  //         '0NHIS0Jbn26wsgCzVBKT')
  //         .collection(
  //         'shops')
  //         .doc(
  //         shopId)
  //         .collection(
  //         'buyOrders')
  //     // FirebaseFirestore.instance.collection('space')
  //         .where('date',
  //         isEqualTo: now
  //             .year
  //             .toString() +
  //             zeroToTen(now
  //                 .month
  //                 .toString()) +
  //             zeroToTen(now
  //                 .day
  //                 .toString()))
  //         .get()
  //         .then((QuerySnapshot
  //     querySnapshot) {
  //       querySnapshot.docs
  //           .forEach((doc) {
  //         dateExist = true;
  //         dateId = doc.id;
  //       });
  //
  //       if (dateExist) {
  //         daily_order
  //             .doc(dateId)
  //             .update({
  //           'daily_order':
  //           FieldValue
  //               .arrayUnion([
  //             now.year.toString() +
  //                 zeroToTen(now
  //                     .month
  //                     .toString()) +
  //                 zeroToTen(now
  //                     .day
  //                     .toString()) +
  //                 zeroToTen(now
  //                     .hour
  //                     .toString()) +
  //                 zeroToTen(now
  //                     .minute
  //                     .toString()) +
  //                 zeroToTen(now
  //                     .second
  //                     .toString()) +
  //                 deviceIdNum
  //                     .toString() +
  //                 length
  //                     .toString() +
  //                 '^' +
  //                 deviceIdNum
  //                     .toString() +
  //                 '^' +
  //                 length
  //                     .toString() +
  //                 '^' +
  //                 TtlProdListPrice2() +
  //                 '^' +
  //                 merchantId
  //                     .split(
  //                     '^')[0] +
  //                 '^pf'
  //           ])
  //         }).then((value) {
  //           print(
  //               'User updated');
  //           setState(() {
  //             orderLoading =
  //             false;
  //           });
  //
  //           FirebaseFirestore
  //               .instance
  //               .collection(
  //               'space')
  //               .doc(
  //               '0NHIS0Jbn26wsgCzVBKT')
  //               .collection(
  //               'shops')
  //               .doc(
  //               shopId)
  //               .collection(
  //               'buyOrders')
  //               .doc(dateId)
  //               .collection(
  //               'expansion')
  //               .doc(now
  //               .year
  //               .toString() +
  //               zeroToTen(now
  //                   .month
  //                   .toString()) +
  //               zeroToTen(now
  //                   .day
  //                   .toString()) +
  //               zeroToTen(now
  //                   .hour
  //                   .toString()) +
  //               zeroToTen(now
  //                   .minute
  //                   .toString()) +
  //               zeroToTen(now
  //                   .second
  //                   .toString()) +
  //               deviceIdNum
  //                   .toString() +
  //               length
  //                   .toString())
  //               .set({
  //             'main':
  //             'total',
  //             'subs':
  //             data,
  //           }).then((value) {
  //             print(
  //                 'order added');
  //           });
  //         });
  //       } else {
  //         daily_order.add({
  //           'daily_order': [
  //             now.year.toString() +
  //                 zeroToTen(now
  //                     .month
  //                     .toString()) +
  //                 zeroToTen(now
  //                     .day
  //                     .toString()) +
  //                 zeroToTen(now
  //                     .hour
  //                     .toString()) +
  //                 zeroToTen(now
  //                     .minute
  //                     .toString()) +
  //                 zeroToTen(now
  //                     .second
  //                     .toString()) +
  //                 deviceIdNum
  //                     .toString() +
  //                 length
  //                     .toString() +
  //                 '^' +
  //                 deviceIdNum
  //                     .toString() +
  //                 '^' +
  //                 length
  //                     .toString() +
  //                 '^' +
  //                 TtlProdListPrice2() +
  //                 '^' +
  //                 merchantId
  //                     .split(
  //                     '^')[0] +
  //                 '^pf'
  //           ],
  //           'date': now.year
  //               .toString() +
  //               zeroToTen(now
  //                   .month
  //                   .toString()) +
  //               zeroToTen(now
  //                   .day
  //                   .toString())
  //         }).then((value) {
  //           print(
  //               'order added');
  //
  //           FirebaseFirestore
  //               .instance
  //               .collection(
  //               'space')
  //               .doc(
  //               '0NHIS0Jbn26wsgCzVBKT')
  //               .collection(
  //               'shops')
  //               .doc(
  //               shopId)
  //               .collection(
  //               'buyOrders')
  //               .doc(value
  //               .id)
  //               .collection(
  //               'expansion')
  //               .doc(now
  //               .year
  //               .toString() +
  //               zeroToTen(now
  //                   .month
  //                   .toString()) +
  //               zeroToTen(now
  //                   .day
  //                   .toString()) +
  //               zeroToTen(now
  //                   .hour
  //                   .toString()) +
  //               zeroToTen(now
  //                   .minute
  //                   .toString()) +
  //               zeroToTen(now
  //                   .second
  //                   .toString()) +
  //               deviceIdNum
  //                   .toString() +
  //               length
  //                   .toString())
  //               .set({
  //             'main':
  //             'total',
  //             'subs':
  //             data,
  //           }).then((value) {
  //             print(
  //                 'order added');
  //           });
  //         });
  //       }
  //     });
  //
  //   });
  //
  // }
  TextEditingController buyPriceController = TextEditingController();
  double qty = 0;
  double totalFixAmount2 = 0;
  double titlePrice2 = 0;
  double price4 = 0;
  String sellprice5 = '0';
  String instock = '';
  String loss5 = '5';
  String barcode5 = '';
  String name5 = '';
  String data = '';
  TextEditingController barcodeCtrl = TextEditingController();
  scannedResult(String result) {
    var _selectedTest;
    showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          barcode5 = result.split('^')[12];
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter stateful) {
              if(_selectedTest.toString() == '{no: 1, keyword: ' + result.split('^')[9] + '}') {
                stateful((){
                  sellprice5 = result.split('^')[2];
                  instock = result.split('^')[5];
                  name5 = result.split('^')[9];
                  data ='^unit_name^';
                });
                print('selected test is true');
              } else  if(_selectedTest.toString() == '{no: 2, keyword: ' + result.split('^')[10] + '}') {
                stateful((){
                  sellprice5 = result.split('^')[3];
                  instock = result.split('^')[6];
                  name5 = result.split('^')[10];
                  data ='^sub1_name^';
                });

                print('selected test is false');
              } else{
                stateful((){
                  sellprice5 = result.split('^')[4];
                  instock = result.split('^')[7];
                  name5 = result.split('^')[11];
                  data ='^sub2_name^';
                });
                print('selected test is tf');}

              barcodeCtrl.addListener((){

                (barcodeCtrl.text != '' && buyPriceController.text != '') ? totalFixAmount2 =double.parse(barcodeCtrl.text) * double.parse(buyPriceController.text) : totalFixAmount2 = 0.0;
              });

              buyPriceController.addListener((){

                (barcodeCtrl.text != '' && buyPriceController.text != '') ? totalFixAmount2 =double.parse(barcodeCtrl.text) * double.parse(buyPriceController.text) : totalFixAmount2 = 0.0;
                if( buyPriceController.text != '') {
                  price4 = double.parse(buyPriceController.text); } else {
                  price4 = 0;
                }

              });


              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18.0),
                              topRight: Radius.circular(18.0),
                            ),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              controller: _controllerTabBarCode,
                              children: [
                                Container(
                                  // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 67,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.blue
                                                          .withOpacity(0.1),
                                                      width: 1.0))),
                                          child:

                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                top: 4),
                                            child:
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('MMK ' + result.split('^')[2], style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey
                                                    )),
                                                  ],
                                                ),
                                                SizedBox(height: 3),
                                                Text(result.split('^')[1], style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 19
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 67.0,
                                              left: 15.0,
                                              right: 15.0,
                                              bottom: 192),
                                          child: Container(
                                              child: ListView(
                                                children: [
                                                  SizedBox(
                                                      height: 15
                                                  ),
                                                  Text('CHOOSE UNIT', style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    letterSpacing: 2,
                                                    color: Colors.grey,
                                                  ),),
                                                  SizedBox(
                                                      height: 15
                                                  ),
                                                  DropdownBelow(
                                                    itemWidth: MediaQuery.of(context).size.width-30,
                                                    itemTextstyle: TextStyle(
                                                        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                                                    boxTextstyle: TextStyle(
                                                        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                                                    boxPadding: EdgeInsets.fromLTRB(15, 12, 13, 12),
                                                    boxWidth: double.infinity,
                                                    boxHeight: 60,
                                                    boxDecoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(10.0),
                                                        color: AppTheme.buttonColor2,
                                                        border: Border.all(width: 1, color: Colors.transparent)),
                                                    icon: Icon(
                                                      Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black,
                                                    ),
                                                    hint: Text('Filter'),
                                                    value: _selectedTest,
                                                    // value: name5.toString(),
                                                    items: _dropdownTestItems,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        stateful((){
                                                          _selectedTest = value;
                                                        });});
                                                      if(_selectedTest.toString() == '{no: 1, keyword: ' + result.split('^')[9] + '}') {
                                                        stateful((){
                                                          buyPriceController.text = result.split('^')[2];
                                                        });
                                                      } else  if(_selectedTest.toString() == '{no: 2, keyword: ' + result.split('^')[10] + '}') {
                                                        stateful((){
                                                          buyPriceController.text = result.split('^')[3];

                                                        });
                                                      } else{
                                                        stateful((){
                                                          buyPriceController.text = result.split('^')[4];
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(height: 15),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('QUANTITY', style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        letterSpacing: 2,
                                                        color: Colors.grey,
                                                      ),),
                                                      SizedBox(height: 15),
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                stateful((){
                                                                  qty = double.parse(barcodeCtrl.text) - 1;
                                                                  barcodeCtrl.text = qty.toString();
                                                                  print('qqq' + qty.toString());
                                                                });});
                                                            },
                                                            child: Container(
                                                              width: (MediaQuery.of(context).size.width - 60)/3,
                                                              height: 48,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.circular(10.0),
                                                                  color: AppTheme.themeColor),
                                                              child: Container(
                                                                  child: Icon(
                                                                    Icons.remove, size: 25,
                                                                  )
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 15),
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 2.5),
                                                            child: Container(
                                                              width: (MediaQuery.of(context).size.width - 60)/3,
                                                              height: 50,
                                                              child: TextField(
                                                                textAlign: TextAlign.center,
                                                                decoration: InputDecoration(
                                                                  enabledBorder: const OutlineInputBorder(
                                                                    // width: 0.0 produces a thin "hairline" border
                                                                      borderSide: const BorderSide(
                                                                          color: AppTheme.skBorderColor, width: 2.0),
                                                                      borderRadius: BorderRadius.all(Radius.circular(10.0))),

                                                                  focusedBorder: const OutlineInputBorder(
                                                                    // width: 0.0 produces a thin "hairline" border
                                                                      borderSide: const BorderSide(
                                                                          color: AppTheme.skThemeColor2, width: 2.0),
                                                                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                  //filled: true,
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                ),
                                                                keyboardType: TextInputType.number,
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    setState((){
                                                                      qty = double.parse(value);
                                                                    });
                                                                  });
                                                                },
                                                                controller: barcodeCtrl,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 15),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                stateful((){
                                                                  qty = double.parse(barcodeCtrl.text) + 1;
                                                                  barcodeCtrl.text = qty.toString();
                                                                  print('qqq' + qty.toString());
                                                                });});
                                                            },
                                                            child: Container(
                                                              width: (MediaQuery.of(context).size.width - 60)/3,
                                                              height: 48,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.circular(10.0),
                                                                  color: AppTheme.themeColor),
                                                              child: Container(
                                                                  child: Icon(
                                                                    Icons.add, size: 25,
                                                                  )
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 15,),
                                                      TextFormField(
                                                        keyboardType: TextInputType.number,
                                                        controller: buyPriceController,
                                                        validator: (value) {
                                                          if (value == null || value.isEmpty) {
                                                            // return '';
                                                            return ' This field is required ';
                                                          }

                                                          return null;
                                                        },
                                                        style: TextStyle(
                                                            height: 0.95
                                                        ),
                                                        maxLines: 1,
                                                        decoration: InputDecoration(
                                                          enabledBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                              borderSide: const BorderSide(
                                                                  color: AppTheme.skBorderColor,
                                                                  width: 2.0),
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(10.0))),

                                                          focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                              borderSide: const BorderSide(
                                                                  color: AppTheme.themeColor,
                                                                  width: 2.0),
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(10.0))),
                                                          // contentPadding: EdgeInsets.symmetric(vertical: 10), //Change this value to custom as you like
                                                          // isDense: true,
                                                          contentPadding: const EdgeInsets.only(
                                                              left: 15.0,
                                                              right: 15.0,
                                                              top: 20,
                                                              bottom: 20.0),
                                                          suffixText: 'MMK',
                                                          suffixStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                            fontFamily: 'capsulesans',
                                                          ),
                                                          //errorText: wrongEmail,
                                                          errorStyle: TextStyle(
                                                              backgroundColor: Colors.white,
                                                              fontSize: 12,
                                                              fontFamily: 'capsulesans',
                                                              height: 0.1
                                                          ),
                                                          labelStyle: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.black,
                                                          ),
// errorText: 'Error message',
                                                          labelText: 'Custom sale price',
                                                          floatingLabelBehavior:
                                                          FloatingLabelBehavior.auto,
//filled: true,
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 15,),
                                                      Text('UNIT PRICING', style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        letterSpacing: 2,
                                                        color: Colors.grey,
                                                      ),),
                                                      SizedBox(height: 15,),
                                                      Container(
                                                        height: 220,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20.0),
                                                          color: AppTheme.lightBgColor,
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                height: 55,
                                                                decoration: BoxDecoration(border: Border(bottom: BorderSide(
                                                                    color: Colors.grey
                                                                        .withOpacity(0.2),
                                                                    width: 1.0))),
                                                                child: Row(
                                                                  children: [
                                                                    Text('Sell price', style:
                                                                    TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500
                                                                    ),),
                                                                    Spacer(),
                                                                    Text('MMK ' +  sellprice5.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                                    TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey
                                                                    ),),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 55,
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(0.2),
                                                                            width: 1.0))),
                                                                child: Row(
                                                                  children: [
                                                                    Text('In stock', style:
                                                                    TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500
                                                                    ),),
                                                                    Spacer(),
                                                                    Text(instock.toString() + ' ' + name5, style:
                                                                    TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey
                                                                    ),),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 55,
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(0.2),
                                                                            width: 1.0))),
                                                                child: Row(
                                                                  children: [
                                                                    Text('Loss', style:
                                                                    TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500
                                                                    ),),
                                                                    Spacer(),
                                                                    Text(loss5.toString() + ' ' + name5, style:
                                                                    TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey
                                                                    ),),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 55,
                                                                child: Row(
                                                                  children: [
                                                                    Text('Barcode', style:
                                                                    TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500
                                                                    ),),
                                                                    Spacer(),
                                                                    Text(barcode5, style:
                                                                    TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.grey
                                                                    ),),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                        color:
                                                        AppTheme.skBorderColor2,
                                                        width: 1.0),
                                                  )),
                                              width: double.infinity,
                                              height: 158,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                                children: [
                                                  ListTile(
                                                    title: Text(
                                                      'Total',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500),
                                                    ),
                                                    trailing: Text('MMK ' + (totalFixAmount2).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Padding(
                                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          setState(() {
                                                            addProduct(result.split('^')[0] + '^' + '^' + price4.toString() + data + qty.toString());
                                                          });
                                                          print('addData' + result.split('^')[0] + '^' + '^' + price4.toString() + data + qty.toString());
                                                          Navigator.pop(context);

                                                        },
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.circular(10.0),
                                                              color: AppTheme.themeColor),
                                                          child: Center(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(bottom: 3.0),
                                                              child: Container(
                                                                  child: Text(
                                                                    'Add to cart',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 18,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.black
                                                                    ),
                                                                  )
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
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
                      ),
                      Positioned(
                        top: 42,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                  color: Colors.white.withOpacity(0.5)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  TextEditingController myController = TextEditingController();
  TextEditingController myControllerTablet = TextEditingController();
  TextEditingController sellPriceController = TextEditingController();
  TextEditingController sellPriceControllerTablet = TextEditingController();

  double totalFixAmount = 0.0;
  double titlePrice = 0.0;

  String eachProd = '';




  var mainLoss = 0;
  var sub1Loss=0;
  var sub2Loss = 0;

  String productName = '';
  String salePrice = '';
  String barcode = '';
  String mainName = '';
  String sub1Name = '';
  String sub2Name = '';
  String unit = '';
  String name ='';
  var mainQty= 0;
  var sub1Qty = 0;
  var sub2Qty = 0;
  String sell1 = '';
  String sell2 = '';
  String sell3 = '';


  final BluePrintPos _bluePrintPos = BluePrintPos.instance;
  List<BlueDevice> _blueDevices = <BlueDevice>[];
  BlueDevice? _selectedDevice;
  bool _isLoading = false;
  int _loadingAtIndex = -1;


  Future<void> _onScanPressed() async {
    setState(() => _isLoading = true);
    _bluePrintPos.scan().then((List<BlueDevice> devices) {
      if (devices.isNotEmpty) {
        setState(() {
          _blueDevices = devices;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    });
  }

  void _onDisconnectDevice() {
    _bluePrintPos.disconnect().then((ConnectionStatus status) {
      if (status == ConnectionStatus.disconnect) {
        setState(() {
          _selectedDevice = null;
        });
      }
    });
  }

  void _onSelectDevice(int index) {
    setState(() {
      _isLoading = true;
      _loadingAtIndex = index;
    });
    final BlueDevice blueDevice = _blueDevices[index];
    _bluePrintPos.connect(blueDevice).then((ConnectionStatus status) {
      if (status == ConnectionStatus.connected) {
        setState(() => _selectedDevice = blueDevice);
      } else if (status == ConnectionStatus.timeout) {
        _onDisconnectDevice();
      } else {
        print('$runtimeType - something wrong');
      }
      setState(() => _isLoading = false);
    });
  }

  Future<void> _onPrintReceipt() async {
    // final ReceiptSectionText receiptText = ReceiptSectionText();

    final doc = await PdfDocument.openFile(pdfFile!.path);
    final pages = doc.pageCount;
    List<imglib.Image> images = [];

// get images from all the pages
    for (int i = 1; i <= pages; i++) {
      var page = await doc.getPage(i);
      var imgPDF = await page.render(width: page.width.round()*5, height: page.height.round()*5);
      var img = await imgPDF.createImageDetached();
      var imgBytes = await img.toByteData(format: ImageByteFormat.png);
      var libImage = imglib.decodeImage(imgBytes!.buffer
          .asUint8List(imgBytes.offsetInBytes, imgBytes.lengthInBytes));
      images.add(libImage!);
    }

// stitch images
    int totalHeight = 0;
    images.forEach((e) {
      totalHeight += e.height;
    });
    int totalWidth = 0;
    images.forEach((element) {
      totalWidth = totalWidth < element.width ? element.width : totalWidth;
    });
    mergedImage = imglib.Image(totalWidth, totalHeight);
    int mergedHeight = 0;
    images.forEach((element) {
      imglib.copyInto(mergedImage, element, dstX: 0, dstY: mergedHeight, blend: false);
      mergedHeight += element.height;
    });

    // mergedImage!.readAsBytes().then((value ) async {
    //   List<int> bytesList = value;
    //   // await _bluePrintPos.printReceiptImage(bytesList);
    //   receiptText.addImage(
    //     base64.encode(Uint8List.view(logoBytes.buffer)),
    //     width: 450,
    //   );
    // });

    // imglib.Image gg;

    // print('type check ' + mergedImage.runtimeType.toString());
    // receiptText.addImage(
    //   base64.encode(imglib.encodeJpg(mergedImage, quality: 600)),
    //   width: 500,
    // );

    // receiptText.addLeftRightText(
    //   'ငှက်ပျောသီး',
    //   '30.000 MMK',
    //   leftStyle: ReceiptTextStyleType.normal,
    //   leftSize: ReceiptTextSizeType.small,
    //   rightSize: ReceiptTextSizeType.small,
    //   rightStyle: ReceiptTextStyleType.bold,
    // );

    // await _bluePrintPos.printReceiptText(receiptText, useRaster: true, paperSize: posUtils.PaperSize.mm80);

    await _bluePrintPos.printReceiptImage(imglib.encodeJpg(mergedImage),width: 570, useRaster: true);



    // receiptText.addText(
    //   'MY Shop Name',
    //   size: ReceiptTextSizeType.medium,
    //   style: ReceiptTextStyleType.bold,
    // );
    // receiptText.addText(
    //   'သစ်သီဆိုင်',
    //   size: ReceiptTextSizeType.small,
    // );
    // receiptText.addSpacer(useDashed: true);
    // receiptText.addLeftRightText('Time', '04/06/21, 10:00');
    // receiptText.addSpacer(useDashed: true);
    // receiptText.addLeftRightText(
    //   'ငှက်ပျောသီး',
    //   '30.000 MMK',
    //   leftStyle: ReceiptTextStyleType.normal,
    //   leftSize: ReceiptTextSizeType.small,
    //   rightSize: ReceiptTextSizeType.small,
    //   rightStyle: ReceiptTextStyleType.bold,
    // );
    // // receiptText.addSpacer(useDashed: true);
    // // receiptText.addLeftRightText(
    // //   'ပန်းသီး',
    // //   '30.000 MMK',
    // //   leftStyle: ReceiptTextStyleType.normal,
    // //   rightStyle: ReceiptTextStyleType.bold,
    // //   leftSize: ReceiptTextSizeType.small,
    // //   rightSize: ReceiptTextSizeType.small,
    // // );
    // // receiptText.addSpacer(useDashed: true);
    // // receiptText.addLeftRightText(
    // //   'လိမ္မော်သီး',
    // //   'Cash',
    // //   leftStyle: ReceiptTextStyleType.bold,
    // //   leftSize: ReceiptTextSizeType.small,
    // //   rightStyle: ReceiptTextStyleType.normal,
    // // );
    // receiptText.addSpacer(count: 2);
    //
    // await _bluePrintPos.printReceiptText(receiptText,);
    //
    // List<int> bytesList = pdfFile!.readAsBytes();




    // /// Example for print QR
    // await _bluePrintPos.printQR('www.google.com', size: 250);

    // /// Text after QR
    // final ReceiptSectionText receiptSecondText = ReceiptSectionText();
    // receiptSecondText.addText('Powered by ayeee',
    //     size: ReceiptTextSizeType.small);
    // receiptSecondText.addSpacer();
    // await _bluePrintPos.printReceiptText(receiptSecondText, feedCount: 1);
    // setState(() {
    //   _selectedDevice = null;
    // });
    // _onDisconnectDevice();
    // _onDisconnectDevice();
  }

  saleCart(priContext) {
    mainLoss = 0;
    sub1Loss=0;
    sub2Loss = 0;

    productName = '';
    salePrice = '';
    barcode = '';
    mainName = '';
    sub1Name = '';
    sub2Name = '';
    unit = '';
    name ='';
    mainQty= 0;
    sub1Qty = 0;
    sub2Qty = 0;
    sell1 = '';
    sell2 = '';
    sell3 = '';


    totalAmount = double.parse(TtlProdListPrice());
    disText = '';

    _controller.animateTo(
      0, duration: Duration(milliseconds: 0), curve: Curves.ease,);
    _textFieldController.clear();
    bool sellDone = false;
    // bool saleCartDrag = true;

    showModalBottomSheet(
        isDismissible: !disableTouch,
        enableDrag: !disableTouch,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              _textFieldController.addListener((){
                print("value: ${_textFieldController.text}");
                setState(() {
                  totalAmount = double.parse(TtlProdListPrice());
                  _textFieldController.text != '' ? paidAmount = double.parse(_textFieldController.text) : paidAmount = 0.0;
                  if((totalAmount - paidAmount).isNegative){
                    debt = 0;
                  } else { debt = (totalAmount - paidAmount);
                  }
                  if((paidAmount - totalAmount).isNegative){
                    refund = 0;
                  } else { refund = (paidAmount - totalAmount);
                  }
                });       });

              myController.addListener((){
                setState(() {
                  mystate((){
                    (myController.text != '' && sellPriceController.text != '') ? totalFixAmount =double.parse(myController.text) * double.parse(sellPriceController.text) : totalFixAmount = 0.0;
                  });});
              });

              sellPriceController.addListener((){
                setState(() {
                  mystate((){
                    (myController.text != '' && sellPriceController.text != '') ? totalFixAmount =double.parse(myController.text) * double.parse(sellPriceController.text) : totalFixAmount = 0.0;
                    if( sellPriceController.text != '') {
                      titlePrice = double.parse(sellPriceController.text);
                      price2 = double.parse(sellPriceController.text); } else {
                      titlePrice = 0.0;
                      price2 = 0;
                    }
                  });});
              });

              Future<void> _onScanPressed() async {
                mystate(() => _isLoading = true);
                _bluePrintPos.scan().then((List<BlueDevice> devices) {
                  if (devices.isNotEmpty) {
                    mystate(() {
                      _blueDevices = devices;
                      _isLoading = false;
                    });
                  } else {
                    mystate(() => _isLoading = false);
                  }
                });
              }

              void _onDisconnectDevice() {
                _bluePrintPos.disconnect().then((ConnectionStatus status) {
                  if (status == ConnectionStatus.disconnect) {
                    mystate(() {
                      _selectedDevice = null;
                    });
                  }
                });
              }

              void _onSelectDevice(int index) {
                mystate(() {
                  _isLoading = true;
                  _loadingAtIndex = index;
                });
                final BlueDevice blueDevice = _blueDevices[index];
                _bluePrintPos.connect(blueDevice).then((ConnectionStatus status) {
                  if (status == ConnectionStatus.connected) {
                    mystate(() => _selectedDevice = blueDevice);
                  } else if (status == ConnectionStatus.timeout) {
                    _onDisconnectDevice();
                  } else {
                    print('$runtimeType - something wrong');
                  }
                  mystate(() => _isLoading = false);
                });
              }

              Future<void> _onPrintReceipt() async {
                // final ReceiptSectionText receiptText = ReceiptSectionText();

                final doc = await PdfDocument.openFile(pdfFile!.path);
                final pages = doc.pageCount;
                List<imglib.Image> images = [];

// get images from all the pages
                for (int i = 1; i <= pages; i++) {
                  var page = await doc.getPage(i);
                  var imgPDF = await page.render(width: page.width.round()*5, height: page.height.round()*5);
                  var img = await imgPDF.createImageDetached();
                  var imgBytes = await img.toByteData(format: ImageByteFormat.png);
                  var libImage = imglib.decodeImage(imgBytes!.buffer
                      .asUint8List(imgBytes.offsetInBytes, imgBytes.lengthInBytes));
                  images.add(libImage!);
                }

// stitch images
                int totalHeight = 0;
                images.forEach((e) {
                  totalHeight += e.height;
                });
                int totalWidth = 0;
                images.forEach((element) {
                  totalWidth = totalWidth < element.width ? element.width : totalWidth;
                });
                mergedImage = imglib.Image(totalWidth, totalHeight);
                int mergedHeight = 0;
                images.forEach((element) {
                  imglib.copyInto(mergedImage, element, dstX: 0, dstY: mergedHeight, blend: false);
                  mergedHeight += element.height;
                });

                // mergedImage!.readAsBytes().then((value ) async {
                //   List<int> bytesList = value;
                //   // await _bluePrintPos.printReceiptImage(bytesList);
                //   receiptText.addImage(
                //     base64.encode(Uint8List.view(logoBytes.buffer)),
                //     width: 450,
                //   );
                // });

                // imglib.Image gg;

                // print('type check ' + mergedImage.runtimeType.toString());
                // receiptText.addImage(
                //   base64.encode(imglib.encodeJpg(mergedImage, quality: 600)),
                //   width: 500,
                // );

                // receiptText.addLeftRightText(
                //   'ငှက်ပျောသီး',
                //   '30.000 MMK',
                //   leftStyle: ReceiptTextStyleType.normal,
                //   leftSize: ReceiptTextSizeType.small,
                //   rightSize: ReceiptTextSizeType.small,
                //   rightStyle: ReceiptTextStyleType.bold,
                // );

                // await _bluePrintPos.printReceiptText(receiptText, useRaster: true, paperSize: posUtils.PaperSize.mm80);

                await _bluePrintPos.printReceiptImage(imglib.encodeJpg(mergedImage),width: 570, useRaster: true);



                // receiptText.addText(
                //   'MY Shop Name',
                //   size: ReceiptTextSizeType.medium,
                //   style: ReceiptTextStyleType.bold,
                // );
                // receiptText.addText(
                //   'သစ်သီဆိုင်',
                //   size: ReceiptTextSizeType.small,
                // );
                // receiptText.addSpacer(useDashed: true);
                // receiptText.addLeftRightText('Time', '04/06/21, 10:00');
                // receiptText.addSpacer(useDashed: true);
                // receiptText.addLeftRightText(
                //   'ငှက်ပျောသီး',
                //   '30.000 MMK',
                //   leftStyle: ReceiptTextStyleType.normal,
                //   leftSize: ReceiptTextSizeType.small,
                //   rightSize: ReceiptTextSizeType.small,
                //   rightStyle: ReceiptTextStyleType.bold,
                // );
                // // receiptText.addSpacer(useDashed: true);
                // // receiptText.addLeftRightText(
                // //   'ပန်းသီး',
                // //   '30.000 MMK',
                // //   leftStyle: ReceiptTextStyleType.normal,
                // //   rightStyle: ReceiptTextStyleType.bold,
                // //   leftSize: ReceiptTextSizeType.small,
                // //   rightSize: ReceiptTextSizeType.small,
                // // );
                // // receiptText.addSpacer(useDashed: true);
                // // receiptText.addLeftRightText(
                // //   'လိမ္မော်သီး',
                // //   'Cash',
                // //   leftStyle: ReceiptTextStyleType.bold,
                // //   leftSize: ReceiptTextSizeType.small,
                // //   rightStyle: ReceiptTextStyleType.normal,
                // // );
                // receiptText.addSpacer(count: 2);
                //
                // await _bluePrintPos.printReceiptText(receiptText,);
                //
                // List<int> bytesList = pdfFile!.readAsBytes();




                // /// Example for print QR
                // await _bluePrintPos.printQR('www.google.com', size: 250);

                // /// Text after QR
                // final ReceiptSectionText receiptSecondText = ReceiptSectionText();
                // receiptSecondText.addText('Powered by ayeee',
                //     size: ReceiptTextSizeType.small);
                // receiptSecondText.addSpacer();
                // await _bluePrintPos.printReceiptText(receiptSecondText, feedCount: 1);
                // setState(() {
                //   _selectedDevice = null;
                // });
                // _onDisconnectDevice();
                // _onDisconnectDevice();
              }
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: IgnorePointer(
                  ignoring: disableTouch,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Form(
                      key: _formKey,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18.0),
                                  topRight: Radius.circular(18.0),
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: TabBarView(
                                  physics: NeverScrollableScrollPhysics(),
                                  controller: _controller,
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      height:
                                      MediaQuery.of(context).size.height -
                                          45,
                                      width: double.infinity,
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 67,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        width: 1.0))),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15.0,
                                                  top: 0.0,
                                                  bottom: 15.0
                                              ),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState((){
                                                        mystate(() {
                                                          prodList = [];
                                                          discount = 0.0;
                                                          discountAmount = 0.0;
                                                          debt =0;
                                                          refund =0;
                                                          customerId = 'name^name';
                                                        });
                                                      });
                                                    },
                                                    child: Container(
                                                      width:
                                                      (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                          2) -
                                                          22.5,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(10.0),
                                                          color: AppTheme.clearColor),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left:
                                                              8.0,
                                                              right:
                                                              8.0,
                                                              bottom:
                                                              2.0),
                                                          child: Container(
                                                              child: Text(
                                                                'Clear cart',
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    18,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15.0,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final result = await showModalActionSheet<String>(
                                                        context: context,
                                                        actions: [
                                                          SheetAction(
                                                            icon: Icons.info,
                                                            label: 'Amount',
                                                            key: 'amount',
                                                          ),
                                                          SheetAction(
                                                            icon: Icons.info,
                                                            label: 'Percent',
                                                            key: 'percent',
                                                          ),
                                                        ],
                                                      );
                                                      mystate(() {
                                                        isDiscount = result.toString();
                                                      });

                                                      if (result == 'amount') {
                                                        final amount = await showTextInputDialog(
                                                          context: context,
                                                          textFields: [
                                                            DialogTextField(
                                                              keyboardType: TextInputType.number,
                                                              hintText: '0',
                                                              suffixText: 'MMK',
                                                              // initialText: 'mono0926@gmail.com',
                                                            ),
                                                          ],
                                                          title: 'Discount',
                                                          message: 'Add Discount Amount to Cart',
                                                        );
                                                        mystate(() {
                                                          discount =double.parse(amount![0].toString());
                                                          print('disss ' + discount.toString());
                                                        });

                                                      } else {
                                                        final percentage = await showTextInputDialog(
                                                          context: context,
                                                          textFields: [
                                                            DialogTextField(
                                                              keyboardType: TextInputType.number,
                                                              hintText: '0.0',
                                                              suffixText: '%',
                                                              // initialText: 'mono0926@gmail.com',
                                                            ),
                                                          ],
                                                          title: 'Discount',
                                                          message: 'Add Discount Percent to Cart',
                                                        );
                                                        mystate(() {
                                                          discount =double.parse(percentage![0].toString());
                                                          print('disss ' + discount.toString());
                                                        });
                                                      }
                                                      print('dis' + result.toString());
                                                      setState(() {
                                                        print('do something');
                                                      });

                                                    },
                                                    child: Container(
                                                      width:
                                                      (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                          2) -
                                                          22.5,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(10.0),
                                                          color: AppTheme.buttonColor2),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left:
                                                              8.0,
                                                              right:
                                                              8.0,
                                                              bottom:
                                                              2.0),
                                                          child: Container(
                                                              child: Text(
                                                                'Discount',
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    18,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('shops')
                                                  .doc(shopId)
                                                  .collection('customers')
                                                  .doc(customerId.split('^')[0].toString())
                                                  .snapshots(),
                                              builder: (BuildContext context, snapshot5) {
                                                if(snapshot5.hasData){
                                                  var output3 = snapshot5.data!.data();
                                                  var address = output3?['customer_address'];
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 67.0,
                                                        left: 0.0,
                                                        right: 0.0,
                                                        bottom: 138
                                                    ),
                                                    child: Container(
                                                        child: ListView(
                                                          children: [
                                                            Stack(
                                                              children: [

                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 19.0),
                                                                  child: Column(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          setState(() {
                                                                            mystate(() {
                                                                              customerId = 'name^name';
                                                                            });
                                                                          });
                                                                        },
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                                          child: Row(
                                                                            children: [
                                                                              Container(
                                                                                height: 58,
                                                                                width: 58,
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius:
                                                                                    BorderRadius.circular(
                                                                                        5.0),
                                                                                    color: Colors.grey
                                                                                        .withOpacity(0.5)
                                                                                ),
                                                                                child: Icon(
                                                                                  SmartKyat_POS.order,
                                                                                  size: 25,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 15),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(customerId.split('^')[1].toString() == 'name' ? 'No customer' : customerId.split('^')[1] , style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, height: 0.9),),
                                                                                  // Text(customerId.split('^')[1].toString() == 'name' ? 'Unknown' : address,
                                                                                  //     style: TextStyle(
                                                                                  //       fontSize: 14,
                                                                                  //       color: Colors.grey
                                                                                  //     )),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 8,),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 15.0),
                                                                        child: Container(height: 12,
                                                                          decoration: BoxDecoration(
                                                                              border: Border(
                                                                                bottom:
                                                                                BorderSide(color: AppTheme.skBorderColor2, width: 0.5),
                                                                              )),),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                ),
                                                                customerId != 'name^name' ? Positioned(
                                                                  top : 11,
                                                                  right: MediaQuery.of(context).size.width - 80,
                                                                  child: Container(
                                                                    // height: 20,
                                                                    // width: 30,
                                                                    alignment: Alignment.center,
                                                                    decoration: BoxDecoration(
                                                                        color: Color(0xffE9625E),
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                        border: Border.all(
                                                                          color: Colors.white,
                                                                          width: 2,
                                                                        )),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 1, bottom: 1),
                                                                      child: Icon(
                                                                        Icons.close_rounded,
                                                                        size: 13,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ): Container(),
                                                              ],
                                                            ),
                                                            for (int i = 0;
                                                            i < prodList.length;
                                                            i++)
                                                              StreamBuilder<
                                                                  DocumentSnapshot<
                                                                      Map<String,
                                                                          dynamic>>>(
                                                                stream: FirebaseFirestore
                                                                    .instance
                                                                    .collection('shops')
                                                                    .doc(
                                                                    shopId)
                                                                    .collection('products')
                                                                    .doc(prodList[i]
                                                                    .split('^')[0])
                                                                    .snapshots(),
                                                                builder:
                                                                    (BuildContext context,
                                                                    snapshot2) {
                                                                  if (snapshot2.hasData) {
                                                                    var output2 = snapshot2
                                                                        .data!
                                                                        .data();
                                                                    var image = output2?[
                                                                    'img_1'];
                                                                    prodList[i] = prodList[i].split('^')[0] + '^' + output2?['prod_name'] + '^' +
                                                                        prodList[i].split('^')[2] + '^' + prodList[i].split('^')[3] + '^' + prodList[i].split('^')[4] + '^' + prodList[i].split('^')[5];
                                                                    return GestureDetector(
                                                                      onTap: (){
                                                                        print('error prod' + prodList[i].toString());
                                                                        setState((){
                                                                          mystate((){
                                                                            quantity = double.parse(prodList[i].split('^')[4]);
                                                                            price2 = double.parse(prodList[i].split('^')[2]);
                                                                            eachProd = prodList[i];
                                                                            unit = prodList[i].split('^')[3];
                                                                            mainName =  output2?['unit_name'];
                                                                            sub1Name = output2?['sub1_name'];
                                                                            sub2Name = output2?['sub2_name'];
                                                                            salePrice = prodList[i].split('^')[2];
                                                                            mainLoss = output2?['Loss1'].round();
                                                                            sub1Loss = output2?['Loss2'].round();
                                                                            sub2Loss = output2?['Loss3'].round();
                                                                            barcode = output2?['bar_code'];
                                                                            mainQty = output2?['inStock1'].round();
                                                                            sub1Qty = output2?['inStock2'].round();
                                                                            sub2Qty = output2?['inStock3'].round();
                                                                            sell1 =output2?['unit_sell'];
                                                                            sell2 =output2?['sub1_sell'];
                                                                            sell3 =output2?['sub2_sell'];

                                                                            productName = output2?['prod_name'];
                                                                            myController.text = double.parse(prodList[i].split('^')[4]).round().toString();
                                                                            sellPriceController.text = prodList[i].split('^')[2];
                                                                            // sellDone = false;
                                                                            onChangeAmountTab = true;
                                                                          });});
                                                                        _controller.animateTo(2);
                                                                        // Future.delayed(const Duration(milliseconds: 1000), () {
                                                                        //   setState(() {
                                                                        //     mystate((){
                                                                        //       saleLoadingState = false;
                                                                        //     });
                                                                        //
                                                                        //   });
                                                                        // });
                                                                      },
                                                                      child: Slidable(
                                                                        key: UniqueKey(),
                                                                        actionPane:
                                                                        SlidableDrawerActionPane(),
                                                                        actionExtentRatio:
                                                                        0.25,
                                                                        child: Stack(
                                                                          children: [
                                                                            Container(
                                                                              color: Colors.white,
                                                                              child: Column(
                                                                                children: [
                                                                                  SizedBox(height: 12),
                                                                                  ListTile(
                                                                                    leading: ClipRRect(
                                                                                        borderRadius:
                                                                                        BorderRadius
                                                                                            .circular(
                                                                                            5.0),
                                                                                        child: image != ""
                                                                                            ? CachedNetworkImage(
                                                                                          imageUrl:
                                                                                          'https://riftplus.me/smartkyat_pos/api/uploads/' +
                                                                                              image,
                                                                                          width: 58,
                                                                                          height: 58,
                                                                                          // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                          fadeInDuration: Duration(milliseconds: 100),
                                                                                          fadeOutDuration: Duration(milliseconds: 10),
                                                                                          fadeInCurve: Curves.bounceIn,
                                                                                          fit: BoxFit.cover,) : Image.asset('assets/system/default-product.png', height: 58, width: 58)),
                                                                                    title: Text(output2?['prod_name'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, height: 0.9),),
                                                                                    subtitle: Padding(
                                                                                      padding: const EdgeInsets.only(top: 4.0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Text(output2?[prodList[i].split('^')[3]] + ' ', style: TextStyle(
                                                                                              fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey, height: 0.9
                                                                                          )),
                                                                                          if (prodList[i].split('^')[3] == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
                                                                                          else if(prodList[i].split('^')[3] == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
                                                                                          else Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    trailing: Text('MMK ' + (double.parse(
                                                                                        prodList[i].split('^')[
                                                                                        2]) *
                                                                                        double.parse(prodList[
                                                                                        i]
                                                                                            .split(
                                                                                            '^')[4]))
                                                                                        .toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                                                      style: TextStyle(
                                                                                          fontSize: 16,
                                                                                          fontWeight: FontWeight.w500
                                                                                      ),),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 15.0),
                                                                                    child: Container(height: 12,
                                                                                      decoration: BoxDecoration(
                                                                                          border: Border(
                                                                                            bottom:
                                                                                            BorderSide(color: AppTheme.skBorderColor2, width: 0.5),
                                                                                          )),),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              top : 11,
                                                                              right: MediaQuery.of(context).size.width - 80,
                                                                              child: Container(
                                                                                // height: 20,
                                                                                // width: 30,
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(
                                                                                    color: AppTheme.skBorderColor2,
                                                                                    borderRadius:
                                                                                    BorderRadius.circular(
                                                                                        10.0),
                                                                                    border: Border.all(
                                                                                      color: Colors.white,
                                                                                      width: 2,
                                                                                    )),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(left: 8.5, right: 8.5, top: 1, bottom: 1),
                                                                                  child: Text(double.parse(prodList[i]
                                                                                      .split(
                                                                                      '^')[4]).round().toString(), style: TextStyle(
                                                                                      fontSize: 11, fontWeight: FontWeight.w500
                                                                                  )),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        dismissal:
                                                                        SlidableDismissal(
                                                                          child:
                                                                          SlidableDrawerDismissal(),
                                                                          onDismissed:
                                                                              (actionType) {
                                                                            setState((){
                                                                              mystate(() {
                                                                                prodList
                                                                                    .removeAt(
                                                                                    i);
                                                                              });
                                                                            });
                                                                          },
                                                                        ),
                                                                        secondaryActions: <
                                                                            Widget>[
                                                                          IconSlideAction(
                                                                            caption: 'Delete',
                                                                            color: Colors.red,
                                                                            icon:
                                                                            Icons.delete,
                                                                            onTap: () {
                                                                              setState((){
                                                                                mystate(() {
                                                                                  prodList
                                                                                      .removeAt(
                                                                                      i);
                                                                                });
                                                                              });
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }
                                                                  return Container();
                                                                },
                                                              ),
                                                            Slidable(
                                                              key: UniqueKey(),
                                                              actionPane:
                                                              SlidableDrawerActionPane(),
                                                              actionExtentRatio:
                                                              0.25,
                                                              child: Container(
                                                                color: Colors.white,
                                                                child: Column(
                                                                  children: [
                                                                    discount != 0.0 ? Container(
                                                                      child: isDiscount == 'percent' ?
                                                                      ListTile(
                                                                        title: Text('Discount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                                        subtitle: Text('Percentage (' +  discountAmount.toString() + '%)', style: TextStyle(
                                                                            fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey
                                                                        )),
                                                                        trailing: Text('- MMK ' + (double.parse(TtlProdListPriceInit()) - double.parse(TtlProdListPrice())).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                                      ) :  ListTile (
                                                                        title: Text('Discount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                                        subtitle: Text('Amount applied', style: TextStyle(
                                                                            fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey
                                                                        )),
                                                                        trailing: Text('- MMK ' + discount.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ) : Container(),
                                                                  ],
                                                                ),
                                                              ),
                                                              dismissal:
                                                              SlidableDismissal(
                                                                child: SlidableDrawerDismissal(),
                                                                onDismissed:
                                                                    (actionType) {
                                                                  mystate(() {
                                                                    discountAmount = 0.0;
                                                                    discount = 0.0;
                                                                  });
                                                                },
                                                              ),
                                                              secondaryActions: <
                                                                  Widget>[
                                                                IconSlideAction(
                                                                  caption: 'Delete',
                                                                  color: Colors.red,
                                                                  icon:
                                                                  Icons.delete,
                                                                  onTap: () =>
                                                                      mystate(() {
                                                                        discountAmount = 0.0;
                                                                        discount =0.0;
                                                                      }),
                                                                ),
                                                              ],
                                                            ),


                                                            // orderLoading?Text('Loading'):Text('')
                                                          ],
                                                        )),
                                                  );
                                                }
                                                return Container();
                                              }),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                      top: BorderSide(
                                                          color:
                                                          AppTheme.skBorderColor2,
                                                          width: 1.0),
                                                    )),
                                                width: double.infinity,
                                                height: 138,
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                                  children: [
                                                    ListTile(
                                                      title: Text(
                                                        'Total sale',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      ),
                                                      subtitle: double.parse(totalItems()) == 1? Text(totalItems() + ' item set',
                                                          style: TextStyle(
                                                              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey
                                                          )) : Text(totalItems() + ' item sets',
                                                          style: TextStyle(
                                                              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey
                                                          )),
                                                      trailing: Text('MMK '+
                                                          TtlProdListPrice().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            mystate(() {
                                                              totalAmount = double.parse(TtlProdListPrice());

                                                            });
                                                          });
                                                          // List<double> cashMM = [500, 1000, 5000, 10000];
                                                          // int i = 0;
                                                          // String totalCashCal = totalAmount.toInt().toString();
                                                          // print('CCC 0--> ' + totalAmount.toInt().toString());
                                                          //
                                                          // for(i = totalCashCal.toString().length-1; i>=0; i--) {
                                                          //   if(totalCashCal.toString()[i] == '0') {
                                                          //
                                                          //   } else {
                                                          //     break;
                                                          //   }
                                                          // }
                                                          //
                                                          // print('CCC 1--> ' + (totalCashCal.length - i).toString());
                                                          // // int j = 0;
                                                          //
                                                          // List<String> cashMMUI = [];
                                                          // cashMMUI.add(totalCashCal);
                                                          // for(int j = 0; j < cashMM.length; j++) {
                                                          //   int k = 0;
                                                          //   int iii = 0;
                                                          //   for(int k = cashMM[j].toInt().toString().length-1; k>=0; k--) {
                                                          //     if(cashMM[j].toInt().toString()[k] == '0') {
                                                          //
                                                          //     } else {
                                                          //       break;
                                                          //     }
                                                          //   }
                                                          //   print('TEST TESET ' + i.toString() + ' ' + cashMM[j].toInt().toString() + ' ' + (cashMM[j].toInt().toString().length - k).toString());
                                                          //
                                                          //   String totalCashCalMod = totalCashCal;
                                                          //   totalCashCalMod = replaceCharAt(totalCashCalMod, i, "0");
                                                          //
                                                          //   print('CCCC' + totalCashCal.length.toString() + ' ' + i.toString());
                                                          //   if(totalCashCal.length-1 == i+1) {
                                                          //     print('CHECKKK');
                                                          //     totalCashCalMod = replaceCharAt(totalCashCalMod, i-1, "0");
                                                          //   }
                                                          //
                                                          //   print('totalCashCalMod ' + totalCashCalMod + ' ' + i.toString());
                                                          //
                                                          //
                                                          //
                                                          //   if(totalCashCal.length - i <= cashMM[j].toInt().toString().length - k) {
                                                          //     print('nyi nyi ' + cashMM[j].toInt().toString() + ' ' + totalCashCal.substring(i, totalCashCal.length));
                                                          //     if(cashMM[j] > double.parse(totalCashCal.substring(i, totalCashCal.length))) {
                                                          //       if(totalCashCalMod.substring(totalCashCalMod.length - i, totalCashCalMod.length).length == cashMM[j].toInt().toString().length) {
                                                          //         iii++;
                                                          //         if(double.parse(totalCashCalMod) < cashMM[j]) {
                                                          //           totalCashCalMod = '0';
                                                          //         }
                                                          //         print('HEHRE ' + cashMM[j].toInt().toString());
                                                          //       }
                                                          //
                                                          //       cashMMUI.add((double.parse(totalCashCalMod) + cashMM[j]).toInt().toString());
                                                          //       print('NYI ' + cashMM[j].toInt().toString());
                                                          //     }
                                                          //   }
                                                          //
                                                          //
                                                          //
                                                          // }
                                                          //
                                                          // print('NYIII ' + cashMMUI.toString());

                                                          print('totalAmount '+ totalAmount.toString());
                                                          _controller.animateTo(1);
                                                          if(_textFieldController.text == '') {
                                                            debt = double.parse(TtlProdListPrice());}
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width - 30,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.circular(10.0),
                                                              color: AppTheme.themeColor),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                  child: Container(
                                                                      child: Text(
                                                                        'Checkout',
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontSize: 17,
                                                                            fontWeight: FontWeight.w600,
                                                                            color: Colors.black
                                                                        ),
                                                                      )
                                                                  ),
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
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 67,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          width: 1.0))),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15.0,
                                                    right: 15.0,
                                                    top: 5.0,
                                                    bottom: 0.0
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(customerId.split('^')[1] == 'name'? 'No customer':customerId.split('^')[1], style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.grey
                                                    )),
                                                    SizedBox(height: 2.5),
                                                    Text('Cash acceptance', style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 19
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 71.0,
                                                  left: 0.0,
                                                  right: 0.0),
                                              child: Container(
                                                  child: ListView(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                        child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 15),
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(
                                                                        Radius.circular(10.0),
                                                                      ),
                                                                      border: Border.all(
                                                                          color: Colors.grey.withOpacity(0.2),
                                                                          width: 1.0),
                                                                      color: AppTheme.lightBgColor),
                                                                  height:  133,
                                                                  width: MediaQuery.of(context).size.width,
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Text('Total sale - MMK',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                            fontSize: 20,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: Colors.grey,
                                                                          )),
                                                                      SizedBox(height: 3),
                                                                      Text(TtlProdListPrice().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                            fontSize: 23, fontWeight: FontWeight.w500,
                                                                          )),
                                                                    ],
                                                                  )),
                                                              SizedBox(height: 15),
                                                              Text('CASH RECEIVED', style: TextStyle(
                                                                letterSpacing: 2,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14,color: Colors.grey,
                                                              ),),
                                                              SizedBox(height: 15),
                                                              TextField(
                                                                style: TextStyle(
                                                                    height: 0.95
                                                                ),
                                                                decoration: InputDecoration(
                                                                  enabledBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                                      borderSide: const BorderSide(
                                                                          color: AppTheme.skBorderColor,
                                                                          width: 2.0),
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(10.0))),

                                                                  focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                                      borderSide: const BorderSide(
                                                                          color: AppTheme.themeColor,
                                                                          width: 2.0),
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(10.0))),
                                                                  contentPadding: const EdgeInsets.only(
                                                                      left: 15.0,
                                                                      right: 15.0,
                                                                      top: 20.0,
                                                                      bottom: 20.0),
                                                                  suffixText: 'MMK' ,
                                                                  // tooltip: 'Increase volume by 10',
                                                                  suffixStyle: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontSize: 15,
                                                                    fontFamily: 'capsulesans',
                                                                  ),
                                                                  errorStyle: TextStyle(
                                                                      backgroundColor: Colors.white,
                                                                      fontSize: 12,
                                                                      fontFamily: 'capsulesans',
                                                                      height: 0.1
                                                                  ),
                                                                  labelStyle: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black,
                                                                  ),
// errorText: 'Error message',
                                                                  labelText: 'Custom price',
                                                                  floatingLabelBehavior:
                                                                  FloatingLabelBehavior.auto,
//filled: true,
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                ),
                                                                keyboardType: TextInputType.number,
                                                                onChanged: (value) {
                                                                  mystate(() {
                                                                    totalAmount = double.parse(TtlProdListPrice());
                                                                    value != '' ? paidAmount = double.parse(value) : paidAmount = 0.0;
                                                                    if((totalAmount - paidAmount).isNegative){
                                                                      debt = 0;
                                                                    } else { debt = (totalAmount - paidAmount);
                                                                    }
                                                                    if((paidAmount - totalAmount).isNegative){
                                                                      refund = 0;
                                                                    } else { refund = (paidAmount - totalAmount);
                                                                    }
                                                                  });
                                                                },
                                                                controller: _textFieldController,
                                                              ),
                                                              SizedBox(height: 15),

                                                              ButtonTheme(
                                                                minWidth: double.infinity,
                                                                //minWidth: 50,
                                                                splashColor: AppTheme.buttonColor2,
                                                                height: 50,
                                                                child: FlatButton(
                                                                  color: AppTheme.buttonColor2,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(7.0),
                                                                  ),
                                                                  onPressed: () async {
                                                                    setState(() {
                                                                      mystate(() {
                                                                        totalAmount =
                                                                            double
                                                                                .parse(
                                                                                TtlProdListPrice());
                                                                        _textFieldController
                                                                            .text =
                                                                            totalAmount
                                                                                .toString();
                                                                        paidAmount =
                                                                            totalAmount;
                                                                        if ((totalAmount -
                                                                            paidAmount)
                                                                            .isNegative) {
                                                                          debt = 0;
                                                                        } else {
                                                                          debt =
                                                                          (totalAmount -
                                                                              paidAmount);
                                                                        }
                                                                        if ((paidAmount -
                                                                            totalAmount)
                                                                            .isNegative) {
                                                                          refund =
                                                                          0;
                                                                        } else {
                                                                          refund =
                                                                          (paidAmount -
                                                                              totalAmount);
                                                                        }
                                                                      });
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                    child: Text( 'MMK ' +
                                                                        TtlProdListPrice().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: 17
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 20),
                                                            ]
                                                        ),
                                                      ),
                                                      // orderLoading?Text('Loading'):Text('')
                                                    ],
                                                  )),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border(
                                                        top: BorderSide(
                                                            color:
                                                            AppTheme.skBorderColor2,
                                                            width: 1.0),
                                                      )),
                                                  width: double.infinity,
                                                  height: 150,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                    children: [
                                                      debt!= 0 ? ListTile(
                                                        title: Text(
                                                          'Debt amount',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        ),
                                                        trailing: Text('- MMK '+
                                                            debt.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        ),
                                                      ) : ListTile(
                                                        title: Text(
                                                          'Cash refund',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        ),
                                                        trailing: Text('MMK '+
                                                            refund.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Padding(
                                                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 27.0),
                                                          child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState((){
                                                                      mystate(() {
                                                                        _controller.animateTo(0);
                                                                        _textFieldController.clear();
                                                                        paidAmount = 0;
                                                                        debt = 0;
                                                                        refund = 0;
                                                                        totalAmount = double.parse(TtlProdListPrice());
                                                                      });
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                    width: (MediaQuery.of(context).size.width - 45)/2,
                                                                    height: 50,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                        BorderRadius.circular(10.0),
                                                                        color: AppTheme.secButtonColor),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Expanded(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                            child: Container(
                                                                                child: Text(
                                                                                  'Back',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                      fontSize: 18,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: Colors.black
                                                                                  ),
                                                                                )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                GestureDetector(
                                                                  onTap: () async {
                                                                    discountAmount = discount;
                                                                    subList2 = [];
                                                                    DateTime now = DateTime.now();
                                                                    int length = 0;
                                                                    int totalOrders = 0;
                                                                    int debts = 0;
                                                                    var dateExist = false;
                                                                    var dateId = '';
                                                                    double debtAmounts = 0 ;
                                                                    mystate(() {
                                                                      setState(() {
                                                                        orderCreating = true;
                                                                        disableTouch = true;
                                                                        //    saleCartDrag = false;
                                                                      });
                                                                    });
                                                                    Navigator.of(context).push(
                                                                        FadeRoute(page: Transparent(key: tranGlobalKey),)
                                                                    );

                                                                    print('order creating');

                                                                    FirebaseFirestore.instance.collection('shops').doc(shopId)
                                                                        .get().then((value) async {
                                                                      length = int.parse(value.data()!['orders_length'].toString());
                                                                      print('lengthsss' + length.toString());
                                                                      length = length + 1;

                                                                      print('CHECK POINT 0' + deviceIdNum.toString());
                                                                      print('CHECK POINT 1');

                                                                      orderLengthIncrease();
                                                                      print('datacheck' + prodList.toString());
                                                                      for (String str in prodList) {
                                                                        CollectionReference productsFire = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products');

                                                                        subList2.add(str.split('^')[0] + '-' + 'veriD' + '-' + 'buy0' + '-' + str.split('^')[4] +'-' + str.split('^')[2] + '-' + str.split('^')[3] +'-' + str.split('^')[4] + '-0-' + 'date');

                                                                        productsFire.doc(str.split('^')[0])
                                                                            .get().then((val22) async {
                                                                          List<String> subLink = [];
                                                                          List<String> subName = [];
                                                                          List<double> subStock = [];

                                                                          var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(str.split('^')[0])
                                                                              .get();

                                                                          if (docSnapshot10.exists) {
                                                                            Map<String, dynamic>? data10 = docSnapshot10.data();

                                                                            for(int i = 0; i < double.parse(data10 ? ["sub_exist"]) + 1; i++) {
                                                                              subLink.add(data10 ? ['sub' + (i+1).toString() + '_link']);
                                                                              subName.add(data10 ? ['sub' + (i+1).toString() + '_name']);
                                                                              print('inStock' + (i+1).toString());
                                                                              print(' CHECKING ' + (data10 ? ['mainSellUnit']).toString());
                                                                              subStock.add(double.parse((data10 ? ['inStock' + (i+1).toString()]).toString()));
                                                                            }
                                                                          }

                                                                          print(subStock.toString());

                                                                          if(str.split('^')[3] == 'unit_name') {
                                                                            decStockFromInv(str.split('^')[0], 'main', str.split('^')[4]);
                                                                            prodSaleData(str.split('^')[0], double.parse(str.split('^')[4].toString()));
                                                                            // await productsFire.update({
                                                                            //   'mainSellUnit' : FieldValue.increment(double.parse(str.split('^')[4].toString())),
                                                                            // });

                                                                          } else if(str.split('^')[3] == 'sub1_name') {
                                                                            sub1Execution(subStock, subLink, str.split('^')[0], str.split('^')[4]);
                                                                            productsFire.doc(str.split('^')[0]).update({
                                                                              'sub1SellUnit' : FieldValue.increment(double.parse(str.split('^')[4].toString())),
                                                                            });

                                                                          } else if(str.split('^')[3] == 'sub2_name') {
                                                                            sub2Execution(subStock, subLink, str.split('^')[0], str.split('^')[4]);
                                                                            productsFire.doc(str.split('^')[0]).update({
                                                                              'sub2SellUnit' : FieldValue.increment(double.parse(str.split('^')[4].toString())),
                                                                            });
                                                                          }
                                                                        });

                                                                      }

                                                                      if(customerId.split('^')[0] != 'name' && debt.toString() != '0.0') {
                                                                        debts = 1;
                                                                        debtAmounts = debt;
                                                                      } else {
                                                                        debts = 0;
                                                                        debtAmounts = 0;
                                                                      }

                                                                      print('subList2 ' + subList2.toString());

                                                                      if(customerId.split('^')[0] != 'name') {
                                                                        totalOrders = totalOrders + 1;
                                                                        CusOrder(totalOrders, debts, debtAmounts);
                                                                      }

                                                                      FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders')
                                                                          .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 00:00:00'))
                                                                          .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 23:59:59'))
                                                                          .get()
                                                                          .then((QuerySnapshot querySnapshot)  async {
                                                                        querySnapshot.docs.forEach((doc) {
                                                                          dateExist = true;
                                                                          dateId = doc.id;
                                                                        });

                                                                        if (dateExist) {
                                                                          addDateExist(dateId, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString())  + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice() + '^' + customerId.split('^')[0] + '^FALSE' + '^' + debt.toString() + '^' + discountAmount.toString() + disText, length.toString());
                                                                          Detail(now, length.toString(),subList2, dateId);
                                                                          print('adddateexist added');
                                                                        }
                                                                        else {
                                                                          DatenotExist(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString())  + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice() + '^' + customerId.split('^')[0] + '^FALSE' + '^' + debt.toString() + '^' + discountAmount.toString() + disText, now, length.toString());
                                                                          Detail(now, length.toString(),subList2, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) +  deviceIdNum.toString());
                                                                          print('adddateexist not');
                                                                        }
                                                                      });



                                                                      List<String> subNameList = [];
                                                                      int subNameListLength = 0;
                                                                      for (String str in prodList) {
                                                                        subNameListLength = subNameListLength + 1;
                                                                        CollectionReference productsFire = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products');
                                                                        print('DATA CHECK PROD ' + str.toString());

                                                                        var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(str.split('^')[0])
                                                                            .get();

                                                                        if (docSnapshot10.exists) {
                                                                          Map<String, dynamic>? data11 = docSnapshot10.data();
                                                                          subNameList.add(data11 ? [str.split('^')[3]]);
                                                                          if(prodList.length == subNameListLength) {
                                                                            print('fianlize : ' + subNameList.toString());
                                                                            // final date = DateTime.now();
                                                                            final date = now;
                                                                            final dueDate = date.add(Duration(days: 7));
                                                                            print('CUZMER CHECK ' + customerId.toString());
                                                                            final invoice = Invoice(
                                                                              supplier: Supplier(
                                                                                name: shopGloName,
                                                                                address: shopGloAddress,
                                                                                phone: shopGloPhone,
                                                                                paymentInfo: '',
                                                                              ),
                                                                              customer: Customer(
                                                                                name: customerId.split('^')[1],
                                                                                address: '',
                                                                              ),
                                                                              info: InvoiceInfo(
                                                                                  date: date,
                                                                                  dueDate: dueDate,
                                                                                  description: 'My description...',
                                                                                  // number: '${DateTime.now().year}-9999',
                                                                                  number: deviceIdNum.toString() + '-' + length.toString()
                                                                              ),
                                                                              items: [
                                                                                for(int i=0; i<prodList.length; i++)
                                                                                  InvoiceItem(
                                                                                    description: prodList[i].split('^')[1],
                                                                                    // date: prodList[i].split('^')[3] + '^' + subNameList[i].toString(),
                                                                                    date: subNameList[i].toString(),
                                                                                    quantity: double.parse(prodList[i].split('^')[4]),
                                                                                    vat: discountAmount,
                                                                                    debt: debt,
                                                                                    type: disText,
                                                                                    unitPrice: double.parse(prodList[i].split('^')[2]),
                                                                                  )

                                                                                // InvoiceItem(
                                                                                //   description: 'Water',
                                                                                //   date: DateTime.now(),
                                                                                //   quantity: 8,
                                                                                //   vat: 0.19,
                                                                                //   unitPrice: 0.99,
                                                                                // ),
                                                                                // InvoiceItem(
                                                                                //   description: 'Orange',
                                                                                //   date: DateTime.now(),
                                                                                //   quantity: 3,
                                                                                //   vat: 0.19,
                                                                                //   unitPrice: 2.99,
                                                                                // ),
                                                                                // InvoiceItem(
                                                                                //   description: 'Apple',
                                                                                //   date: DateTime.now(),
                                                                                //   quantity: 8,
                                                                                //   vat: 0.19,
                                                                                //   unitPrice: 3.99,
                                                                                // ),
                                                                                // InvoiceItem(
                                                                                //   description: 'Mango',
                                                                                //   date: DateTime.now(),
                                                                                //   quantity: 1,
                                                                                //   vat: 0.19,
                                                                                //   unitPrice: 1.59,
                                                                                // ),
                                                                                // InvoiceItem(
                                                                                //   description: 'Blue Berries',
                                                                                //   date: DateTime.now(),
                                                                                //   quantity: 5,
                                                                                //   vat: 0.19,
                                                                                //   unitPrice: 0.99,
                                                                                // ),
                                                                                // InvoiceItem(
                                                                                //   description: 'Black',
                                                                                //   date: DateTime.now(),
                                                                                //   quantity: 4,
                                                                                //   vat: 0.19,
                                                                                //   unitPrice: 1.29,
                                                                                // ),
                                                                              ],
                                                                            );

                                                                            // mystate(()  {
                                                                            //   prodList = [];
                                                                            //   discount = 0.0;
                                                                            //   debt =0;
                                                                            //   refund =0;
                                                                            // });
                                                                            // // _controller.animateTo(0);
                                                                            // // _controller.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);
                                                                            //
                                                                            // _textFieldController.clear();
                                                                            // Navigator.pop(context);
                                                                            sellDone = true;
                                                                            _controllerTablet.animateTo(0);
                                                                            // //discountAmount =0.0;
                                                                            // pdfFile = await PdfInvoiceApi.generate(invoice, pageType);
                                                                            // mystate(() {
                                                                            //   // setState(() {
                                                                            //   pdfText = pdfFile!.path.toString();
                                                                            //   // });
                                                                            // });


                                                                            // mystate(()  {
                                                                            //   prodList = [];
                                                                            //   discount = 0.0;
                                                                            //   debt =0;
                                                                            //   refund =0;
                                                                            //   //customerId = 'name^name';
                                                                            // });

                                                                            getPaperId().then((value) async {
                                                                              print('VVAALLUUEE ' + value.toString());
                                                                              pdfFile = await PdfInvoiceApi.generate(invoice, value);

                                                                              Uint8List bytes = pdfFile!.readAsBytesSync();


                                                                              Future.delayed(const Duration(milliseconds: 3000), () {
                                                                                setState(() {
                                                                                  mystate(() {
                                                                                    // setState(() {
                                                                                    pdfText = pdfFile!.path.toString();
                                                                                    // });

                                                                                    orderCreating = false;
                                                                                    disableTouch = false;
                                                                                    // saleCartDrag = false;
                                                                                  });
                                                                                });
                                                                                // print('saleCartDrag ' + saleCartDrag.toString());
                                                                                tranGlobalKey.currentState!.disLoading();
                                                                                _controller.animateTo(3, duration: Duration(milliseconds: 0), curve: Curves.ease);
                                                                              });
                                                                            });
                                                                          }
                                                                        }
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                    width: (MediaQuery.of(context).size.width - 45)/2,
                                                                    height: 50,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                        BorderRadius.circular(10.0),
                                                                        color: AppTheme.themeColor),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Expanded(
                                                                            child: orderCreating? Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                                                child: CupertinoActivityIndicator(radius: 10,)): Padding(
                                                                              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                              child: Container(
                                                                                  child: Text(
                                                                                    'Done',
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(
                                                                                        fontSize: 17,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: Colors.black
                                                                                    ),
                                                                                  )
                                                                              ),
                                                                            )
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        child:
                                        Stack(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 71,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.blue
                                                              .withOpacity(0.1),
                                                          width: 1.0))),
                                              child:

                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15.0,
                                                    right: 15.0,
                                                    top: 6),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('MMK '+ titlePrice.toString(), style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.grey
                                                        )),
                                                        SizedBox(width: 5),
                                                        if (unit == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
                                                        else if(unit == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
                                                        else if(unit == 'sub2_name') Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,)
                                                          else Icon( Icons.check, size: 17, color: Colors.grey,),
                                                      ],
                                                    ),
                                                    SizedBox(height: 3.5),
                                                    Text(productName, style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 21
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            eachProd.length !=0 ? Stack(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 85.0,
                                                      left: 15.0,
                                                      right: 15.0),
                                                  child: Container(
                                                      child: ListView(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('QUANTITY', style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14,
                                                                letterSpacing: 2,
                                                                color: Colors.grey,
                                                              ),),
                                                              SizedBox(height: 15),
                                                              Row(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      mystate(() {
                                                                        quantity = double.parse(myController.text) -1;
                                                                        myController.text = quantity.round().toString();
                                                                        print('qqq' + quantity.toString());
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      width: (MediaQuery.of(context).size.width - 60)/3,
                                                                      height: 55,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius:
                                                                          BorderRadius.circular(10.0),
                                                                          color: AppTheme.themeColor),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top: 15.0,
                                                                            bottom: 15.0),
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                                child: Container(
                                                                                    child: Icon(
                                                                                      Icons.remove, size: 20,
                                                                                    )
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 15),
                                                                  Container(
                                                                    width: (MediaQuery.of(context).size.width - 60)/3,
                                                                    height: 55,
                                                                    child: TextField(
                                                                      textAlign: TextAlign.center,
                                                                      decoration: InputDecoration(
                                                                        enabledBorder: const OutlineInputBorder(
                                                                          // width: 0.0 produces a thin "hairline" border
                                                                            borderSide: const BorderSide(
                                                                                color: AppTheme.skBorderColor, width: 2.0),
                                                                            borderRadius: BorderRadius.all(Radius.circular(10.0))),

                                                                        focusedBorder: const OutlineInputBorder(
                                                                          // width: 0.0 produces a thin "hairline" border
                                                                            borderSide: const BorderSide(
                                                                                color: AppTheme.skThemeColor2, width: 2.0),
                                                                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                                                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                        //filled: true,
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                      ),
                                                                      keyboardType: TextInputType.number,
                                                                      onChanged: (value) {
                                                                        setState(() {
                                                                          quantity = double.parse(value);
                                                                        });
                                                                      },
                                                                      controller: myController,
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 15),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        mystate(() {
                                                                          quantity = double.parse(myController.text) +1;
                                                                          myController.text = quantity.round().toString();
                                                                          print('qqq' + quantity.toString());
                                                                        });
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      width: (MediaQuery.of(context).size.width - 60)/3,
                                                                      height: 55,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius:
                                                                          BorderRadius.circular(10.0),
                                                                          color: AppTheme.themeColor),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top: 15.0,
                                                                            bottom: 15.0),
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                                child: Container(
                                                                                    child: Icon(
                                                                                      Icons.add, size: 20,
                                                                                    )
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: 15,),
                                                              Text('COST PER UNIT', style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14,
                                                                letterSpacing: 2,
                                                                color: Colors.grey,
                                                              ),),
                                                              SizedBox(height: 15,),
                                                              TextFormField(
                                                                keyboardType: TextInputType.number,
                                                                controller: sellPriceController,
                                                                validator: (value) {
                                                                  if (value == null || value.isEmpty) {
                                                                    setState(() {
                                                                      price2 = 0;
                                                                    });
                                                                    // return '';
                                                                    return ' This field is required ';
                                                                  }
                                                                  return null;
                                                                },
                                                                style: TextStyle(
                                                                    height: 0.95
                                                                ),
                                                                maxLines: 1,
                                                                decoration: InputDecoration(
                                                                  enabledBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                                      borderSide: const BorderSide(
                                                                          color: AppTheme.skBorderColor,
                                                                          width: 2.0),
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(10.0))),

                                                                  focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                                      borderSide: const BorderSide(
                                                                          color: AppTheme.themeColor,
                                                                          width: 2.0),
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(10.0))),
                                                                  // contentPadding: EdgeInsets.symmetric(vertical: 10), //Change this value to custom as you like
                                                                  // isDense: true,
                                                                  contentPadding: const EdgeInsets.only(
                                                                      left: 15.0,
                                                                      right: 15.0,
                                                                      top: 20,
                                                                      bottom: 20.0),
                                                                  suffixText: 'MMK',
                                                                  suffixStyle: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontSize: 12,
                                                                    fontFamily: 'capsulesans',
                                                                  ),
                                                                  //errorText: wrongEmail,
                                                                  errorStyle: TextStyle(
                                                                      backgroundColor: Colors.white,
                                                                      fontSize: 12,
                                                                      fontFamily: 'capsulesans',
                                                                      height: 0.1
                                                                  ),
                                                                  labelStyle: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black,
                                                                  ),
// errorText: 'Error message',
                                                                  labelText: 'Custom Sell Price',
                                                                  floatingLabelBehavior:
                                                                  FloatingLabelBehavior.auto,
//filled: true,
                                                                  border: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 15,),
                                                              Text('UNIT PRICING', style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 14,
                                                                letterSpacing: 2,
                                                                color: Colors.grey,
                                                              ),),
                                                              SizedBox(height: 15,),
                                                              // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                                              //   stream: FirebaseFirestore
                                                              //       .instance
                                                              //       .collection('space')
                                                              //       .doc(
                                                              //       '0NHIS0Jbn26wsgCzVBKT')
                                                              //       .collection('shops')
                                                              //       .doc(
                                                              //       shopId)
                                                              //       .collection('products')
                                                              //       .doc(eachProd.split('^')[0])
                                                              //       .snapshots(),
                                                              //   builder: (BuildContext context, snapshot2) {
                                                              //     if (snapshot2.hasData) {
                                                              // var output = snapshot2.data!.data();
                                                              // // var prodName = output?['prod_name'];
                                                              // var mainName = output?['unit_name'];
                                                              // var sub1Name = output?['sub1_name'];
                                                              // var sub2Name = output?['sub2_name'];
                                                              // // var sub3Name = output?['sub3_name'];
                                                              // var barcode = output?['bar_code'];
                                                              // // var mainPrice = output?['unit_sell'];
                                                              // // var sub1Price = output?['sub1_sell'];
                                                              // // var sub2Price = output?['sub2_sell'];
                                                              // // var sub3Price = output?['sub3_sell'];
                                                              // // var sub1Unit = output?['sub1_link'];
                                                              // // var sub2Unit = output?['sub2_link'];
                                                              // // var sub3Unit = output?['sub3_link'];
                                                              // // var subExist = output?['sub_exist'];
                                                              // var mainLoss = output?['Loss1'].round();
                                                              // var sub1Loss = output?['Loss2'].round();
                                                              // var sub2Loss = output?['Loss3'].round();
                                                              // var mainQty = output?['inStock1'].round();
                                                              // var sub1Qty = output?['inStock2'].round();
                                                              // var sub2Qty = output?['inStock3'].round();
                                                              // var image = output?['img_1'];
                                                              //return
                                                              Container(
                                                                height: 220,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(20.0),
                                                                  color: AppTheme.lightBgColor,
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Container(
                                                                        height: 55,
                                                                        decoration: BoxDecoration(border: Border(bottom: BorderSide(
                                                                            color: Colors.grey
                                                                                .withOpacity(0.2),
                                                                            width: 1.0))),
                                                                        child: Row(
                                                                          children: [
                                                                            Text('Sell price', style:
                                                                            TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),),
                                                                            Spacer(),
                                                                            eachProd.split('^')[3]== 'unit_name' ? Text('MMK ' +  sell1.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                                            TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.grey,
                                                                            ),) :
                                                                            eachProd.split('^')[3]== 'sub1_name' ? Text('MMK ' +  sell2.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                                            TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.grey,
                                                                            ),) :  Text('MMK ' +  sell3.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                                            TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.grey,
                                                                            ),),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 55,
                                                                        decoration: BoxDecoration(
                                                                            border: Border(
                                                                                bottom: BorderSide(
                                                                                    color: Colors.grey
                                                                                        .withOpacity(0.2),
                                                                                    width: 1.0))),
                                                                        child: Row(
                                                                          children: [
                                                                            Text('In stock', style:
                                                                            TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),),
                                                                            Spacer(),
                                                                            eachProd.split('^')[3]== 'unit_name' ? Text(mainQty.toString() + ' ' + mainName, style:
                                                                            TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.grey,
                                                                            ),) : eachProd.split('^')[3]== 'sub1_name'? Text( sub1Qty.toString() + ' ' + sub1Name, style:
                                                                            TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.grey,
                                                                            ),) : Text(sub2Qty.toString() + ' ' + sub2Name, style:
                                                                            TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.grey,
                                                                            ),),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 55,
                                                                        decoration: BoxDecoration(
                                                                            border: Border(
                                                                                bottom: BorderSide(
                                                                                    color: Colors.grey
                                                                                        .withOpacity(0.2),
                                                                                    width: 1.0))),
                                                                        child: Row(
                                                                          children: [
                                                                            Text('Loss', style:
                                                                            TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),),
                                                                            Spacer(),
                                                                            eachProd.split('^')[3]== 'unit_name' ? Text(mainLoss.toString() + ' ' + mainName, style:
                                                                            TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.grey,
                                                                            ),) : eachProd.split('^')[3]== 'sub1_name'? Text(sub1Loss.toString() + ' ' + sub1Name, style:
                                                                            TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.grey,
                                                                            ),) : Text(sub2Loss.toString() + ' ' + sub2Name, style:
                                                                            TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.grey,
                                                                            ),),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 55,
                                                                        child: Row(
                                                                          children: [
                                                                            Text('Barcode', style:
                                                                            TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),),
                                                                            Spacer(),
                                                                            Text(barcode, style:
                                                                            TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.grey,
                                                                            ),),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              //     }
                                                              //     return Container();
                                                              //   },
                                                              // ),
                                                            ],
                                                          ),
                                                        ],
                                                      )),

                                                ),
                                                Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                                color:
                                                                AppTheme.skBorderColor2,
                                                                width: 1.0),
                                                          )),
                                                      width: double.infinity,
                                                      height: 158,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                        children: [
                                                          ListTile(
                                                            title: Text(
                                                              'Total',
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                            ),
                                                            trailing: Text('MMK '+
                                                                (totalFixAmount).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          Padding(
                                                              padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
                                                              child: Row(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        setState((){
                                                                          mystate(() {
                                                                            _controller.animateTo(0);
                                                                            _textFieldController.clear();
                                                                            paidAmount = 0;
                                                                            debt = 0;
                                                                            refund = 0;
                                                                            totalAmount = double.parse(TtlProdListPrice());
                                                                          });
                                                                        });

                                                                      },
                                                                      child: Container(
                                                                        width: (MediaQuery.of(context).size.width - 45)/2,
                                                                        height: 55,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                            color: AppTheme.secButtonColor),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 15.0,
                                                                              bottom: 15.0),
                                                                          child: Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .center,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                                  child: Container(
                                                                                      child: Text(
                                                                                        'Back',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(
                                                                                            fontSize: 18,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            color: Colors.black
                                                                                        ),
                                                                                      )
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Spacer(),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        if (_formKey.currentState!.validate()) {
                                                                          print('eachProduct' +eachProd);
                                                                          for (int j = 0; j < prodList.length; j++)
                                                                            if( prodList[j].split('^')[0] == eachProd.split('^')[0] && prodList[j].split('^')[3] == eachProd.split('^')[3]){
                                                                              setState((){
                                                                                mystate((){
                                                                                  eachProd = eachProd.split('^')[0] +'^' + eachProd.split('^')[1]+'^'+ (price2.toString()) +'^'+eachProd.split('^')[3]+ '^'+ (quantity.toString())+'^'+eachProd.split('^')[5];
                                                                                  prodList[j] = eachProd;
                                                                                }); });
                                                                              print('leepae' + prodList[j]);
                                                                            } else print('leelar');
                                                                          _controller.animateTo(0);
                                                                          // if(mainQty - quantity <= 0) {smartKyatFlash('Out of Stock', 'w');}

                                                                        }
                                                                      },
                                                                      child: Container(
                                                                        width: (MediaQuery.of(context).size.width - 45)/2,
                                                                        height: 50,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                            color: AppTheme.themeColor),
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                                child: Container(
                                                                                    child: Text(
                                                                                      'Done',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(
                                                                                          fontSize: 17,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          color: Colors.black
                                                                                      ),
                                                                                    )
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ) :
                                            Expanded(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 15.0),
                                                  child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                      child: CupertinoActivityIndicator(radius: 15,)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ) ,
                                      ),
                                    ),
                                    Container(
                                      // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 67,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          width: 1.0))),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15.0,
                                                    right: 15.0,
                                                    top: 5.0,
                                                    bottom: 0.0
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(customerId.split('^')[1] == 'name'? 'No customer':customerId.split('^')[1], style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.grey,
                                                    )),
                                                    SizedBox(height: 2.5),
                                                    Text('Invoice receipt', style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 19
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 71.0,
                                                  left: 0.0,
                                                  right: 0.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Padding(
                                                        padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 12.0),
                                                        child: Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  final doc = await PdfDocument.openFile(pdfFile!.path);
                                                                  final pages = doc.pageCount;
                                                                  List<imglib.Image> images = [];

// get images from all the pages
                                                                  for (int i = 1; i <= pages; i++) {
                                                                    var page = await doc.getPage(i);
                                                                    var imgPDF = await page.render(width: page.width.round()*5, height: page.height.round()*5);
                                                                    var img = await imgPDF.createImageDetached();
                                                                    var imgBytes = await img.toByteData(format: ImageByteFormat.png);
                                                                    var libImage = imglib.decodeImage(imgBytes!.buffer
                                                                        .asUint8List(imgBytes.offsetInBytes, imgBytes.lengthInBytes));
                                                                    images.add(libImage!);
                                                                  }

// stitch images
                                                                  int totalHeight = 0;
                                                                  images.forEach((e) {
                                                                    totalHeight += e.height;
                                                                  });
                                                                  int totalWidth = 0;
                                                                  images.forEach((element) {
                                                                    totalWidth = totalWidth < element.width ? element.width : totalWidth;
                                                                  });
                                                                  mergedImage = imglib.Image(totalWidth, totalHeight);
                                                                  int mergedHeight = 0;
                                                                  images.forEach((element) {
                                                                    imglib.copyInto(mergedImage, element, dstX: 0, dstY: mergedHeight, blend: false);
                                                                    mergedHeight += element.height;
                                                                  });

                                                                  // Save image as a file
                                                                  // final documentDirectory = await getExternalStorageDirectory();
                                                                  // Directory appDocDirectory = await getApplicationDocumentsDirectory();
                                                                  // File imgFile = new File(appDocDirectory.path + 'test.jpg');
                                                                  // new File(imgFile.path).writeAsBytes(imglib.encodeJpg(mergedImage));

                                                                  // Save to album.
                                                                  // bool? success = await ImageSave.saveImage(Uint8List.fromList(imglib.encodeJpg(mergedImage)), "demo.jpg", albumName: "demo");
                                                                  _saveImage(Uint8List.fromList(imglib.encodeJpg(mergedImage)));
                                                                },
                                                                child: Container(
                                                                  width: (MediaQuery.of(context).size.width - 45)* (3/4),
                                                                  height: 50,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.circular(10.0),
                                                                    color: AppTheme.secButtonColor,
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(
                                                                        top: 0.0,
                                                                        bottom: 0.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Expanded(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                            child: Container(
                                                                                child: Text(
                                                                                  'Save as image',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                      fontSize: 17,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: Colors.black
                                                                                  ),
                                                                                )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  _onScanPressed();
                                                                  Future.delayed(const Duration(milliseconds: 1000), () {
                                                                    _controller.animateTo(4);
                                                                  });
                                                                },
                                                                child: Container(
                                                                  width: (MediaQuery.of(context).size.width - 45)* (1/4),
                                                                  height: 50,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(10.0),
                                                                      color: AppTheme.themeColor),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(
                                                                        top: 0.0,
                                                                        bottom: 0.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Expanded(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
                                                                            child: Container(
                                                                                child: Icon(
                                                                                  Icons.print_rounded,
                                                                                  size: 25,
                                                                                  color: Colors.black,
                                                                                )
                                                                              // child: Text(
                                                                              //   '',
                                                                              //   textAlign: TextAlign.center,
                                                                              //   style: TextStyle(
                                                                              //       fontSize: 18,
                                                                              //       fontWeight: FontWeight.w600,
                                                                              //       color: Colors.black
                                                                              //   ),
                                                                              // )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                        )
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  // Container(
                                                  //   height: 500,
                                                  //   width: 200,
                                                  //   child: GestureDetector(
                                                  //       onTap: () {
                                                  //         print('clicked');
                                                  //         PdfApi.openFile(pdfFile);
                                                  //       },
                                                  //       child: PdfViewer.openFile(pdfText)
                                                  //   ),
                                                  // )
                                                  // SizedBox(
                                                  //   height: 10,
                                                  // ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                    child: Text('RECEIPT VOUCHER',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        letterSpacing: 2,
                                                        color: Colors.grey,
                                                      ),),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  pdfText == '' ? Container() :
                                                  Expanded(
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            print('clicked');
                                                            PdfApi.openFile(pdfFile!);
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                            child: PdfViewer.openFile(pdfText),
                                                          )
                                                      )
                                                  ),
                                                  SizedBox(
                                                    height: 150,
                                                  )
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border(
                                                        top: BorderSide(
                                                            color:
                                                            AppTheme.skBorderColor2,
                                                            width: 1.0),
                                                      )),
                                                  width: double.infinity,
                                                  height: 150,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                    children: [
                                                      ListTile(
                                                        title: Text(
                                                          'Total price',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        ),
                                                        trailing: Text('MMK '+
                                                            TtlProdListPrice().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Padding(
                                                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 27.0),
                                                          child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () async {
                                                                    setState(() {
                                                                      mystate(()  {
                                                                        prodList = [];
                                                                        discount = 0.0;
                                                                        discountAmount =0.0;
                                                                        debt =0;
                                                                        refund =0;
                                                                        customerId = 'name^name';
                                                                        disText = '';
                                                                        isDiscount = '';
                                                                      });
                                                                    });
                                                                    // _controller.animateTo(0);
                                                                    // _controller.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);
                                                                    // saleCartDrag = true;
                                                                    _textFieldController.clear();
                                                                    Navigator.pop(context);
                                                                    // sellDone = true;


                                                                  },
                                                                  child: Container(
                                                                    width: (MediaQuery.of(context).size.width - 30),
                                                                    height: 50,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                        BorderRadius.circular(10.0),
                                                                        color: AppTheme.themeColor),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        Expanded(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                            child: Container(
                                                                                child: Text(
                                                                                  'Next sale',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                      fontSize: 17,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: Colors.black
                                                                                  ),
                                                                                )
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 67,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        width: 1.0))),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15.0,
                                                  top: 5.0,
                                                  bottom: 0.0
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(customerId.split('^')[1] == 'name'? 'No customer':customerId.split('^')[1], style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                  )),
                                                  SizedBox(height: 2.5),
                                                  Text('Printing service', style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 19
                                                  )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // GestureDetector(
                                          //     onTap: _isLoading ? null : _onScanPressed,
                                          //     child: Text('click to scan', style: TextStyle(fontSize: 25),)
                                          // ),
                                          Expanded(
                                            child: _isLoading && _blueDevices.isEmpty
                                                ? Center(
                                              child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                  child: CupertinoActivityIndicator(radius: 15,)),
                                            )
                                                : _blueDevices.isNotEmpty
                                                ? SingleChildScrollView(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(height: 5),
                                                    Column(
                                                      children: List<Widget>.generate(_blueDevices.length,
                                                              (int index) {
                                                            return Row(
                                                              children: <Widget>[
                                                                Expanded(
                                                                  child: GestureDetector(
                                                                    onTap: _blueDevices[index].address ==
                                                                        (_selectedDevice?.address ?? '')
                                                                        ? _onDisconnectDevice
                                                                        : () => _onSelectDevice(index),
                                                                    child: Container(
                                                                      color: Colors.white,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            Text(
                                                                              _blueDevices[index].name,
                                                                              style: TextStyle(
                                                                                  color:
                                                                                  _selectedDevice?.address ==
                                                                                      _blueDevices[index]
                                                                                          .address
                                                                                      ? AppTheme.themeColor
                                                                                      : Colors.black,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 19
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              _blueDevices[index].address,
                                                                              style: TextStyle(
                                                                                  color:
                                                                                  _selectedDevice?.address ==
                                                                                      _blueDevices[index]
                                                                                          .address
                                                                                      ? Colors.blueGrey
                                                                                      : Colors.grey,
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w500
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                if (_loadingAtIndex == index && _isLoading)
                                                                  Container(
                                                                    height: 24.0,
                                                                    width: 65.0,
                                                                    margin: const EdgeInsets.only(right: 8.0),
                                                                    child: Center(
                                                                      child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                                                            child: CupertinoActivityIndicator(radius: 10,),
                                                                          )
                                                                      ),
                                                                    ),
                                                                  ),
                                                                if (!_isLoading &&
                                                                    _blueDevices[index].address ==
                                                                        (_selectedDevice?.address ?? ''))
                                                                  TextButton(
                                                                    onPressed: _onPrintReceipt,
                                                                    // child: Container(
                                                                    //   color: _selectedDevice == null
                                                                    //       ? AppTheme.buttonColor2
                                                                    //       : AppTheme.themeColor,
                                                                    //   padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10, left: 10),
                                                                    //   child: Icon(
                                                                    //     Icons.print_rounded,
                                                                    //     size: 25,
                                                                    //     color: Colors.black,
                                                                    //   )
                                                                    //   // child: const Text(
                                                                    //   //     'Print',
                                                                    //   //     style: TextStyle(color: Colors.white)
                                                                    //   // ),
                                                                    // ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0, left: 20.0, right: 20.0),
                                                                      child: Icon(
                                                                        Icons.print_rounded,
                                                                        size: 25,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                    style: ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty
                                                                            .resolveWith<Color>(
                                                                              (Set<MaterialState> states) {
                                                                            if (states.contains(
                                                                                MaterialState.pressed)) {
                                                                              return AppTheme.themeColor.withOpacity(0.5);
                                                                            }
                                                                            return AppTheme.themeColor;
                                                                          },
                                                                        ),
                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            )
                                                                        )
                                                                    ),
                                                                  ),
                                                                SizedBox(width: 8.5)
                                                              ],
                                                            );
                                                          }),
                                                    ),
                                                    SizedBox(height: 5),
                                                  ],
                                                ),
                                              ),
                                            )
                                                : Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: const <Widget>[
                                                  Text(
                                                    'Scan bluetooth device',
                                                    style: TextStyle(fontSize: 24, color: Colors.blue),
                                                  ),
                                                  Text(
                                                    'Press button scan',
                                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // child: _devices.isEmpty
                                            //     ? Center(child: Text(_devicesMsg ?? ''))
                                            //     : ListView.builder(
                                            //   itemCount: _devices.length,
                                            //   itemBuilder: (c, i) {
                                            //     return ListTile(
                                            //       leading: Icon(Icons.print),
                                            //       title: Text(_devices[i].name.toString()),
                                            //       subtitle: Text(_devices[i].address.toString()),
                                            //       onTap: () {
                                            //         // _startPrint(_devices[i]);
                                            //       },
                                            //     );
                                            //   },
                                            // )
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                      top: BorderSide(
                                                          color:
                                                          AppTheme.skBorderColor2,
                                                          width: 1.0),
                                                    )),
                                                width: double.infinity,
                                                height: 150,
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                                  children: [
                                                    ListTile(
                                                      title: Text(
                                                        'Total price',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      ),
                                                      trailing: Text('MMK '+
                                                          debt.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Padding(
                                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 27.0),
                                                        child: Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  setState(() {
                                                                    mystate(()  {
                                                                      prodList = [];
                                                                      discount = 0.0;
                                                                      discountAmount =0.0;
                                                                      debt =0;
                                                                      refund =0;
                                                                      customerId = 'name^name';
                                                                      disText = '';
                                                                      isDiscount = '';
                                                                    });
                                                                  });
                                                                  // _controller.animateTo(0);
                                                                  // _controller.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);

                                                                  _textFieldController.clear();
                                                                  Navigator.pop(context);
                                                                  // sellDone = true;


                                                                },
                                                                child: Container(
                                                                  width: (MediaQuery.of(context).size.width - 30),
                                                                  height: 50,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(10.0),
                                                                      color: AppTheme.themeColor),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                          child: Container(
                                                                              child: Text(
                                                                                'Next sale',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                    fontSize: 17,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: Colors.black
                                                                                ),
                                                                              )
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ]
                                                        )
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 42,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25.0),
                                      ),
                                      color: Colors.white.withOpacity(0.5)),
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
          );
        }).whenComplete(() {
      print('Hey there, I\'m calling after hide bottomSheet');
      if(sellDone) {
        setState(() {
          // mystate(()  {
          prodList = [];
          discount = 0.0;
          discountAmount =0.0;
          debt =0;
          refund =0;
          customerId = 'name^name';
          disText = '';
          isDiscount = '';
          // });
        });
        // _controller.animateTo(0);
        // _controller.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);

        _textFieldController.clear();
        _textFieldControllerTablet.clear();
        sellDone = false;
      }
    });
  }



  setStoreId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setString('store', id);
  }

  getStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('store');
  }

  getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('device');
  }


  var counter = 0;
  var orderLoading = false;

  String total = 'T';
  int disPercent = 0;
  int disPercent2 =0;


  Future<void> _saveImage(_data) async {
    bool success = false;
    try {
      success = (await ImageSave.saveImage(_data, "receipt.jpg", albumName: "SmartKyatPOS"))!;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
    }

    print(success ? "Save to album success" : "Save to album failed");
    // setState(() {
    //   _result = success ? "Save to album success" : "Save to album failed";
    // });
  }

  TtlProdListPriceInit()  {
    double total = 0;
    print(prodList.toString());
    for (String str in prodList) {
      total += double.parse(str.split('^')[2]) * double.parse(str.split('^')[4]);
    }
    return total.toString();
  }

  TtlProdListPriceInit2()  {
    double total = 0;
    print(prodList2.toString());
    for (String str in prodList2) {
      total += double.parse(str.split('^')[1]) * double.parse(str.split('^')[2]);
    }
    return total.toString();
  }

  TtlProdListPrice()  {
    double total = 0;
    print(prodList.toString());
    for (String str in prodList) {
      total += double.parse(str.split('^')[2]) * double.parse(str.split('^')[4]);
      disPercent = (double.parse(total.toString()) *
          (discountAmount / 100)).round();
    }
    if(isDiscount == 'percent'){
      discountAmount = discount;
      print(discountAmount.toString());
      disText = '-p';
      total = (double.parse(total.toString()) -
          (double.parse(total.toString()) *
              (discountAmount / 100)));
    } else if(isDiscount == 'amount'){
      discountAmount = discount;
      disText ='-d';
      total = (double.parse(total.toString()) - discountAmount);
    } else {
      disText = '';
      discountAmount = 0.0;
      total = double.parse(total.toString());
    }
    return total.toString();
  }

  totalItems2() {
    int total = 0;
    //print(prodList.toString());
    for (String str in prodList2) {
      total ++;
    }
    return total.toString();
  }

  totalItems() {
    int total = 0;
    //print(prodList.toString());
    for (String str in prodList) {
      total ++;
    }
    return total.toString();
  }
  zeroToTen(String string) {
    if (double.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
  }

  selectedTab() {
    if(_selectIndex==0) {
      return Row(
        children: [
          Icon(
            SmartKyat_POS.home,
            size: 20,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 0.0),
                child: Text(
                  'Home',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              )
          )
        ],
      );
    } else if(_selectIndex==1) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: Icon(
              SmartKyat_POS.product,
              size: 21,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 1.0),
                child: Text(
                  'Product',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              )
          )
        ],
      );
    } else if(_selectIndex==2) {
      return Row(
        children: [
          Icon(
            SmartKyat_POS.order,
            size: 23,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 1.0),
                child: Text(
                  'Sale orders',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              )
          )
        ],
      );
    } else if(_selectIndex==3) {
      return Row(
        children: [
          Icon(
            SmartKyat_POS.order,
            size: 23,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 1.0),
                child: Text(
                  'Buy orders',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              )
          )
        ],
      );
    } else if(_selectIndex==4) {
      return Row(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: Icon(
                  SmartKyat_POS.customer1,
                  size: 17.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, top: 11.0),
                child: Icon(
                  SmartKyat_POS.customer2,
                  size: 9,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 5),
                child: Container(
                  width: 8,
                  height: 7.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.5, top: 7.5),
                child: Container(
                  width: 5,
                  height: 4.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black),
                ),
              )
            ],
          ),
          SizedBox(
            width: 8,
          ),
          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 1.0),
                child: Text(
                  'Customers',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              )
          )
        ],
      );
    } else if(_selectIndex==5) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: Icon(
              SmartKyat_POS.merchant,
              size: 20,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 1.0),
                child: Text(
                  'Merchants',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              )
          )
        ],
      );
    } else if(_selectIndex==6) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: Icon(
              SmartKyat_POS.setting,
              size: 22,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 1.0),
                child: Text(
                  'Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              )
          )
        ],
      );
    } else {
      return Row(
        children: [
          Icon(
            SmartKyat_POS.search,
            size: 23,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 1.0),
                child: Text(
                  'Searching',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              )
          )
        ],
      );
    }
  }

  changeUnitName2Stock(String split) {
    if(split == 'main') {
      return 'inStock1';
    } else {
      return 'inStock' + (int.parse(split[3]) + 1).toString();
    }
  }

  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) + newChar + oldString.substring(index + 1);
  }

  Future<void> Detail(date, length, subs, docId) async {
    print('CHECKING PRODSALE ORD');
    CollectionReference detail = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('order');
    String customId = deviceIdNum.toString() + length.toString();

    detail.doc(customId).set({
      'date': date,
      'total': TtlProdListPrice(),
      'debt' : debt,
      'discount' : discountAmount.toString() + disText,
      'refund': 'FALSE',
      'subs': subs,
      'customerId' : customerId.split('^')[0],
      'deviceId' : deviceIdNum.toString() + '-',
      'orderId' : length.toString(),
      'documentId' : docId,
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> orderLengthIncrease() async {
    print('CHECKING PRODSALE ORD');
    CollectionReference users = await FirebaseFirestore.instance.collection('shops');

    // print('gg ' + str.split('^')[0] + ' ' + changeUnitName2Stock(str.split('^')[3]));

    users.doc(shopId).update({'orders_length': FieldValue.increment(1)}).then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> CusOrder(ttlOrders, debts , debtAmount) async {
    print('CHECKING PRODSALE ORD');
    CollectionReference cusOrder = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('customers');

    cusOrder.doc(customerId.split('^')[0]).update({
      'total_orders': FieldValue.increment(double.parse(ttlOrders.toString())),
      'debtAmount' : FieldValue.increment(double.parse(debtAmount.toString())),
      'debts': FieldValue.increment(double.parse(debts.toString())),
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> prodSaleData(id, num) async {
    print('CHECKING PRODSALE');
    CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products');

    // print('gg ' + str.split('^')[0] + ' ' + changeUnitName2Stock(str.split('^')[3]));

    users
        .doc(id)
        .update({'mainSellUnit': FieldValue.increment(double.parse(num.toString()))})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> decStockFromInv(id, unit, num) async {
    print('Double Check Sub1');
    CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products');

    // print('gg ' + str.split('^')[0] + ' ' + changeUnitName2Stock(str.split('^')[3]));

    users
        .doc(id)
        .update({changeUnitName2Stock(unit): FieldValue.increment(0 - (double.parse(num.toString())))})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> incStockFromInv(id, unit, num) async {
    CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products');

    // print('gg ' + str.split('^')[0] + ' ' + changeUnitName2Stock(str.split('^')[3]));

    users
        .doc(id)
        .update({changeUnitName2Stock(unit): FieldValue.increment(double.parse(num.toString()))})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> sub1Execution(subStock, subLink, id, num) async {
    var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(id).get();
    if (docSnapshot10.exists) {
      Map<String, dynamic>? data10 = docSnapshot10.data();
      subStock[1] = double.parse((data10 ? ['inStock2']).toString());
      if(subStock[1] > double.parse(num)) {
        decStockFromInv(id, 'sub1', num);
      } else {
        decStockFromInv(id, 'main', ((double.parse(num)  - subStock[1])/double.parse(subLink[0])).ceil());
        incStockFromInv(id, 'sub1', ((double.parse(num)-subStock[1].round()) % double.parse(subLink[0])) == 0? 0: (double.parse(subLink[0]) - (double.parse(num)-subStock[1].round()) % double.parse(subLink[0])));
        decStockFromInv(id, 'sub1', subStock[1]);
      }
    }
  }

  Future<void> sub2Execution(subStock, subLink, id, num) async {
    var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(id).get();
    if (docSnapshot10.exists) {
      Map<String, dynamic>? data10 = docSnapshot10.data();
      subStock[2] = double.parse((data10 ? ['inStock3']).toString());
      if(subStock[2] > double.parse(num)) {
        decStockFromInv(id, 'sub2', num);
      } else {
        await incStockFromInv(id, 'sub2', ((double.parse(num)-subStock[2].round()) % double.parse(subLink[1])) == 0? 0: (double.parse(subLink[1]) - (double.parse(num)-subStock[2].round()) % double.parse(subLink[1])));
        await decStockFromInv(id, 'sub2', subStock[2]);
        sub1Execution(subStock, subLink, id, ((double.parse(num)  - subStock[2])/double.parse(subLink[1])).ceil().toString());
      }
    }
  }

  todayToYearStart(DateTime now) {
    DateTime yearStart = DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-00-00 00:00:00');
    print('DDDD ' + yearStart.toString());
    return yearStart;
  }

  getPaperId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('paper') == null) {
      return 'Roll-57';
    }
    return prefs.getString('paper');
  }

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }

  Future<void> addDateExist(id1, dOrder , length) async {
    CollectionReference daily = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders');
    daily.doc(id1).update({
      'daily_order': FieldValue.arrayUnion([dOrder.toString()]),
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> DatenotExist(dOrder, date, length) async {
    CollectionReference daily = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders');

    String customId = date.year.toString() + zeroToTen(date.month.toString()) + zeroToTen(date.day.toString()) +  deviceIdNum.toString();

    daily.doc(customId).set({
      'daily_order': FieldValue.arrayUnion([dOrder.toString()]),
      'date' : date
    }).then((value) {
      print('date Exist added');
    }).catchError((error) => print("Failed to update user: $error"));
  }

  void smartKyatFlash(String text, String type) {
    Widget widgetCon = Container();
    Color bdColor = Color(0xffffffff);
    Color bgColor = Color(0xffffffff);
    if(type == 's') {
      bdColor = Color(0xffB1D3B1);
      bgColor = Color(0xffCFEEE0);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff419373)),
        child: Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: Icon(
            Icons.check_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'w') {
      bdColor = Color(0xffF2E0BC);
      bgColor = Color(0xffFCF4E2);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffF5C04A)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 1.0),
          child: Text('!', textScaleFactor: 1, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    } else if(type == 'e') {
      bdColor = Color(0xffEAD2C8);
      bgColor = Color(0xffFAEEEC);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xffE9625E)),
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Icon(
            Icons.close_rounded,
            size: 15,
            color: Colors.white,
          ),
        ),
      );
    } else if(type == 'i') {
      bdColor = Color(0xffBCCEEA);
      bgColor = Color(0xffE8EEF9);
      widgetCon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
            color: Color(0xff4788E2)),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.5, top: 1.5),
          child: Text('i', textScaleFactor: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,)),
          // child: Icon(
          //   Icons.warning_rounded,
          //   size: 15,
          //   color: Colors.white,
          // ),
        ),
      );
    }
    showFlash(
      context: context,
      duration: const Duration(milliseconds: 2500),
      persistent: true,
      transitionDuration: Duration(milliseconds: 300),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          // boxShadows: [BoxShadow(blurRadius: 4)],
          // barrierBlur: 3.0,
          // barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 93.0, left: 15, right: 15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: bgColor,
                border: Border.all(
                    color: bdColor,
                    width: 1.0
                ),
              ),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: widgetCon,
                ),
                minLeadingWidth: 15,
                horizontalTitleGap: 10,
                minVerticalPadding: 0,
                title: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 16.3),
                  child: Container(
                    child: Text(text, textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15, height: 1.2)),
                  ),
                ),
                // subtitle: Text('shit2'),
                // trailing: Text('GGG',
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //   ),),
              ),
            ),
          ),
          // child: Padding(
          //   padding: const EdgeInsets.only(
          //       top: 93.0, left: 15, right: 15),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(10.0),
          //       ),
          //       color: bgColor,
          //       border: Border.all(
          //           color: bdColor,
          //           width: 1.0
          //       ),
          //     ),
          //     child: Padding(
          //         padding: const EdgeInsets.only(
          //             top: 15.0, left: 10, right: 10, bottom: 15),
          //         child: Row(
          //           children: [
          //             SizedBox(width: 5),
          //             widgetCon,
          //             SizedBox(width: 10),
          //             Padding(
          //               padding: const EdgeInsets.only(bottom: 2.5),
          //               child: Container(
          //                 child: Text(text, overflow: TextOverflow.visible, style: TextStyle(
          //                     fontWeight: FontWeight.w400, fontSize: 14.5)),
          //               ),
          //             )
          //           ],
          //         )
          //     ),
          //   ),
          // ),
        );
      },
    );
  }

  closeCart() {
    setState(() {
      closeGoToCart = true;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _goToCartHeight = 61;
      });
    });
  }

  bool homeCartOpen = true;
  bool prodCartOpen = true;
  bool sordCartOpen = true;
  bool bordCartOpen = true;
  bool custCartOpen = true;
  bool mercCartOpen = true;
  bool settCartOpen = true;
  bool searCartOpen = true;
  bool homeDrawerOpen = true;
  bool prodDrawerOpen = true;
  bool sordDrawerOpen = true;
  bool bordDrawerOpen = true;
  bool custDrawerOpen = true;
  bool merchDrawerOpen = true;
  bool settDrawerOpen = true;
  bool searDrawerOpen = true;

  int ayinIndex2 = 1;

  checkDrawerOpen() async {
    bool isFirstRouteInProd = !await tabs[3].key.currentState!.maybePop();
    print('check isFirst Prod ' + isFirstRouteInProd.toString());
  }

  closeByClick() async {
    print('closebyclick' + _selectIndex.toString());
    if(ayinIndex2 != _selectIndex) {
      if(_selectIndex == 0) {
        closeGoToCart = !homeCartOpen;
        drawerDrag = !homeDrawerOpen;

      } else if(_selectIndex == 1) {
        closeGoToCart = !prodCartOpen;
        drawerDrag = !prodDrawerOpen;
        // bool isFirstRouteInCur = await tabs[currentTab].key.currentState!.maybePop();
        // print('shwwwwww' + isFirstRouteInCur.toString());
        // if(isFirstRouteInCur) {
        //   closeGoToCart = false;
        //   prodCartOpen = true;
        //
        //   // print('shwwwwww');
        // } else {
        //
        // }
      } else if(_selectIndex == 2) {
        drawerDrag = !sordDrawerOpen;
        closeGoToCart = !sordCartOpen;
      } else if(_selectIndex == 3) {
        drawerDrag = !bordDrawerOpen;
        closeGoToCart = !bordCartOpen;
      } else if(_selectIndex == 4) {
        drawerDrag = !custDrawerOpen;
        closeGoToCart = !custCartOpen;
      } else if(_selectIndex == 5) {
        drawerDrag = !merchDrawerOpen;
        closeGoToCart = !mercCartOpen;
      } else if(_selectIndex == 6) {
        drawerDrag = !settDrawerOpen;
        closeGoToCart = true;
      } else if(_selectIndex == 7) {
        drawerDrag = !searDrawerOpen;
        closeGoToCart = !searCartOpen;
      }
    } else {
      if(_selectIndex == 0) {
        drawerDrag = false;
        homeDrawerOpen = true;
        closeGoToCart = false;
        homeCartOpen = true;
      } else if(_selectIndex == 1) {
        drawerDrag = false;
        prodDrawerOpen = true;
        closeGoToCart = false;
        prodCartOpen = true;
      } else if(_selectIndex == 2) {
        drawerDrag = false;
        sordDrawerOpen = true;
        closeGoToCart = false;
        sordCartOpen = true;
      } else if(_selectIndex == 3) {
        drawerDrag = false;
        bordDrawerOpen = true;
        closeGoToCart = false;
        bordCartOpen = true;
      } else if(_selectIndex == 4) {
        drawerDrag = false;
        custDrawerOpen = true;
        closeGoToCart = false;
        custCartOpen = true;
      } else if(_selectIndex == 5) {
        drawerDrag = false;
        merchDrawerOpen = true;
        closeGoToCart = false;
        mercCartOpen = true;
      } else if(_selectIndex == 6) {
        drawerDrag = false;
        settDrawerOpen = true;
        closeGoToCart = true;
      } else if(_selectIndex == 7) {
        drawerDrag = false;
        searDrawerOpen = true;
        closeGoToCart = false;
        searCartOpen = true;
      }


    }
    ayinIndex2 = _selectIndex;

    if(!closeGoToCart) {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          closeGoToCart = false;
        });
      });
      setState(() {
        _goToCartHeight = 142;
      });
    } else {
      setState(() {
        closeGoToCart = true;
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _goToCartHeight = 61;
        });
      });
    }
  }

  closeCartFrom(String from) {
    print('FROM close' + from);
    if(from == 'products') {
      prodCartOpen = false;
    } else if(from == 'saleorders') {
      sordCartOpen = false;
    } else if(from == 'buyorders') {
      bordCartOpen = false;
    } else if(from == 'customers') {
      custCartOpen = false;
    } else if(from == 'merchants') {
      mercCartOpen = false;
    } else if(from == 'settings') {
      settCartOpen = false;
    } else if(from == 'search') {
      searCartOpen = false;
    }
    setState(() {
      closeGoToCart = true;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _goToCartHeight = 61;
      });
    });
  }

  openCartFrom(String from) {
    print('FROM open' + from);
    if(from == 'products') {
      prodCartOpen = true;
    } else if(from == 'saleorders') {
      sordCartOpen = true;
    } else if(from == 'buyorders') {
      bordCartOpen = true;
    } else if(from == 'customers') {
      custCartOpen = true;
    } else if(from == 'merchants') {
      mercCartOpen = true;
    } else if(from == 'settings') {
      settCartOpen = true;
    } else if(from == 'search') {
      searCartOpen = true;
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        closeGoToCart = false;
      });
    });
    setState(() {
      _goToCartHeight = 142;
    });
  }

  closeDrawerFrom(String from) {
    print('FROM close' + from);
    if(from == 'products') {
      prodDrawerOpen = false;
    } else if(from == 'saleorders') {
      sordDrawerOpen = false;
    } else if(from == 'buyorders') {
      bordDrawerOpen = false;
    } else if(from == 'customers') {
      custDrawerOpen = false;
    } else if(from == 'merchants') {
      merchDrawerOpen = false;
    } else if(from == 'settings') {
      settDrawerOpen = false;
    } else if(from == 'search') {
      searDrawerOpen = false;
    }else if(from == 'home') {
      homeDrawerOpen = false;
    }
    setState(() {
      drawerDrag = true;
    });
  }

  openDrawerFrom(String from) {
    print('FROM open' + from);
    if(from == 'products') {
      prodDrawerOpen = true;
    } else if(from == 'saleorders') {
      sordDrawerOpen = true;
    } else if(from == 'buyorders') {
      bordDrawerOpen = true;
    } else if(from == 'customers') {
      custDrawerOpen = true;
    } else if(from == 'merchants') {
      merchDrawerOpen = true;
    } else if(from == 'settings') {
      settDrawerOpen = true;
    } else if(from == 'search') {
      searDrawerOpen = true;
    } else if(from == 'home') {
      homeDrawerOpen = true;
    }

    setState(() {
      drawerDrag = false;
    });
  }

  openCart() {
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        closeGoToCart = false;
      });
    });
    setState(() {
      _goToCartHeight = 142;
    });
  }

  void toggleGoToCart() {
    if(!closeGoToCart) {
      setState(() {
        closeGoToCart = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _goToCartHeight = 61;
        });
      });

    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          closeGoToCart = false;
        });
      });
      setState(() {
        _goToCartHeight = 142;
      });

    }
  }


  printFromOrders(File file) {
    showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              Future<void> _onScanPressed() async {
                mystate(() => _isLoading = true);
                _bluePrintPos.scan().then((List<BlueDevice> devices) {
                  if (devices.isNotEmpty) {
                    mystate(() {
                      _blueDevices = devices;
                      _isLoading = false;
                    });
                  } else {
                    mystate(() => _isLoading = false);
                  }
                });
              }

              void _onDisconnectDevice() {
                _bluePrintPos.disconnect().then((ConnectionStatus status) {
                  if (status == ConnectionStatus.disconnect) {
                    mystate(() {
                      _selectedDevice = null;
                    });
                  }
                });
              }

              void _onSelectDevice(int index) {
                mystate(() {
                  _isLoading = true;
                  _loadingAtIndex = index;
                });
                print('status ' + 'gg'.toString());
                final BlueDevice blueDevice = _blueDevices[index];
                _bluePrintPos.connect(blueDevice).then((ConnectionStatus status) {
                  print('status ' + status.toString());
                  if (status == ConnectionStatus.connected) {
                    mystate(() => _selectedDevice = blueDevice);
                  } else if (status == ConnectionStatus.timeout) {
                    _onDisconnectDevice();
                  } else {
                    print('$runtimeType - something wrong');
                  }
                  mystate(() => _isLoading = false);
                });
              }

              Future<void> _onPrintReceipt() async {
                // final ReceiptSectionText receiptText = ReceiptSectionText();
                if(file != null) {
                  final doc = await PdfDocument.openFile(file!.path);
                  final pages = doc.pageCount;
                  List<imglib.Image> images = [];

// get images from all the pages
                  for (int i = 1; i <= pages; i++) {
                    var page = await doc.getPage(i);
                    var imgPDF = await page.render(width: page.width.round()*5, height: page.height.round()*5);
                    var img = await imgPDF.createImageDetached();
                    var imgBytes = await img.toByteData(format: ImageByteFormat.png);
                    var libImage = imglib.decodeImage(imgBytes!.buffer
                        .asUint8List(imgBytes.offsetInBytes, imgBytes.lengthInBytes));
                    images.add(libImage!);
                  }
                  int totalHeight = 0;
                  images.forEach((e) {
                    totalHeight += e.height;
                  });
                  int totalWidth = 0;
                  images.forEach((element) {
                    totalWidth = totalWidth < element.width ? element.width : totalWidth;
                  });
                  mergedImage = imglib.Image(totalWidth, totalHeight);
                  int mergedHeight = 0;
                  images.forEach((element) {
                    imglib.copyInto(mergedImage, element, dstX: 0, dstY: mergedHeight, blend: false);
                    mergedHeight += element.height;
                  });
                  await _bluePrintPos.printReceiptImage(imglib.encodeJpg(mergedImage),width: 570, useRaster: true);
                }
              }


              Future.delayed(const Duration(milliseconds: 1000), () {
                _onScanPressed();
              });
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: IgnorePointer(
                  ignoring: disableTouch,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 60.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18.0),
                                topRight: Radius.circular(18.0),
                              ),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 67,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  width: 1.0))),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.0,
                                            right: 15.0,
                                            top: 5.0,
                                            bottom: 0.0
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(customerId.split('^')[1] == 'name'? 'No customer':customerId.split('^')[1], style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            )),
                                            SizedBox(height: 2.5),
                                            Text('Printing service', style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 19
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: _isLoading && _blueDevices.isEmpty
                                          ? Center(
                                        child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                            child: CupertinoActivityIndicator(radius: 15,)),
                                      )
                                          : _blueDevices.isNotEmpty
                                          ? SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(height: 5),
                                              // GestureDetector(
                                              //     onTap: _isLoading ? null : _onScanPressed,
                                              //     child: Text('click to scan', style: TextStyle(fontSize: 25),)
                                              // ),
                                              Column(
                                                children: List<Widget>.generate(_blueDevices.length,
                                                        (int index) {
                                                      return Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: GestureDetector(
                                                              onTap: _blueDevices[index].address ==
                                                                  (_selectedDevice?.address ?? '')
                                                                  ? _onDisconnectDevice
                                                                  : () => _onSelectDevice(index),
                                                              child: Container(
                                                                color: Colors.white,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                    children: <Widget>[
                                                                      Text(
                                                                        _blueDevices[index].name,
                                                                        style: TextStyle(
                                                                            color:
                                                                            _selectedDevice?.address ==
                                                                                _blueDevices[index]
                                                                                    .address
                                                                                ? AppTheme.themeColor
                                                                                : Colors.black,
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: 19
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        _blueDevices[index].address,
                                                                        style: TextStyle(
                                                                            color:
                                                                            _selectedDevice?.address ==
                                                                                _blueDevices[index]
                                                                                    .address
                                                                                ? Colors.blueGrey
                                                                                : Colors.grey,
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.w500
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          if (_loadingAtIndex == index && _isLoading)
                                                            Container(
                                                              height: 24.0,
                                                              width: 65.0,
                                                              margin: const EdgeInsets.only(right: 8.0),
                                                              child: Center(
                                                                child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                                                      child: CupertinoActivityIndicator(radius: 10,),
                                                                    )
                                                                ),
                                                              ),
                                                            ),
                                                          if (!_isLoading &&
                                                              _blueDevices[index].address ==
                                                                  (_selectedDevice?.address ?? ''))
                                                            TextButton(
                                                              onPressed: _onPrintReceipt,
                                                              // child: Container(
                                                              //   color: _selectedDevice == null
                                                              //       ? AppTheme.buttonColor2
                                                              //       : AppTheme.themeColor,
                                                              //   padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10, left: 10),
                                                              //   child: Icon(
                                                              //     Icons.print_rounded,
                                                              //     size: 25,
                                                              //     color: Colors.black,
                                                              //   )
                                                              //   // child: const Text(
                                                              //   //     'Print',
                                                              //   //     style: TextStyle(color: Colors.white)
                                                              //   // ),
                                                              // ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top: 3.0, bottom: 3.0, left: 20.0, right: 20.0),
                                                                child: Icon(
                                                                  Icons.print_rounded,
                                                                  size: 25,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty
                                                                      .resolveWith<Color>(
                                                                        (Set<MaterialState> states) {
                                                                      if (states.contains(
                                                                          MaterialState.pressed)) {
                                                                        return AppTheme.themeColor.withOpacity(0.5);
                                                                      }
                                                                      return AppTheme.themeColor;
                                                                    },
                                                                  ),
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                      RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(10.0),
                                                                      )
                                                                  )
                                                              ),
                                                            ),
                                                          SizedBox(width: 8.5)
                                                        ],
                                                      );
                                                    }),
                                              ),
                                              SizedBox(height: 5),
                                            ],
                                          ),
                                        ),
                                      )
                                          : Center(
                                        child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                            child: CupertinoActivityIndicator(radius: 15,)),
                                      ),
                                      // child: _devices.isEmpty
                                      //     ? Center(child: Text(_devicesMsg ?? ''))
                                      //     : ListView.builder(
                                      //   itemCount: _devices.length,
                                      //   itemBuilder: (c, i) {
                                      //     return ListTile(
                                      //       leading: Icon(Icons.print),
                                      //       title: Text(_devices[i].name.toString()),
                                      //       subtitle: Text(_devices[i].address.toString()),
                                      //       onTap: () {
                                      //         // _startPrint(_devices[i]);
                                      //       },
                                      //     );
                                      //   },
                                      // )
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                top: BorderSide(
                                                    color:
                                                    AppTheme.skBorderColor2,
                                                    width: 1.0),
                                              )),
                                          width: double.infinity,
                                          height: 81,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              // ListTile(
                                              //   title: Text(
                                              //     'Total price',
                                              //     style: TextStyle(
                                              //         fontSize: 17,
                                              //         fontWeight:
                                              //         FontWeight
                                              //             .w500),
                                              //   ),
                                              //   trailing: Text('MMK '+
                                              //       debt.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                              //     style: TextStyle(
                                              //         fontSize: 17,
                                              //         fontWeight:
                                              //         FontWeight
                                              //             .w500),
                                              //   ),
                                              // ),
                                              SizedBox(height: 10),
                                              Padding(
                                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                                                  child: Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            _onScanPressed();
                                                          },
                                                          child: Container(
                                                            width: (MediaQuery.of(context).size.width - 45)/2,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(10.0),
                                                                color: AppTheme.secButtonColor),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Expanded(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                    child: Container(
                                                                        child: Text(
                                                                          'Scan',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Colors.black
                                                                          ),
                                                                        )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Container(
                                                            width: (MediaQuery.of(context).size.width - 45)/2,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                BorderRadius.circular(10.0),
                                                                color: AppTheme.themeColor),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Expanded(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                    child: Container(
                                                                        child: Text(
                                                                          'Close',
                                                                          textAlign: TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 17,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Colors.black
                                                                          ),
                                                                        )
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ]
                                                  )
                                              )
                                            ],
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
                        Positioned(
                          top: 42,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25.0),
                                    ),
                                    color: Colors.white.withOpacity(0.5)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}

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