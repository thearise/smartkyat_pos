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
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fraction/fraction.dart';
import 'package:intl/intl.dart';
import 'package:metooltip/metooltip.dart';
import 'package:ntp/ntp.dart';
import 'package:one_context/one_context.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/api/pdf_api.dart';
import 'package:smartkyat_pos/api/pdf_invoice_api.dart';
import 'package:smartkyat_pos/fragments/buy_list_fragment.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/buylist_fragment2.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/fragments/customers_fragment.dart';
import 'package:smartkyat_pos/fragments/home_fragment6.dart';
import 'package:smartkyat_pos/fragments/merchant_cart2.dart';
import 'package:smartkyat_pos/fragments/merchants_fragment.dart';
import 'package:smartkyat_pos/fragments/orders_fragment2.dart';
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

  const HomePage(
      {Key? key, required this.deviceId,});
  final String deviceId;

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

  bool printClosed = true;

  bool homePageLoading = false;

  String finalTotal = '';

  homePageLoadingOn() {
    setState(() {
      homePageLoading = true;
    });
  }

  homePageLoadingOff() {
    setState(() {
      homePageLoading = false;
    });
  }
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

  String _getRegexString() =>
      r'[0-9]+[,.]{0,1}[0-9]*';

  String _getNum() =>
      r'[0-9]';

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

  String currencyUnit = 'MMK';

  String textSetGotoCart = 'Go to cart';
  String totalVPrice = 'Total price';
  String VPaid = 'Paid';
  String VDebt = 'Total debt';
  String subVTotal = 'Sub Total';
  String VDiscount = 'Discount';

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }



  getLangId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang') == null) {
      return 'english';
    }
    return prefs.getString('lang');
  }

  @override
  initState() {

    // showOkCancelAlertDialog(
    //   context: context,
    //   title: 'Are you sure you want to switch?',
    //   message: 'This action will restart the application',
    //   defaultType: OkCancelAlertDefaultType.cancel,
    // ).then((result) async {
    //   if(result == OkCancelResult.ok) {
    //
    //   }
    // }
    // );
    print('dev check ' + widget.deviceId.toString());
    getLangId().then((value) {
      if(value=='burmese') {
        setState(() {
          textSetGotoCart = 'ရောင်းရန်စာရင်းသို့';
          totalVPrice = 'Total price';
          VPaid = 'Paid';
          VDebt = 'Total debt';
          subVTotal = 'Sub Total';
          VDiscount = 'Discount';
        });
      }
      else if(value=='english') {
        setState(() {
          textSetGotoCart = 'Go to cart';
          totalVPrice = 'စုစုပေါင်း';
          VPaid = 'ပေးငွေ';
          VDebt = 'ကျန်ငွေ';
          subVTotal = 'ကျသင့်ငွေပေါင်း';
          VDiscount = 'လျှော့ငွေ';
        });
      }
    });

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
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      // showOkAlertDialog(
      //     context: context,
      //     title: 'Restart required',
      //     message: 'New shop created and please restart the application to enter your shop.'
      // ).then((result) async {
      //
      // });
      // premiumCart();
      // Navigator.of(context).push(
      //     FadeRoute(page: FirstLaunchPage(),)
      // );
    });
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    if(Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        // systemNavigationBarColor: Colors.white,
        // statusBarColor: Colors.white,
        // statusBarBrightness: Brightness.light

        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        // systemNavigationBarColor: Colors.transparent,
        // systemNavigationBarIconBrightness: Brightness.dark,
        // systemNavigationBarContrastEnforced: false,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Colors.black
    // ));
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
      if(value0 == '' || value0 == null) {
        Navigator.of(context).push(
            FadeRoute(page: chooseStore(),)
        );
      }
      setState(() {
        shopId = value0;
      });
      userSnapshot2 = FirebaseFirestore.instance.collection('users').where('email', isEqualTo: auth.currentUser!.email.toString()).snapshots();
      userSnapshot = FirebaseFirestore.instance.collection('users').where('email', isEqualTo: auth.currentUser!.email.toString()).snapshots();
      emailSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('users').where('email', isEqualTo: auth.currentUser!.email.toString()).limit(1).snapshots();
      shopSnapshot =  FirebaseFirestore.instance.collection('shops').doc(shopId).snapshots();
      shopFoundSnapshot = FirebaseFirestore.instance.collection('shops').where('users', arrayContains: FirebaseAuth.instance.currentUser == null? '': FirebaseAuth.instance.currentUser!.email.toString()).snapshots();

      // lowStockSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('products').orderBy('inStock1', descending: false).snapshots();
      //productSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('products').snapshots();
      // productSnapshot2 = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('products').snapshots();

      // orderSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('orders').orderBy('date', descending: true).limit(60).snapshots();
      // buyOrderSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('buyOrders').orderBy('date', descending: true).snapshots();
      // // buyOrderSnapshot2 = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('buyOrders').orderBy('date', descending: true).snapshots();
      // customerSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('customers').snapshots();
      // merchantSnapshot = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('merchants').snapshots();
      // merchantSnapshot2 = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('merchants').snapshots();
      // customerSnapshot2 = FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('customers').snapshots();
      // homeOrderSnapshot =   FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('orders').orderBy('date', descending: true).snapshots();
      // homeBuyOrderSnapshot =  FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('buyOrder').where('date', isLessThanOrEqualTo: lossDayStartByDate(DateTime.now())).where('date', isGreaterThanOrEqualTo: lossDayEndByDate(DateTime.now())).orderBy('date', descending: true).snapshots();
      // homeLossSnapshot =  FirebaseFirestore.instance.collection('shops').doc(shopId.toString()).collection('loss').where('date', isLessThanOrEqualTo: lossDayStartByDate(DateTime.now())).where('date', isGreaterThanOrEqualTo: lossDayEndByDate(DateTime.now())).orderBy('date', descending: true).snapshots();
      WidgetsFlutterBinding.ensureInitialized();
      setState(() {
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
              toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart, barcodeBtn: openBarcodeSearch, shopId: shopId.toString(),  closeCartBtn: closeCartFrom, openCartBtn: openCartFrom,openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,),
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
            page: SettingsFragment(homePageLoadingOn: homePageLoadingOn, homePageLoadingOff: homePageLoadingOff, key: settGlobalKey, premiumCart: premiumCart, changeShopCallback: chgShopIdFromSetting, usersSnapshot: userSnapshot2, openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,),
          ),
          TabItem(
            tabName: "Settings",
            icon: Icon(
              Icons.add,
            ),
            // page: BuyListFragment(),
            page: BuyListFragment2( selectedDev: _selectedDevice, printFromOrders: printFromOrders,
              key: bordGlobalKey, searchBtn: openSearchFromFrag,
              toggleCoinCallback2: addProduct,
              toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart, barcodeBtn: openBarcodeSearch, shopId: shopId.toString(),closeCartBtn: closeCartFrom, openCartBtn: openCartFrom, openDrawerBtn: openDrawerFrom, closeDrawerBtn: closeDrawerFrom,),
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

  remProdListInd(int i) {
    setState(() {
      prodList2.removeAt(i);
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
                                      Text('Untitled',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                          strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          )
                                      ),
                                      SizedBox(height: 2.5),
                                      Text('New merchant creation',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 19
                                          ),
                                          strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.6
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 67.0,
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
                                              width: 1.0)
                                      )),
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
                                        Text('Untitled',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                          strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          )
                                        ),
                                        SizedBox(height: 2.5),
                                        Text('New customer creation',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 19
                                          ),
                                          strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.6
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 67.0, left: 0.0, right: 0.0),
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
                                        Text('Untitled',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                          strutStyle: StrutStyle(
                                              forceStrutHeight: true,
                                              height: 1.2
                                          )
                                        ),
                                        SizedBox(height: 2.5),
                                        Text('New product creation',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 19
                                          ),
                                          strutStyle: StrutStyle(
                                            forceStrutHeight: true,
                                            height: 1.6
                                          )
                                        ),
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            child: IgnorePointer(
              ignoring: disableTouch,
              child: StreamBuilder(
                  stream: emailSnapshot,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotUser) {
                    if(snapshotUser.hasData) {
                      Map<String, dynamic> dataUser = snapshotUser.data!.docs[0].data()! as Map<String, dynamic>;
                      print('waiting? ' + dataUser['device0']);
                      // _getId().then((value) async {
                      if(dataUser['device0'] != widget.deviceId) {
                        print('matuu');
                        FirebaseAuth.instance.signOut();
                        setStoreId('').then((_) {
                          showOkAlertDialog(
                              context: OneContext().context!,
                              title: 'Restricted activity',
                              message: 'Your account was signed in to this same shop from another device.'
                          ).then((result) async {
                            // Navigator.of(context).pushReplacement(
                            //   FadeRoute(page: Welcome()),
                            // );
                          });
                        });

                        // SchedulerBinding.instance!.addPostFrameCallback((_) async {
                        //   // FirebaseAuth.instance.signOut();
                        //   // await setStoreId('');
                        //   // Navigator.of(context).pushReplacement(
                        //   //   FadeRoute(page: Welcome()),
                        //   // );
                        //   // setState(() {
                        //   //
                        //   // });
                        // });

                      }
                      // });

                      // print('deviceidnum ' + await );
                      // if(dataUser['device0'] != )
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
                                                                      'Orders',
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
                                                                            ),
                                                                              strutStyle: StrutStyle(
                                                                                  forceStrutHeight: true,
                                                                                  height: 1.6
                                                                              ),
                                                                            ),
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
                                                              final result =
                                                              Platform.isIOS ?
                                                              await showModalActionSheet<String>(
                                                                context: context,
                                                                //title: 'Confirmation alert',
                                                                title: 'Are you sure you want to log out?',
                                                                actions: [
                                                                  SheetAction(
                                                                    label: 'Logout',
                                                                    key: 'logout',
                                                                    isDestructiveAction: true,
                                                                  ),
                                                                ],
                                                              ) : await showModalActionSheet<String>(
                                                                context: context,
                                                                // title: 'Confirmation alert',
                                                                title: 'Are you sure you want to log out?',
                                                                actions: [
                                                                  SheetAction(
                                                                    label: 'Logout',
                                                                    key: 'logout',
                                                                    isDestructiveAction: true,
                                                                  ),
                                                                ],
                                                              );
                                                              print('clicked log ' + result.toString());
                                                              if(result.toString() == 'logout') {
                                                                _selectTab(0);
                                                                await FirebaseAuth.instance.signOut();
                                                                setStoreId('');
                                                                Navigator.of(context).pushReplacement(
                                                                  FadeRoute(page: Welcome()),
                                                                );
                                                              }
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
                                //                                   totalItems() + ' item - ' + TtlProdListPrice() + ' $currencyUnit',
                                //                                   textAlign: TextAlign.center,
                                //                                   style: TextStyle(
                                //                                       fontSize: 18,
                                //                                       fontWeight: FontWeight.w500,
                                //                                       color: Colors.black),
                                //                                 ),
                                //                               ) : Container(
                                //                                 child:
                                //                                 Text(
                                //                                   totalItems() + ' items - ' + TtlProdListPrice() + ' $currencyUnit',
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
                                                                                                                  SizedBox(width: 1),
                                                                                                                  Container(
                                                                                                                    height: 58,
                                                                                                                    width: 58,
                                                                                                                    decoration: BoxDecoration(
                                                                                                                        borderRadius:
                                                                                                                        BorderRadius.circular(
                                                                                                                            5.0),
                                                                                                                        color: AppTheme.buttonColor2
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
                                                                                                      child: GestureDetector(
                                                                                                        onTap: () {
                                                                                                          setState(() {
                                                                                                            customerId = 'name^name';
                                                                                                          });
                                                                                                        },
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
                                                                                                      ),
                                                                                                    ): Container(),
                                                                                                  ],
                                                                                                ),
                                                                                                for (int i = 0; i < prodList.length; i++)
                                                                                                  prodInCartTab(prodList[i], i),
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
                                                                                                            trailing: Text('- $currencyUnit ' + (double.parse(TtlProdListPriceInit()) - double.parse(TtlProdListPrice())).toStringAsFixed(1).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

                                                                                                          ) :  ListTile (
                                                                                                            title: Text('Discount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                                                                            subtitle: Text('Amount applied', style: TextStyle(
                                                                                                                fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey
                                                                                                            )),
                                                                                                            trailing: Text('- $currencyUnit ' + discount.toStringAsFixed(1).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
                                                                                                  3),
                                                                                              child: Container(
                                                                                                  child: Text(
                                                                                                    'Clear cart',
                                                                                                    textAlign:
                                                                                                    TextAlign
                                                                                                        .center,
                                                                                                    style: TextStyle(
                                                                                                        height: 1.3,
                                                                                                        fontSize:
                                                                                                        17,
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
                                                                                          if(discount > 0) {
                                                                                            final resultNew =
                                                                                            Platform.isIOS ?
                                                                                            await showModalActionSheet<String>(
                                                                                              context: context,
                                                                                              //title: 'Confirmation alert',
                                                                                              title: 'Are you sure you want to change discount?',
                                                                                              actions: [
                                                                                                SheetAction(
                                                                                                  label: 'New discount',
                                                                                                  key: 'newdis',
                                                                                                  isDestructiveAction: true,
                                                                                                ),
                                                                                              ],
                                                                                            ) : await showModalActionSheet<String>(
                                                                                              context: context,
                                                                                              // title: 'Confirmation alert',
                                                                                              title: 'Are you sure you want to change discount?',
                                                                                              actions: [
                                                                                                SheetAction(
                                                                                                  label: 'New discount',
                                                                                                  key: 'newdis',
                                                                                                  isDestructiveAction: true,
                                                                                                ),
                                                                                              ],
                                                                                            );
                                                                                            if(resultNew.toString() == 'newdis') {
                                                                                              setState(() {
                                                                                                discountAmount = 0.0;
                                                                                                discount = 0.0;
                                                                                              });

                                                                                              final result = await showModalActionSheet<String>(
                                                                                                context: context,
                                                                                                title: 'Choose discount type',
                                                                                                actions: [
                                                                                                  SheetAction(
                                                                                                    icon: Icons.warning,
                                                                                                    label: 'Amount',
                                                                                                    key: 'amount',
                                                                                                  ),
                                                                                                  SheetAction(
                                                                                                    icon: Icons.warning,
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
                                                                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                                                      // inputFormatters: <TextInputFormatter>[
                                                                                                      //   FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                                                                      hintText: '0',
                                                                                                      suffixText: '$currencyUnit  ',
                                                                                                      validator: (value) {
                                                                                                        if (value == null || value.isEmpty) {
                                                                                                          // return '';
                                                                                                          return 'this field is required ';
                                                                                                        } else {
                                                                                                          if(double.parse(TtlProdListPriceReal()) <= 0) {
                                                                                                            return 'no item in cart';
                                                                                                          } else if(double.parse(value) > double.parse(TtlProdListPriceReal())) {
                                                                                                            return 'much less than total sale';
                                                                                                          } else if(double.parse(value) < 0) {
                                                                                                            return 'invalid amount';
                                                                                                          }
                                                                                                        }
                                                                                                        return null;
                                                                                                      },
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

                                                                                              } else if(result == 'percent') {
                                                                                                final percentage = await showTextInputDialog(
                                                                                                  context: context,
                                                                                                  textFields: [
                                                                                                    DialogTextField(
                                                                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                                                      // inputFormatters: <TextInputFormatter>[
                                                                                                      //   FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                                                                      hintText: '0',
                                                                                                      suffixText: '%  ',
                                                                                                      validator: (value) {
                                                                                                        if (value == null || value.isEmpty) {
                                                                                                          // return '';
                                                                                                          return 'this field is required ';
                                                                                                        } else {
                                                                                                          if(double.parse(TtlProdListPriceReal()) <= 0) {
                                                                                                            return 'no item in cart';
                                                                                                          }
                                                                                                          if(double.parse(value) > 100 || double.parse(value) < 0) {
                                                                                                            return 'invalid amount';
                                                                                                          }
                                                                                                        }
                                                                                                        return null;
                                                                                                      },
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
                                                                                            }
                                                                                          } else {
                                                                                            final result = await showModalActionSheet<String>(
                                                                                              context: context,
                                                                                              title: 'Choose discount type',
                                                                                              actions: [
                                                                                                SheetAction(
                                                                                                  icon: Icons.warning,
                                                                                                  label: 'Amount',
                                                                                                  key: 'amount',
                                                                                                ),
                                                                                                SheetAction(
                                                                                                  icon: Icons.warning,
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
                                                                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                                                    // inputFormatters: <TextInputFormatter>[
                                                                                                    //   FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                                                                    hintText: '0',
                                                                                                    suffixText: '$currencyUnit  ',
                                                                                                    validator: (value) {
                                                                                                      if (value == null || value.isEmpty) {
                                                                                                        // return '';
                                                                                                        return 'this field is required ';
                                                                                                      } else {
                                                                                                        if(double.parse(TtlProdListPriceReal()) <= 0) {
                                                                                                          return 'no item in cart';
                                                                                                        } else if(double.parse(value) > double.parse(TtlProdListPriceReal())) {
                                                                                                          return 'much less than total sale';
                                                                                                        } else if(double.parse(value) < 0) {
                                                                                                          return 'invalid amount';
                                                                                                        }
                                                                                                      }
                                                                                                      return null;
                                                                                                    },
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

                                                                                            } else if(result == 'percent') {
                                                                                              final percentage = await showTextInputDialog(
                                                                                                context: context,
                                                                                                textFields: [
                                                                                                  DialogTextField(
                                                                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                                                    // inputFormatters: <TextInputFormatter>[
                                                                                                    //   FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                                                                    hintText: '0',
                                                                                                    suffixText: '%  ',
                                                                                                    validator: (value) {
                                                                                                      if (value == null || value.isEmpty) {
                                                                                                        // return '';
                                                                                                        return 'this field is required ';
                                                                                                      } else {
                                                                                                        if(double.parse(TtlProdListPriceReal()) <= 0) {
                                                                                                          return 'no item in cart';
                                                                                                        }
                                                                                                        if(double.parse(value) > 100 || double.parse(value) < 0) {
                                                                                                          return 'invalid amount';
                                                                                                        }
                                                                                                      }
                                                                                                      return null;
                                                                                                    },
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
                                                                                          }


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
                                                                                                  3),
                                                                                              child: Container(
                                                                                                  child: Text(
                                                                                                    'Discount',
                                                                                                    textAlign:
                                                                                                    TextAlign
                                                                                                        .center,
                                                                                                    style: TextStyle(
                                                                                                        height: 1.3,
                                                                                                        fontSize:
                                                                                                        17,
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
                                                                                        trailing: Text('$currencyUnit '+
                                                                                            TtlProdListPrice().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                                                          style: TextStyle(
                                                                                              fontSize: 17,
                                                                                              fontWeight:
                                                                                              FontWeight
                                                                                                  .w500),
                                                                                        ),
                                                                                      ),
                                                                                      prodList.length != 0 ? Container(
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
                                                                                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3),
                                                                                                      child: Container(
                                                                                                          child: Text(
                                                                                                            'Checkout',
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                                height: 1.3,
                                                                                                                fontSize: 17.5,
                                                                                                                fontWeight: FontWeight.w600,
                                                                                                                color: Colors.black
                                                                                                            ),
                                                                                                            strutStyle: StrutStyle(
                                                                                                              height: 1.3,
                                                                                                              // fontSize:,
                                                                                                              forceStrutHeight: true,
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
                                                                                      ) :
                                                                                      Container(
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                                                                                          child: GestureDetector(
                                                                                            onTap: () {
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
                                                                                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3),
                                                                                                      child: Container(
                                                                                                          child: Text(
                                                                                                            'Checkout',
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                                height: 1.3,
                                                                                                                fontSize: 17.5,
                                                                                                                fontWeight: FontWeight.w600,
                                                                                                                color: Colors.black
                                                                                                            ),
                                                                                                            strutStyle: StrutStyle(
                                                                                                              height: 1.3,
                                                                                                              // fontSize:,
                                                                                                              forceStrutHeight: true,
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
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 67.0),
                                                                                  child: Container(
                                                                                    // color: Colors.yellow,
                                                                                      child: ListView(
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                                                                            child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  Container(
                                                                                                      decoration: BoxDecoration(
                                                                                                          borderRadius: BorderRadius.all(
                                                                                                            Radius.circular(10.0),
                                                                                                          ),
                                                                                                          border: Border.all(
                                                                                                            // color: Colors.black,
                                                                                                              color: Colors.grey.withOpacity(0.2),
                                                                                                              width: 1.0),
                                                                                                          color: AppTheme.lightBgColor),
                                                                                                      height:  133,
                                                                                                      width: MediaQuery.of(context).size.width,
                                                                                                      child: Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [
                                                                                                          Text('Total sale - $currencyUnit',
                                                                                                              textAlign: TextAlign.center,
                                                                                                              style: TextStyle(
                                                                                                                fontSize: 20,
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                color: Colors.grey,
                                                                                                              )),
                                                                                                          SizedBox(height: 8),
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
                                                                                                      suffixText: '$currencyUnit' ,
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
                                                                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                                                    inputFormatters: <TextInputFormatter>[
                                                                                                      FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
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
                                                                                                        child: Text( '$currencyUnit ' +
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
                                                                                        top: 2,
                                                                                        bottom: 0.0
                                                                                    ),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(customerId.split('^')[1] == 'name'? 'No customer':customerId.split('^')[1], style: TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.black,
                                                                                          fontSize: 13,
                                                                                          height: 1.5,
                                                                                        )),
                                                                                        Text('Cash acceptance', style: TextStyle(
                                                                                            fontWeight: FontWeight.w600,
                                                                                            fontSize: 18,
                                                                                            height: 1.3
                                                                                        )),
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
                                                                                        debt!= 0 ? ListTile(
                                                                                          title: Text(
                                                                                            'Debt amount',
                                                                                            style: TextStyle(
                                                                                                fontSize: 17,
                                                                                                fontWeight:
                                                                                                FontWeight
                                                                                                    .w500),
                                                                                          ),
                                                                                          trailing: Text('- $currencyUnit '+
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
                                                                                          trailing: Text('$currencyUnit '+
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
                                                                                                      WriteBatch batch = FirebaseFirestore.instance.batch();
                                                                                                      discountAmount = discount;
                                                                                                      subList = [];
                                                                                                      DateTime now = DateTime.now();
                                                                                                      //CollectionReference daily_order = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders');
                                                                                                      int length = 0;
                                                                                                      int totalOrders = 0;
                                                                                                      int debts = 0;
                                                                                                      var dateExist = false;
                                                                                                      var dateId = '';
                                                                                                      var monthId = '';
                                                                                                      bool monthExist = false;
                                                                                                      var yearId = '';
                                                                                                      bool yearExist = false;
                                                                                                      bool reFilter = false;
                                                                                                      bool deFilter = false;
                                                                                                      double debtAmounts = 0 ;
                                                                                                      print('order creating');

                                                                                                      FirebaseFirestore.instance.collection('shops').doc(shopId)
                                                                                                          .get().then((value) async {
                                                                                                        length = int.parse(value.data()!['orders_length'].toString());
                                                                                                        print('lengthsss' + length.toString());

                                                                                                        length = length + 1;

                                                                                                        batch = await updateOrderLength(batch);

                                                                                                        print('datacheck' + prodList.toString());
                                                                                                        for (int k=0; k< prodList.length;  k++) {
                                                                                                          //CollectionReference productsFire = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products');

                                                                                                          subList.add(prodList[k].split('^')[0] + '-' + 'veriD' + '-' + 'buy0' + '-' + prodList[k].split('^')[4] +'-' + prodList[k].split('^')[2] + '-' + prodList[k].split('^')[3] +'-' + prodList[k].split('^')[4] + '-0-' + 'date');

                                                                                                          // productsFire.doc(prodList[k].split('^')[0])
                                                                                                          //     .get().then((val22) async {
                                                                                                          //
                                                                                                          // });

                                                                                                          List<String> subLink = [];
                                                                                                          List<String> subName = [];
                                                                                                          List<double> subStock = [];

                                                                                                          var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(prodList[k].split('^')[0])
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

                                                                                                            print(subStock.toString());

                                                                                                            if(prodList[k].split('^')[3] == 'unit_name') {
                                                                                                              batch = await decStockFromInv(batch, prodList[k].split('^')[0], 'main', prodList[k].split('^')[4]);
                                                                                                              //decStockFromInv(str.split('^')[0], 'main', str.split('^')[4]);
                                                                                                              //batch = await updateB2(batch, prodList[k].split('^')[0], double.parse(prodList[k].split('^')[4].toString()));
                                                                                                              // if ( k == prodList.length-1) {
                                                                                                              //   batch.commit();
                                                                                                              // }
                                                                                                              //print('batch complete');
                                                                                                              // prodSaleData(str.split('^')[0], double.parse(str.split('^')[4].toString()));
                                                                                                            }
                                                                                                            else if(prodList[k].split('^')[3] == 'sub1_name') {
                                                                                                              batch = await sub1Execution(batch, subStock, subLink, prodList[k].split('^')[0], prodList[k].split('^')[4], docSnapshot10);
                                                                                                              // productsFire.doc(prodList[k].split('^')[0]).update({
                                                                                                              //   'sub1SellUnit' : FieldValue.increment(double.parse(prodList[k].split('^')[4].toString())),
                                                                                                              //});
                                                                                                            }
                                                                                                            else if(prodList[k].split('^')[3] == 'sub2_name') {
                                                                                                              batch = await sub2Execution(batch, subStock, subLink, prodList[k].split('^')[0], prodList[k].split('^')[4], docSnapshot10);
                                                                                                              // productsFire.doc(str.split('^')[0]).update({
                                                                                                              //   'sub2SellUnit' : FieldValue.increment(double.parse(str.split('^')[4].toString())),
                                                                                                              // });
                                                                                                            }
                                                                                                          }

                                                                                                        }
                                                                                                        if( debt.toString() != '0.0') {
                                                                                                          debts = 1;
                                                                                                          debtAmounts = debt;
                                                                                                          deFilter = true;
                                                                                                        } else {
                                                                                                          debts = 0;
                                                                                                          debtAmounts = 0;
                                                                                                          deFilter = false;
                                                                                                        }

                                                                                                        print('subList ' + subList.toString());

                                                                                                        totalOrders = totalOrders + 1;

                                                                                                        batch = await updateCusOrder(batch, totalOrders, debts, debtAmounts);

                                                                                                        print('why total1 ' + customerId.split('^')[0]+ '<>' + customerId.split('^')[1]);
                                                                                                        String whyTotal = TtlProdListPrice().toString();
                                                                                                        double whyDiscount = discountAmount;
                                                                                                        String whyDisText = disText.toString();
                                                                                                        double whyDebt = debt;
                                                                                                        String whyCustomer = customerId.split('^')[0]+ '<>' + customerId.split('^')[1];
                                                                                                        String detailCus = customerId.split('^')[0];
                                                                                                        finalTotal = TtlProdListPrice().toString();

                                                                                                        CollectionReference monthlyData = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_monthly');

                                                                                                        monthlyData.where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + '01' + ' 00:00:00'))
                                                                                                            .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + '31' + ' 23:59:59'))
                                                                                                            .get()
                                                                                                            .then((QuerySnapshot querySnapshot)  async {
                                                                                                          querySnapshot.docs.forEach((doc) {
                                                                                                            monthExist = true;
                                                                                                            monthId = doc.id;
                                                                                                          });
                                                                                                          print('month ' + monthExist.toString());
                                                                                                          if (monthExist) {
                                                                                                            batch = await updateMonthlyData(batch, monthId,  now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'cash_cust', now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'debt_cust', whyTotal, debtAmounts);
                                                                                                          }
                                                                                                          else {
                                                                                                            monthlyData.add({
                                                                                                              for(int j = 1; j<= 31; j++)
                                                                                                                now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'cash_cust' : 0,
                                                                                                              for(int j = 1; j<= 31; j++)
                                                                                                                now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'cash_merc' : 0,
                                                                                                              for(int j = 1; j<= 31; j++)
                                                                                                                now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'debt_cust' : 0,
                                                                                                              for(int j = 1; j<= 31; j++)
                                                                                                                now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'debt_merc' : 0,
                                                                                                              for(int j = 1; j<= 31; j++)
                                                                                                                now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'loss_cust' : 0,
                                                                                                              for(int j = 1; j<= 31; j++)
                                                                                                                now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'refu_cust' : 0,
                                                                                                              for(int j = 1; j<= 31; j++)
                                                                                                                now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'refu_merc' : 0,

                                                                                                              'date': now,

                                                                                                            }).then((value) async {
                                                                                                              batch = await updateMonthlyData(batch, value.id,  now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'cash_cust', now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'debt_cust', whyTotal, debtAmounts);

                                                                                                            }).catchError((error) => print("Failed to update user: $error"));
                                                                                                          }

                                                                                                          CollectionReference yearlyData = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_yearly');

                                                                                                          yearlyData.where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + '01' + '-' + '01' + ' 00:00:00'))
                                                                                                              .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + '12' + '-' + '31' + ' 23:59:59'))
                                                                                                              .get()
                                                                                                              .then((QuerySnapshot querySnapshot)  async {
                                                                                                            querySnapshot.docs.forEach((doc) {
                                                                                                              yearExist = true;
                                                                                                              yearId = doc.id;
                                                                                                            });
                                                                                                            print('year ' + yearExist.toString());
                                                                                                            if (yearExist) {
                                                                                                              batch = await updateYearlyData(batch, yearId,  now.year.toString() +  zeroToTen(now.month.toString())  + 'cash_cust', now.year.toString() +  zeroToTen(now.month.toString())  + 'debt_cust', whyTotal, debtAmounts);

                                                                                                            }
                                                                                                            else {
                                                                                                              yearlyData.add({
                                                                                                                for(int j = 1; j<= 12; j++)
                                                                                                                  now.year.toString()  + zeroToTen(j.toString()) + 'cash_cust' : 0,
                                                                                                                for(int j = 1; j<= 12; j++)
                                                                                                                  now.year.toString()  + zeroToTen(j.toString()) + 'cash_merc' : 0,
                                                                                                                for(int j = 1; j<= 12; j++)
                                                                                                                  now.year.toString() + zeroToTen(j.toString()) + 'debt_cust' : 0,
                                                                                                                for(int j = 1; j<= 12; j++)
                                                                                                                  now.year.toString() + zeroToTen(j.toString()) + 'debt_merc' : 0,
                                                                                                                for(int j = 1; j<= 12; j++)
                                                                                                                  now.year.toString() + zeroToTen(j.toString()) + 'loss_cust' : 0,
                                                                                                                for(int j = 1; j<= 12; j++)
                                                                                                                  now.year.toString() + zeroToTen(j.toString()) + 'refu_cust' : 0,
                                                                                                                for(int j = 1; j<= 12; j++)
                                                                                                                  now.year.toString() + zeroToTen(j.toString()) + 'refu_merc' : 0,

                                                                                                                'date': now,

                                                                                                              }).then((value5) async {
                                                                                                                batch = await updateYearlyData(batch, value5.id,  now.year.toString() +  zeroToTen(now.month.toString())  + 'cash_cust', now.year.toString() +  zeroToTen(now.month.toString())  + 'debt_cust', whyTotal, debtAmounts);
                                                                                                              }).catchError((error) => print("Failed to update user: $error"));
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
                                                                                                                print('why total12 ' + customerId.split('^')[0]+ '<>' + customerId.split('^')[1]);

                                                                                                                batch = await updateDateExist(batch,dateId, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + whyTotal + '^' + whyCustomer + '^F' + '^' + whyDebt.toString() + '^' + whyDiscount.toString() + whyDisText.toString(), length.toString());
                                                                                                                batch = await updateDetail(batch,now, length.toString(), subList, dateId, reFilter, deFilter, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()), whyDiscount.toString() + whyDisText.toString(), whyDebt, whyTotal, detailCus);

                                                                                                              }
                                                                                                              else {
                                                                                                                batch = await updateDetail(batch, now, length.toString(),subList, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) +  deviceIdNum.toString(), reFilter, deFilter, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()), whyDiscount.toString() + whyDisText.toString(), whyDebt, whyTotal, detailCus);
                                                                                                                DatenotExist(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice() + '^' + whyCustomer + '^F' + '^' + whyDebt.toString() + '^' + whyDiscount.toString() + whyDisText.toString(), now, length.toString());

                                                                                                              }


                                                                                                              batch.commit();
                                                                                                            });
                                                                                                          });
                                                                                                        });


                                                                                                        List<String> subNameList = [];
                                                                                                        int subNameListLength = 0;
                                                                                                        for (String str in prodList) {
                                                                                                          subNameListLength = subNameListLength + 1;
                                                                                                          //CollectionReference productsFire = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products');
                                                                                                          print('DATA CHECK PROD ' + str.toString());
                                                                                                          subNameList.add(str.split('^')[7]);
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
                                                                                                                    description: prodList[i].split('^')[6],
                                                                                                                    // date: prodList[i].split('^')[3] + '^' + subNameList[i].toString(),
                                                                                                                    date: subNameList[i].toString(),
                                                                                                                    quantity: double.parse(prodList[i].split('^')[4]),
                                                                                                                    vat: discountAmount,
                                                                                                                    type: disText,
                                                                                                                    debt: debt,
                                                                                                                    unitPrice: double.parse(prodList[i].split('^')[2]),
                                                                                                                    currencyUnit: currencyUnit,
                                                                                                                    totalPriceText: totalVPrice,
                                                                                                                    paidText: VPaid,
                                                                                                                    totalDebtText: VDebt,
                                                                                                                    subTotalText: subVTotal,
                                                                                                                    discountText: VDiscount,
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
                                                                                                                        fontSize: 17.5,
                                                                                                                        fontWeight: FontWeight.w600,
                                                                                                                        color: Colors.black
                                                                                                                    ),
                                                                                                                    strutStyle: StrutStyle(
                                                                                                                      height: 1.3,
                                                                                                                      // fontSize:,
                                                                                                                      forceStrutHeight: true,
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
                                                                            color: Colors.white,
                                                                            borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(20.0),
                                                                              topRight: Radius.circular(20.0),
                                                                            ),
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
                                                                                        top: 2),
                                                                                    child:
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [

                                                                                            Text('$currencyUnit '+ titlePrice.toString(), style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              color: Colors.black,
                                                                                              fontSize: 13,
                                                                                              height: 1.5,
                                                                                            )),
                                                                                            // SizedBox(width: 5),
                                                                                            if (unit == 'unit_name') Padding(
                                                                                              padding: const EdgeInsets.only(left: 5.0, top: 4.7),
                                                                                              child: Icon( SmartKyat_POS.prodm, size: 13, color: Colors.grey,),
                                                                                            )
                                                                                            else if(unit == 'sub1_name') Padding(
                                                                                              padding: const EdgeInsets.only(left: 5.0, top: 4.7),
                                                                                              child: Icon(SmartKyat_POS.prods1, size: 13, color: Colors.grey,),
                                                                                            )
                                                                                            else if(unit == 'sub2_name') Padding(
                                                                                                padding: const EdgeInsets.only(left: 5.0, top: 4.7),
                                                                                                child: Icon(SmartKyat_POS.prods2, size: 13, color: Colors.grey,),
                                                                                              )
                                                                                            // else Icon( Icons.check, size: 17, color: Colors.grey,),
                                                                                          ],
                                                                                        ),
                                                                                        Text(
                                                                                          productName,
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontSize: 18,
                                                                                              height: 1.3
                                                                                          ),
                                                                                          strutStyle: StrutStyle(
                                                                                            height: 1.7,
                                                                                            forceStrutHeight: true,
                                                                                          )
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                eachProd.length !=0 ?
                                                                                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                                                                    stream: FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(productId).snapshots(),
                                                                                    builder: (context, snapshot) {
                                                                                      if(snapshot.hasData) {
                                                                                        var output2 = snapshot.data!.data();
                                                                                        return Padding(
                                                                                          padding: const EdgeInsets.only(
                                                                                            top: 67.0,
                                                                                            left: 15.0,
                                                                                            right: 15.0,
                                                                                            bottom: 138,
                                                                                          ),
                                                                                          child: Container(
                                                                                              child: ListView(
                                                                                                padding: EdgeInsets.zero,
                                                                                                children: [
                                                                                                  SizedBox(
                                                                                                    height: 15,
                                                                                                  ),
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
                                                                                                            myControllerTablet.text = quantity.round().toString();
                                                                                                            print('qqq' + quantity.toString());
                                                                                                          });
                                                                                                        },
                                                                                                        child: Container(
                                                                                                          width: (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5)) - 61)/3,
                                                                                                          height: 50,
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
                                                                                                        height: 50,
                                                                                                        child: TextField(
                                                                                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                                                          inputFormatters: <TextInputFormatter>[
                                                                                                            FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                                                                          textAlign: TextAlign.center,
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
                                                                                                                top: 20,
                                                                                                                bottom: 20.0),
                                                                                                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                                                            //filled: true,
                                                                                                            border: OutlineInputBorder(
                                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                                            ),
                                                                                                          ),
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
                                                                                                              myControllerTablet.text = quantity.round().toString();
                                                                                                              print('qqq' + quantity.toString());
                                                                                                            });
                                                                                                          });
                                                                                                        },
                                                                                                        child: Container(
                                                                                                          width: (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * (2 / 3.5)) - 61)/3,
                                                                                                          height: 50,
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
                                                                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                                                    inputFormatters: <TextInputFormatter>[
                                                                                                      FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
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
                                                                                                      suffixText: '$currencyUnit',
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
                                                                                                                eachProd.split('^')[3]== 'unit_name' ? Text('$currencyUnit ' +  output2?['unit_sell'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                                                                                TextStyle(
                                                                                                                  fontSize: 15,
                                                                                                                  fontWeight: FontWeight.w500,
                                                                                                                  color: Colors.grey,
                                                                                                                ),) :
                                                                                                                eachProd.split('^')[3]== 'sub1_name' ? Text('$currencyUnit ' +  output2?['sub1_sell'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                                                                                TextStyle(
                                                                                                                  fontSize: 15,
                                                                                                                  fontWeight: FontWeight.w500,
                                                                                                                  color: Colors.grey,
                                                                                                                ),) :  Text('$currencyUnit ' +  output2?['sub2_sell'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
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
                                                                                                                eachProd.split('^')[3]== 'unit_name' ? Text(output2!['inStock1'].round().toString() + ' ' + productLink, style:
                                                                                                                TextStyle(
                                                                                                                  fontSize: 15,
                                                                                                                  fontWeight: FontWeight.w500,
                                                                                                                  color: Colors.grey,
                                                                                                                ),) : eachProd.split('^')[3]== 'sub1_name'? Text(output2!['inStock2'].round().toString() + ' ' + productLink, style:
                                                                                                                TextStyle(
                                                                                                                  fontSize: 15,
                                                                                                                  fontWeight: FontWeight.w500,
                                                                                                                  color: Colors.grey,
                                                                                                                ),) : Text(output2!['inStock3'].round().toString().toString() + ' ' + productLink, style:
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
                                                                                                                eachProd.split('^')[3]== 'unit_name' ? Text(output2['Loss1'].round().toString() + ' ' + productLink, style:
                                                                                                                TextStyle(
                                                                                                                  fontSize: 15,
                                                                                                                  fontWeight: FontWeight.w500,
                                                                                                                  color: Colors.grey,
                                                                                                                ),) : eachProd.split('^')[3]== 'sub1_name'? Text(output2['Loss2'].round().toString() + ' ' + productLink, style:
                                                                                                                TextStyle(
                                                                                                                  fontSize: 15,
                                                                                                                  fontWeight: FontWeight.w500,
                                                                                                                  color: Colors.grey,
                                                                                                                ),) : Text(output2['Loss3'].round().toString() + ' ' + productLink, style:
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
                                                                                                                Text(output2['bar_code'], style:
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
                                                                                                  SizedBox(height: 20,),
                                                                                                  //     }
                                                                                                  //     return Container();
                                                                                                  //   },
                                                                                                  // ),
                                                                                                ],
                                                                                              )),
                                                                                        );
                                                                                      }
                                                                                      return Padding(
                                                                                        padding: EdgeInsets.only(bottom: homeBotPadding),
                                                                                        child: Container(
                                                                                          child: Center(
                                                                                            child: Padding(
                                                                                              padding: EdgeInsets.only(bottom: 15.0),
                                                                                              child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                                                                  child: CupertinoActivityIndicator(radius: 15,)),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                ):
                                                                                Center(
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(bottom: 15.0),
                                                                                    child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                                                        child: CupertinoActivityIndicator(radius: 15,)),
                                                                                  ),
                                                                                ),
                                                                                Align(
                                                                                  alignment: Alignment.bottomCenter,
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.only(bottom: 0),
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
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
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 16),
                                                                                            child: Row(
                                                                                                children: [
                                                                                                  Text(
                                                                                                    'Total',
                                                                                                    style: TextStyle(
                                                                                                        fontSize: 17,
                                                                                                        fontWeight:
                                                                                                        FontWeight
                                                                                                            .w500),
                                                                                                  ),
                                                                                                  Expanded(
                                                                                                      child: Text('$currencyUnit '+
                                                                                                          (totalFixAmount).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                                                                        textAlign: TextAlign.right,
                                                                                                        style: TextStyle(
                                                                                                            fontSize: 17,
                                                                                                            fontWeight:
                                                                                                            FontWeight
                                                                                                                .w500),
                                                                                                      )
                                                                                                  )
                                                                                                ]
                                                                                            ),
                                                                                          ),

                                                                                          SizedBox(height: 10),
                                                                                          Padding(
                                                                                              padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 0.0),
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
                                                                                                                          fontSize: 17.5,
                                                                                                                          fontWeight: FontWeight.w600,
                                                                                                                          color: Colors.black
                                                                                                                      ),
                                                                                                                      strutStyle: StrutStyle(
                                                                                                                        height: 1.3,
                                                                                                                        // fontSize:,
                                                                                                                        forceStrutHeight: true,
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
                                                                                                      onTap: () {
                                                                                                        if (_formKey2.currentState!.validate()) {
                                                                                                          print('eachProduct' +eachProd);
                                                                                                          for (int j = 0; j < prodList.length; j++)
                                                                                                            if( prodList[j].split('^')[0] == eachProd.split('^')[0] && prodList[j].split('^')[3] == eachProd.split('^')[3]){
                                                                                                              setState((){
                                                                                                                eachProd = eachProd.split('^')[0] +'^' + eachProd.split('^')[1]+'^'+ (price2.toString()) +'^'+eachProd.split('^')[3]+ '^' + (quantity.toString()) + '^' + eachProd.split('^')[5] + '^' + prodList[j].split('^')[6] + '^' + prodList[j].split('^')[7] + '^' + prodList[j].split('^')[8];
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
                                                                                                                          fontSize: 17.5,
                                                                                                                          fontWeight: FontWeight.w600,
                                                                                                                          color: Colors.black
                                                                                                                      ),
                                                                                                                      strutStyle: StrutStyle(
                                                                                                                        height: 1.3,
                                                                                                                        // fontSize:,
                                                                                                                        forceStrutHeight: true,
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
                                                                                          ),
                                                                                          SizedBox(height: 15),
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
                                                                                                                          fontSize: 17.5,
                                                                                                                          fontWeight: FontWeight.w600,
                                                                                                                          color: Colors.black
                                                                                                                      ),
                                                                                                                      strutStyle: StrutStyle(
                                                                                                                        height: 1.3,
                                                                                                                        // fontSize:,
                                                                                                                        forceStrutHeight: true,
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
                                                                                          trailing: Text('$currencyUnit '+
                                                                                              finalTotal.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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
                                                                                                                        fontSize: 17.5,
                                                                                                                        fontWeight: FontWeight.w600,
                                                                                                                        color: Colors.black
                                                                                                                    ),
                                                                                                                    strutStyle: StrutStyle(
                                                                                                                      height: 1.3,
                                                                                                                      // fontSize:,
                                                                                                                      forceStrutHeight: true,
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
                                                                                          trailing: Text('$currencyUnit '+
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
                                                                                                                        fontSize: 17.5,
                                                                                                                        fontWeight: FontWeight.w600,
                                                                                                                        color: Colors.black
                                                                                                                    ),
                                                                                                                    strutStyle: StrutStyle(
                                                                                                                      height: 1.3,
                                                                                                                      // fontSize:,
                                                                                                                      forceStrutHeight: true,
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
                                            bottom: homeBotPadding + 157,
                                            right: 15,
                                            child: GestureDetector(
                                              onTap: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => MerchantCart(deviceId: deviceIdNum, shop: shopId.toString(), merchantId: merchantId, prodList2: prodList2, toggleCoinCallback: clearProd2, toggleCoinCallback2: clearMerch, toggleCoinCallback4:  endProdLoadingState, toggleCoinCallback3: prodLoadingState, remProdListInd: remProdListInd)),);
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
                                                    //                           totalItems() + ' item - ' + TtlProdListPrice() + ' $currencyUnit',
                                                    //                           textAlign: TextAlign.center,
                                                    //                           style: TextStyle(
                                                    //                               fontSize: 18,
                                                    //                               fontWeight: FontWeight.w500,
                                                    //                               color: Colors.black),
                                                    //                         ),
                                                    //                       ) : Container(
                                                    //                         child:
                                                    //                         Text(
                                                    //                           totalItems() + ' items - ' + TtlProdListPrice() + ' $currencyUnit',
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

                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment.center,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 8.0, right: 8.0, bottom: 2.5
                                                                          ),
                                                                          child: Container(
                                                                            child: Text(
                                                                              customerId == 'name^name' ? textSetGotoCart : customerId.split('^')[1].toString(),
                                                                                                                                                                                 textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                  fontSize: 17.5,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Colors.black),
                                                                              strutStyle: StrutStyle(
                                                                                height: 1.3,
                                                                                // fontSize:,
                                                                                forceStrutHeight: true,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
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
                                                                                totalItems() + ' item - ' + TtlProdListPrice() + ' $currencyUnit',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                    fontSize: 18,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.black),
                                                                              ),
                                                                            ) :
                                                                            Container(
                                                                              child:
                                                                              Text(
                                                                                totalItems() + ' items - ' + TtlProdListPrice() + ' $currencyUnit',
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
                                                                  onTap: () async {
                                                                    print('go to cart 3');
                                                                  },
                                                                  child: Container(),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  // Text(startDate.isBefore(nowCheck) && endDate.isAfter(nowCheck)? 'Pro': 'Free'),
                                                                  //SizedBox(width:15),
                                                                  GestureDetector(
                                                                    onTap: () async {
                                                                      await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('users')
                                                                          .where('email', isEqualTo: auth.currentUser!.email)
                                                                          .get()
                                                                          .then((QuerySnapshot querySnapshot) {
                                                                        print('shit ' + querySnapshot.docs[0]['devices'].toString());
                                                                      });
                                                                    },
                                                                    child: Padding(
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
          ),
          homePageLoading? Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.8),
              child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                  child: CupertinoActivityIndicator(radius: 15,)),
            ),
          ) : Container()
        ],
      ),
    );
  }

  List<String> prodList = [];

  List<String> productSale = [];

  String saleInfo = '';


  late final SlidableController slidableController;
  addProduct(data) async {
    print('added producting ' + data);
    String prod_name = data.split('^')[5];
    String unit_name = data.split('^')[6];
    String prod_img = data.split('^')[7];

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
        setState((){
          prodList[i] = data + '^0^' + prod_name + '^' + unit_name + '^' + prod_img;
        });
        print('prod list check 0 ' + prodList.toString());
        return;
      }
    }
    if (data != 'null') {
      data = data.split('^')[0] + '^' + data.split('^')[1] + '^' + data.split('^')[2] + '^' + data.split('^')[3] + '^' +
          data.split('^')[4] + '^' + '0' + '^' + data.split('^')[5] + '^' + data.split('^')[6] + '^' + data.split('^')[7];
      setState((){prodList.add(data);});
    }

    print('prod list check 1 ' + prodList.toString());
  }

  List<String> prodList2 = [];
  late final SlidableController slidableController1;
  addProduct3(data) {
    if (data != 'null') {
      data =  data.split('^')[0] + '^' + data.split('^')[1] + '^' + data.split('^')[2] + '^' + data.split('^')[3] + '^' +
          data.split('^')[4] + '^' + data.split('^')[5] + '^' +  '0'+ '^'  + data.split('^')[6] + '^' + data.split('^')[7]+ '^' + data.split('^')[8];
      setState(() {
        prodList2.add(data);
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
          barcodeCtrl.text = qty.round().toString();
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
                                                    Text('$currencyUnit ' + result.split('^')[2], style: TextStyle(
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
                                                                  barcodeCtrl.text = qty.round().toString();
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
                                                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                inputFormatters: <TextInputFormatter>[
                                                                  FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
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
                                                                //keyboardType: TextInputType.number,
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
                                                                  barcodeCtrl.text = qty.round().toString();
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
                                                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                        inputFormatters: <TextInputFormatter>[
                                                          FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
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
                                                          suffixText: '$currencyUnit',
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
                                                                    Text('$currencyUnit ' +  sellprice5.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
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
                                                    trailing: Text('$currencyUnit ' + (totalFixAmount2).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
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

  String productId = '';
  String productLink = '';
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
    //   '30.000 $currencyUnit',
    //   leftStyle: ReceiptTextStyleType.normal,
    //   leftSize: ReceiptTextSizeType.small,
    //   rightSize: ReceiptTextSizeType.small,
    //   rightStyle: ReceiptTextStyleType.bold,
    // );

    // await _bluePrintPos.printReceiptText(receiptText, useRaster: true, paperSize: posUtils.PaperSize.mm80);

    getPaperId().then((value) async {
      print('VVAALLUUEE ' + value.toString());
      int width = 570;
      if(value == 'Roll-57') {
        width = 413;
      } else if(value == 'Roll-80') {
        width = 570;
      }
      await _bluePrintPos.printReceiptImage(imglib.encodeJpg(mergedImage),width: width, useRaster: true);
    });
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
    //   '30.000 $currencyUnit',
    //   leftStyle: ReceiptTextStyleType.normal,
    //   leftSize: ReceiptTextSizeType.small,
    //   rightSize: ReceiptTextSizeType.small,
    //   rightStyle: ReceiptTextStyleType.bold,
    // );
    // // receiptText.addSpacer(useDashed: true);
    // // receiptText.addLeftRightText(
    // //   'ပန်းသီး',
    // //   '30.000 $currencyUnit',
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

  prodInCartTab(String prodListInd, int index) {
    prodList[index] = prodList[index].split('^')[0] + '^' + prodList[index].split('^')[5] + '^' +
        prodList[index].split('^')[2] + '^' + prodList[index].split('^')[3] + '^' + prodList[index].split('^')[4] + '^' + prodList[index].split('^')[5] + '^' + prodList[index].split('^')[6] + '^' + prodList[index].split('^')[7] + '^' + prodList[index].split('^')[8];

    print('prodincarttab ' + prodList.toString());
    String image = prodList[index].split('^')[8];
    prodListInd = prodListInd.split('^')[0] + '^' + prodList[index].split('^')[5] + '^' +
        prodListInd.split('^')[2] + '^' + prodListInd.split('^')[3] + '^' + prodListInd.split('^')[4] + '^' + prodListInd.split('^')[5];
    return GestureDetector(
      onTap: (){
        print('error prod' + prodListInd.toString());
        setState((){
          quantity = double.parse(prodListInd.split('^')[4]);
          price2 = double.parse(prodListInd.split('^')[2]);
          eachProd = prodListInd;
          unit = prodListInd.split('^')[3];
          mainName =  'mainName?';
          sub1Name = 'sub1Name?';
          sub2Name = 'sub2Name?';
          salePrice = prodListInd.split('^')[2];
          // mainLoss = double.parse(prodListInCartModData[index].split('^')[5]);
          // sub1Loss = double.parse(prodListInCartModData[index].split('^')[6]);
          // sub2Loss = double.parse(prodListInCartModData[index].split('^')[7]);
          // barcode = output2?['bar_code'];
          // mainQty = output2?['inStock1'].round();
          // sub1Qty = output2?['inStock2'].round();
          // sub2Qty = output2?['inStock3'].round();
          // sell1 =output2?['unit_sell'];
          // sell2 =output2?['sub1_sell'];
          // sell3 =output2?['sub2_sell'];

          productId = prodList[index].split('^')[0];
          productLink = prodList[index].split('^')[7];
          productName = prodList[index].split('^')[6];
          myControllerTablet.text = double.parse(prodListInd.split('^')[4]).round().toString();
          sellPriceControllerTablet.text = prodListInd.split('^')[2];
          // sellDone = false;
          onChangeAmountTab = true;
        });
        _controllerTablet.animateTo(2);
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
                          progressIndicatorBuilder: (context, url, downloadProgress) => Image.asset('assets/system/default-product.png', height: 58, width: 58, fit: BoxFit.cover,),
                          errorWidget: (context, url, error) => Image.asset('assets/system/default-product.png', height: 58, width: 58, fit: BoxFit.cover,),
                          fadeInDuration: Duration(milliseconds: 100),
                          fadeOutDuration: Duration(milliseconds: 10),
                          fadeInCurve: Curves.bounceIn,
                          fit: BoxFit.cover,) : Image.asset('assets/system/default-product.png', height: 58, width: 58, fit: BoxFit.cover,)),
                    title: Tooltip(
                      message: prodList[index].split('^')[6],
                      // preferOri: PreferOrientation.up,
                      // isShow: false,
                      child: Text(
                        prodList[index].split('^')[6],
                        maxLines: 1,
                        style:
                        TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16, height: 1.3, overflow: TextOverflow.ellipsis,),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          Text(prodList[index].split('^')[7] + ' ', style: TextStyle(
                              fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey, height: 0.9
                          )),
                          if (prodList[index].split('^')[3] == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
                          else if(prodList[index].split('^')[3] == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
                          else Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
                        ],
                      ),
                    ),
                    trailing: Text('$currencyUnit ' + (double.parse(
                        prodListInd.split('^')[
                        2]) *
                        double.parse(prodListInd.split('^')[4]))
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
                  child: Text(double.parse(prodListInd.split('^')[4]).round().toString(), style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w500
                  )),
                ),
              ),
            ),
          ],
        ),
        dismissal:
        SlidableDismissal(
          child: SlidableDrawerDismissal(),
          onDismissed: (actionType) {
            setState((){
              prodList.removeAt(index);
              if(discount > double.parse(TtlProdListPriceReal())) {
                discount = 0;
              }
            });
          },
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              setState((){
                prodList.removeAt(index);
                if(discount > double.parse(TtlProdListPriceReal())) {
                  discount = 0;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  saleCart(priContext) {
    int orderLength = 0;
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
    bool priInProgHome = false;
    printClosed = false;
    showModalBottomSheet(
        isDismissible: !disableTouch,
        enableDrag: !disableTouch,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {

              prodInCart(String prodListInd, int index) {
                prodList[index] = prodList[index].split('^')[0] + '^' + prodList[index].split('^')[5] + '^' +
                    prodList[index].split('^')[2] + '^' + prodList[index].split('^')[3] + '^' + prodList[index].split('^')[4] + '^' + prodList[index].split('^')[5] + '^' + prodList[index].split('^')[6] + '^' + prodList[index].split('^')[7] + '^' + prodList[index].split('^')[8];

                print('prodincart ' + prodList.toString());
                String image = prodList[index].split('^')[8];
                prodListInd = prodListInd.split('^')[0] + '^' + prodList[index].split('^')[5] + '^' +
                    prodListInd.split('^')[2] + '^' + prodListInd.split('^')[3] + '^' + prodListInd.split('^')[4] + '^' + prodListInd.split('^')[5];
                return GestureDetector(
                  onTap: (){
                    print('error prod' + prodListInd.toString());
                    setState((){
                      mystate((){
                        quantity = double.parse(prodListInd.split('^')[4]);
                        price2 = double.parse(prodListInd.split('^')[2]);
                        eachProd = prodListInd;
                        unit = prodListInd.split('^')[3];
                        mainName =  'mainName?';
                        sub1Name = 'sub1Name?';
                        sub2Name = 'sub2Name?';
                        salePrice = prodListInd.split('^')[2];
                        // mainLoss = double.parse(prodListInCartModData[index].split('^')[5]);
                        // sub1Loss = double.parse(prodListInCartModData[index].split('^')[6]);
                        // sub2Loss = double.parse(prodListInCartModData[index].split('^')[7]);
                        // barcode = output2?['bar_code'];
                        // mainQty = output2?['inStock1'].round();
                        // sub1Qty = output2?['inStock2'].round();
                        // sub2Qty = output2?['inStock3'].round();
                        // sell1 =output2?['unit_sell'];
                        // sell2 =output2?['sub1_sell'];
                        // sell3 =output2?['sub2_sell'];

                        productId = prodList[index].split('^')[0];
                        productLink = prodList[index].split('^')[7];
                        productName = prodList[index].split('^')[6];
                        myController.text = double.parse(prodListInd.split('^')[4]).round().toString();
                        sellPriceController.text = prodListInd.split('^')[2];
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
                                      progressIndicatorBuilder: (context, url, downloadProgress) => Image.asset('assets/system/default-product.png', height: 58, width: 58, fit: BoxFit.cover,),
                                      errorWidget: (context, url, error) => Image.asset('assets/system/default-product.png', height: 58, width: 58, fit: BoxFit.cover,),
                                      fadeInDuration: Duration(milliseconds: 100),
                                      fadeOutDuration: Duration(milliseconds: 10),
                                      fadeInCurve: Curves.bounceIn,
                                      fit: BoxFit.cover,) : Image.asset('assets/system/default-product.png', height: 58, width: 58, fit: BoxFit.cover,)),
                                title: Tooltip(
                                  message: prodList[index].split('^')[6],
                                  // preferOri: PreferOrientation.up,
                                  // isShow: false,
                                  child: Text(
                                    prodList[index].split('^')[6],
                                    maxLines: 1,
                                    style:
                                    TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 16, height: 1.3, overflow: TextOverflow.ellipsis,),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    children: [
                                      if (prodList[index].split('^')[3] == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
                                      else if(prodList[index].split('^')[3] == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
                                      else Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
                                      Text(' ' + prodList[index].split('^')[7] + ' ', style: TextStyle(
                                          fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey, height: 0.9
                                      )),
                                    ],
                                  ),
                                ),
                                trailing: Text('$currencyUnit ' + (double.parse(
                                    prodListInd.split('^')[
                                    2]) *
                                    double.parse(prodListInd.split('^')[4]))
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
                              child: Text(double.parse(prodListInd.split('^')[4]).round().toString(), style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w500
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    dismissal:
                    SlidableDismissal(
                      child: SlidableDrawerDismissal(),
                      onDismissed: (actionType) {
                        setState((){
                          mystate(() {
                            prodList.removeAt(index);
                            if(discount > double.parse(TtlProdListPriceReal())) {
                              discount = 0;
                            }
                          });
                        });
                      },
                    ),
                    secondaryActions: <
                        Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          setState((){
                            mystate(() {
                              prodList.removeAt(index);
                              if(discount > double.parse(TtlProdListPriceReal())) {
                                discount = 0;
                              }
                            });
                          });
                        },
                      ),
                    ],
                  ),
                );
              }

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

              Future<void> _onScanPressedHome() async {
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

              void _onDisconnectDeviceHome() {
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
                    _onDisconnectDeviceHome();
                  } else {
                    print('$runtimeType - something wrong');
                  }
                  mystate(() => _isLoading = false);
                });
              }

              Future<void> _onPrintReceipt() async {
                mystate(() {
                  priInProgHome = true;
                });

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
                //   '30.000 $currencyUnit',
                //   leftStyle: ReceiptTextStyleType.normal,
                //   leftSize: ReceiptTextSizeType.small,
                //   rightSize: ReceiptTextSizeType.small,
                //   rightStyle: ReceiptTextStyleType.bold,
                // );

                // await _bluePrintPos.printReceiptText(receiptText, useRaster: true, paperSize: posUtils.PaperSize.mm80);

                print('Got Snapshot' + saleInfo.toString());
                getPaperId().then((value) async {
                  print('VVAALLUUEE ' + value.toString());
                  int width = 570;
                  if(value == 'Roll-57') {
                    width = 413;
                  } else if(value == 'Roll-80') {
                    width = 570;
                  }
                  final ReceiptSectionText receiptText = ReceiptSectionText();
                  receiptText.addSpacer(count: 1);
                  receiptText.addText(
                    shopGloName.toString(),
                    size: ReceiptTextSizeType.small,
                    style: ReceiptTextStyleType.bold,
                  );
                  receiptText.addText(
                    shopGloAddress,
                    size: ReceiptTextSizeType.extraextraSmall,
                  );
                  receiptText.addText(
                    shopGloPhone,
                    size: ReceiptTextSizeType.extraextraSmall,
                  );
                  receiptText.addSpacer(useDashed: true);
                  receiptText.addLeftText(
                    'Receipt info: ' + deviceIdNum.toString() + '-' +orderLength.toString(),
                    size: ReceiptTextSizeType.extraextraSmall,
                    style: ReceiptTextStyleType.bold,
                  );
                  receiptText.addLeftText(
                    'Name: ' + saleInfo.split('^')[3].toString(),
                    size: ReceiptTextSizeType.extraextraSmall,
                  );
                  var dateNow = DateTime.now();
                  final date2 = DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateNow.year.toString()  + '-' + zeroToTen(dateNow.month.toString())  + '-' +  zeroToTen(dateNow.day.toString())+ ' 00:00:00');
                  receiptText.addLeftText(
                    'Date: ' + date2.day.toString() + '-' + date2.month.toString() + '-' + date2.year.toString(),
                    size: ReceiptTextSizeType.extraextraSmall,
                  );
                  receiptText.addTableList([['Items', 'Total']], '1rem', '500');
                  //receiptText.addSpacer(count: 1);
                  List<List<String>> tableList = [];

                  double sTotal = 0;
                  for(int i = 0; i <  productSale.length ; i++) {
                    List<String> innerLRList = ['', ''];
                    innerLRList[0] =  productSale[i].split('^')[0].toString() + ' (' +
                        productSale[i].split('^')[1].toString() + ' - ' +  productSale[i].split('^')[2].toString() + ' x ' +
                        productSale[i].split('^')[3].toString() + ')';
                    innerLRList[1] = (double.parse(productSale[i].split('^')[2]) * double.parse( productSale[i].split('^')[3])).toStringAsFixed(1) + ' $currencyUnit' ;
                    tableList.add(innerLRList);
                    sTotal += double.parse( productSale[i].split('^')[2]) * double.parse( productSale[i].split('^')[3]);
                  }
                  double disAmt = 0.0;
                  if(saleInfo.split('^')[1].toString() == '-p') {
                    disAmt = sTotal * (double.parse(saleInfo.split('^')[0])/100);
                  } else {disAmt = double.parse(saleInfo.split('^')[0]);}
                  receiptText.addTableList(tableList, '1rem', 'normal');
                  // //  receiptText.addSpacer(count: 1);
                  receiptText.addSpacer(useDashed: true);
                  receiptText.addTableList([[subVTotal, sTotal.toStringAsFixed(1) + ' $currencyUnit']], '1rem', '500');
                  receiptText.addTableList([[VDiscount, disAmt.toStringAsFixed(1) + ' $currencyUnit']], '1rem', '500');
                  receiptText.addTableList([[totalVPrice, (sTotal - disAmt).toStringAsFixed(1) + ' $currencyUnit']], '1rem', '500');
                  receiptText.addTableList([[VPaid, ((sTotal - disAmt) - double.parse(saleInfo.split('^')[2])).toStringAsFixed(1) + ' $currencyUnit']], '1rem', '500');
                  receiptText.addTableList([[VDebt, double.parse(saleInfo.split('^')[2]).toStringAsFixed(1) + ' $currencyUnit']], '1rem', '500');
                  receiptText.addSpacer(emptyLine: true);
                  receiptText.addText(
                    'ကျေးဇူးတင်ပါသည်။',
                    size: ReceiptTextSizeType.small,
                    style: ReceiptTextStyleType.bold,
                  );
                  final ByteData logoBytes = await rootBundle.load(
                    'assets/system/poweredby.png',
                  );
                  receiptText.addImage(
                    base64.encode(Uint8List.view(logoBytes.buffer)),
                    width: 150,
                  );
                  // receiptText.addLeftRightText(
                  //   subVTotal,
                  //   subTotal.toStringAsFixed(1) + ' $currencyUnit',
                  //   leftStyle: ReceiptTextStyleType.normal,
                  //   leftSize: ReceiptTextSizeType.extraextraSmall,
                  //   rightStyle: ReceiptTextStyleType.normal,
                  //   rightSize: ReceiptTextSizeType.extraextraSmall,
                  // );
                  // receiptText.addSpacer(count: 2);
                  // receiptText.addLeftRightText(
                  //   VDiscount,
                  //   'Cash',
                  //   leftStyle: ReceiptTextStyleType.normal,
                  //   leftSize: ReceiptTextSizeType.extraextraSmall,
                  //   rightStyle: ReceiptTextStyleType.normal,
                  //   rightSize: ReceiptTextSizeType.extraextraSmall,
                  // );
                  // receiptText.addSpacer(count: 2);
                  // receiptText.addLeftRightText(
                  //   totalVPrice,
                  //   'Cash',
                  //   leftStyle: ReceiptTextStyleType.normal,
                  //   leftSize: ReceiptTextSizeType.extraextraSmall,
                  //   rightStyle: ReceiptTextStyleType.normal,
                  //   rightSize: ReceiptTextSizeType.extraextraSmall,
                  // );
                  // receiptText.addSpacer(count: 2);
                  // receiptText.addLeftRightText(
                  //   VPaid,
                  //   'Cash',
                  //   leftStyle: ReceiptTextStyleType.normal,
                  //   leftSize: ReceiptTextSizeType.extraextraSmall,
                  //   rightStyle: ReceiptTextStyleType.normal,
                  //   rightSize: ReceiptTextSizeType.extraextraSmall,
                  // );
                  // receiptText.addSpacer(count: 2);
                  // receiptText.addLeftRightText(
                  //   VDebt,
                  //   'Cash',
                  //   leftStyle: ReceiptTextStyleType.normal,
                  //   leftSize: ReceiptTextSizeType.extraextraSmall,
                  //   rightStyle: ReceiptTextStyleType.normal,
                  //   rightSize: ReceiptTextSizeType.extraextraSmall,
                  // );
                  receiptText.addSpacer(count: 1, useDashed: false, emptyLine: false);
                  await _bluePrintPos.printReceiptText(receiptText, paperSize: posUtils.PaperSize.mm80);
                  // await _bluePrintPos.printReceiptImage(imglib.encodeJpg(mergedImage),width: width, useRaster: true);
                  mystate(() {
                    priInProgHome = false;
                  });
                  productSale = [];
                  saleInfo = '';
                  Navigator.pop(context);
                  printClosed = true;
                  Future.delayed(const Duration(milliseconds: 30000), () {
                    if(printClosed) {
                      print('complete');
                      _onDisconnectDevice();
                    }
                  });
                });



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
                //   '30.000 $currencyUnit',
                //   leftStyle: ReceiptTextStyleType.normal,
                //   leftSize: ReceiptTextSizeType.small,
                //   rightSize: ReceiptTextSizeType.small,
                //   rightStyle: ReceiptTextStyleType.bold,
                // );
                // // receiptText.addSpacer(useDashed: true);
                // // receiptText.addLeftRightText(
                // //   'ပန်းသီး',
                // //   '30.000 $currencyUnit',
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
                                                              3),
                                                          child: Container(
                                                              child: Text(
                                                                'Clear cart',
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                    height: 1.3,
                                                                    fontSize:
                                                                    17,
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
                                                      if(discount > 0) {
                                                        final resultNew =
                                                        Platform.isIOS ?
                                                        await showModalActionSheet<String>(
                                                          context: context,
                                                          //title: 'Confirmation alert',
                                                          title: 'Are you sure you want to change discount?',
                                                          actions: [
                                                            SheetAction(
                                                              label: 'New discount',
                                                              key: 'newdis',
                                                              isDestructiveAction: true,
                                                            ),
                                                          ],
                                                        ) : await showModalActionSheet<String>(
                                                          context: context,
                                                          // title: 'Confirmation alert',
                                                          title: 'Are you sure you want to change discount?',
                                                          actions: [
                                                            SheetAction(
                                                              label: 'New discount',
                                                              key: 'newdis',
                                                              isDestructiveAction: true,
                                                            ),
                                                          ],
                                                        );
                                                        if(resultNew.toString() == 'newdis') {
                                                          setState(() {
                                                            mystate(() {
                                                              discountAmount = 0.0;
                                                              discount = 0.0;
                                                            });
                                                          });

                                                          final result = await showModalActionSheet<String>(
                                                            context: context,
                                                            title: 'Choose discount type',
                                                            actions: [
                                                              SheetAction(
                                                                icon: Icons.error,
                                                                label: 'Amount',
                                                                key: 'amount',
                                                              ),
                                                              SheetAction(
                                                                icon: Icons.warning,
                                                                label: 'Percent',
                                                                key: 'percent',
                                                              ),
                                                            ],
                                                          );

                                                          if(result != null) {
                                                            mystate(() {
                                                              isDiscount = result.toString();
                                                            });

                                                            if (result == 'amount') {
                                                              final amount = await showTextInputDialog(
                                                                context: context,
                                                                textFields: [
                                                                  DialogTextField(
                                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                    // inputFormatters: <TextInputFormatter>[
                                                                    //   FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                                    hintText: '0',
                                                                    suffixText: '$currencyUnit  ',
                                                                    validator: (value) {
                                                                      if (value == null || value.isEmpty) {
                                                                        // return '';
                                                                        return 'this field is required ';
                                                                      } else {
                                                                        if(double.parse(TtlProdListPriceReal()) <= 0) {
                                                                          return 'no item in cart';
                                                                        } else if(double.parse(value) > double.parse(TtlProdListPriceReal())) {
                                                                          return 'much less than total sale';
                                                                        } else if(double.parse(value) < 0) {
                                                                          return 'invalid amount';
                                                                        }
                                                                      }
                                                                      return null;
                                                                    },
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

                                                            } else if(result == 'percent') {
                                                              final percentage = await showTextInputDialog(
                                                                context: context,
                                                                textFields: [
                                                                  DialogTextField(
                                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                    // inputFormatters: <TextInputFormatter>[
                                                                    //   FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                                    hintText: '0',
                                                                    suffixText: '%  ',
                                                                    validator: (value) {
                                                                      if (value == null || value.isEmpty) {
                                                                        // return '';
                                                                        return 'this field is required ';
                                                                      } else {
                                                                        if(double.parse(TtlProdListPriceReal()) <= 0) {
                                                                          return 'no item in cart';
                                                                        }
                                                                        if(double.parse(value) > 100 || double.parse(value) < 0) {
                                                                          return 'invalid amount';
                                                                        }
                                                                      }
                                                                      return null;
                                                                    },
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
                                                          }
                                                        }


                                                      } else {
                                                        final result = await showModalActionSheet<String>(
                                                          context: context,
                                                          title: 'Choose discount type',
                                                          actions: [
                                                            SheetAction(
                                                              icon: Icons.error,
                                                              label: 'Amount',
                                                              key: 'amount',
                                                            ),
                                                            SheetAction(
                                                              icon: Icons.warning,
                                                              label: 'Percent',
                                                              key: 'percent',
                                                            ),
                                                          ],
                                                        );

                                                        if(result != null) {
                                                          mystate(() {
                                                            isDiscount = result.toString();
                                                          });

                                                          if (result == 'amount') {
                                                            final amount = await showTextInputDialog(
                                                              context: context,
                                                              textFields: [
                                                                DialogTextField(
                                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                  // inputFormatters: <TextInputFormatter>[
                                                                  //   FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                                  hintText: '0',
                                                                  suffixText: '$currencyUnit  ',
                                                                  validator: (value) {
                                                                    if (value == null || value.isEmpty) {
                                                                      // return '';
                                                                      return 'this field is required ';
                                                                    } else {
                                                                      if(double.parse(TtlProdListPriceReal()) <= 0) {
                                                                        return 'no item in cart';
                                                                      } else if(double.parse(value) > double.parse(TtlProdListPriceReal())) {
                                                                        return 'much less than total sale';
                                                                      } else if(double.parse(value) < 0) {
                                                                        return 'invalid amount';
                                                                      }
                                                                    }
                                                                    return null;
                                                                  },
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

                                                          } else if(result == 'percent') {
                                                            final percentage = await showTextInputDialog(
                                                              context: context,
                                                              textFields: [
                                                                DialogTextField(
                                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                  // inputFormatters: <TextInputFormatter>[
                                                                  //   FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                                  hintText: '0',
                                                                  suffixText: '%  ',
                                                                  validator: (value) {
                                                                    if (value == null || value.isEmpty) {
                                                                      // return '';
                                                                      return 'this field is required ';
                                                                    } else {
                                                                      if(double.parse(TtlProdListPriceReal()) <= 0) {
                                                                        return 'no item in cart';
                                                                      }
                                                                      if(double.parse(value) > 100 || double.parse(value) < 0) {
                                                                        return 'invalid amount';
                                                                      }
                                                                    }
                                                                    return null;
                                                                  },
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
                                                        }
                                                      }
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
                                                              3),
                                                          child: Container(
                                                              child: Text(
                                                                'Discount',
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                    height: 1.3,
                                                                    fontSize:
                                                                    17,
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
                                                                              SizedBox(width: 1),
                                                                              Container(
                                                                                height: 58,
                                                                                width: 58,
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius:
                                                                                    BorderRadius.circular(
                                                                                        5.0),
                                                                                    color: AppTheme.buttonColor2
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
                                                                  child: GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        mystate(() {
                                                                          customerId = 'name^name';
                                                                        });
                                                                      });
                                                                    },
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
                                                                  ),
                                                                ): Container(),
                                                              ],
                                                            ),
                                                            for (int i = 0; i < prodList.length; i++)
                                                              prodInCart(prodList[i], i),
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
                                                                        trailing: Text('- $currencyUnit ' + (double.parse(TtlProdListPriceInit()) - double.parse(TtlProdListPrice())).toStringAsFixed(1).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                                      ) :  ListTile (
                                                                        title: Text('Discount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                                        subtitle: Text('Amount applied', style: TextStyle(
                                                                            fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey
                                                                        )),
                                                                        trailing: Text('- $currencyUnit ' + discount.toStringAsFixed(1).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
                                                      trailing: Text('$currencyUnit '+
                                                          TtlProdListPrice().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      ),
                                                    ),
                                                    prodList.length != 0 ? Padding(
                                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          print('productList' + prodList.toString());
                                                          setState(() {
                                                            mystate(() {
                                                              totalAmount = double.parse(TtlProdListPrice());

                                                            });
                                                          });
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
                                                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3),
                                                                  child: Container(
                                                                      child: Text(
                                                                        'Checkout',
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                            height: 1.3,
                                                                            fontSize: 17.5,
                                                                            fontWeight: FontWeight.w600,
                                                                            color: Colors.black
                                                                        ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1.3,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
                                                                        ),
                                                                      )
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ) :
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          print('productList' + prodList.toString());
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
                                                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.5),
                                                                  child: Container(
                                                                      child: Text(
                                                                        'Checkout',
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                            height: 1.3,
                                                                            fontSize: 17.5,
                                                                            fontWeight: FontWeight.w600,
                                                                            color: Colors.black
                                                                        ),
                                                                        strutStyle: StrutStyle(
                                                                          height: 1.3,
                                                                          // fontSize:,
                                                                          forceStrutHeight: true,
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
                                                    Text(customerId.split('^')[1] == 'name'? 'No customer': customerId.split('^')[1], style: TextStyle(
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
                                              padding: EdgeInsets.only(
                                                  top: 67.0,
                                                  left: 0.0,
                                                  right: 0.0,
                                                  bottom: homeBotPadding + 129
                                              ),
                                              child: Container(
                                                  child: ListView(
                                                    children: [
                                                      Container(
                                                        child: Padding(
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
                                                                        Text('Total sale - $currencyUnit',
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.grey,
                                                                            )),
                                                                        SizedBox(height: 8),
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
                                                                    suffixText: '$currencyUnit' ,
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
                                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                  inputFormatters: <TextInputFormatter>[
                                                                    FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
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
                                                                      child: Text( '$currencyUnit ' +
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
                                                        trailing: Text('- $currencyUnit '+
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
                                                        trailing: Text('$currencyUnit '+
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
                                                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
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

                                                                    WriteBatch batch = FirebaseFirestore.instance.batch();

                                                                    discountAmount = discount;
                                                                    subList = [];
                                                                    DateTime now = DateTime.now();
                                                                    int length = 0;
                                                                    int totalOrders = 0;
                                                                    int debts = 0;
                                                                    var dateExist = false;
                                                                    var dateId = '';
                                                                    var monthId = '';
                                                                    bool monthExist = false;
                                                                    var yearId = '';
                                                                    bool yearExist = false;
                                                                    bool reFilter = false;
                                                                    bool deFilter = false;
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

                                                                      orderLength = length;

                                                                      print('CHECK POINT 0' + deviceIdNum.toString());
                                                                      print('CHECK POINT 1');

                                                                      batch = await updateOrderLength(batch);

                                                                      print('datacheck' + prodList.toString());
                                                                      for (int k=0; k< prodList.length;  k++) {
                                                                        //CollectionReference productsFire = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products');

                                                                        subList.add(prodList[k].split('^')[0] + '-' + 'veriD' + '-' + 'buy0' + '-' + prodList[k].split('^')[4] +'-' + prodList[k].split('^')[2] + '-' + prodList[k].split('^')[3] +'-' + prodList[k].split('^')[4] + '-0-' + 'date');

                                                                        // productsFire.doc(prodList[k].split('^')[0])
                                                                        //     .get().then((val22) async {
                                                                        //
                                                                        // });

                                                                        List<String> subLink = [];
                                                                        List<String> subName = [];
                                                                        List<double> subStock = [];

                                                                        var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(prodList[k].split('^')[0])
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

                                                                          print(subStock.toString());

                                                                          if(prodList[k].split('^')[3] == 'unit_name') {
                                                                            batch = await decStockFromInv(batch, prodList[k].split('^')[0], 'main', prodList[k].split('^')[4]);
                                                                            //decStockFromInv(str.split('^')[0], 'main', str.split('^')[4]);
                                                                            //batch = await updateB2(batch, prodList[k].split('^')[0], double.parse(prodList[k].split('^')[4].toString()));
                                                                            // if ( k == prodList.length-1) {
                                                                            //   batch.commit();
                                                                            // }
                                                                            //print('batch complete');
                                                                            // prodSaleData(str.split('^')[0], double.parse(str.split('^')[4].toString()));
                                                                          }
                                                                          else if(prodList[k].split('^')[3] == 'sub1_name') {
                                                                            batch = await sub1Execution(batch, subStock, subLink, prodList[k].split('^')[0], prodList[k].split('^')[4], docSnapshot10);
                                                                            // productsFire.doc(prodList[k].split('^')[0]).update({
                                                                            //   'sub1SellUnit' : FieldValue.increment(double.parse(prodList[k].split('^')[4].toString())),
                                                                            //});
                                                                          }
                                                                          else if(prodList[k].split('^')[3] == 'sub2_name') {
                                                                            batch = await sub2Execution(batch, subStock, subLink, prodList[k].split('^')[0], prodList[k].split('^')[4], docSnapshot10);
                                                                            // productsFire.doc(str.split('^')[0]).update({
                                                                            //   'sub2SellUnit' : FieldValue.increment(double.parse(str.split('^')[4].toString())),
                                                                            // });
                                                                          }
                                                                        }

                                                                      }

                                                                      if( debt.toString() != '0.0') {
                                                                        debts = 1;
                                                                        debtAmounts = debt;
                                                                        deFilter = true;
                                                                      } else {
                                                                        debts = 0;
                                                                        debtAmounts = 0;
                                                                        deFilter = false;
                                                                      }

                                                                      print('subList ' + subList.toString());

                                                                      totalOrders = totalOrders + 1;
                                                                      //CusOrder(totalOrders, debts, debtAmounts);

                                                                      batch = await updateCusOrder(batch, totalOrders, debts, debtAmounts);



                                                                      CollectionReference monthlyData = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_monthly');

                                                                      monthlyData.where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + '01' + ' 00:00:00'))
                                                                          .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + '31' + ' 23:59:59'))
                                                                          .get()
                                                                          .then((QuerySnapshot querySnapshot)  async {
                                                                        querySnapshot.docs.forEach((doc) {
                                                                          monthExist = true;
                                                                          monthId = doc.id;
                                                                        });
                                                                        print('month ' + monthExist.toString());
                                                                        if (monthExist) {
                                                                          batch = await updateMonthlyData(batch, monthId,  now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'cash_cust', now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'debt_cust', TtlProdListPrice(), debtAmounts);

                                                                          // monthlyData.doc(monthId).update({
                                                                          //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'cash_cust' : FieldValue.increment(double.parse(TtlProdListPrice())),
                                                                          //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'debt_cust' : FieldValue.increment(debtAmounts)
                                                                          //
                                                                          // }).then((value) => print("data Updated"))
                                                                          //     .catchError((error) => print("Failed to update user: $error"));

                                                                        }
                                                                        else {
                                                                          monthlyData.add({
                                                                            for(int j = 1; j<= 31; j++)
                                                                              now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'cash_cust' : 0,
                                                                            for(int j = 1; j<= 31; j++)
                                                                              now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'cash_merc' : 0,
                                                                            for(int j = 1; j<= 31; j++)
                                                                              now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'debt_cust' : 0,
                                                                            for(int j = 1; j<= 31; j++)
                                                                              now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'debt_merc' : 0,
                                                                            for(int j = 1; j<= 31; j++)
                                                                              now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'loss_cust' : 0,
                                                                            for(int j = 1; j<= 31; j++)
                                                                              now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'refu_cust' : 0,
                                                                            for(int j = 1; j<= 31; j++)
                                                                              now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(j.toString()) + 'refu_merc' : 0,

                                                                            'date': now,

                                                                          }).then((value) async {
                                                                            print('valueid' + value.id.toString());

                                                                            batch = await updateMonthlyData(batch, value.id,  now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'cash_cust', now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'debt_cust', TtlProdListPrice(), debtAmounts);

                                                                            // monthlyData.doc(value.id).update({
                                                                            //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'cash_cust' : FieldValue.increment(double.parse(TtlProdListPrice())),
                                                                            //   now.year.toString() +  zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + 'debt_cust' : FieldValue.increment(debtAmounts)
                                                                            // }).then((value) => print("Data Updated"))
                                                                            //     .catchError((error) => print("Failed to update user: $error"));
                                                                          }).catchError((error) => print("Failed to update user: $error"));
                                                                        }

                                                                        CollectionReference yearlyData = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_yearly');

                                                                        yearlyData.where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + '01' + '-' + '01' + ' 00:00:00'))
                                                                            .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + '12' + '-' + '31' + ' 23:59:59'))
                                                                            .get()
                                                                            .then((QuerySnapshot querySnapshot)  async {
                                                                          querySnapshot.docs.forEach((doc) {
                                                                            yearExist = true;
                                                                            yearId = doc.id;
                                                                          });
                                                                          print('year ' + yearExist.toString());
                                                                          if (yearExist) {
                                                                            batch = await updateYearlyData(batch, yearId,  now.year.toString() +  zeroToTen(now.month.toString())  + 'cash_cust', now.year.toString() +  zeroToTen(now.month.toString())  + 'debt_cust', TtlProdListPrice(), debtAmounts);
                                                                          }
                                                                          else {
                                                                            yearlyData.add({
                                                                              for(int j = 1; j<= 12; j++)
                                                                                now.year.toString()  + zeroToTen(j.toString()) + 'cash_cust' : 0,
                                                                              for(int j = 1; j<= 12; j++)
                                                                                now.year.toString()  + zeroToTen(j.toString()) + 'cash_merc' : 0,
                                                                              for(int j = 1; j<= 12; j++)
                                                                                now.year.toString() + zeroToTen(j.toString()) + 'debt_cust' : 0,
                                                                              for(int j = 1; j<= 12; j++)
                                                                                now.year.toString() + zeroToTen(j.toString()) + 'debt_merc' : 0,
                                                                              for(int j = 1; j<= 12; j++)
                                                                                now.year.toString() + zeroToTen(j.toString()) + 'loss_cust' : 0,
                                                                              for(int j = 1; j<= 12; j++)
                                                                                now.year.toString() + zeroToTen(j.toString()) + 'refu_cust' : 0,
                                                                              for(int j = 1; j<= 12; j++)
                                                                                now.year.toString() + zeroToTen(j.toString()) + 'refu_merc' : 0,

                                                                              'date': now,

                                                                            }).then((value5) async {
                                                                              print('valueid' + value.id.toString());
                                                                              batch = await updateYearlyData(batch, value5.id,  now.year.toString() +  zeroToTen(now.month.toString())  + 'cash_cust', now.year.toString() +  zeroToTen(now.month.toString())  + 'debt_cust', TtlProdListPrice(), debtAmounts);

                                                                              // yearlyData.doc(value.id).update({
                                                                              //   now.year.toString() +  zeroToTen(now.month.toString()) + 'cash_cust' : FieldValue.increment(double.parse(TtlProdListPrice())),
                                                                              //   now.year.toString() +  zeroToTen(now.month.toString())  + 'debt_cust' : FieldValue.increment(debtAmounts)
                                                                              // }).then((value) => print("Data Updated"))
                                                                              //     .catchError((error) => print("Failed to update user: $error"));
                                                                            }).catchError((error) => print("Failed to update user: $error"));
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
                                                                              batch = await updateDateExist(batch,dateId, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice() + '^' + customerId.split('^')[0]+ '<>' + customerId.split('^')[1] + '^F' + '^' + debt.toString() + '^' + discountAmount.toString() + disText, length.toString());
                                                                              batch = await updateDetail(batch,now, length.toString(), subList, dateId, reFilter, deFilter, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()), discountAmount.toString() + disText.toString(), debt, TtlProdListPrice(), customerId.split('^')[0].toString());

                                                                              //addDateExist(dateId, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice() + '^' + customerId.split('^')[0]+ '<>' + customerId.split('^')[1] + '^F' + '^' + debt.toString() + '^' + discountAmount.toString() + disText, length.toString());
                                                                              //Detail(now, length.toString(), subList, dateId, reFilter, deFilter, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()));
                                                                              print('adddateexist added');
                                                                            }
                                                                            else {
                                                                              batch = await updateDetail(batch, now, length.toString(),subList, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) +  deviceIdNum.toString(), reFilter, deFilter, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()), discountAmount.toString() + disText.toString(), debt, TtlProdListPrice(), customerId.split('^')[0].toString());
                                                                              DatenotExist(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice() + '^' + customerId.split('^')[0]+ '<>' + customerId.split('^')[1] + '^F' + '^' + debt.toString() + '^' + discountAmount.toString() + disText, now, length.toString());
                                                                              //Detail(now, length.toString(),subList, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) +  deviceIdNum.toString(), reFilter, deFilter, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()));
                                                                              print('adddateexist not');
                                                                            }
                                                                            print('prodList--' + prodList.toString());
                                                                            batch.commit();
                                                                          });      });
                                                                      });



                                                                      List<String> subNameList = [];
                                                                      int subNameListLength = 0;
                                                                      for (String str in prodList) {
                                                                        subNameListLength = subNameListLength + 1;

                                                                        subNameList.add(str.split('^')[7]);
                                                                        if(prodList.length == subNameListLength) {
                                                                          print('fianlize : ' + subNameList.toString());
                                                                          // final date = DateTime.now();
                                                                          final date = now;
                                                                          final dueDate = date.add(Duration(days: 7));
                                                                          print('CUZMER CHECK ' + customerId.toString());
                                                                          for(int i=0; i<prodList.length; i++) {
                                                                            productSale.add(prodList[i].split('^')[6].toString() + '^' +subNameList[i].toString() + '^' + prodList[i].split('^')[2].toString() + '^' + prodList[i].split('^')[4].toString());
                                                                          }
                                                                          saleInfo = discountAmount.toString()  + '^' + disText.toString()  + '^' + debt.toString() + '^' + customerId.split('^')[1].toString();
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
                                                                                  description: prodList[i].split('^')[6],
                                                                                  // date: prodList[i].split('^')[3] + '^' + subNameList[i].toString(),
                                                                                  date: subNameList[i].toString(),
                                                                                  quantity: double.parse(prodList[i].split('^')[4]),
                                                                                  vat: discountAmount,
                                                                                  debt: debt,
                                                                                  type: disText,
                                                                                  unitPrice: double.parse(prodList[i].split('^')[2]),
                                                                                  currencyUnit: currencyUnit,
                                                                                  totalPriceText: totalVPrice,
                                                                                  paidText: VPaid,
                                                                                  totalDebtText: VDebt,
                                                                                  subTotalText: subVTotal,
                                                                                  discountText: VDiscount,
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
                                                                                        fontSize: 17.5,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: Colors.black
                                                                                    ),
                                                                                    strutStyle: StrutStyle(
                                                                                      height: 1.3,
                                                                                      // fontSize:,
                                                                                      forceStrutHeight: true,
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
                                              height: 67,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
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
                                                        Text('$currencyUnit '+ titlePrice.toString(), style: TextStyle(
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
                                                    SizedBox(height: 2.5),
                                                    Text(productName, style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 19
                                                    ),
                                                        strutStyle: StrutStyle(
                                                          height: 1.7,
                                                          forceStrutHeight: true,
                                                        )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            eachProd.length !=0 ? Stack(
                                              children: [
                                                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                                  stream: FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(productId).snapshots(),
                                                  builder: (BuildContext context, snapshot2) {
                                                    if (snapshot2.hasData) {
                                                      var output2 = snapshot2.data!.data();
                                                      return Padding(
                                                        padding: const EdgeInsets.only(
                                                            top: 67.0,
                                                            left: 15.0,
                                                            right: 15.0),
                                                        child: Container(
                                                            child: ListView(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    SizedBox(height: 15),
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
                                                                            height: 50,
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
                                                                          height: 50,
                                                                          child: TextField(
                                                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                            inputFormatters: <TextInputFormatter>[
                                                                              FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
                                                                            textAlign: TextAlign.center,
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
                                                                                  top: 20,
                                                                                  bottom: 20.0),
                                                                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                                              //filled: true,
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                            ),
                                                                            //keyboardType: TextInputType.number,
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
                                                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                                      inputFormatters: <TextInputFormatter>[
                                                                        FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
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
                                                                        suffixText: '$currencyUnit',
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
                                                                                  eachProd.split('^')[3]== 'unit_name' ? Text('$currencyUnit ' +  output2?['unit_sell'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                                                  TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.grey,
                                                                                  ),) :
                                                                                  eachProd.split('^')[3]== 'sub1_name' ? Text('$currencyUnit ' +  output2?['sub1_sell'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
                                                                                  TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.grey,
                                                                                  ),) :  Text('$currencyUnit ' +  output2?['sub2_sell'].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
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
                                                                                  eachProd.split('^')[3]== 'unit_name' ? Text(output2!['inStock1'].round().toString() + ' ' + productLink, style:
                                                                                  TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.grey,
                                                                                  ),) : eachProd.split('^')[3]== 'sub1_name'? Text(output2!['inStock2'].round().toString() + ' ' + productLink, style:
                                                                                  TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.grey,
                                                                                  ),) : Text(output2!['inStock3'].round().toString().toString() + ' ' + productLink, style:
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
                                                                                  eachProd.split('^')[3]== 'unit_name' ? Text(output2['Loss1'].round().toString() + ' ' + productLink, style:
                                                                                  TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.grey,
                                                                                  ),) : eachProd.split('^')[3]== 'sub1_name'? Text(output2['Loss2'].round().toString() + ' ' + productLink, style:
                                                                                  TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.grey,
                                                                                  ),) : Text(output2['Loss3'].round().toString() + ' ' + productLink, style:
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
                                                                                  Text(output2['bar_code'], style:
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

                                                      );
                                                    }
                                                    return Padding(
                                                      padding: EdgeInsets.only(bottom: homeBotPadding),
                                                      child: Container(
                                                        child: Center(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(bottom: 15.0),
                                                            child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                                child: CupertinoActivityIndicator(radius: 15,)),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
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
                                                      height: 138,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                        children: [
                                                          ListTile(
                                                            title: Text(
                                                              'Total ss',
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                            ),
                                                            trailing: Text('$currencyUnit '+
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
                                                              padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
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
                                                                      onTap: () {
                                                                        if (_formKey.currentState!.validate()) {
                                                                          print('eachProduct' + eachProd);
                                                                          for (int j = 0; j < prodList.length; j++)
                                                                            if( prodList[j].split('^')[0] == eachProd.split('^')[0] && prodList[j].split('^')[3] == eachProd.split('^')[3]){
                                                                              setState((){
                                                                                mystate((){
                                                                                  eachProd = eachProd.split('^')[0] +'^' + eachProd.split('^')[1]+'^'+ (price2.toString()) +'^'+eachProd.split('^')[3]+ '^' + (quantity.toString()) + '^' + eachProd.split('^')[5] + '^' + prodList[j].split('^')[6] + '^' + prodList[j].split('^')[7] + '^' + prodList[j].split('^')[8];
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
                                                                                          fontSize: 17.5,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          color: Colors.black
                                                                                      ),
                                                                                      strutStyle: StrutStyle(
                                                                                        height: 1.3,
                                                                                        // fontSize:,
                                                                                        forceStrutHeight: true,
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
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 15.0),
                                                child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                    child: CupertinoActivityIndicator(radius: 15,)),
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
                                                                                      fontSize: 17.5,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: Colors.black
                                                                                  ),
                                                                                  strutStyle: StrutStyle(
                                                                                    height: 1.3,
                                                                                    // fontSize:,
                                                                                    forceStrutHeight: true,
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
                                                                  _onScanPressedHome();
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
                                                        trailing: Text('$currencyUnit '+
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
                                                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
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
                                                                                      fontSize: 17.5,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: Colors.black
                                                                                  ),
                                                                                  strutStyle: StrutStyle(
                                                                                    height: 1.3,
                                                                                    // fontSize:,
                                                                                    forceStrutHeight: true,
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
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(18.0),
                                                topRight: Radius.circular(18.0),
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: Container(
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 67, bottom: 70),
                                                    child: _isLoading && _blueDevices.isEmpty
                                                        ? Center(
                                                      child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                                          child: CupertinoActivityIndicator(radius: 15,)),
                                                    )
                                                        : _blueDevices.isNotEmpty
                                                        ? Container(
                                                      child: Column(
                                                        children: [
                                                          if(priInProgHome)
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0, bottom: 8.0),
                                                              child: Container(
                                                                  child: Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                          child: Container(
                                                                            width: MediaQuery.of(context).size.width,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10.0),
                                                                              ),
                                                                              color: Color(0xffE8EEF9),
                                                                              border: Border.all(
                                                                                  color: Color(0xffBCCEEA),
                                                                                  width: 1.0
                                                                              ),
                                                                            ),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(top: 10, bottom: 11.3),
                                                                              child: Row(
                                                                                children: [
                                                                                  SizedBox(width: 15),
                                                                                  Icon(
                                                                                    Icons.print_rounded,
                                                                                    size: 25,
                                                                                    color: Color(0xff5786DB),
                                                                                  ),
                                                                                  SizedBox(width: 8),
                                                                                  Expanded(
                                                                                    child: Text('Printing is in progress.', textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
                                                                                        fontWeight: FontWeight.w400, fontSize: 15, height: 1.2)),
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      mystate(() {
                                                                                        priInProgHome = false;
                                                                                      });
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.all(
                                                                                            Radius.circular(15.0),
                                                                                          ),
                                                                                          color: Color(0xffBCCEEA),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(2.0),
                                                                                          child: Icon(
                                                                                            Icons.close_rounded,
                                                                                            size: 15,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 15),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 8),
                                                                      ]
                                                                  )
                                                              ),
                                                            ),
                                                          Expanded(
                                                            child: SingleChildScrollView(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    SizedBox(height: 15),
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
                                                                                        ? _onDisconnectDeviceHome
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
                                                                                              _blueDevices[index].name == ''? 'Unknown': _blueDevices[index].name,
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
                                                                    SizedBox(height: 15),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
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
                                                  Container(
                                                    height: 67,
                                                    width: double.infinity,
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
                                                            //   trailing: Text('$currencyUnit '+
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
                                                                          //printClosed = true;
                                                                          Navigator.of(context).pop();
                                                                          // Future.delayed(const Duration(milliseconds: 10000), () {
                                                                          //   if(printClosed) {
                                                                          //     _bluePrintPos.disconnect().then((ConnectionStatus status) {
                                                                          //       if (status == ConnectionStatus.disconnect) {
                                                                          //         setState(() {
                                                                          //           _selectedDevice = null;
                                                                          //         });
                                                                          //       }
                                                                          //     });
                                                                          //   }
                                                                          // });

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
                                                                                            fontSize: 17.5,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            color: Colors.black
                                                                                        ),
                                                                                        strutStyle: StrutStyle(
                                                                                          height: 1.3,
                                                                                          // fontSize:,
                                                                                          forceStrutHeight: true,
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
                                          ),
                                          // Align(
                                          //   alignment: Alignment.topCenter,
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.only(top: 90.0),
                                          //     child: LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
                                          //   )
                                          // ),
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
      productSale = [];
      saleInfo = '';
      printClosed = true;
      Future.delayed(const Duration(milliseconds: 30000), () {
        if(printClosed) {
          _onDisconnectDevice();
        }
      });
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

  setPrinterCon(bool data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setBool('printer_con', data);
  }

  getPrinterCon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('printer_con') == null || prefs.getBool('printer_con') == true) {
      return true;
    } else {
      return false;
    }

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

  TtlProdListPriceReal()  {
    double total = 0;
    print(prodList.toString());
    for (String str in prodList) {
      total += double.parse(str.split('^')[2]) * double.parse(str.split('^')[4]);
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
                  'Home' ,
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

  updateDetail(WriteBatch batch, date, length, subs, docId, reF, deF, dateTime, whyDiscount, whyDebt, whyTotal, detailCus) {
    DocumentReference documentReference =  FirebaseFirestore.instance.collection('shops').doc(shopId).collection('order').doc(deviceIdNum.toString() + length.toString());
    batch.set(documentReference, {
      'date': date,
      'total': whyTotal,
      'debt' : whyDebt,
      'discount' : whyDiscount.toString(),
      'refund': 'F',
      'subs': subs,
      'customerId' : detailCus,
      'deviceId' : deviceIdNum.toString() + '-',
      'orderId' : length.toString(),
      'documentId' : docId,
      'refund_filter' : reF,
      'debt_filter' : deF,
      'dateTime' : dateTime.toString()
    });
    return batch;
  }

  updateOrderLength(WriteBatch batch){
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId);
    batch.update(documentReference, {'orders_length': FieldValue.increment(1)});
    return batch;
  }

  updateCusOrder(WriteBatch batch, ttlOrders, debts , debtAmount){
    DocumentReference documentReference =FirebaseFirestore.instance.collection('shops').doc(shopId).collection('customers').doc(customerId.split('^')[0]);
    batch.update(documentReference, {
      'total_orders': FieldValue.increment(double.parse(ttlOrders.toString())),
      'debtAmount' : FieldValue.increment(double.parse(debtAmount.toString())),
      'debts': FieldValue.increment(double.parse(debts.toString())),
    });
    return batch;
  }

  updateB2(WriteBatch batch, id, num) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(id);
    batch.update(documentReference, {'mainSellUnit': FieldValue.increment(double.parse(num.toString()))});
    return batch;
  }

  updateMonthlyData(WriteBatch batch, id, field1, field2, price1, price2) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_monthly').doc(id);
    batch.update(documentReference, {
      field1 : FieldValue.increment(double.parse(price1.toString())),
      field2 : FieldValue.increment(double.parse(price2.toString())),

    });
    return batch;
  }

  updateYearlyData(WriteBatch batch, id, field1, field2, price1, price2) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders_yearly').doc(id);
    batch.update(documentReference, {
      field1 : FieldValue.increment(double.parse(price1.toString())),
      field2 : FieldValue.increment(double.parse(price2.toString())),

    });
    return batch;
  }

  decStockFromInv(WriteBatch batch, id, unit, num) {
    print('Double Check Sub1');
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(id);

    batch.update(documentReference, {changeUnitName2Stock(unit): FieldValue.increment(0 - (double.parse(num.toString()))),});

    return batch;
  }

  incStockFromInv(WriteBatch batch, id, unit, num) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(id);

    batch.update(documentReference, {changeUnitName2Stock(unit): FieldValue.increment((double.parse(num.toString()))),});
    return batch;
  }

  sub1Execution(WriteBatch batch, subStock, subLink, id, num, docSnapshot10) {
    //var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(id).get();
    if (docSnapshot10.exists) {
      Map<String, dynamic>? data10 = docSnapshot10.data();
      subStock[1] = double.parse((data10 ? ['inStock2']).toString());
      if(subStock[1] > double.parse(num)) {
        batch = decStockFromInv(batch, id, 'sub1', num);
      } else {
        batch = decStockFromInv(batch, id, 'main', ((double.parse(num)  - subStock[1])/double.parse(subLink[0])).ceil());
        batch = incStockFromInv(batch, id, 'sub1', ((double.parse(num)-subStock[1].round()) % double.parse(subLink[0])) == 0? 0: (double.parse(subLink[0]) - (double.parse(num)-subStock[1].round()) % double.parse(subLink[0])));
        batch = decStockFromInv(batch, id, 'sub1', subStock[1]);
      }
    }
    return batch;
  }

  sub2Execution(WriteBatch batch, subStock, subLink, id, num, docSnapshot10) {
    //var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(id).get();
    if (docSnapshot10.exists) {
      Map<String, dynamic>? data10 = docSnapshot10.data();
      subStock[2] = double.parse((data10 ? ['inStock3']).toString());
      if(subStock[2] > double.parse(num)) {
        batch = decStockFromInv(batch, id, 'sub2', num);
      } else {
        batch =  incStockFromInv(batch, id, 'sub2', ((double.parse(num)-subStock[2].round()) % double.parse(subLink[1])) == 0? 0: (double.parse(subLink[1]) - (double.parse(num)-subStock[2].round()) % double.parse(subLink[1])));
        batch = decStockFromInv(batch, id, 'sub2', subStock[2]);
        batch = sub1Execution(batch, subStock, subLink, id, ((double.parse(num)  - subStock[2])/double.parse(subLink[1])).ceil().toString(), docSnapshot10);
      }
    }
    return batch;
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

  updateDateExist(WriteBatch batch, id1, dOrder , length) {
    DocumentReference documentReference =  FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders').doc(id1);
    batch.update(documentReference, {'daily_order': FieldValue.arrayUnion([dOrder.toString()]),});
    return batch;
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
  double subTotal = 0.0;

  printFromOrders(File file, var prodListPR,) {

    print('PRRRRR ' +   prodListPR.toString());
    subTotal = 0.0;
    printClosed = false;
    bool firstTimeOrderPri = true;
    bool priInProgOrders = false;

    showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              Future<void> _onScanPressedOrder() async {
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


              void _onDisconnectDeviceOrder() {
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
                    _onDisconnectDeviceOrder();
                  } else {
                    print('$runtimeType - something wrong');
                  }
                  mystate(() => _isLoading = false);
                });
              }

              Future<void> _onPrintReceiptOrder() async {
                mystate(() {
                  priInProgOrders = true;
                });
                // Future.delayed(const Duration(milliseconds: 20000), () {
                //   if(printClosed) {
                //     _onDisconnectDeviceOrder();
                //   }
                // });

                // smartKyatFlash('Print command received and working on it.', 'i');
                // final ReceiptSectionText receiptText = ReceiptSectionText();
                if(file != null) {
                  final doc = await PdfDocument.openFile(file.path);
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

                  getPaperId().then((value) async {
                    print('VVAALLUUEE ' + value.toString());
                    int width = 570;
                    if(value == 'Roll-57') {
                      width = 413;
                    } else if(value == 'Roll-80') {
                      width = 570;
                    }

                    // final ReceiptSectionText receiptText = ReceiptSectionText();
                    // for(int i = 0; i< prodListPR.length; i++) {
                    //   receiptText.addLeftRightText(
                    //     prodListPR[i].split('^')[0] + ' (' + prodListPR[i].split('^')[1] + ' - ' + prodListPR[i].split('^')[2] + ' x ' + prodListPR[i].split('^')[3] + ')',
                    //     (double.parse(prodListPR[i].split('^')[2]) * double.parse(prodListPR[i].split('^')[2])).toStringAsFixed(1) + ' $currencyUnit',
                    //     leftStyle: ReceiptTextStyleType.normal,
                    //     leftSize: ReceiptTextSizeType.small,
                    //     rightSize: ReceiptTextSizeType.small,
                    //     rightStyle: ReceiptTextStyleType.bold,
                    //   );
                    // }
                    // // await _bluePrintPos.printReceiptImage(imglib.encodeJpg(mergedImage),width: width, useRaster: true);
                    // await _bluePrintPos.printReceiptText(receiptText, useRaster: true, paperSize: posUtils.PaperSize.mm80);
                    // mystate(() {
                    //   priInProgOrders = false;
                    // });
                    final ReceiptSectionText receiptText = ReceiptSectionText();
                    receiptText.addSpacer(count: 1);
                    receiptText.addText(
                      shopGloName.toString(),
                      size: ReceiptTextSizeType.small,
                      style: ReceiptTextStyleType.bold,
                    );
                    receiptText.addText(
                      shopGloAddress,
                      size: ReceiptTextSizeType.extraextraSmall,
                    );
                    receiptText.addText(
                      shopGloPhone,
                      size: ReceiptTextSizeType.extraextraSmall,
                    );
                    receiptText.addSpacer(useDashed: true);
                    receiptText.addLeftText(
                      'Receipt info: ' + prodListPR[prodListPR.length-1].split('<>')[6].toString(),
                      size: ReceiptTextSizeType.extraextraSmall,
                      style: ReceiptTextStyleType.bold,
                    );
                    receiptText.addLeftText(
                      'Name: ' + prodListPR[prodListPR.length-1].split('<>')[7].toString(),
                      size: ReceiptTextSizeType.extraextraSmall,
                    );
                    receiptText.addLeftText(
                      'Date ' + prodListPR[prodListPR.length-1].split('<>')[8].toString(),
                      size: ReceiptTextSizeType.extraextraSmall,
                    );
                    //receiptText.addSpacer(count: 1);
                    // receiptText.addLeftRightText(
                    //   '   Items', 'Total   ',
                    //   leftStyle: ReceiptTextStyleType.bold,
                    //   leftSize: ReceiptTextSizeType.extraextraSmall,
                    //   rightStyle: ReceiptTextStyleType.bold,
                    //   rightSize: ReceiptTextSizeType.extraextraSmall,
                    // );
                    receiptText.addTableList([['Items', 'Total']], '1rem', '500');
                    //receiptText.addSpacer(count: 1);
                    List<List<String>> tableList = [];
                    for(int i = 0; i <  prodListPR.length -1 ; i++) {
                      List<String> innerLRList = ['', ''];
                      innerLRList[0] =  prodListPR[i].split('^')[0].toString() + ' (' +
                          prodListPR[i].split('^')[1].toString() + ' - ' +  prodListPR[i].split('^')[2].toString() + ' x ' +
                          prodListPR[i].split('^')[3].toString() + ')';
                      innerLRList[1] = (double.parse( prodListPR[i].split('^')[2]) * double.parse( prodListPR[i].split('^')[3])).toStringAsFixed(1) + ' $currencyUnit' ;
                      tableList.add(innerLRList);
                      subTotal += double.parse( prodListPR[i].split('^')[2]) * double.parse( prodListPR[i].split('^')[3]);
                    }
                    double disAmt = 0.0;
                    if(prodListPR[prodListPR.length-1].split('<>')[3].toString() == 'p') {
                      disAmt = subTotal * (double.parse(prodListPR[prodListPR.length-1].split('<>')[4])/100);
                    } else {disAmt = double.parse(prodListPR[prodListPR.length-1].split('<>')[4]);}
                    receiptText.addTableList(tableList, '1rem', 'normal');
                    //  receiptText.addSpacer(count: 1);
                    receiptText.addSpacer(useDashed: true);
                    receiptText.addTableList([[subVTotal, subTotal.toStringAsFixed(1) + ' $currencyUnit']], '1rem', '500');
                    receiptText.addTableList([[VDiscount, disAmt.toStringAsFixed(1) + ' $currencyUnit']], '1rem', '500');
                    receiptText.addTableList([[totalVPrice, (subTotal - disAmt).toStringAsFixed(1) + ' $currencyUnit']], '1rem', '500');
                    receiptText.addTableList([[VPaid, ((subTotal - disAmt) - double.parse(prodListPR[prodListPR.length-1].split('<>')[5])).toStringAsFixed(1) + ' $currencyUnit']], '1rem', '500');
                    receiptText.addTableList([[VDebt, double.parse(prodListPR[prodListPR.length-1].split('<>')[5]).toStringAsFixed(1) + ' $currencyUnit']], '1rem', '500');
                    receiptText.addSpacer(emptyLine: true);
                    receiptText.addText(
                      'ကျေးဇူးတင်ပါသည်။',
                      size: ReceiptTextSizeType.small,
                      style: ReceiptTextStyleType.bold,
                    );
                    final ByteData logoBytes = await rootBundle.load(
                      'assets/system/poweredby.png',
                    );
                    receiptText.addImage(
                      base64.encode(Uint8List.view(logoBytes.buffer)),
                      width: 150,
                    );
                    // receiptText.addLeftRightText(
                    //   subVTotal,
                    //   subTotal.toStringAsFixed(1) + ' $currencyUnit',
                    //   leftStyle: ReceiptTextStyleType.normal,
                    //   leftSize: ReceiptTextSizeType.extraextraSmall,
                    //   rightStyle: ReceiptTextStyleType.normal,
                    //   rightSize: ReceiptTextSizeType.extraextraSmall,
                    // );
                    // receiptText.addSpacer(count: 2);
                    // receiptText.addLeftRightText(
                    //   VDiscount,
                    //   'Cash',
                    //   leftStyle: ReceiptTextStyleType.normal,
                    //   leftSize: ReceiptTextSizeType.extraextraSmall,
                    //   rightStyle: ReceiptTextStyleType.normal,
                    //   rightSize: ReceiptTextSizeType.extraextraSmall,
                    // );
                    // receiptText.addSpacer(count: 2);
                    // receiptText.addLeftRightText(
                    //   totalVPrice,
                    //   'Cash',
                    //   leftStyle: ReceiptTextStyleType.normal,
                    //   leftSize: ReceiptTextSizeType.extraextraSmall,
                    //   rightStyle: ReceiptTextStyleType.normal,
                    //   rightSize: ReceiptTextSizeType.extraextraSmall,
                    // );
                    // receiptText.addSpacer(count: 2);
                    // receiptText.addLeftRightText(
                    //   VPaid,
                    //   'Cash',
                    //   leftStyle: ReceiptTextStyleType.normal,
                    //   leftSize: ReceiptTextSizeType.extraextraSmall,
                    //   rightStyle: ReceiptTextStyleType.normal,
                    //   rightSize: ReceiptTextSizeType.extraextraSmall,
                    // );
                    // receiptText.addSpacer(count: 2);
                    // receiptText.addLeftRightText(
                    //   VDebt,
                    //   'Cash',
                    //   leftStyle: ReceiptTextStyleType.normal,
                    //   leftSize: ReceiptTextSizeType.extraextraSmall,
                    //   rightStyle: ReceiptTextStyleType.normal,
                    //   rightSize: ReceiptTextSizeType.extraextraSmall,
                    // );
                    receiptText.addSpacer(count: 1, useDashed: false, emptyLine: false);
                    await _bluePrintPos.printReceiptText(receiptText, paperSize: posUtils.PaperSize.mm80);
                    mystate(() {
                      priInProgOrders = false;
                    });
                    prodListPR = [];
                    subTotal = 0.0;
                    Navigator.pop(context);
                    printClosed = true;
                    Future.delayed(const Duration(milliseconds: 30000), () {
                      if(printClosed) {
                        print('complete');
                        _onDisconnectDevice();
                      }
                    });
                    // /// Example for print QR
                    // await _bluePrintPos.printQR('www.google.com', size: 250);
                    //
                    // /// Text after QR
                    // final ReceiptSectionText receiptSecondText = ReceiptSectionText();
                    // receiptSecondText.addText('Powered by ayeee',
                    //     size: ReceiptTextSizeType.small);
                    // receiptSecondText.addSpacer();
                    // await _bluePrintPos.printReceiptText(receiptSecondText, feedCount: 1);
                    // await _bluePrintPos.printReceiptImage(imglib.encodeJpg(mergedImage),width: width, useRaster: true);

                  });
                }
              }


              Future.delayed(const Duration(milliseconds: 1000), () {
                if(firstTimeOrderPri) {
                  _onScanPressedOrder();
                  firstTimeOrderPri = false;
                }
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
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 67, bottom: 70),
                                      child: _isLoading && _blueDevices.isEmpty
                                          ? Center(
                                        child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
                                            child: CupertinoActivityIndicator(radius: 15,)),
                                      )
                                          : _blueDevices.isNotEmpty
                                          ? Container(
                                        child: Column(
                                          children: [
                                            if(priInProgOrders)
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0, bottom: 8.0),
                                                child: Container(
                                                    child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                            child: Container(
                                                              width: MediaQuery.of(context).size.width,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(
                                                                  Radius.circular(10.0),
                                                                ),
                                                                color: Color(0xffE8EEF9),
                                                                border: Border.all(
                                                                    color: Color(0xffBCCEEA),
                                                                    width: 1.0
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top: 10, bottom: 11.3),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: 15),
                                                                    Icon(
                                                                      Icons.print_rounded,
                                                                      size: 25,
                                                                      color: Color(0xff5786DB),
                                                                    ),
                                                                    SizedBox(width: 8),
                                                                    Expanded(
                                                                      child: Text('Printing is in progress.', textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
                                                                          fontWeight: FontWeight.w400, fontSize: 15, height: 1.2)),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        mystate(() {
                                                                          priInProgOrders = false;
                                                                        });
                                                                      },
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.all(
                                                                              Radius.circular(15.0),
                                                                            ),
                                                                            color: Color(0xffBCCEEA),
                                                                          ),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(2.0),
                                                                            child: Icon(
                                                                              Icons.close_rounded,
                                                                              size: 15,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 15),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 8),
                                                        ]
                                                    )
                                                ),
                                              ),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      SizedBox(height: 15),
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
                                                                          ? _onDisconnectDeviceOrder
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
                                                                                _blueDevices[index].name == ''? 'Unknown': _blueDevices[index].name,
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
                                                                      onPressed: _onPrintReceiptOrder,
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
                                                      SizedBox(height: 15),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
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
                                    Container(
                                      height: 67,
                                      width: double.infinity,
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
                                              //   trailing: Text('$currencyUnit '+
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
                                                            _onScanPressedOrder();
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
                                                            // printClosed = true;
                                                            Navigator.of(context).pop();
                                                            // Future.delayed(const Duration(milliseconds: 30000), () {
                                                            //   if(printClosed) {
                                                            //     _bluePrintPos.disconnect().then((ConnectionStatus status) {
                                                            //       if (status == ConnectionStatus.disconnect) {
                                                            //         setState(() {
                                                            //           _selectedDevice = null;
                                                            //         });
                                                            //       }
                                                            //     });
                                                            //   }
                                                            // });

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
                                                                              fontSize: 17.5,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Colors.black
                                                                          ),
                                                                          strutStyle: StrutStyle(
                                                                            height: 1.3,
                                                                            // fontSize:,
                                                                            forceStrutHeight: true,
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
                        ),
                        // Align(
                        //   alignment: Alignment.topCenter,
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(top: 90.0),
                        //     child: LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
                        //   )
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).whenComplete(() {
      printClosed = true;
      prodListPR = [];
      subTotal = 0.0;
      Future.delayed(const Duration(milliseconds: 30000), () {
        if(printClosed) {
          print('complete');
          _onDisconnectDevice();
        }
      });
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