// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';
//
// import 'package:adaptive_dialog/adaptive_dialog.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:device_info/device_info.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:fraction/fraction.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf_render/pdf_render_widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smartkyat_pos/api/pdf_api.dart';
// import 'package:smartkyat_pos/api/pdf_invoice_api.dart';
// import 'package:smartkyat_pos/fragments/buy_list_fragment.dart';
// import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
// import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
// import 'package:smartkyat_pos/fragments/customers_fragment.dart';
// // import 'package:smartkyat_pos/fragments/home_fragment.dart';
// import 'package:smartkyat_pos/fragments/home_fragment4.dart';
// import 'package:smartkyat_pos/fragments/merchants_fragment.dart';
// import 'package:smartkyat_pos/fragments/orders_fragment.dart';
// import 'package:smartkyat_pos/fragments/products_fragment.dart';
// import 'package:smartkyat_pos/fragments/settings_fragment.dart';
// import 'package:smartkyat_pos/fragments/test.dart';
// import 'package:smartkyat_pos/fragments/welcome_fragment.dart';
// import 'package:smartkyat_pos/model/customer.dart';
// import 'package:smartkyat_pos/model/invoice.dart';
// import 'package:smartkyat_pos/model/supplier.dart';
// import 'package:smartkyat_pos/pages2/single_assets_page.dart';
// import 'package:smartkyat_pos/src/screens/loading.dart';
// import '../app_theme.dart';
// import 'TabItem.dart';
//
//
// import 'package:image_save/image_save.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart' as PDF;
// import 'package:pdf_render/pdf_render_widgets.dart';
// // import 'package:printing/printing.dart';
// import 'package:pdf_render/pdf_render.dart';
// import 'package:image/image.dart' as imglib;
// import 'package:native_pdf_renderer/native_pdf_renderer.dart' as nativePDF;
//
// class HomePage extends StatefulWidget {
//
//   @override
//   State<StatefulWidget> createState() => HomePageState();
// }
//
// class HomePageState extends State<HomePage>
//     with TickerProviderStateMixin<HomePage> {
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   static int currentTab = 0;
//   var deviceIdNum = 0;
//   String? shopId;
//
//   List<TabItem> tabs = [];
//
//   Animation<double>? _rotationAnimation;
//   Color _fabColor = Colors.blue;
//
//   // bool sellDone = true;
//   bool onChangeAmountTab = false;
//
//   double homeBotPadding = 0;
//   void handleSlideAnimationChanged(Animation<double>? slideAnimation) {
//     setState(() {
//       _rotationAnimation = slideAnimation;
//     });
//   }
//
//   void handleSlideIsOpenChanged(bool? isOpen) {
//     setState(() {
//       _fabColor = isOpen! ? Colors.green : Colors.blue;
//     });
//   }
//
//   List<String> subList = [];
//   testFunc() async {
//     print('hi');
//     CollectionReference users = FirebaseFirestore.instance.collection('test');
//
//     print('gg ');
//
//     users
//         .doc('TtWFXrDF1feBVlUTPyQr')
//         .update({'double': FieldValue.increment(1)})
//         .then((value) => print("User Updated"))
//         .catchError((error) => print("Failed to update user: $error"));
//   }
//
//   testLoopData() {
//     for(int i=0; i<1; i++) {
//       testFunc();
//     }
//   }
//   late TabController _controller;
//   late TabController _controller2;
//   int _sliding = 0;
//
//
//   TextEditingController _textFieldController = TextEditingController();
//   TextEditingController _textFieldController2 = TextEditingController();
//
//
//   double paidAmount = 0;
//   double refund = 0;
//   double debt =0;
//   int quantity = 0;
//
//   double discount =0.0;
//   double discountAmount =0.0;
//   String disText ='';
//   String isDiscount = '';
//   double totalAmount = 0.0;
//
//   double paidAmount2 = 0;
//   double refund2 = 0;
//   double debt2 =0;
//   int quantity2 = 0;
//
//   double discount2 =0.0;
//   double discountAmount2 =0.0;
//   String disText2 ='';
//   String isDiscount2 = '';
//   double totalAmount2 = 0.0;
//
//   @override
//   void dispose() {
//     // Clean up the controller when the Widget is disposed
//     _textFieldController.dispose();
//     _textFieldController2.dispose();
//     super.dispose();
//   }
//
//   GlobalKey<HomeFragmentState> homeGlobalKey = GlobalKey();
//   GlobalKey<ProductsFragmentState> prodGlobalKey = GlobalKey();
//   GlobalKey<BuyListFragmentState> bordGlobalKey = GlobalKey();
//   GlobalKey<OrdersFragmentState> sordGlobalKey = GlobalKey();
//   GlobalKey<CustomersFragmentState> custGlobalKey = GlobalKey();
//   GlobalKey<MerchantsFragmentState> mercGlobalKey = GlobalKey();
//   GlobalKey<SettingsFragmentState> settGlobalKey = GlobalKey();
//
//   Future<String?> _getId() async {
//     var deviceInfo = DeviceInfoPlugin();
//     if (Platform.isIOS) { // import 'dart:io'
//       var iosDeviceInfo = await deviceInfo.iosInfo;
//       return iosDeviceInfo.identifierForVendor; // unique ID on iOS
//     } else {
//       var androidDeviceInfo = await deviceInfo.androidInfo;
//       return androidDeviceInfo.androidId; // unique ID on Android
//     }
//   }
//
//   @override
//   void initState() {
//     SystemChannels.textInput.invokeMethod('TextInput.hide');
//
//
//     getStoreId().then((value0) {
//       setState(() {
//         shopId = value0;
//       });
//
//       _getId().then((value1) async {
//         print('IDD ' + value1.toString());
//
//
//         // if(value2.data()!['devices'] == null) {
//         //   FirebaseFirestore.instance.collection('shops').doc(shopId).update({
//         //     'devices': FieldValue.arrayUnion([value1.toString()]),
//         //   }).then((value3) async {
//         //     print('User updated');
//         //   });
//         // }
//         await FirebaseFirestore.instance.collection('shops').doc(shopId).update({
//           'devices': FieldValue.arrayUnion([value1.toString()]),
//         }).then((value3) async {
//           print('User updated');
//           await FirebaseFirestore.instance.collection('shops').doc(shopId)
//           // .where('date', isGreaterThanOrEqualTo: todayToYearStart(now))
//               .get().then((value2) async {
//             List devicesList = value2.data()!['devices'];
//
//             for(int i = 0; i < devicesList.length; i++) {
//               if(devicesList[i] == value1.toString()) {
//                 print('DV LIST ' + devicesList[i].toString());
//                 setState(() {
//                   deviceIdNum = i;
//                   print('DV LIST 2 ' + deviceIdNum.toString());
//                 });
//               }
//             }
//           });
//         });
//       });
//     });
//     _controller = new TabController(length: 4, vsync: this);
//     _controller2 = new TabController(length: 3, vsync: this);
//     print('home_page' + 'sub1'.substring(3,4));
//
//
//     slidableController = SlidableController(
//       onSlideAnimationChanged: handleSlideAnimationChanged,
//       onSlideIsOpenChanged: handleSlideIsOpenChanged,
//     );
//     slidableController1 = SlidableController(
//       onSlideAnimationChanged: handleSlideAnimationChanged,
//       onSlideIsOpenChanged: handleSlideIsOpenChanged,
//     );
//
//     WidgetsFlutterBinding.ensureInitialized();
//     setState(() {
//       tabs = [
//         TabItem(
//           tabName: "Champions",
//           icon: Icon(
//             Icons.add,
//           ),
//           page: HomeFragment(
//             toggleCoinCallback:addMerchant2Cart, key: homeGlobalKey, toggleCoinCallback2: addCustomer2Cart, toggleCoinCallback3: addProduct, toggleCoinCallback4: addProduct3,
//           ),
//         ),
//         TabItem(
//           tabName: "Items",
//           icon: Icon(
//             Icons.add,
//           ),
//           page: OrdersFragment(
//             key: sordGlobalKey,
//             toggleCoinCallback2: addProduct,
//             toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart,),
//         ),
//         TabItem(
//           tabName: "Settings",
//           icon: Icon(
//             Icons.add,
//           ),
//           page: CustomersFragment(key: custGlobalKey, toggleCoinCallback2: addCustomer2Cart, toggleCoinCallback3: addMerchant2Cart, toggleCoinCallback4: addProduct, toggleCoinCallback: addProduct3,),
//         ),
//         TabItem(
//           tabName: "Settings",
//           icon: Icon(
//             Icons.add,
//           ),
//           page: ProductsFragment(
//             key: prodGlobalKey,
//             toggleCoinCallback: addNewProd2,
//             toggleCoinCallback2: addProduct,
//             toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart,),
//         ),
//         TabItem(
//           tabName: "Settings",
//           icon: Icon(
//             Icons.add,
//           ),
//           page: MerchantsFragment(key: mercGlobalKey, toggleCoinCallback3: addMerchant2Cart, toggleCoinCallback2: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback: addProduct,),
//         ),
//         TabItem(
//           tabName: "Settings",
//           icon: Icon(
//             Icons.add,
//           ),
//           // page: BuyListFragment(),
//           page: SettingsFragment(changeShopCallback: chgShopIdFromSetting),
//         ),
//         TabItem(
//           tabName: "Settings",
//           icon: Icon(
//             Icons.add,
//           ),
//           // page: BuyListFragment(),
//           page: SettingsFragment(key: settGlobalKey, changeShopCallback: chgShopIdFromSetting),
//         ),
//         TabItem(
//           tabName: "Settings",
//           icon: Icon(
//             Icons.add,
//           ),
//           // page: BuyListFragment(),
//           page: BuyListFragment( key: bordGlobalKey,
//             toggleCoinCallback2: addProduct,
//             toggleCoinCallback3: addProduct3, toggleCoinCallback4: addCustomer2Cart, toggleCoinCallback5: addMerchant2Cart,),
//         ),
//       ];
//     });
//
//     tabs.asMap().forEach((index, details) {
//       details.setIndex(index);
//     });
//
//     super.initState();
//   }
//
//   chgShopIdFromSetting() {
//     // print('gg');
//     homeGlobalKey.currentState!.chgShopIdFrmHomePage();
//     prodGlobalKey.currentState!.chgShopIdFrmHomePage();
//     bordGlobalKey.currentState!.chgShopIdFrmHomePage();
//     sordGlobalKey.currentState!.chgShopIdFrmHomePage();
//     mercGlobalKey.currentState!.chgShopIdFrmHomePage();
//     custGlobalKey.currentState!.chgShopIdFrmHomePage();
//     settGlobalKey.currentState!.chgShopIdFrmHomePage();
//   }
//
//   closeNewProduct() {
//     Navigator.pop(context);
//   }
//
//   addNewProd2() {
//     final List<String> prodFieldsValue = [];
//     final _formKey = GlobalKey<FormState>();
//     // myController.clear();
//     showModalBottomSheet(
//         enableDrag: false,
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext context) {
//           return SingleAssetPage(toggleCoinCallback: closeNewProduct);
//         });
//   }
//
//   int _selectIndex = 0;
//   void _selectTab(int index) {
//     if (index == currentTab) {
//       tabs[index].key.currentState!.popUntil((route) => route.isFirst);
//     } else {
//       // update the state
//       // in order to repaint
//       setState(() => currentTab = index);
//     }
//   }
//
//   String pdfText = '';
//
//   File? pdfFile;
//
//   late final mergedImage;
//
//   String pageType = 'roll57';
//
//   final auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     homeBotPadding = MediaQuery.of(context).padding.bottom;
//     return Scaffold(
//       onDrawerChanged: (isOpened) {
//         if(isOpened) {
//           homeGlobalKey.currentState!.unfocusSearch();
//           prodGlobalKey.currentState!.unfocusSearch();
//           custGlobalKey.currentState!.unfocusSearch();
//           mercGlobalKey.currentState!.unfocusSearch();
//           sordGlobalKey.currentState!.unfocusSearch();
//           bordGlobalKey.currentState!.unfocusSearch();
//         }
//       },
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       key: _scaffoldKey,
//       drawer: new Drawer(
//         child: Container(
//           color: Colors.white,
//           child: SafeArea(
//             top: true,
//             bottom: true,
//
//             child: Column(
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Container(
//                         height: 80,
//                         decoration: BoxDecoration(
//                             border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.grey.withOpacity(0.3),
//                                     width: 1.0))),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
//                           child: GestureDetector(
//                             onTap: () async {
//                               // MainFragmentState().changeState(1);
//                               _selectTab(0);
//                               await FirebaseAuth.instance.signOut();
//                               setStoreId('');
//                               // Navigator.pop(context);
//                               // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoadingScreen()));
//                               // Navigator.of(context).pushReplacement(FadeRoute(builder: (context) => Welcome()));
//                               Navigator.of(context).pushReplacement(
//                                 FadeRoute(page: Welcome()),
//                               );
//
//                             },
//                             child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                                 stream: FirebaseFirestore.instance
//                                     .collection('shops')
//                                     .doc(shopId)
//                                     .snapshots(),
//                                 builder: (BuildContext context, snapshot) {
//                                   if (snapshot.hasData) {
//                                     var output = snapshot.data!.data();
//                                     var shopName = output?['shop_name'];
//                                     var shopAddress = output?['shop_address'];
//                                     return Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         SizedBox(
//                                           height: 2,
//                                         ),
//                                         Text(
//                                           shopName.toString(),overflow: TextOverflow.ellipsis,
//                                           style: TextStyle(
//                                               height: 1.4, fontSize: 18, fontWeight: FontWeight.w500),
//                                         ),
//                                         SizedBox(
//                                           height: 3,
//                                         ),
//                                         Text(
//                                           shopAddress.toString(),overflow: TextOverflow.ellipsis,
//                                           style: TextStyle(height: 1, fontSize: 14),
//                                         ),
//                                         SizedBox(
//                                           height: 3,
//                                         ),
//                                       ],
//                                     );
//                                   }
//                                   return Container();
//                                 }
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Expanded(
//                     child: ListView(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//                           // child: new Column(children: drawerOptions),
//                           child: Stack(
//                             children: [
//                               new Column(children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       _selectTab(0);
//                                       _selectIndex = 0;
//                                     });
//                                     _scaffoldKey.currentState!.openEndDrawer();
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                                     child: new Container(
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10.0),
//                                           color: _selectIndex == 0? AppTheme.secButtonColor: Colors.transparent),
//                                       height: 50,
//                                       width: double.infinity,
//                                       child: Row(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 18.0, right: 15.0, bottom: 2.0),
//                                             child: Icon(
//                                               // Icons.home_filled,
//                                               SmartKyat_POS.home,
//                                               size: 20,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(bottom: 1.0),
//                                             child: Text(
//                                               'Home',
//                                               style: TextStyle(
//                                                   fontSize: 17, fontWeight: FontWeight.w500),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     homeGlobalKey.currentState!.closeSearch();
//                                     prodGlobalKey.currentState!.closeSearch();
//                                     custGlobalKey.currentState!.closeSearch();
//                                     mercGlobalKey.currentState!.closeSearch();
//                                     sordGlobalKey.currentState!.closeSearch();
//                                     bordGlobalKey.currentState!.closeSearch();
//
//                                     // Future.delayed(const Duration(milliseconds: 500), () {
//                                     setState(() {
//                                       _selectTab(3);
//                                       _selectIndex = 1;
//                                     });
//                                     // });
//
//
//                                     _scaffoldKey.currentState!.openEndDrawer();
//
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                                     child: new Container(
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10.0),
//                                           color: _selectIndex == 1? AppTheme.secButtonColor: Colors.transparent),
//                                       height: 50,
//                                       width: double.infinity,
//                                       child: Row(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 18.0, right: 15.0, bottom: 1),
//                                             child: Icon(
//                                               SmartKyat_POS.product,
//                                               size: 21,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(bottom: 1.0),
//                                             child: Text(
//                                               'Products',
//                                               style: TextStyle(
//                                                   fontSize: 17, fontWeight: FontWeight.w500),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                                     child: new Container(
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10.0),
//                                           color: Colors.transparent),
//                                       height: 50,
//                                       width: double.infinity,
//                                       child: Row(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 18.0, right: 15.0, bottom: 2),
//                                             child: Icon(
//                                               SmartKyat_POS.order,
//                                               size: 23,
//                                             ),
//                                           ),
//                                           Text(
//                                             'Orders',
//                                             style: TextStyle(
//                                                 fontSize: 17, fontWeight: FontWeight.w500),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       _selectTab(1);
//                                       _selectIndex = 2;
//                                     });
//
//                                     _scaffoldKey.currentState!.openEndDrawer();
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 58.0, right: 15.0),
//                                     child: new Container(
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10.0),
//                                           color: _selectIndex == 2? AppTheme.secButtonColor: Colors.transparent),
//                                       height: 50,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(left: 13.0),
//                                         child: Row(
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.only(bottom: 1.0),
//                                               child: Text(
//                                                 'Sale orders',
//                                                 style: TextStyle(
//                                                     fontSize: 17, fontWeight: FontWeight.w500),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       _selectTab(7);
//                                       _selectIndex = 3;
//                                     });
//
//                                     _scaffoldKey.currentState!.openEndDrawer();
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 58.0, right: 15.0),
//                                     child: new Container(
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10.0),
//                                           color: _selectIndex == 3? AppTheme.secButtonColor: Colors.transparent),
//                                       height: 50,
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(left: 13.0),
//                                         child: Row(
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.only(bottom: 1.0),
//                                               child: Text(
//                                                 'Buy orders',
//                                                 style: TextStyle(
//                                                     fontSize: 17, fontWeight: FontWeight.w500),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       _selectTab(2);
//                                       _selectIndex = 4;
//                                     });
//
//                                     _scaffoldKey.currentState!.openEndDrawer();
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                                     child: new Container(
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10.0),
//                                           color: _selectIndex == 4? AppTheme.secButtonColor: Colors.transparent),
//                                       height: 50,
//                                       width: double.infinity,
//                                       child: Row(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 18.0, right: 15.0, bottom: 1.0),
//                                             child: Stack(
//                                               children: [
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(top: 7.0),
//                                                   child: Icon(
//                                                     SmartKyat_POS.customer1,
//                                                     size: 17.5,
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(left: 14.0, top: 11.0),
//                                                   child: Icon(
//                                                     SmartKyat_POS.customer2,
//                                                     size: 9,
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(left: 5.0, top: 5),
//                                                   child: Container(
//                                                     width: 8,
//                                                     height: 7.5,
//                                                     decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(10.0),
//                                                         color: Colors.black),
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(left: 14.5, top: 7.5),
//                                                   child: Container(
//                                                     width: 5,
//                                                     height: 4.5,
//                                                     decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(10.0),
//                                                         color: Colors.black),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(bottom: 1.0),
//                                             child: Text(
//                                               'Customers',
//                                               style: TextStyle(
//                                                   fontSize: 17, fontWeight: FontWeight.w500),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       _selectTab(4);
//                                       _selectIndex = 5;
//                                     });
//
//                                     _scaffoldKey.currentState!.openEndDrawer();
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                                     child: new Container(
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10.0),
//                                           color: _selectIndex == 5? AppTheme.secButtonColor: Colors.transparent),
//                                       height: 50,
//                                       width: double.infinity,
//                                       child: Row(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 18.0, right: 15.0),
//                                             child: Icon(
//                                               SmartKyat_POS.merchant,
//                                               size: 20,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(bottom: 1.0),
//                                             child: Text(
//                                               'Merchants',
//                                               style: TextStyle(
//                                                   fontSize: 17, fontWeight: FontWeight.w500),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       _selectTab(6);
//                                       _selectIndex = 6;
//                                     });
//
//                                     _scaffoldKey.currentState!.openEndDrawer();
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                                     child: new Container(
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10.0),
//                                           color: _selectIndex == 6? AppTheme.secButtonColor: Colors.transparent),
//                                       height: 50,
//                                       width: double.infinity,
//                                       child: Row(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 18.0, right: 15.0, top: 0.0),
//                                             child: Icon(
//                                               SmartKyat_POS.setting,
//                                               size: 22,
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(bottom: 1.0),
//                                             child: Text(
//                                               'Settings',
//                                               style: TextStyle(
//                                                   fontSize: 17, fontWeight: FontWeight.w500),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ]),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 10.0, top: 150.0),
//                                 child: Icon(
//                                   SmartKyat_POS.merge_arrow,
//                                   size: 80,
//                                   color: Colors.grey.withOpacity(0.3),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       Container(
//                         height: 61,
//                         decoration: BoxDecoration(
//                             border: Border(
//                                 top: BorderSide(
//                                     color: Colors.grey.withOpacity(0.3),
//                                     width: 1.0))),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 15.0, right: 15, top: 15, bottom: 15),
//                           child: Row(
//                             children: [
//                               StreamBuilder(
//                                   stream: FirebaseFirestore.instance.collection('users')
//                                       .where('email', isEqualTo: auth.currentUser!.email.toString())
//                                       .snapshots(),
//                                   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                                     if(snapshot.hasData) {
//                                       return Expanded(
//                                         child: ListView(
//                                           physics: NeverScrollableScrollPhysics(),
//                                           children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                                             Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//                                             return  Container(
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(top: 3.0),
//                                                 child: Text(data['name'], overflow: TextOverflow.ellipsis, style: TextStyle(
//                                                   fontSize: 17,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),),
//                                               ),
//                                             );
//                                           }).toList(),
//                                         ),
//                                       );
//                                     }
//                                     return Container();
//                                   }
//                               ),
//                               ButtonTheme(
//                                 minWidth: 35,
//                                 splashColor: Colors.transparent,
//                                 height: 35,
//                                 child: FlatButton(
//                                   color: AppTheme.buttonColor2,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                     BorderRadius.circular(10.0),
//                                     side: BorderSide(
//                                       color: AppTheme.buttonColor2,
//                                     ),
//                                   ),
//                                   onPressed: () async {
//                                     _selectTab(0);
//                                     await FirebaseAuth.instance.signOut();
//                                     setStoreId('');
//                                     Navigator.of(context).pushReplacement(
//                                       FadeRoute(page: Welcome()),
//                                     );
//                                   },
//                                   child: Container(
//                                     child: Text(
//                                       'Log out',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//
//                         ),
//                       ),
//                     ],
//                   ),
//
//                 ]),
//
//
//           ),
//
//
//         ),
//       ),
//
//       body: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('shops')
//               .where('users', arrayContains: FirebaseAuth.instance.currentUser == null? '': FirebaseAuth.instance.currentUser!.email.toString())
//               .snapshots(),
//           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             print('current ' + FirebaseAuth.instance.currentUser.toString());
//             if(snapshot.hasData) {
//               List<bool> shopFound = [];
//               getStoreId().then((value) async {
//                 if(snapshot.data!.docs.length == 0) {
//                   await FirebaseAuth.instance.signOut();
//                   setStoreId('');
//                   // Navigator.pop(context);
//                   // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoadingScreen()));
//                   // Navigator.of(context).pushReplacement(FadeRoute(builder: (context) => Welcome()));
//                   Navigator.of(context).pushReplacement(
//                     FadeRoute(page: Welcome()),
//                   );
//                 }
//               });
//
//               for(int loop = 0; loop < snapshot.data!.docs.length; loop++) {
//                 Map<String, dynamic> data = snapshot.data!.docs[loop]
//                     .data()! as Map<String, dynamic>;
//                 var shop_name = data['shop_name'];
//                 print('SHOP LIST ' + shop_name);
//                 getStoreId().then((value) async {
//                   if(snapshot.data!.docs[loop].id == value) {
//                     shopFound.add(true);
//                   } else {
//                     shopFound.add(false);
//                   }
//                   if(loop == snapshot.data!.docs.length-1) {
//                     print('SHOP LIST LIST ' + shopFound.toString());
//                     for(int i = 0; i < shopFound.length; i++) {
//                       if(shopFound[i]) {
//                         break;
//                       } else {
//                         if(i == shopFound.length-1) {
//                           await FirebaseAuth.instance.signOut();
//                           setStoreId('');
//                           // Navigator.pop(context);
//                           // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoadingScreen()));
//                           // Navigator.of(context).pushReplacement(FadeRoute(builder: (context) => Welcome()));
//                           Navigator.of(context).pushReplacement(
//                             FadeRoute(page: Welcome()),
//                           );
//                         }
//                       }
//                     }
//                   }
//                 });
//
//
//                 // print(snapshot.data!.docs[loop].data()!['shop_name'].toString());
//
//               }
//               // for(int loop = 0; loop < snapshot.data!.docs.length; loop++) {
//               //   Map<String, dynamic> data = snapshot.data!.docs[loop]
//               //       .data()! as Map<String, dynamic>;
//               //   var shop_name = data['shop_name'];
//               //   print('SHOP LIST ' + shop_name);
//               //   getStoreId().then((value) async {
//               //     if(snapshot.data!.docs[loop].id == value) {
//               //       shopFound.add(true);
//               //     } else {
//               //       shopFound.add(false);
//               //     }
//               //     if(loop == snapshot.data!.docs.length-1) {
//               //       print('SHOP LIST LIST ' + shopFound.toString());
//               //       for(int i = 0; i < shopFound.length; i++) {
//               //         if(shopFound[i]) {
//               //           break;
//               //         } else {
//               //           if(i == shopFound.length-1) {
//               //             await FirebaseAuth.instance.signOut();
//               //             setStoreId('');
//               //             // Navigator.pop(context);
//               //             // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoadingScreen()));
//               //             // Navigator.of(context).pushReplacement(FadeRoute(builder: (context) => Welcome()));
//               //             Navigator.of(context).pushReplacement(
//               //               FadeRoute(page: Welcome()),
//               //             );
//               //           }
//               //         }
//               //       }
//               //     }
//               //   });
//               //
//               //
//               //   // print(snapshot.data!.docs[loop].data()!['shop_name'].toString());
//               //
//               // }
//             }
//             return Stack(
//               children: [
//                 WillPopScope(
//                   onWillPop: () async {
//                     final isFirstRouteInCurrentTab =
//                     !await tabs[currentTab].key.currentState!.maybePop();
//                     if (isFirstRouteInCurrentTab) {
//                       // if not on the 'main' tab
//                       if (currentTab != 0) {
//                         // select 'main' tab
//                         _selectTab(0);
//                         // back button handled by app
//                         return false;
//                       }
//                     }
//                     // let system handle back button if we're on the first route
//                     return isFirstRouteInCurrentTab;
//                   },
//                   // this is the base scaffold
//                   // don't put appbar in here otherwise you might end up
//                   // with multiple appbars on one screen
//                   // eventually breaking the app
//
//                   child: Scaffold(
//                       resizeToAvoidBottomInset: false,
//                       // backgroundColor: Colors.white,
//                       // indexed stack shows only one child
//                       body: IndexedStack(
//                         index: currentTab,
//                         children: tabs.map((e) => e.page).toList(),
//                       ),
//                       bottomNavigationBar: Padding(
//                         padding: EdgeInsets.only(
//                             bottom: homeBotPadding
//                         ),
//                         child: Container(
//                           color: Colors.white,
//                           height: MediaQuery.of(context).size.width > 900 ? 57 : 142,
//                           child: Column(
//                             children: [
//                               if (MediaQuery.of(context).size.width > 900) Container() else Container(
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     border: Border(
//                                       top: BorderSide(
//                                           color: AppTheme.skBorderColor2,
//                                           width: 1.0),
//                                     )
//                                 ),
//                                 child: Padding(
//                                   padding:
//                                   const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
//                                   child: Container(
//                                     height: 50,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         if (prodList2.length != 0 || merchantId != 'name-name' ) {
//                                           addDailyExp2(context);
//                                         } else if(prodList.length != 0 || customerId != 'name-name') {
//                                           addDailyExp(context);
//                                         } else addDailyExp(context);
//                                         // if (prodList.length != 0 || customerId != 'name-name') {
//                                         //   addDailyExp(context);
//                                         // } else {
//                                         //   addDailyExp2(context);
//                                         // }
//                                       },
//                                       child: (prodList.length == 0) ? Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10.0),
//                                           color: customerId == 'name-name' ? AppTheme.buttonColor2 : AppTheme.themeColor,
//                                           // color: Colors.blue
//                                         ),
//
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 13.0, bottom: 15.0),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                             children: [
//                                               Expanded(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.only(
//                                                       left: 8.0,
//                                                       right: 8.0,
//                                                       bottom: 2.0),
//                                                   child: Container(
//                                                     child: Text(
//                                                       'Go to cart',
//                                                       textAlign: TextAlign.center,
//                                                       style: TextStyle(
//                                                           fontSize: 18,
//                                                           fontWeight: FontWeight.w500,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ) : Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10.0),
//                                           color: AppTheme.themeColor,
//                                           // color: Colors.blue
//                                         ),
//
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 13.0, bottom: 15.0),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                             children: [
//                                               Expanded(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.only(
//                                                       left: 8.0,
//                                                       right: 8.0,
//                                                       bottom: 2.0),
//                                                   child: int.parse(totalItems()) == 1? Container(
//                                                     child:
//                                                     Text(
//                                                       totalItems() + ' item - ' + TtlProdListPrice() + ' MMK',
//                                                       textAlign: TextAlign.center,
//                                                       style: TextStyle(
//                                                           fontSize: 18,
//                                                           fontWeight: FontWeight.w500,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ) : Container(
//                                                     child:
//                                                     Text(
//                                                       totalItems() + ' items - ' + TtlProdListPrice() + ' MMK',
//                                                       textAlign: TextAlign.center,
//                                                       style: TextStyle(
//                                                           fontSize: 18,
//                                                           fontWeight: FontWeight.w500,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 height: 57,
//                                 decoration: BoxDecoration(
//                                     border: Border(
//                                       top: BorderSide(
//                                           color: AppTheme.skBorderColor2, width: 1.0),
//                                     )),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 15.0,top:0.0
//                                         ),
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             _scaffoldKey.currentState!.openDrawer();
//                                           },
//                                           child: selectedTab(
//
//                                           ),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Container(
//                                             child: Text(
//                                               '',
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                   fontSize: 16.5,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Colors.black.withOpacity(0.6)),
//                                             )),
//                                       ),
//                                       GestureDetector(
//                                         onTap: () {
//                                           homeGlobalKey.currentState!.closeSearch();
//                                           prodGlobalKey.currentState!.closeSearch();
//                                           custGlobalKey.currentState!.closeSearch();
//                                           mercGlobalKey.currentState!.closeSearch();
//                                           sordGlobalKey.currentState!.closeSearch();
//                                           bordGlobalKey.currentState!.closeSearch();
//                                           // print('sub ' + subList.toString());
//                                           // testLoopData();
//                                           // addDailyExp(context);
//                                           // _controller.animateTo(3, duration: Duration(milliseconds: 0), curve: Curves.ease);
//                                           // homeGlobalKey.currentState!.Testing();
//                                           // HomeFragmentState().Testing();
//                                         },
//                                         child: Row(
//                                           children: [
//                                             // StreamBuilder<
//                                             //     DocumentSnapshot<
//                                             //         Map<String, dynamic>>>(
//                                             //     stream: FirebaseFirestore.instance
//                                             //         .collection('test')
//                                             //         .doc('TtWFXrDF1feBVlUTPyQr')
//                                             //         .snapshots(),
//                                             //     builder:
//                                             //         (BuildContext context, snapshot2) {
//                                             //       if (snapshot2.hasData) {
//                                             //         var output1 = snapshot2.data!.data();
//                                             //         var mainUnit =
//                                             //         output1?['double'];
//                                             //         return Text(mainUnit.toString(),
//                                             //           style: TextStyle(
//                                             //             fontSize: 18,
//                                             //             fontWeight: FontWeight.bold,
//                                             //           ),
//                                             //         );
//                                             //       }
//                                             //       return Container();
//                                             //     }),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   right: 13.0,top:2.0
//                                               ),
//                                               child: Container(
//                                                   child: Image.asset('assets/system/menu.png', height: 33,)
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     // Bottom navigation
//
//                   ),
//                 ),
//               ],
//             );
//           }
//       ),
//     );
//   }
//
//   List<String> prodList = [];
//   late final SlidableController slidableController;
//   addProduct(data) async {
//     for (var i = 0; i < prodList.length; i++) {
//       if (prodList[i].split('-')[0] == data.split('-')[0] &&
//           prodList[i].split('-')[3] == data.split('-')[3]) {
//         data = data.split('-')[0] +
//             '-' +
//             data.split('-')[1] +
//             '-' +
//             data.split('-')[2] +
//             '-' +
//             data.split('-')[3] +
//             '-' +
//             (int.parse(prodList[i].split('-')[4]) + 1).toString();
//         setState((){prodList[i] = data + '-0'; });
//         return;
//       }
//     }
//     if (data != 'null') {
//       setState((){prodList.add(data + '-0');});
//     }
//   }
//
//
//   List<String> prodList2 = [];
//   late final SlidableController slidableController1;
//   addProduct3(data) {
//     if (data != 'null') {
//       prodList2.add(data + '-0-');
//     }
//   }
//
//   String customerId = 'name-name';
//
//   addCustomer2Cart(data) {
//     customerId = data.toString();
//   }
//
//   String merchantId = 'name-name';
//
//   addMerchant2Cart(data) {
//     merchantId = data.toString();
//   }
//
//   // addString2Sub(data){
//   //
//   //   DateTime now =
//   //   DateTime.now();
//   //   CollectionReference
//   //   daily_order =
//   //   FirebaseFirestore
//   //       .instance
//   //       .collection(
//   //       'space')
//   //       .doc(
//   //       '0NHIS0Jbn26wsgCzVBKT')
//   //       .collection(
//   //       'shops')
//   //       .doc(
//   //       shopId)
//   //       .collection(
//   //       'buyOrders');
//   //   var length = 0;
//   //   setState(() {
//   //     orderLoading = true;
//   //   });
//   //
//   //   print('order creating');
//   //
//   //   FirebaseFirestore
//   //       .instance
//   //       .collection('space')
//   //       .doc(
//   //       '0NHIS0Jbn26wsgCzVBKT')
//   //       .collection('shops')
//   //       .doc(
//   //       shopId)
//   //       .collection(
//   //       'buyOrders')
//   //   // FirebaseFirestore.instance.collection('space')
//   //       .get()
//   //       .then((QuerySnapshot
//   //   querySnapshot) async {
//   //     querySnapshot.docs
//   //         .forEach((doc) {
//   //       length += int.parse(
//   //           doc['daily_order']
//   //               .length
//   //               .toString());
//   //     });
//   //     length =
//   //         1000 + length + 1;
//   //
//   //     //Check new date or not
//   //     var dateExist = false;
//   //     var dateId = '';
//   //
//   //     FirebaseFirestore
//   //         .instance
//   //         .collection(
//   //         'space')
//   //         .doc(
//   //         '0NHIS0Jbn26wsgCzVBKT')
//   //         .collection(
//   //         'shops')
//   //         .doc(
//   //         shopId)
//   //         .collection(
//   //         'buyOrders')
//   //     // FirebaseFirestore.instance.collection('space')
//   //         .where('date',
//   //         isEqualTo: now
//   //             .year
//   //             .toString() +
//   //             zeroToTen(now
//   //                 .month
//   //                 .toString()) +
//   //             zeroToTen(now
//   //                 .day
//   //                 .toString()))
//   //         .get()
//   //         .then((QuerySnapshot
//   //     querySnapshot) {
//   //       querySnapshot.docs
//   //           .forEach((doc) {
//   //         dateExist = true;
//   //         dateId = doc.id;
//   //       });
//   //
//   //       if (dateExist) {
//   //         daily_order
//   //             .doc(dateId)
//   //             .update({
//   //           'daily_order':
//   //           FieldValue
//   //               .arrayUnion([
//   //             now.year.toString() +
//   //                 zeroToTen(now
//   //                     .month
//   //                     .toString()) +
//   //                 zeroToTen(now
//   //                     .day
//   //                     .toString()) +
//   //                 zeroToTen(now
//   //                     .hour
//   //                     .toString()) +
//   //                 zeroToTen(now
//   //                     .minute
//   //                     .toString()) +
//   //                 zeroToTen(now
//   //                     .second
//   //                     .toString()) +
//   //                 deviceIdNum
//   //                     .toString() +
//   //                 length
//   //                     .toString() +
//   //                 '^' +
//   //                 deviceIdNum
//   //                     .toString() +
//   //                 '-' +
//   //                 length
//   //                     .toString() +
//   //                 '^' +
//   //                 TtlProdListPrice2() +
//   //                 '^' +
//   //                 merchantId
//   //                     .split(
//   //                     '-')[0] +
//   //                 '^pf'
//   //           ])
//   //         }).then((value) {
//   //           print(
//   //               'User updated');
//   //           setState(() {
//   //             orderLoading =
//   //             false;
//   //           });
//   //
//   //           FirebaseFirestore
//   //               .instance
//   //               .collection(
//   //               'space')
//   //               .doc(
//   //               '0NHIS0Jbn26wsgCzVBKT')
//   //               .collection(
//   //               'shops')
//   //               .doc(
//   //               shopId)
//   //               .collection(
//   //               'buyOrders')
//   //               .doc(dateId)
//   //               .collection(
//   //               'expansion')
//   //               .doc(now
//   //               .year
//   //               .toString() +
//   //               zeroToTen(now
//   //                   .month
//   //                   .toString()) +
//   //               zeroToTen(now
//   //                   .day
//   //                   .toString()) +
//   //               zeroToTen(now
//   //                   .hour
//   //                   .toString()) +
//   //               zeroToTen(now
//   //                   .minute
//   //                   .toString()) +
//   //               zeroToTen(now
//   //                   .second
//   //                   .toString()) +
//   //               deviceIdNum
//   //                   .toString() +
//   //               length
//   //                   .toString())
//   //               .set({
//   //             'main':
//   //             'total',
//   //             'subs':
//   //             data,
//   //           }).then((value) {
//   //             print(
//   //                 'order added');
//   //           });
//   //         });
//   //       } else {
//   //         daily_order.add({
//   //           'daily_order': [
//   //             now.year.toString() +
//   //                 zeroToTen(now
//   //                     .month
//   //                     .toString()) +
//   //                 zeroToTen(now
//   //                     .day
//   //                     .toString()) +
//   //                 zeroToTen(now
//   //                     .hour
//   //                     .toString()) +
//   //                 zeroToTen(now
//   //                     .minute
//   //                     .toString()) +
//   //                 zeroToTen(now
//   //                     .second
//   //                     .toString()) +
//   //                 deviceIdNum
//   //                     .toString() +
//   //                 length
//   //                     .toString() +
//   //                 '^' +
//   //                 deviceIdNum
//   //                     .toString() +
//   //                 '-' +
//   //                 length
//   //                     .toString() +
//   //                 '^' +
//   //                 TtlProdListPrice2() +
//   //                 '^' +
//   //                 merchantId
//   //                     .split(
//   //                     '-')[0] +
//   //                 '^pf'
//   //           ],
//   //           'date': now.year
//   //               .toString() +
//   //               zeroToTen(now
//   //                   .month
//   //                   .toString()) +
//   //               zeroToTen(now
//   //                   .day
//   //                   .toString())
//   //         }).then((value) {
//   //           print(
//   //               'order added');
//   //
//   //           FirebaseFirestore
//   //               .instance
//   //               .collection(
//   //               'space')
//   //               .doc(
//   //               '0NHIS0Jbn26wsgCzVBKT')
//   //               .collection(
//   //               'shops')
//   //               .doc(
//   //               shopId)
//   //               .collection(
//   //               'buyOrders')
//   //               .doc(value
//   //               .id)
//   //               .collection(
//   //               'expansion')
//   //               .doc(now
//   //               .year
//   //               .toString() +
//   //               zeroToTen(now
//   //                   .month
//   //                   .toString()) +
//   //               zeroToTen(now
//   //                   .day
//   //                   .toString()) +
//   //               zeroToTen(now
//   //                   .hour
//   //                   .toString()) +
//   //               zeroToTen(now
//   //                   .minute
//   //                   .toString()) +
//   //               zeroToTen(now
//   //                   .second
//   //                   .toString()) +
//   //               deviceIdNum
//   //                   .toString() +
//   //               length
//   //                   .toString())
//   //               .set({
//   //             'main':
//   //             'total',
//   //             'subs':
//   //             data,
//   //           }).then((value) {
//   //             print(
//   //                 'order added');
//   //           });
//   //         });
//   //       }
//   //     });
//   //
//   //   });
//   //
//   // }
//
//   addDailyExp(priContext) {
//     var mainLoss = 0;
//     var sub1Loss=0;
//     var sub2Loss = 0;
//     String eachProd = '';
//     String productName = '';
//     String salePrice = '';
//     String barcode = '';
//     String mainName = '';
//     String sub1Name = '';
//     String sub2Name = '';
//     String unit = '';
//     String name ='';
//     var mainQty= 0;
//     var sub1Qty = 0;
//     var sub2Qty = 0;
//     totalAmount = double.parse(TtlProdListPrice());
//     bool sellDone = true;
//     TextEditingController myController = TextEditingController();
//
//
//     // if(sellDone == true) {
//     //   _controller.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);
//     // }
//     if(sellDone == true) {
//       _controller.animateTo(
//         0, duration: Duration(milliseconds: 0), curve: Curves.ease,);
//       _textFieldController.clear();
//       paidAmount = 0;
//       debt = 0;
//       refund = 0;
//       totalAmount = double.parse(TtlProdListPrice());
//       sellDone = false;
//     }
//     // if(onChangeAmountTab == true) {
//     //
//     //   onChangeAmountTab = false;
//     // }
//
//     showModalBottomSheet(
//         enableDrag: true,
//         isScrollControlled: true,
//         context: context,
//         backgroundColor: Colors.transparent,
//         builder: (BuildContext context) {
//           return StatefulBuilder(
//             builder: (BuildContext context, StateSetter mystate) {
//               _textFieldController.addListener((){
//                 print("value: ${_textFieldController.text}");
//                 setState(() {
//                   totalAmount = double.parse(TtlProdListPrice());
//                   _textFieldController.text != '' ? paidAmount = double.parse(_textFieldController.text) : paidAmount = 0.0;
//                   if((totalAmount - paidAmount).isNegative){
//                     debt = 0;
//                   } else { debt = (totalAmount - paidAmount);
//                   }
//                   if((paidAmount - totalAmount).isNegative){
//                     refund = 0;
//                   } else { refund = (paidAmount - totalAmount);
//                   }
//                 });       });
//               return Scaffold(
//                 resizeToAvoidBottomInset: false,
//                 body: GestureDetector(
//                   onTap: () {
//                     FocusScope.of(context).unfocus();
//                   },
//                   child: Stack(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 60.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(15.0),
//                               topRight: Radius.circular(15.0),
//                             ),
//                             color: Colors.white,
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 15.0),
//                             child: TabBarView(
//                               physics: NeverScrollableScrollPhysics(),
//                               controller: _controller,
//                               children: [
//                                 Container(
//                                   color: Colors.white,
//                                   height:
//                                   MediaQuery.of(context).size.height -
//                                       45,
//                                   width: double.infinity,
//                                   child: Stack(
//                                     children: [
//                                       Container(
//                                         height: 71,
//                                         decoration: BoxDecoration(
//                                             border: Border(
//                                                 bottom: BorderSide(
//                                                     color: Colors.grey
//                                                         .withOpacity(0.3),
//                                                     width: 1.0))),
//                                         child: Padding(
//                                           padding: EdgeInsets.only(
//                                               left: 15.0,
//                                               right: 15.0,
//                                               top: 0.0,
//                                               bottom: 15.0
//                                           ),
//                                           child: Row(
//                                             children: [
//                                               Container(
//                                                 width:
//                                                 (MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                     2) -
//                                                     22.5,
//                                                 height: 55,
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                     BorderRadius
//                                                         .circular(10.0),
//                                                     color: AppTheme.clearColor),
//                                                 child: Padding(
//                                                   padding:
//                                                   const EdgeInsets.only(
//                                                       top: 15.0,
//                                                       bottom: 15.0),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .center,
//                                                     children: [
//                                                       Expanded(
//                                                         child:
//                                                         GestureDetector(
//                                                           onTap: () {
//                                                             setState((){
//                                                               mystate(() {
//                                                                 prodList = [];
//                                                                 discount = 0.0;
//                                                                 discountAmount = 0.0;
//                                                                 debt =0;
//                                                                 refund =0;
//                                                                 customerId = 'name-name';
//                                                               });
//                                                             });
//                                                           },
//                                                           child: Padding(
//                                                             padding:
//                                                             const EdgeInsets
//                                                                 .only(
//                                                                 left:
//                                                                 8.0,
//                                                                 right:
//                                                                 8.0,
//                                                                 bottom:
//                                                                 3.0),
//                                                             child: Container(
//                                                                 child: Text(
//                                                                   'Clear cart',
//                                                                   textAlign:
//                                                                   TextAlign
//                                                                       .center,
//                                                                   style: TextStyle(
//                                                                       fontSize:
//                                                                       18,
//                                                                       fontWeight:
//                                                                       FontWeight
//                                                                           .w600,
//                                                                       color: Colors
//                                                                           .black),
//                                                                 )),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 15.0,
//                                               ),
//                                               Container(
//                                                 width: (MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                     2) -
//                                                     22.5,
//                                                 height: 55,
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                     BorderRadius.circular(
//                                                         10.0),
//                                                     color: Colors.grey
//                                                         .withOpacity(0.5)),
//                                                 child: Padding(
//                                                   padding:
//                                                   const EdgeInsets.only(
//                                                       top: 15.0,
//                                                       bottom: 15.0),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .center,
//                                                     children: [
//                                                       Expanded(
//                                                         child:
//                                                         GestureDetector(
//                                                           onTap: () async {
//                                                             final result = await showModalActionSheet<String>(
//                                                               context: context,
//                                                               actions: [
//                                                                 SheetAction(
//                                                                   icon: Icons.info,
//                                                                   label: 'Amount',
//                                                                   key: 'amount',
//                                                                 ),
//                                                                 SheetAction(
//                                                                   icon: Icons.info,
//                                                                   label: 'Percent',
//                                                                   key: 'percent',
//                                                                 ),
//                                                               ],
//                                                             );
//                                                             mystate(() {
//                                                               isDiscount = result.toString();
//                                                             });
//
//                                                             if (result == 'amount') {
//                                                               final amount = await showTextInputDialog(
//                                                                 context: context,
//                                                                 textFields: [
//                                                                   DialogTextField(
//                                                                     keyboardType: TextInputType.number,
//                                                                     hintText: '0',
//                                                                     suffixText: 'MMK',
//                                                                     // initialText: 'mono0926@gmail.com',
//                                                                   ),
//                                                                 ],
//                                                                 title: 'Discount',
//                                                                 message: 'Add Discount Amount to Cart',
//                                                               );
//                                                               mystate(() {
//                                                                 discount =double.parse(amount![0].toString());
//                                                                 print('disss ' + discount.toString());
//                                                               });
//
//                                                             } else {
//                                                               final percentage = await showTextInputDialog(
//                                                                 context: context,
//                                                                 textFields: [
//                                                                   DialogTextField(
//                                                                     keyboardType: TextInputType.number,
//                                                                     hintText: '0.0',
//                                                                     suffixText: '%',
//                                                                     // initialText: 'mono0926@gmail.com',
//                                                                   ),
//                                                                 ],
//                                                                 title: 'Discount',
//                                                                 message: 'Add Discount Percent to Cart',
//                                                               );
//                                                               mystate(() {
//                                                                 discount =double.parse(percentage![0].toString());
//                                                                 print('disss ' + discount.toString());
//                                                               });
//                                                             }
//                                                             print('dis' + result.toString());
//                                                             setState(() {
//                                                               print('do something');
//                                                             });
//
//                                                           },
//                                                           child: Padding(
//                                                             padding:
//                                                             const EdgeInsets
//                                                                 .only(
//                                                                 left: 8.0,
//                                                                 right:
//                                                                 8.0,
//                                                                 bottom:
//                                                                 3.0),
//                                                             child: Container(
//                                                                 child: Text(
//                                                                   'Discount',
//                                                                   textAlign:
//                                                                   TextAlign
//                                                                       .center,
//                                                                   style: TextStyle(
//                                                                       fontSize:
//                                                                       18,
//                                                                       fontWeight:
//                                                                       FontWeight
//                                                                           .w600,
//                                                                       color: Colors
//                                                                           .black),
//                                                                 )),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             top: 71.0,
//                                             left: 0.0,
//                                             right: 0.0),
//                                         child: Container(
//                                             child: ListView(
//                                               children: [
//                                                 Container(
//                                                   height: 52,
//                                                   width: MediaQuery.of(context).size.width,
//                                                   color: AppTheme.lightBgColor,
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                                                     child: Row(
//                                                       children: [
//                                                         Icon(
//                                                           SmartKyat_POS.order,
//                                                           size: 20,
//                                                         ),
//                                                         SizedBox(width: 5),
//                                                         Text('Customer', style: TextStyle(
//                                                           fontSize: 16, fontWeight: FontWeight.bold,
//                                                         )),
//                                                         Spacer(),
//                                                         Text(customerId.split('-')[1].toString() == 'name' ? 'Unknown' : customerId.split('-')[1], style: TextStyle(
//                                                           fontSize: 16, fontWeight: FontWeight.bold,
//                                                         )),
//                                                         SizedBox(width: 5),
//                                                         GestureDetector(
//                                                           onTap: (){
//                                                             setState(() {
//                                                               mystate((){
//                                                                 customerId = 'name-name';
//                                                               });
//                                                             });
//                                                           },
//                                                           child: Container(
//                                                             height: 18,
//                                                             width: 18,
//                                                             alignment: Alignment.center,
//                                                             decoration: BoxDecoration(
//                                                               color: AppTheme.skBorderColor2,
//                                                               borderRadius:
//                                                               BorderRadius.circular(
//                                                                   10.0),),
//                                                             child:  Icon(Icons.clear, size: 13, color: Colors.black,),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 for (int i = 0;
//                                                 i < prodList.length;
//                                                 i++)
//                                                   StreamBuilder<
//                                                       DocumentSnapshot<
//                                                           Map<String,
//                                                               dynamic>>>(
//                                                     stream: FirebaseFirestore
//                                                         .instance
//                                                         .collection('shops')
//                                                         .doc(
//                                                         shopId)
//                                                         .collection('products')
//                                                         .doc(prodList[i]
//                                                         .split('-')[0])
//                                                         .snapshots(),
//                                                     builder:
//                                                         (BuildContext context,
//                                                         snapshot2) {
//                                                       if (snapshot2.hasData) {
//                                                         var output2 = snapshot2
//                                                             .data!
//                                                             .data();
//                                                         var image = output2?[
//                                                           'img_1'];
//                                                         prodList[i] = prodList[i].split('-')[0] + '-' + output2?['prod_name'] + '-' +
//                                                             prodList[i].split('-')[2] + '-' + prodList[i].split('-')[3] + '-' + prodList[i].split('-')[4] + '-' + prodList[i].split('-')[5];
//                                                         return GestureDetector(
//                                                           onTap: (){
//                                                             print('error prod' + prodList[i].toString());
//                                                             setState((){
//                                                               mystate((){
//                                                                 quantity = 0;
//                                                                 eachProd = prodList[i];
//                                                                 unit = prodList[i].split('-')[3];
//                                                                 mainName =  output2?['unit_name'];
//                                                                 sub1Name = output2?['sub1_name'];
//                                                                 sub2Name = output2?['sub2_name'];
//                                                                 salePrice = prodList[i].split('-')[2];
//                                                                 mainLoss = output2?['Loss1'].round();
//                                                                 sub1Loss = output2?['Loss2'].round();
//                                                                 sub2Loss = output2?['Loss3'].round();
//                                                                 barcode = output2?['bar_code'];
//                                                                 mainQty = output2?['inStock1'].round();
//                                                                 sub1Qty = output2?['inStock2'].round();
//                                                                 sub2Qty = output2?['inStock3'].round();
//                                                                 productName = output2?['prod_name'];
//                                                                 myController.text = prodList[i].split('-')[4];
//                                                                 sellDone = false;
//                                                                 onChangeAmountTab = true;
//                                                                 _controller.animateTo(2);});});
//                                                           },
//                                                           child: Slidable(
//                                                             key: UniqueKey(),
//                                                             actionPane:
//                                                             SlidableDrawerActionPane(),
//                                                             actionExtentRatio:
//                                                             0.25,
//                                                             child: Stack(
//                                                               children: [
//                                                                 Container(
//                                                                   color: Colors.white,
//                                                                   child: Column(
//                                                                     children: [
//                                                                       SizedBox(height: 12),
//                                                                       ListTile(
//                                                                         leading: ClipRRect(
//                                                                             borderRadius:
//                                                                             BorderRadius
//                                                                                 .circular(
//                                                                                 5.0),
//                                                                             child: image != ""
//                                                                                 ? CachedNetworkImage(
//                                                                               imageUrl:
//                                                                               'https://riftplus.me/smartkyat_pos/api/uploads/' +
//                                                                                   image,
//                                                                               width: 58,
//                                                                               height: 58,
//                                                                               // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
//                                                                               errorWidget: (context,
//                                                                                   url,
//                                                                                   error) =>
//                                                                                   Icon(Icons
//                                                                                       .error),
//                                                                               fadeInDuration:
//                                                                               Duration(
//                                                                                   milliseconds:
//                                                                                   100),
//                                                                               fadeOutDuration:
//                                                                               Duration(
//                                                                                   milliseconds:
//                                                                                   10),
//                                                                               fadeInCurve:
//                                                                               Curves
//                                                                                   .bounceIn,
//                                                                               fit: BoxFit
//                                                                                   .cover,
//                                                                             )
//                                                                                 : CachedNetworkImage(
//                                                                               imageUrl:
//                                                                               'https://riftplus.me/smartkyat_pos/api/uploads/shark1.jpg',
//                                                                               width: 58,
//                                                                               height: 58,
//                                                                               // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
//                                                                               errorWidget: (context,
//                                                                                   url,
//                                                                                   error) =>
//                                                                                   Icon(Icons
//                                                                                       .error),
//                                                                               fadeInDuration:
//                                                                               Duration(
//                                                                                   milliseconds:
//                                                                                   100),
//                                                                               fadeOutDuration:
//                                                                               Duration(
//                                                                                   milliseconds:
//                                                                                   10),
//                                                                               fadeInCurve:
//                                                                               Curves
//                                                                                   .bounceIn,
//                                                                               fit: BoxFit
//                                                                                   .cover,
//                                                                             )),
//                                                                         title: Text(
//                                                                           output2?[
//                                                                             'prod_name'],
//                                                                           style:
//                                                                           TextStyle(
//                                                                               fontWeight: FontWeight.w500, fontSize: 16),
//                                                                         ),
//                                                                         subtitle: Padding(
//                                                                           padding: const EdgeInsets.only(top: 4.0),
//                                                                           child: Row(
//                                                                             children: [
//                                                                               Text(output2?[prodList[i].split('-')[3]] + ' ', style: TextStyle(
//                                                                                 fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
//                                                                               )),
//                                                                               if (prodList[i].split('-')[3] == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
//                                                                               else if(prodList[i].split('-')[3] == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
//                                                                               else Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
//                                                                             ],
//                                                                           ),
//                                                                         ),
//                                                                         trailing: Text('MMK ' + (int.parse(
//                                                                             prodList[i].split('-')[
//                                                                             2]) *
//                                                                             int.parse(prodList[
//                                                                             i]
//                                                                                 .split(
//                                                                                 '-')[4]))
//                                                                             .toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
//                                                                           style: TextStyle(
//                                                                             fontSize: 16,
//                                                                             fontWeight: FontWeight.w500,
//                                                                           ),),
//                                                                       ),
//                                                                       Padding(
//                                                                         padding: const EdgeInsets.only(left: 15.0),
//                                                                         child: Container(height: 12,
//                                                                           decoration: BoxDecoration(
//                                                                               border: Border(
//                                                                                 bottom:
//                                                                                 BorderSide(color: AppTheme.skBorderColor2, width: 1.0),
//                                                                               )),),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                                 Positioned(
//                                                                   top : 8,
//                                                                   left : 50,
//                                                                   child: Container(
//                                                                     height: 20,
//                                                                     width: 30,
//                                                                     alignment: Alignment.center,
//                                                                     decoration: BoxDecoration(
//                                                                         color: AppTheme.skBorderColor2,
//                                                                         borderRadius:
//                                                                         BorderRadius.circular(
//                                                                             10.0),
//                                                                         border: Border.all(
//                                                                           color: Colors.white,
//                                                                           width: 2,
//                                                                         )),
//                                                                     child: Text(prodList[i]
//                                                                         .split(
//                                                                         '-')[4], style: TextStyle(
//                                                                       fontSize: 11, fontWeight: FontWeight.w500,
//                                                                     )),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                             dismissal:
//                                                             SlidableDismissal(
//                                                               child:
//                                                               SlidableDrawerDismissal(),
//                                                               onDismissed:
//                                                                   (actionType) {
//                                                                 setState((){
//                                                                   mystate(() {
//                                                                     prodList
//                                                                         .removeAt(
//                                                                         i);
//                                                                   });
//                                                                 });
//                                                               },
//                                                             ),
//                                                             secondaryActions: <
//                                                                 Widget>[
//                                                               IconSlideAction(
//                                                                 caption: 'Delete',
//                                                                 color: Colors.red,
//                                                                 icon:
//                                                                 Icons.delete,
//                                                                 onTap: () {
//                                                                   setState((){
//                                                                     mystate(() {
//                                                                       prodList
//                                                                           .removeAt(
//                                                                           i);
//                                                                     });
//                                                                   });
//                                                                 },
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         );
//                                                       }
//                                                       return Container();
//                                                     },
//                                                   ),
//                                                 Slidable(
//                                                   key: UniqueKey(),
//                                                   actionPane:
//                                                   SlidableDrawerActionPane(),
//                                                   actionExtentRatio:
//                                                   0.25,
//
//                                                   child: Container(
//                                                     color: Colors.white,
//                                                     child: Column(
//                                                       children: [
//                                                         discount != 0.0 ? Container(
//                                                           child: isDiscount == 'percent' ?
//                                                           ListTile(
//                                                             title: Text('Discount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                                                             subtitle: Text('Percentage (' +  discountAmount.toString() + '%)', style: TextStyle(
//                                                               fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
//                                                             )),
//                                                             trailing: Text('- MMK ' + (double.parse(TtlProdListPriceInit()) - double.parse(TtlProdListPrice())).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//
//                                                           ) :  ListTile (
//                                                             title: Text('Discount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                                                             subtitle: Text('Amount applied', style: TextStyle(
//                                                               fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
//                                                             )),
//                                                             trailing: Text('- MMK ' + discount.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                                                           ),
//                                                         ) : Container(),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   dismissal:
//                                                   SlidableDismissal(
//                                                     child: SlidableDrawerDismissal(),
//                                                     onDismissed:
//                                                         (actionType) {
//                                                       mystate(() {
//                                                         discountAmount = 0.0;
//                                                         discount = 0.0;
//                                                       });
//                                                     },
//                                                   ),
//                                                   secondaryActions: <
//                                                       Widget>[
//                                                     IconSlideAction(
//                                                       caption: 'Delete',
//                                                       color: Colors.red,
//                                                       icon:
//                                                       Icons.delete,
//                                                       onTap: () =>
//                                                           mystate(() {
//                                                             discountAmount = 0.0;
//                                                             discount =0.0;
//                                                           }),
//                                                     ),
//                                                   ],
//                                                 ),
//
//
//                                                 // orderLoading?Text('Loading'):Text('')
//                                               ],
//                                             )),
//                                       ),
//                                       Align(
//                                         alignment: Alignment.bottomCenter,
//                                         child: Padding(
//                                           padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 border: Border(
//                                                   top: BorderSide(
//                                                       color:
//                                                       AppTheme.skBorderColor2,
//                                                       width: 1.0),
//                                                 )),
//                                             width: double.infinity,
//                                             height: 158,
//                                             child: Column(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                               crossAxisAlignment:
//                                               CrossAxisAlignment.end,
//                                               children: [
//                                                 ListTile(
//                                                   title: Text(
//                                                     'Total sale',
//                                                     style: TextStyle(
//                                                         fontSize: 17,
//                                                         fontWeight:
//                                                         FontWeight
//                                                             .w500),
//                                                   ),
//                                                   subtitle: int.parse(totalItems()) == 1? Text(totalItems() + ' item',
//                                                       style: TextStyle(
//                                                         fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
//                                                       )) : Text(totalItems() + ' items',
//                                                       style: TextStyle(
//                                                         fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
//                                                       )),
//                                                   trailing: Text('MMK '+
//                                                       TtlProdListPrice().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
//                                                     style: TextStyle(
//                                                         fontSize: 17,
//                                                         fontWeight:
//                                                         FontWeight
//                                                             .w500),
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
//                                                   child: GestureDetector(
//                                                     onTap: () {
//                                                       setState(() {
//                                                         mystate(() {
//                                                           totalAmount = double.parse(TtlProdListPrice());
//
//                                                         }); });
//
//                                                       print('totalAmount '+ totalAmount.toString());
//                                                       _controller.animateTo(1);
//                                                       sellDone = false;
//                                                     },
//                                                     child: Container(
//                                                       width: MediaQuery.of(context).size.width - 30,
//                                                       height: 55,
//                                                       decoration: BoxDecoration(
//                                                           borderRadius:
//                                                           BorderRadius.circular(10.0),
//                                                           color: AppTheme.themeColor),
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(
//                                                             top: 15.0,
//                                                             bottom: 15.0),
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                           children: [
//                                                             Expanded(
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                 child: Container(
//                                                                     child: Text(
//                                                                       'Checkout',
//                                                                       textAlign: TextAlign.center,
//                                                                       style: TextStyle(
//                                                                           fontSize: 18,
//                                                                           fontWeight: FontWeight.w600,
//                                                                           color: Colors.black
//                                                                       ),
//                                                                     )
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(20.0),
//                                       topRight: Radius.circular(20.0),
//                                     ),
//                                     color: Colors.white,
//                                   ),
//                                   child: Container(
//                                     width: double.infinity,
//                                     child: Stack(
//                                       children: [
//                                         Container(
//                                           width: double.infinity,
//                                           height: 71,
//                                           decoration: BoxDecoration(
//                                               border: Border(
//                                                   bottom: BorderSide(
//                                                       color: Colors.grey
//                                                           .withOpacity(0.3),
//                                                       width: 1.0))),
//                                           child: Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: 15.0,
//                                                 right: 15.0,
//                                                 top: 6),
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(customerId.split('-')[1], style: TextStyle(
//                                                   fontWeight: FontWeight.w500,
//                                                   color: Colors.grey,
//                                                 )),
//                                                 SizedBox(height: 3.5),
//                                                 Text('Cash acceptance', style: TextStyle(
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 21
//                                                 )),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 71.0,
//                                               left: 0.0,
//                                               right: 0.0),
//                                           child: Container(
//                                               child: ListView(
//                                                 children: [
//                                                   SizedBox(
//                                                     height: 15,
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                                                     child: Column(
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           Container(
//                                                               decoration: BoxDecoration(
//                                                                   borderRadius: BorderRadius.all(
//                                                                     Radius.circular(10.0),
//                                                                   ),
//                                                                   border: Border.all(
//                                                                       color: Colors.grey.withOpacity(0.2),
//                                                                       width: 1.0),
//                                                                   color: AppTheme.lightBgColor),
//                                                               height:  100,
//                                                               width: MediaQuery.of(context).size.width,
//                                                               child: Column(
//                                                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                                                 mainAxisAlignment: MainAxisAlignment.center,
//                                                                 children: [
//                                                                   Text('Total sale', style: TextStyle(
//                                                                     fontSize: 20,
//                                                                     fontWeight: FontWeight.w500,
//                                                                     color: Colors.grey,
//                                                                   )),
//                                                                   SizedBox(height: 3),
//                                                                   Text('MMK ' + TtlProdListPrice().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: TextStyle(
//                                                                     fontSize: 23, fontWeight: FontWeight.w500,
//                                                                   )),
//                                                                 ],
//                                                               )),
//                                                           SizedBox(height: 20),
//                                                           Text('MMK: Amount received', style: TextStyle(
//                                                             fontSize: 16, fontWeight: FontWeight.w500,
//                                                           )),
//                                                           SizedBox(height: 20),
//                                                           ButtonTheme(
//                                                             minWidth: double.infinity,
//                                                             //minWidth: 50,
//                                                             splashColor: AppTheme.buttonColor2,
//                                                             height: 50,
//                                                             child: FlatButton(
//                                                               color: AppTheme.buttonColor2,
//                                                               shape: RoundedRectangleBorder(
//                                                                 borderRadius: BorderRadius.circular(7.0),
//                                                                 side: BorderSide(
//                                                                   color: Colors.grey.withOpacity(0.85),
//                                                                 ),
//                                                               ),
//                                                               onPressed: () async {
//                                                                 setState(() {
//                                                                   mystate(() {
//                                                                     totalAmount =
//                                                                         double
//                                                                             .parse(
//                                                                             TtlProdListPrice());
//                                                                     _textFieldController
//                                                                         .text =
//                                                                         totalAmount
//                                                                             .toString();
//                                                                     paidAmount =
//                                                                         totalAmount;
//                                                                     if ((totalAmount -
//                                                                         paidAmount)
//                                                                         .isNegative) {
//                                                                       debt = 0;
//                                                                     } else {
//                                                                       debt =
//                                                                       (totalAmount -
//                                                                           paidAmount);
//                                                                     }
//                                                                     if ((paidAmount -
//                                                                         totalAmount)
//                                                                         .isNegative) {
//                                                                       refund =
//                                                                       0;
//                                                                     } else {
//                                                                       refund =
//                                                                       (paidAmount -
//                                                                           totalAmount);
//                                                                     }
//                                                                   });
//                                                                 });
//                                                               },
//                                                               child: Container(
//                                                                 child: Text( 'MMK ' +
//                                                                     TtlProdListPrice().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
//                                                                   style: TextStyle(
//                                                                     fontWeight: FontWeight.bold,
//                                                                     fontSize: 16,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: 20),
//                                                           Text('(OR)', style: TextStyle(
//                                                             fontSize: 16, fontWeight: FontWeight.w500,
//                                                           )),
//                                                           SizedBox(height: 20),
//                                                           Text('Type other amount', style: TextStyle(
//                                                             fontSize: 16, fontWeight: FontWeight.w500,
//                                                           )),
//                                                           SizedBox(height: 20),
//                                                           TextField(
//                                                             decoration: InputDecoration(
//                                                               enabledBorder: const OutlineInputBorder(
//                                                                 // width: 0.0 produces a thin "hairline" border
//                                                                   borderSide: const BorderSide(
//                                                                       color: AppTheme.skBorderColor, width: 2.0),
//                                                                   borderRadius: BorderRadius.all(Radius.circular(10.0))),
//
//                                                               focusedBorder: const OutlineInputBorder(
//                                                                 // width: 0.0 produces a thin "hairline" border
//                                                                   borderSide: const BorderSide(
//                                                                       color: AppTheme.skThemeColor2, width: 2.0),
//                                                                   borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                                                               contentPadding: const EdgeInsets.only(
//                                                                   left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
//                                                               suffixText: 'MMK',
//                                                               suffixStyle: TextStyle(
//                                                                 color: Colors.grey,
//                                                                 fontSize: 12,
//                                                               ),
//                                                               labelStyle: TextStyle(
//                                                                 fontWeight: FontWeight.w500,
//                                                                 color: Colors.grey,
//                                                               ),
//                                                               // errorText: 'Error message',
//                                                               labelText: 'other  amount',
//                                                               floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                                               //filled: true,
//                                                               border: OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.circular(10),
//                                                               ),
//                                                             ),
//                                                             keyboardType: TextInputType.number,
//                                                             onChanged: (value) {
//                                                               mystate(() {
//                                                                 totalAmount = double.parse(TtlProdListPrice());
//                                                                 value != '' ? paidAmount = double.parse(value) : paidAmount = 0.0;
//                                                                 if((totalAmount - paidAmount).isNegative){
//                                                                   debt = 0;
//                                                                 } else { debt = (totalAmount - paidAmount);
//                                                                 }
//                                                                 if((paidAmount - totalAmount).isNegative){
//                                                                   refund = 0;
//                                                                 } else { refund = (paidAmount - totalAmount);
//                                                                 }
//                                                               });
//                                                             },
//                                                             controller: _textFieldController,
//                                                           ),
//                                                         ]
//                                                     ),
//                                                   ),
//                                                   // orderLoading?Text('Loading'):Text('')
//                                                 ],
//                                               )),
//                                         ),
//                                         Align(
//                                           alignment: Alignment.bottomCenter,
//                                           child: Padding(
//                                             padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   border: Border(
//                                                     top: BorderSide(
//                                                         color:
//                                                         AppTheme.skBorderColor2,
//                                                         width: 1.0),
//                                                   )),
//                                               width: double.infinity,
//                                               height: 158,
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                                 crossAxisAlignment:
//                                                 CrossAxisAlignment.end,
//                                                 children: [
//                                                   debt!= 0 ? ListTile(
//                                                     title: Text(
//                                                       'Debt amount',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                     trailing: Text('- MMK '+
//                                                         debt.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ) : ListTile(
//                                                     title: Text(
//                                                       'Cash refund',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                     trailing: Text('MMK '+
//                                                         refund.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 10),
//                                                   Padding(
//                                                       padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
//                                                       child: Row(
//                                                           children: [
//                                                             GestureDetector(
//                                                               onTap: () {
//                                                                 setState((){
//                                                                   mystate(() {
//                                                                     _controller.animateTo(0);
//                                                                     _textFieldController.clear();
//                                                                     paidAmount = 0;
//                                                                     debt = 0;
//                                                                     refund = 0;
//                                                                     totalAmount = double.parse(TtlProdListPrice());
//                                                                   });
//                                                                 });
//                                                               },
//                                                               child: Container(
//                                                                 width: (MediaQuery.of(context).size.width - 45)/2,
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(
//                                                                     borderRadius:
//                                                                     BorderRadius.circular(10.0),
//                                                                     color: AppTheme.secButtonColor),
//                                                                 child: Padding(
//                                                                   padding: const EdgeInsets.only(
//                                                                       top: 15.0,
//                                                                       bottom: 15.0),
//                                                                   child: Row(
//                                                                     mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .center,
//                                                                     children: [
//                                                                       Expanded(
//                                                                         child: Padding(
//                                                                           padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                           child: Container(
//                                                                               child: Text(
//                                                                                 'Back',
//                                                                                 textAlign: TextAlign.center,
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 18,
//                                                                                     fontWeight: FontWeight.w600,
//                                                                                     color: Colors.black
//                                                                                 ),
//                                                                               )
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             Spacer(),
//                                                             GestureDetector(
//                                                               onTap: () async {
//                                                                 discountAmount = discount;
//                                                                 subList = [];
//                                                                 DateTime now = DateTime.now();
//
//                                                                 CollectionReference daily_order = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders');
//
//                                                                 int length = 0;
//                                                                 print('order creating');
//
//                                                                 await FirebaseFirestore.instance.collection('shops').doc(shopId)
//                                                                 // .where('date', isGreaterThanOrEqualTo: todayToYearStart(now))
//                                                                     .get().then((value) async {
//                                                                   length = int.parse(value.data()!['orders_length'].toString());
//                                                                   print('lengthsss' + length.toString());
//
//                                                                   length = length + 1;
//                                                                   //Check new date or not
//                                                                   var dateExist = false;
//                                                                   var dateId = '';
//
//                                                                   print('CHECK POINT 0' + deviceIdNum.toString());
//
//                                                                   print('CHECK POINT 1');
//
//                                                                   for (String str in prodList) {
//                                                                     var productsFire = FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(str.split('-')[0]);
//                                                                     // print('DATA CHECK ' + )
//                                                                     await productsFire
//                                                                         .get().then((val22) async {
//                                                                       // List<String> subSell = [];
//                                                                       subList.add(str.split('-')[0] + '-' + 'veriD' + '-' + 'buy0' + '-' + str.split('-')[4] +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + 'date');
//
//                                                                       List<String> subLink = [];
//                                                                       List<String> subName = [];
//                                                                       List<double> subStock = [];
//
//                                                                       var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(str.split('-')[0])
//                                                                           .get();
//
//                                                                       if (docSnapshot10.exists) {
//                                                                         Map<String, dynamic>? data10 = docSnapshot10.data();
//
//                                                                         for(int i = 0; i < int.parse(data10 ? ["sub_exist"]) + 1; i++) {
//                                                                           subLink.add(data10 ? ['sub' + (i+1).toString() + '_link']);
//                                                                           subName.add(data10 ? ['sub' + (i+1).toString() + '_name']);
//                                                                           print('inStock' + (i+1).toString());
//                                                                           print(' CHECKING ' + (data10 ? ['mainSellUnit']).toString());
//                                                                           subStock.add(double.parse((data10 ? ['inStock' + (i+1).toString()]).toString()));
//                                                                         }
//                                                                       }
//
//                                                                       print(subStock.toString());
//                                                                       if(str.split('-')[3] == 'unit_name') {
//                                                                         orderLengthIncrease(str.split('-')[0]);
//                                                                         decStockFromInv(str.split('-')[0], 'main', str.split('-')[4]);
//                                                                         prodSaleData(str.split('-')[0], int.parse(str.split('-')[4].toString()));
//                                                                         // await productsFire.update({
//                                                                         //   'mainSellUnit' : FieldValue.increment(int.parse(str.split('-')[4].toString())),
//                                                                         // });
//
//                                                                       } else if(str.split('-')[3] == 'sub1_name') {
//                                                                         sub1Execution(subStock, subLink, str.split('-')[0], str.split('-')[4]);
//                                                                         await productsFire.update({
//                                                                           'sub1SellUnit' : FieldValue.increment(int.parse(str.split('-')[4].toString())),
//                                                                         });
//
//                                                                       } else if(str.split('-')[3] == 'sub2_name') {
//                                                                         sub2Execution(subStock, subLink, str.split('-')[0], str.split('-')[4]);
//                                                                         await productsFire.update({
//                                                                           'sub2SellUnit' : FieldValue.increment(int.parse(str.split('-')[4].toString())),
//                                                                         });
//                                                                       }
//                                                                     });
//
//
//                                                                   }
//
//                                                                   print('subList ' + subList.toString());
//
//
//                                                                   //Order Add
//                                                                   await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders')
//                                                                   // FirebaseFirestore.instance.collection('space')
//                                                                   //     .where('date', isEqualTo: now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()))
//                                                                       .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 00:00:00'))
//                                                                       .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 23:59:59'))
//                                                                       .get()
//                                                                       .then((QuerySnapshot querySnapshot)  {
//                                                                     querySnapshot.docs.forEach((doc) {
//                                                                       dateExist = true;
//                                                                       dateId = doc.id;
//                                                                     });
//
//                                                                     if (dateExist) {
//                                                                       addDateExist(dateId, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString(), now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice() + '^' + customerId.split('-')[0] + '^pf' + '^' + debt.toString() + '^' + discountAmount.toString() + disText, length.toString());
//                                                                       Detail(dateId, now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString(), length.toString());
//                                                                       if(customerId.split('-')[0] != 'name') {
//                                                                         CusOrder(dateId,
//                                                                             now.year.toString() + zeroToTen(now.month.toString()) +
//                                                                                 zeroToTen(now.day.toString()) +
//                                                                                 zeroToTen(now.hour.toString()) +
//                                                                                 zeroToTen(now.minute.toString()) +
//                                                                                 zeroToTen(now.second.toString()) +
//                                                                                 deviceIdNum.toString() + length.toString(),
//                                                                             length.toString());
//                                                                       }
//                                                                       // daily_order.doc(dateId).update({
//                                                                       //   'daily_order': FieldValue.arrayUnion([now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice() + '^' + customerId.split('-')[0] + '^pf' + '^' + debt.toString() + '^' + discountAmount.toString() + disText]),
//                                                                       //   'each_order' : FieldValue.arrayUnion([length.toString()])
//                                                                       // }).then((value) async {
//                                                                       //   print('User updated');
//                                                                       //   setState(() {
//                                                                       //     orderLoading = false;
//                                                                       //   });
//                                                                       //   await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders').doc(dateId).collection('detail')
//                                                                       //       .doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString())
//                                                                       //       .set({
//                                                                       //     'total': TtlProdListPrice(),
//                                                                       //     'subs': subList,
//                                                                       //     'docId' : dateId,
//                                                                       //     'customerId' : customerId.split('-')[0],
//                                                                       //     'orderId' : length.toString(),
//                                                                       //     'debt' : debt,
//                                                                       //     'deviceId' : deviceIdNum.toString() + '-',
//                                                                       //     'refund' : 'FALSE',
//                                                                       //     'discount' : discountAmount.toString() + disText,
//                                                                       //   }).then((value) {
//                                                                       //     print('order added');
//                                                                       //     print('totalPrice3 ' + TtlProdListPrice());
//                                                                       //   });
//                                                                       //
//                                                                       //
//                                                                       //   if(customerId.split('-')[0] != 'name') {
//                                                                       //
//                                                                       //     await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('customers').doc(customerId.split('-')[0]).collection('orders').doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString())
//                                                                       //         .set({
//                                                                       //       'order_id': (now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString()),
//                                                                       //       'debt' : debt,
//                                                                       //       'order_pid': dateId,
//                                                                       //       'refund' : 'FALSE',
//                                                                       //       'discount' : discountAmount.toString() + disText,
//                                                                       //       'total': TtlProdListPrice(),
//                                                                       //       'deviceId' : deviceIdNum.toString() + '-',
//                                                                       //       'voucherId' : length.toString(),
//                                                                       //     }).then((value) {
//                                                                       //       print('cus order added');
//                                                                       //     }); }
//                                                                       // });
//                                                                     } else {
//
//                                                                       daily_order.add({
//                                                                         'daily_order': [now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice() + '^' + customerId.split('-')[0] + '^pf' + '^' + debt.toString() + '^' + discountAmount.toString() + disText],
//                                                                         // 'date': FieldValue.serverTimestamp(),
//                                                                         'date' : now,
//                                                                         'each_order' : FieldValue.arrayUnion([length.toString()])
//                                                                       }).then((value) async  {
//                                                                         print('totalPrice ' + TtlProdListPrice());
//                                                                         print('order added');
//                                                                         await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders').doc(value.id).collection('detail').doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString())
//                                                                             .set({
//                                                                           'total': TtlProdListPrice(),
//                                                                           'subs': subList,
//                                                                           'docId' : value.id,
//                                                                           'customerId' : customerId.split('-')[0],
//                                                                           'orderId' : length.toString(),
//                                                                           'debt' : debt,
//                                                                           'deviceId' : deviceIdNum.toString() + '-',
//                                                                           'refund' : 'FALSE',
//                                                                           'discount' : discountAmount.toString() + disText,
//                                                                         }).then((value) {
//                                                                           print('order added');
//                                                                         });
//
//                                                                         if(customerId.split('-')[0] != 'name') {
//                                                                           await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('customers').doc(customerId.split('-')[0]).collection('orders').doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString()).set({
//                                                                             'order_id': (now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString()),
//                                                                             'debt' : debt,
//                                                                             'order_pid': value.id,
//                                                                             'refund' : 'FALSE',
//                                                                             'discount' : discountAmount.toString() + disText,
//                                                                             'total': TtlProdListPrice(),
//                                                                             'deviceId' : deviceIdNum.toString() + '-',
//                                                                             'voucherId' : length.toString(),
//                                                                           })
//                                                                               .then((
//                                                                               value) {
//                                                                             print(
//                                                                                 'cus order added');
//                                                                           });
//                                                                         }
//                                                                       });
//                                                                     }
//                                                                   });
//
//                                                                   final date = DateTime.now();
//                                                                   final dueDate = date.add(Duration(days: 7));
//                                                                   final invoice = Invoice(
//                                                                     supplier: Supplier(
//                                                                       name: 'Sarah Field',
//                                                                       address: 'Sarah Street 9, Beijing, China',
//                                                                       paymentInfo: 'https://paypal.me/sarahfieldzz',
//                                                                     ),
//                                                                     customer: Customer(
//                                                                       name: 'Apple Inc.',
//                                                                       address: 'Apple Street, Cupertino, CA 95014',
//                                                                     ),
//                                                                     info: InvoiceInfo(
//                                                                       date: date,
//                                                                       dueDate: dueDate,
//                                                                       description: 'My description...',
//                                                                       number: '${DateTime.now().year}-9999',
//                                                                     ),
//                                                                     items: [
//                                                                       for(int i=0; i<prodList.length; i++)
//                                                                         InvoiceItem(
//                                                                           description: prodList[i].split('-')[1],
//                                                                           date: DateTime.now(),
//                                                                           quantity: int.parse(prodList[i].split('-')[4]),
//                                                                           vat: 0,
//                                                                           unitPrice: double.parse(prodList[i].split('-')[2]),
//                                                                         )
//
//                                                                       // InvoiceItem(
//                                                                       //   description: 'Water',
//                                                                       //   date: DateTime.now(),
//                                                                       //   quantity: 8,
//                                                                       //   vat: 0.19,
//                                                                       //   unitPrice: 0.99,
//                                                                       // ),
//                                                                       // InvoiceItem(
//                                                                       //   description: 'Orange',
//                                                                       //   date: DateTime.now(),
//                                                                       //   quantity: 3,
//                                                                       //   vat: 0.19,
//                                                                       //   unitPrice: 2.99,
//                                                                       // ),
//                                                                       // InvoiceItem(
//                                                                       //   description: 'Apple',
//                                                                       //   date: DateTime.now(),
//                                                                       //   quantity: 8,
//                                                                       //   vat: 0.19,
//                                                                       //   unitPrice: 3.99,
//                                                                       // ),
//                                                                       // InvoiceItem(
//                                                                       //   description: 'Mango',
//                                                                       //   date: DateTime.now(),
//                                                                       //   quantity: 1,
//                                                                       //   vat: 0.19,
//                                                                       //   unitPrice: 1.59,
//                                                                       // ),
//                                                                       // InvoiceItem(
//                                                                       //   description: 'Blue Berries',
//                                                                       //   date: DateTime.now(),
//                                                                       //   quantity: 5,
//                                                                       //   vat: 0.19,
//                                                                       //   unitPrice: 0.99,
//                                                                       // ),
//                                                                       // InvoiceItem(
//                                                                       //   description: 'Black',
//                                                                       //   date: DateTime.now(),
//                                                                       //   quantity: 4,
//                                                                       //   vat: 0.19,
//                                                                       //   unitPrice: 1.29,
//                                                                       // ),
//                                                                     ],
//                                                                   );
//
//
//
//                                                                   // mystate(()  {
//                                                                   //   prodList = [];
//                                                                   //   discount = 0.0;
//                                                                   //   debt =0;
//                                                                   //   refund =0;
//                                                                   // });
//                                                                   // // _controller.animateTo(0);
//                                                                   // // _controller.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);
//                                                                   //
//                                                                   // _textFieldController.clear();
//                                                                   // Navigator.pop(context);
//                                                                   // sellDone = true;
//                                                                   // //discountAmount =0.0;
//
//
//
//                                                                   pdfFile = await PdfInvoiceApi.generate(invoice, pageType);
//                                                                   mystate(() {
//                                                                     // setState(() {
//                                                                     pdfText = pdfFile!.path.toString();
//                                                                     // });
//                                                                   });
//
//
//                                                                   // mystate(()  {
//                                                                   //   prodList = [];
//                                                                   //   discount = 0.0;
//                                                                   //   debt =0;
//                                                                   //   refund =0;
//                                                                   //   //customerId = 'name-name';
//                                                                   // });
//
//
//                                                                   _controller.animateTo(3, duration: Duration(milliseconds: 0), curve: Curves.ease);
//
//
//
//                                                                 });
//
//                                                               },
//                                                               child: Container(
//                                                                 width: (MediaQuery.of(context).size.width - 45)/2,
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(
//                                                                     borderRadius:
//                                                                     BorderRadius.circular(10.0),
//                                                                     color: AppTheme.themeColor),
//                                                                 child: Padding(
//                                                                   padding: const EdgeInsets.only(
//                                                                       top: 15.0,
//                                                                       bottom: 15.0),
//                                                                   child: Row(
//                                                                     mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .center,
//                                                                     children: [
//                                                                       Expanded(
//                                                                         child: Padding(
//                                                                           padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                           child: Container(
//                                                                               child: Text(
//                                                                                 'Done',
//                                                                                 textAlign: TextAlign.center,
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 18,
//                                                                                     fontWeight: FontWeight.w600,
//                                                                                     color: Colors.black
//                                                                                 ),
//                                                                               )
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ]
//                                                       )
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(20.0),
//                                       topRight: Radius.circular(20.0),
//                                     ),
//                                     color: Colors.white,
//                                   ),
//                                   child: Container(
//                                     width: double.infinity,
//                                     child:
//                                     eachProd.length!=0 ? Stack(
//                                       children: [
//                                         Container(
//                                           width: double.infinity,
//                                           height: 71,
//                                           decoration: BoxDecoration(
//                                               border: Border(
//                                                   bottom: BorderSide(
//                                                       color: Colors.blue
//                                                           .withOpacity(0.1),
//                                                       width: 1.0))),
//                                           child:
//
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: 15.0,
//                                                 right: 15.0,
//                                                 top: 6),
//                                             child:
//                                             Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Text('MMK '+ salePrice, style: TextStyle(
//                                                       fontWeight: FontWeight.w500,
//                                                       color: Colors.grey,
//                                                     )),
//                                                     SizedBox(width: 5),
//                                                     if (unit == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
//                                                     else if(unit == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
//                                                     else if(unit == 'sub2_name') Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,)
//                                                       else Icon( Icons.check, size: 17, color: Colors.grey,),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 3.5),
//                                                 Text(productName, style: TextStyle(
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 21
//                                                 )),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 85.0,
//                                               left: 15.0,
//                                               right: 15.0),
//                                           child: Container(
//                                               child: ListView(
//                                                 children: [
//                                                   Column(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//                                                       Text('QUANTITY', style: TextStyle(
//                                                         fontWeight: FontWeight.bold,
//                                                         fontSize: 14,
//                                                         letterSpacing: 2,
//                                                         color: Colors.grey,
//                                                       ),),
//                                                       SizedBox(height: 15),
//                                                       Row(
//                                                         children: [
//                                                           GestureDetector(
//                                                             onTap: () {
//                                                               mystate(() {
//                                                                 quantity = int.parse(myController.text) -1;
//                                                                 myController.text = quantity.toString();
//                                                                 print('qqq' + quantity.toString());
//                                                               });
//                                                             },
//                                                             child: Container(
//                                                               width: (MediaQuery.of(context).size.width - 60)/3,
//                                                               height: 55,
//                                                               decoration: BoxDecoration(
//                                                                   borderRadius:
//                                                                   BorderRadius.circular(10.0),
//                                                                   color: AppTheme.themeColor),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(
//                                                                     top: 15.0,
//                                                                     bottom: 15.0),
//                                                                 child: Row(
//                                                                   mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .center,
//                                                                   children: [
//                                                                     Expanded(
//                                                                       child: Padding(
//                                                                         padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                         child: Container(
//                                                                             child: Icon(
//                                                                               Icons.remove, size: 20,
//                                                                             )
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(width: 15),
//                                                           Container(
//                                                             width: (MediaQuery.of(context).size.width - 60)/3,
//                                                             height: 55,
//                                                             child: TextField(
//                                                               textAlign: TextAlign.center,
//                                                               decoration: InputDecoration(
//                                                                 enabledBorder: const OutlineInputBorder(
//                                                                   // width: 0.0 produces a thin "hairline" border
//                                                                     borderSide: const BorderSide(
//                                                                         color: AppTheme.skBorderColor, width: 2.0),
//                                                                     borderRadius: BorderRadius.all(Radius.circular(10.0))),
//
//                                                                 focusedBorder: const OutlineInputBorder(
//                                                                   // width: 0.0 produces a thin "hairline" border
//                                                                     borderSide: const BorderSide(
//                                                                         color: AppTheme.skThemeColor2, width: 2.0),
//                                                                     borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                                                                 contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//                                                                 floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                                                 //filled: true,
//                                                                 border: OutlineInputBorder(
//                                                                   borderRadius: BorderRadius.circular(10),
//                                                                 ),
//                                                               ),
//                                                               keyboardType: TextInputType.number,
//                                                               onChanged: (value) {
//                                                                 setState(() {
//                                                                   quantity = int.parse(value);
//                                                                 });
//                                                               },
//                                                               controller: myController,
//                                                             ),
//                                                           ),
//                                                           SizedBox(width: 15),
//                                                           GestureDetector(
//                                                             onTap: () {
//                                                               setState(() {
//                                                                 mystate(() {
//                                                                   quantity = int.parse(myController.text) +1;
//                                                                   myController.text = quantity.toString();
//                                                                   print('qqq' + quantity.toString());
//                                                                 });
//                                                               });
//                                                             },
//                                                             child: Container(
//                                                               width: (MediaQuery.of(context).size.width - 60)/3,
//                                                               height: 55,
//                                                               decoration: BoxDecoration(
//                                                                   borderRadius:
//                                                                   BorderRadius.circular(10.0),
//                                                                   color: AppTheme.themeColor),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(
//                                                                     top: 15.0,
//                                                                     bottom: 15.0),
//                                                                 child: Row(
//                                                                   mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .center,
//                                                                   children: [
//                                                                     Expanded(
//                                                                       child: Padding(
//                                                                         padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                         child: Container(
//                                                                             child: Icon(
//                                                                               Icons.add, size: 20,
//                                                                             )
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       SizedBox(height: 15,),
//                                                       Text('MAIN UNIT PRICING', style: TextStyle(
//                                                         fontWeight: FontWeight.bold,
//                                                         fontSize: 14,
//                                                         letterSpacing: 2,
//                                                         color: Colors.grey,
//                                                       ),),
//                                                       SizedBox(height: 15,),
//                                                       // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                                                       //   stream: FirebaseFirestore
//                                                       //       .instance
//                                                       //       .collection('space')
//                                                       //       .doc(
//                                                       //       '0NHIS0Jbn26wsgCzVBKT')
//                                                       //       .collection('shops')
//                                                       //       .doc(
//                                                       //       shopId)
//                                                       //       .collection('products')
//                                                       //       .doc(eachProd.split('-')[0])
//                                                       //       .snapshots(),
//                                                       //   builder: (BuildContext context, snapshot2) {
//                                                       //     if (snapshot2.hasData) {
//                                                       // var output = snapshot2.data!.data();
//                                                       // // var prodName = output?['prod_name'];
//                                                       // var mainName = output?['unit_name'];
//                                                       // var sub1Name = output?['sub1_name'];
//                                                       // var sub2Name = output?['sub2_name'];
//                                                       // // var sub3Name = output?['sub3_name'];
//                                                       // var barcode = output?['bar_code'];
//                                                       // // var mainPrice = output?['unit_sell'];
//                                                       // // var sub1Price = output?['sub1_sell'];
//                                                       // // var sub2Price = output?['sub2_sell'];
//                                                       // // var sub3Price = output?['sub3_sell'];
//                                                       // // var sub1Unit = output?['sub1_link'];
//                                                       // // var sub2Unit = output?['sub2_link'];
//                                                       // // var sub3Unit = output?['sub3_link'];
//                                                       // // var subExist = output?['sub_exist'];
//                                                       // var mainLoss = output?['Loss1'].round();
//                                                       // var sub1Loss = output?['Loss2'].round();
//                                                       // var sub2Loss = output?['Loss3'].round();
//                                                       // var mainQty = output?['inStock1'].round();
//                                                       // var sub1Qty = output?['inStock2'].round();
//                                                       // var sub2Qty = output?['inStock3'].round();
//                                                       // var image = output?['img_1'];
//                                                       //return
//                                                       Container(
//                                                         height: 220,
//                                                         decoration: BoxDecoration(
//                                                           borderRadius: BorderRadius.circular(20.0),
//                                                           color: AppTheme.lightBgColor,
//                                                         ),
//                                                         child: Padding(
//                                                           padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                                                           child: Column(
//                                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                                             children: [
//                                                               Container(
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(border: Border(bottom: BorderSide(
//                                                                     color: Colors.grey
//                                                                         .withOpacity(0.2),
//                                                                     width: 1.0))),
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Text('Sell price', style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                     ),),
//                                                                     Spacer(),
//                                                                     Text('MMK ' + salePrice.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               Container(
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(
//                                                                     border: Border(
//                                                                         bottom: BorderSide(
//                                                                             color: Colors.grey
//                                                                                 .withOpacity(0.2),
//                                                                             width: 1.0))),
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Text('In stock', style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                     ),),
//                                                                     Spacer(),
//                                                                     eachProd.split('-')[3]== 'unit_name' ? Text(mainQty.toString() + ' ' + mainName, style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),) : eachProd.split('-')[3]== 'sub1_name'? Text( sub1Qty.toString() + ' ' + sub1Name, style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),) : Text(sub2Qty.toString() + ' ' + sub2Name, style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               Container(
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(
//                                                                     border: Border(
//                                                                         bottom: BorderSide(
//                                                                             color: Colors.grey
//                                                                                 .withOpacity(0.2),
//                                                                             width: 1.0))),
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Text('Loss', style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                     ),),
//                                                                     Spacer(),
//                                                                     eachProd.split('-')[3]== 'unit_name' ? Text(mainLoss.toString() + ' ' + mainName, style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),) : eachProd.split('-')[3]== 'sub1_name'? Text(sub1Loss.toString() + ' ' + sub1Name, style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),) : Text(sub2Loss.toString() + ' ' + sub2Name, style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               Container(
//                                                                 height: 55,
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Text('Barcode', style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                     ),),
//                                                                     Spacer(),
//                                                                     Text(barcode, style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       //     }
//                                                       //     return Container();
//                                                       //   },
//                                                       // ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               )),
//                                         ),
//                                         Align(
//                                           alignment: Alignment.bottomCenter,
//                                           child: Padding(
//                                             padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   border: Border(
//                                                     top: BorderSide(
//                                                         color:
//                                                         AppTheme.skBorderColor2,
//                                                         width: 1.0),
//                                                   )),
//                                               width: double.infinity,
//                                               height: 158,
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                                 crossAxisAlignment:
//                                                 CrossAxisAlignment.end,
//                                                 children: [
//                                                   ListTile(
//                                                     title: Text(
//                                                       'Total',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                     trailing: Text('MMK '+
//                                                         (int.parse(myController.text) * int.parse(salePrice)).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 10),
//                                                   Padding(
//                                                       padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
//                                                       child: Row(
//                                                           children: [
//                                                             GestureDetector(
//                                                               onTap: () {
//                                                                 setState((){
//                                                                   mystate(() {
//                                                                     _controller.animateTo(0);
//                                                                     _textFieldController.clear();
//                                                                     paidAmount = 0;
//                                                                     debt = 0;
//                                                                     refund = 0;
//                                                                     totalAmount = double.parse(TtlProdListPrice());
//                                                                   });
//                                                                 });
//                                                               },
//                                                               child: Container(
//                                                                 width: (MediaQuery.of(context).size.width - 45)/2,
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(
//                                                                     borderRadius:
//                                                                     BorderRadius.circular(10.0),
//                                                                     color: AppTheme.secButtonColor),
//                                                                 child: Padding(
//                                                                   padding: const EdgeInsets.only(
//                                                                       top: 15.0,
//                                                                       bottom: 15.0),
//                                                                   child: Row(
//                                                                     mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .center,
//                                                                     children: [
//                                                                       Expanded(
//                                                                         child: Padding(
//                                                                           padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                           child: Container(
//                                                                               child: Text(
//                                                                                 'Back',
//                                                                                 textAlign: TextAlign.center,
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 18,
//                                                                                     fontWeight: FontWeight.w600,
//                                                                                     color: Colors.black
//                                                                                 ),
//                                                                               )
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             Spacer(),
//                                                             GestureDetector(
//                                                               onTap: () {
//
//                                                                 print('eachProduct' +eachProd);
//                                                                 for (int j = 0; j < prodList.length; j++)
//                                                                   if( prodList[j].split('-')[0] == eachProd.split('-')[0] && prodList[j].split('-')[3] == eachProd.split('-')[3]){
//                                                                     setState((){
//                                                                       mystate((){
//                                                                         eachProd = eachProd.split('-')[0] +'-' + eachProd.split('-')[1]+'-'+eachProd.split('-')[2]+'-'+eachProd.split('-')[3]+ '-'+ (quantity.toString())+'-'+eachProd.split('-')[5];
//                                                                         prodList[j] = eachProd;
//                                                                       }); });
//                                                                     print('leepae' + prodList[j]);
//                                                                   } else print('leelar');
//
//
//                                                                 _controller.animateTo(0);
//                                                               },
//                                                               child: Container(
//                                                                 width: (MediaQuery.of(context).size.width - 45)/2,
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(
//                                                                     borderRadius:
//                                                                     BorderRadius.circular(10.0),
//                                                                     color: AppTheme.themeColor),
//                                                                 child: Padding(
//                                                                   padding: const EdgeInsets.only(
//                                                                       top: 15.0,
//                                                                       bottom: 15.0),
//                                                                   child: Row(
//                                                                     mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .center,
//                                                                     children: [
//                                                                       Expanded(
//                                                                         child: Padding(
//                                                                           padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                           child: Container(
//                                                                               child: Text(
//                                                                                 'Done',
//                                                                                 textAlign: TextAlign.center,
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 18,
//                                                                                     fontWeight: FontWeight.w600,
//                                                                                     color: Colors.black
//                                                                                 ),
//                                                                               )
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ]
//                                                       )
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//
//                                       ],
//                                     ) : Container(),
//                                   ),
//                                 ),
//                                 Container(
//                                   // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(20.0),
//                                       topRight: Radius.circular(20.0),
//                                     ),
//                                     color: Colors.white,
//                                   ),
//                                   child: Container(
//                                     width: double.infinity,
//                                     child: Stack(
//                                       children: [
//                                         Container(
//                                           width: double.infinity,
//                                           height: 71,
//                                           decoration: BoxDecoration(
//                                               border: Border(
//                                                   bottom: BorderSide(
//                                                       color: Colors.grey
//                                                           .withOpacity(0.3),
//                                                       width: 1.0))),
//                                           child: Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: 15.0,
//                                                 right: 15.0,
//                                                 top: 6),
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(customerId.split('-')[1], style: TextStyle(
//                                                   fontWeight: FontWeight.w500,
//                                                   color: Colors.grey,
//                                                 )),
//                                                 SizedBox(height: 3.5),
//                                                 Text('Invoice receipt', style: TextStyle(
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 21
//                                                 )),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 71.0,
//                                               left: 0.0,
//                                               right: 0.0),
//                                           child: Column(
//                                             children: [
//                                               Container(
//                                                 child: Padding(
//                                                     padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 12.0),
//                                                     child: Row(
//                                                         children: [
//                                                           GestureDetector(
//                                                             onTap: () async {
//                                                               final doc = await PdfDocument.openFile(pdfFile!.path);
//                                                               final pages = doc.pageCount;
//                                                               List<imglib.Image> images = [];
//
// // get images from all the pages
//                                                               for (int i = 1; i <= pages; i++) {
//                                                                 var page = await doc.getPage(i);
//                                                                 var imgPDF = await page.render(width: page.width.round()*5, height: page.height.round()*5);
//                                                                 var img = await imgPDF.createImageDetached();
//                                                                 var imgBytes = await img.toByteData(format: ImageByteFormat.png);
//                                                                 var libImage = imglib.decodeImage(imgBytes!.buffer
//                                                                     .asUint8List(imgBytes.offsetInBytes, imgBytes.lengthInBytes));
//                                                                 images.add(libImage!);
//                                                               }
//
// // stitch images
//                                                               int totalHeight = 0;
//                                                               images.forEach((e) {
//                                                                 totalHeight += e.height;
//                                                               });
//                                                               int totalWidth = 0;
//                                                               images.forEach((element) {
//                                                                 totalWidth = totalWidth < element.width ? element.width : totalWidth;
//                                                               });
//                                                               mergedImage = imglib.Image(totalWidth, totalHeight);
//                                                               int mergedHeight = 0;
//                                                               images.forEach((element) {
//                                                                 imglib.copyInto(mergedImage, element, dstX: 0, dstY: mergedHeight, blend: false);
//                                                                 mergedHeight += element.height;
//                                                               });
//
//                                                               // Save image as a file
//                                                               // final documentDirectory = await getExternalStorageDirectory();
//                                                               // Directory appDocDirectory = await getApplicationDocumentsDirectory();
//                                                               // File imgFile = new File(appDocDirectory.path + 'test.jpg');
//                                                               // new File(imgFile.path).writeAsBytes(imglib.encodeJpg(mergedImage));
//
//                                                               // Save to album.
//                                                               // bool? success = await ImageSave.saveImage(Uint8List.fromList(imglib.encodeJpg(mergedImage)), "demo.jpg", albumName: "demo");
//                                                               _saveImage(Uint8List.fromList(imglib.encodeJpg(mergedImage)));
//                                                             },
//                                                             child: Container(
//                                                               width: (MediaQuery.of(context).size.width - 45)* (3/4),
//                                                               height: 50,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius:
//                                                                 BorderRadius.circular(10.0),
//                                                                 color: AppTheme.secButtonColor,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(
//                                                                     top: 0.0,
//                                                                     bottom: 0.0),
//                                                                 child: Row(
//                                                                   mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .center,
//                                                                   children: [
//                                                                     Expanded(
//                                                                       child: Padding(
//                                                                         padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                         child: Container(
//                                                                             child: Text(
//                                                                               'Save as image',
//                                                                               textAlign: TextAlign.center,
//                                                                               style: TextStyle(
//                                                                                   fontSize: 18,
//                                                                                   fontWeight: FontWeight.w600,
//                                                                                   color: Colors.black
//                                                                               ),
//                                                                             )
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           Spacer(),
//                                                           GestureDetector(
//                                                             onTap: () async {
//
//                                                             },
//                                                             child: Container(
//                                                               width: (MediaQuery.of(context).size.width - 45)* (1/4),
//                                                               height: 50,
//                                                               decoration: BoxDecoration(
//                                                                   borderRadius:
//                                                                   BorderRadius.circular(10.0),
//                                                                   color: AppTheme.themeColor),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(
//                                                                     top: 0.0,
//                                                                     bottom: 0.0),
//                                                                 child: Row(
//                                                                   mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .center,
//                                                                   children: [
//                                                                     Expanded(
//                                                                       child: Padding(
//                                                                         padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
//                                                                         child: Container(
//                                                                             child: Icon(
//                                                                               Icons.print_rounded,
//                                                                               size: 25,
//                                                                               color: Colors.black,
//                                                                             )
//                                                                           // child: Text(
//                                                                           //   '',
//                                                                           //   textAlign: TextAlign.center,
//                                                                           //   style: TextStyle(
//                                                                           //       fontSize: 18,
//                                                                           //       fontWeight: FontWeight.w600,
//                                                                           //       color: Colors.black
//                                                                           //   ),
//                                                                           // )
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ]
//                                                     )
//                                                 ),
//                                               ),
//
//                                               // Container(
//                                               //   height: 500,
//                                               //   width: 200,
//                                               //   child: GestureDetector(
//                                               //       onTap: () {
//                                               //         print('clicked');
//                                               //         PdfApi.openFile(pdfFile);
//                                               //       },
//                                               //       child: PdfViewer.openFile(pdfText)
//                                               //   ),
//                                               // )
//                                               pdfText == '' ? Container() :
//                                               Expanded(
//                                                   child: GestureDetector(
//                                                       onTap: () {
//                                                         print('clicked');
//                                                         PdfApi.openFile(pdfFile!);
//                                                       },
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                                                         child: PdfViewer.openFile(pdfText),
//                                                       )
//                                                   )
//                                               ),
//                                               SizedBox(
//                                                 height: 200,
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         Align(
//                                           alignment: Alignment.bottomCenter,
//                                           child: Padding(
//                                             padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   border: Border(
//                                                     top: BorderSide(
//                                                         color:
//                                                         AppTheme.skBorderColor2,
//                                                         width: 1.0),
//                                                   )),
//                                               width: double.infinity,
//                                               height: 158,
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                                 crossAxisAlignment:
//                                                 CrossAxisAlignment.end,
//                                                 children: [
//                                                   ListTile(
//                                                     title: Text(
//                                                       'Total price',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                     trailing: Text('MMK '+
//                                                         debt.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 10),
//                                                   Padding(
//                                                       padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
//                                                       child: Row(
//                                                           children: [
//                                                             GestureDetector(
//                                                               onTap: () async {
//                                                                 setState(() {
//                                                                   mystate(()  {
//                                                                     prodList = [];
//                                                                     discount = 0.0;
//                                                                     debt =0;
//                                                                     refund =0;
//                                                                     customerId = 'name-name';
//                                                                   });
//                                                                 });
//                                                                 // _controller.animateTo(0);
//                                                                 // _controller.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);
//
//                                                                 _textFieldController.clear();
//                                                                 Navigator.pop(context);
//                                                                 sellDone = true;
//                                                                 //discountAmount =0.0;
//                                                               },
//                                                               child: Container(
//                                                                 width: (MediaQuery.of(context).size.width - 30),
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(
//                                                                     borderRadius:
//                                                                     BorderRadius.circular(10.0),
//                                                                     color: AppTheme.themeColor),
//                                                                 child: Padding(
//                                                                   padding: const EdgeInsets.only(
//                                                                       top: 15.0,
//                                                                       bottom: 15.0),
//                                                                   child: Row(
//                                                                     mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .center,
//                                                                     children: [
//                                                                       Expanded(
//                                                                         child: Padding(
//                                                                           padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                           child: Container(
//                                                                               child: Text(
//                                                                                 'Done',
//                                                                                 textAlign: TextAlign.center,
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 18,
//                                                                                     fontWeight: FontWeight.w600,
//                                                                                     color: Colors.black
//                                                                                 ),
//                                                                               )
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ]
//                                                       )
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 42,
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           child: Align(
//                             alignment: Alignment.center,
//                             child: Container(
//                               width: 50,
//                               height: 5,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(25.0),
//                                   ),
//                                   color: Colors.white.withOpacity(0.5)),
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         });
//   }
//   // addDailyExp2(priContext) {
//   //   print('BRmfo76jzim66dLrm9pj-1500-10-Phyo-unit_name-1-0-' + prodList2.toString());
//   // }
//
//   setStoreId(String id) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     // return(prefs.getString('store'));
//     prefs.setString('store', id);
//   }
//
//   getStoreId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('store');
//   }
//
//   addDailyExp2(priContext) {
//     var mainLoss = 0;
//     var sub1Loss=0;
//     var sub2Loss = 0;
//     String eachProd = '';
//     String productName = '';
//     String salePrice = '';
//     String barcode = '';
//     String mainName = '';
//     String sub1Name = '';
//     String sub2Name = '';
//     String unit = '';
//     String name ='';
//     var mainQty= 0;
//     var sub1Qty = 0;
//     var sub2Qty = 0;
//     totalAmount2 = double.parse(TtlProdListPrice2());
//     bool sellDone = true;
//     TextEditingController myController = TextEditingController();
//
//
//     // if(sellDone == true) {
//     //   _controller.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);
//     // }
//     if(sellDone == true) {
//       _controller2.animateTo(
//         0, duration: Duration(milliseconds: 0), curve: Curves.ease,);
//       _textFieldController2.clear();
//       paidAmount2 = 0;
//       debt2 = 0;
//       refund2 = 0;
//       totalAmount2 = double.parse(TtlProdListPrice2());
//       sellDone = false;
//     }
//     // if(onChangeAmountTab == true) {
//     //
//     //   onChangeAmountTab = false;
//     // }
//
//     showModalBottomSheet(
//         enableDrag: true,
//         isScrollControlled: true,
//         context: context,
//         backgroundColor: Colors.transparent,
//         builder: (BuildContext context) {
//           return StatefulBuilder(
//             builder: (BuildContext context, StateSetter mystate) {
//               _textFieldController2.addListener((){
//                 print("value: ${_textFieldController2.text}");
//                 setState(() {
//                   totalAmount2 = double.parse(TtlProdListPrice2());
//                   _textFieldController2.text != '' ? paidAmount2 = double.parse(_textFieldController2.text) : paidAmount2 = 0.0;
//                   if((totalAmount2 - paidAmount2).isNegative){
//                     debt2 = 0;
//                   } else { debt2 = (totalAmount2 - paidAmount2);
//                   }
//                   if((paidAmount2 - totalAmount2).isNegative){
//                     refund2 = 0;
//                   } else { refund2 = (paidAmount2 - totalAmount2);
//                   }
//                 });       });
//               return Scaffold(
//                 resizeToAvoidBottomInset: false,
//                 body: GestureDetector(
//                   onTap: () {
//                     FocusScope.of(context).unfocus();
//                   },
//                   child: Stack(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 60.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(15.0),
//                               topRight: Radius.circular(15.0),
//                             ),
//                             color: Colors.white,
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 15.0),
//                             child: TabBarView(
//                               physics: NeverScrollableScrollPhysics(),
//                               controller: _controller2,
//                               children: [
//                                 Container(
//                                   color: Colors.white,
//                                   height:
//                                   MediaQuery.of(context).size.height -
//                                       45,
//                                   width: double.infinity,
//                                   child: Stack(
//                                     children: [
//                                       Container(
//                                         height: 71,
//                                         decoration: BoxDecoration(
//                                             border: Border(
//                                                 bottom: BorderSide(
//                                                     color: Colors.grey
//                                                         .withOpacity(0.3),
//                                                     width: 1.0))),
//                                         child: Padding(
//                                           padding: EdgeInsets.only(
//                                               left: 15.0,
//                                               right: 15.0,
//                                               top: 0.0,
//                                               bottom: 15.0
//                                           ),
//                                           child: Row(
//                                             children: [
//                                               Container(
//                                                 width:
//                                                 (MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                     2) -
//                                                     22.5,
//                                                 height: 55,
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                     BorderRadius
//                                                         .circular(10.0),
//                                                     color: AppTheme.clearColor),
//                                                 child: Padding(
//                                                   padding:
//                                                   const EdgeInsets.only(
//                                                       top: 15.0,
//                                                       bottom: 15.0),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .center,
//                                                     children: [
//                                                       Expanded(
//                                                         child:
//                                                         GestureDetector(
//                                                           onTap: () {
//                                                             setState((){
//                                                               mystate(() {
//                                                                 prodList2 = [];
//                                                                 discount2 = 0.0;
//                                                                 discountAmount2 = 0.0;
//                                                                 debt2 =0;
//                                                                 refund2 =0;
//                                                                 merchantId = 'name-name';
//                                                               });
//                                                             });
//                                                           },
//                                                           child: Padding(
//                                                             padding:
//                                                             const EdgeInsets
//                                                                 .only(
//                                                                 left:
//                                                                 8.0,
//                                                                 right:
//                                                                 8.0,
//                                                                 bottom:
//                                                                 3.0),
//                                                             child: Container(
//                                                                 child: Text(
//                                                                   'Clear cart',
//                                                                   textAlign:
//                                                                   TextAlign
//                                                                       .center,
//                                                                   style: TextStyle(
//                                                                       fontSize:
//                                                                       18,
//                                                                       fontWeight:
//                                                                       FontWeight
//                                                                           .w600,
//                                                                       color: Colors
//                                                                           .black),
//                                                                 )),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 15.0,
//                                               ),
//                                               Container(
//                                                 width: (MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                     2) -
//                                                     22.5,
//                                                 height: 55,
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                     BorderRadius.circular(
//                                                         10.0),
//                                                     color: Colors.grey
//                                                         .withOpacity(0.5)),
//                                                 child: Padding(
//                                                   padding:
//                                                   const EdgeInsets.only(
//                                                       top: 15.0,
//                                                       bottom: 15.0),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .center,
//                                                     children: [
//                                                       Expanded(
//                                                         child:
//                                                         GestureDetector(
//                                                           onTap: () async {
//                                                             final result = await showModalActionSheet<String>(
//                                                               context: context,
//                                                               actions: [
//                                                                 SheetAction(
//                                                                   icon: Icons.info,
//                                                                   label: 'Amount',
//                                                                   key: 'amount',
//                                                                 ),
//                                                                 SheetAction(
//                                                                   icon: Icons.info,
//                                                                   label: 'Percent',
//                                                                   key: 'percent',
//                                                                 ),
//                                                               ],
//                                                             );
//                                                             mystate(() {
//                                                               isDiscount2 = result.toString();
//                                                             });
//
//                                                             if (result == 'amount') {
//                                                               final amount = await showTextInputDialog(
//                                                                 context: context,
//                                                                 textFields: [
//                                                                   DialogTextField(
//                                                                     keyboardType: TextInputType.number,
//                                                                     hintText: '0',
//                                                                     suffixText: 'MMK',
//                                                                     // initialText: 'mono0926@gmail.com',
//                                                                   ),
//                                                                 ],
//                                                                 title: 'Discount',
//                                                                 message: 'Add Discount Amount to Cart',
//                                                               );
//                                                               mystate(() {
//                                                                 discount2 =double.parse(amount![0].toString());
//                                                                 print('disss ' + discount2.toString());
//                                                               });
//
//                                                             } else {
//                                                               final percentage = await showTextInputDialog(
//                                                                 context: context,
//                                                                 textFields: [
//                                                                   DialogTextField(
//                                                                     keyboardType: TextInputType.number,
//                                                                     hintText: '0.0',
//                                                                     suffixText: '%',
//                                                                     // initialText: 'mono0926@gmail.com',
//                                                                   ),
//                                                                 ],
//                                                                 title: 'Discount',
//                                                                 message: 'Add Discount Percent to Cart',
//                                                               );
//                                                               mystate(() {
//                                                                 discount2 =double.parse(percentage![0].toString());
//                                                                 print('disss ' + discount2.toString());
//                                                               });
//                                                             }
//                                                             print('dis' + result.toString());
//                                                             setState(() {
//                                                               print('do something');
//                                                             });
//
//                                                           },
//                                                           child: Padding(
//                                                             padding:
//                                                             const EdgeInsets
//                                                                 .only(
//                                                                 left: 8.0,
//                                                                 right:
//                                                                 8.0,
//                                                                 bottom:
//                                                                 3.0),
//                                                             child: Container(
//                                                                 child: Text(
//                                                                   'Discount',
//                                                                   textAlign:
//                                                                   TextAlign
//                                                                       .center,
//                                                                   style: TextStyle(
//                                                                       fontSize:
//                                                                       18,
//                                                                       fontWeight:
//                                                                       FontWeight
//                                                                           .w600,
//                                                                       color: Colors
//                                                                           .black),
//                                                                 )),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             top: 71.0,
//                                             left: 0.0,
//                                             right: 0.0),
//                                         child: Container(
//                                             child: ListView(
//                                               children: [
//                                                 Container(
//                                                   height: 52,
//                                                   width: MediaQuery.of(context).size.width,
//                                                   color: AppTheme.lightBgColor,
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                                                     child: Row(
//                                                       children: [
//                                                         Icon(
//                                                           SmartKyat_POS.merchant,
//                                                           size: 20,
//                                                         ),
//                                                         SizedBox(width: 5),
//                                                         Text('Merchant', style: TextStyle(
//                                                           fontSize: 16, fontWeight: FontWeight.bold,
//                                                         )),
//                                                         Spacer(),
//                                                         Text(merchantId.split('-')[1].toString() == 'name' ? 'Unknown' : merchantId.split('-')[1] , style: TextStyle(
//                                                           fontSize: 16, fontWeight: FontWeight.bold,
//                                                         )),
//                                                         SizedBox(width: 5),
//                                                         GestureDetector(
//                                                           onTap: (){
//                                                             setState(() {
//                                                               mystate((){
//                                                                 merchantId = 'name-name';
//                                                               });
//                                                             });
//                                                           },
//                                                           child: Container(
//                                                             height: 18,
//                                                             width: 18,
//                                                             alignment: Alignment.center,
//                                                             decoration: BoxDecoration(
//                                                               color: AppTheme.skBorderColor2,
//                                                               borderRadius:
//                                                               BorderRadius.circular(
//                                                                   10.0),),
//                                                             child:  Icon(Icons.clear, size: 13, color: Colors.black,),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 for (int i = 0;
//                                                 i < prodList2.length;
//                                                 i++)
//                                                   StreamBuilder<
//                                                       DocumentSnapshot<
//                                                           Map<String,
//                                                               dynamic>>>(
//                                                     stream: FirebaseFirestore
//                                                         .instance
//                                                         .collection('shops')
//                                                         .doc(
//                                                         shopId)
//                                                         .collection('products')
//                                                         .doc(prodList2[i]
//                                                         .split('-')[0])
//                                                         .snapshots(),
//                                                     builder:
//                                                         (BuildContext context,
//                                                         snapshot2) {
//                                                       if (snapshot2.hasData) {
//                                                         var output2 = snapshot2
//                                                             .data!
//                                                             .data();
//                                                         var image = output2?[
//                                                           'img_1'];
//                                                         prodList2[i] = prodList2[i].split('-')[0] + '-' + prodList2[i].split('-')[1] + '-' +
//                                                             prodList2[i].split('-')[2] + '-' + prodList2[i].split('-')[3] + '-' + prodList2[i].split('-')[4] + '-' + prodList2[i].split('-')[5] +'-' + prodList2[i].split('-')[6];
//                                                         return GestureDetector(
//                                                           onTap: (){
//                                                             print('error prod' + prodList2[i].toString());
//                                                             setState((){
//                                                               mystate((){
//                                                                 quantity2 = 0;
//                                                                 eachProd = prodList2[i];
//                                                                 unit = prodList2[i].split('-')[4];
//                                                                 mainName =  output2?['unit_name'];
//                                                                 sub1Name = output2?['sub1_name'];
//                                                                 sub2Name = output2?['sub2_name'];
//                                                                 salePrice = prodList2[i].split('-')[1];
//                                                                 mainLoss = output2?['Loss1'].round();
//                                                                 sub1Loss = output2?['Loss2'].round();
//                                                                 sub2Loss = output2?['Loss3'].round();
//                                                                 barcode = output2?['bar_code'];
//                                                                 mainQty = output2?['inStock1'].round();
//                                                                 sub1Qty = output2?['inStock2'].round();
//                                                                 sub2Qty = output2?['inStock3'].round();
//                                                                 productName = output2?['prod_name'];
//                                                                 myController.text = prodList2[i].split('-')[2];
//                                                                 sellDone = false;
//                                                                 onChangeAmountTab = true;
//                                                                 _controller2.animateTo(2);});});
//                                                           },
//                                                           child: Slidable(
//                                                             key: UniqueKey(),
//                                                             actionPane:
//                                                             SlidableDrawerActionPane(),
//                                                             actionExtentRatio:
//                                                             0.25,
//                                                             child: Stack(
//                                                               children: [
//                                                                 Container(
//                                                                   color: Colors.white,
//                                                                   child: Column(
//                                                                     children: [
//                                                                       SizedBox(height: 12),
//                                                                       ListTile(
//                                                                         leading: ClipRRect(
//                                                                             borderRadius:
//                                                                             BorderRadius
//                                                                                 .circular(
//                                                                                 5.0),
//                                                                             child: image != ""
//                                                                                 ? CachedNetworkImage(
//                                                                               imageUrl:
//                                                                               'https://riftplus.me/smartkyat_pos/api/uploads/' +
//                                                                                   image,
//                                                                               width: 58,
//                                                                               height: 58,
//                                                                               // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
//                                                                               errorWidget: (context,
//                                                                                   url,
//                                                                                   error) =>
//                                                                                   Icon(Icons
//                                                                                       .error),
//                                                                               fadeInDuration:
//                                                                               Duration(
//                                                                                   milliseconds:
//                                                                                   100),
//                                                                               fadeOutDuration:
//                                                                               Duration(
//                                                                                   milliseconds:
//                                                                                   10),
//                                                                               fadeInCurve:
//                                                                               Curves
//                                                                                   .bounceIn,
//                                                                               fit: BoxFit
//                                                                                   .cover,
//                                                                             )
//                                                                                 : CachedNetworkImage(
//                                                                               imageUrl:
//                                                                               'https://riftplus.me/smartkyat_pos/api/uploads/shark1.jpg',
//                                                                               width: 58,
//                                                                               height: 58,
//                                                                               // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
//                                                                               errorWidget: (context,
//                                                                                   url,
//                                                                                   error) =>
//                                                                                   Icon(Icons
//                                                                                       .error),
//                                                                               fadeInDuration:
//                                                                               -  Duration(
//                                                                                   milliseconds:
//                                                                                   100),
//                                                                               fadeOutDuration:
//                                                                               Duration(
//                                                                                   milliseconds:
//                                                                                   10),
//                                                                               fadeInCurve:
//                                                                               Curves
//                                                                                   .bounceIn,
//                                                                               fit: BoxFit
//                                                                                   .cover,
//                                                                             )),
//                                                                         title: Text(
//                                                                           output2?[
//                                                                             'prod_name'],
//                                                                           style:
//                                                                           TextStyle(
//                                                                               fontWeight: FontWeight.w500, fontSize: 16),
//                                                                         ),
//                                                                         subtitle: Padding(
//                                                                           padding: const EdgeInsets.only(top: 4.0),
//                                                                           child: Row(
//                                                                             children: [
//                                                                               Text(output2?[prodList2[i].split('-')[4]] + ' ', style: TextStyle(
//                                                                                 fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
//                                                                               )),
//                                                                               if (prodList2[i].split('-')[4] == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
//                                                                               else if(prodList2[i].split('-')[4] == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
//                                                                               else Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,),
//                                                                             ],
//                                                                           ),
//                                                                         ),
//                                                                         trailing: Text('MMK ' + (int.parse(
//                                                                             prodList2[i].split('-')[
//                                                                             1]) *
//                                                                             int.parse(prodList2[
//                                                                             i]
//                                                                                 .split(
//                                                                                 '-')[2]))
//                                                                             .toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
//                                                                           style: TextStyle(
//                                                                             fontSize: 16,
//                                                                             fontWeight: FontWeight.w500,
//                                                                           ),),
//                                                                       ),
//                                                                       Padding(
//                                                                         padding: const EdgeInsets.only(left: 15.0),
//                                                                         child: Container(height: 12,
//                                                                           decoration: BoxDecoration(
//                                                                               border: Border(
//                                                                                 bottom:
//                                                                                 BorderSide(color: AppTheme.skBorderColor2, width: 1.0),
//                                                                               )),),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                                 Positioned(
//                                                                   top : 8,
//                                                                   left : 50,
//                                                                   child: Container(
//                                                                     height: 20,
//                                                                     width: 30,
//                                                                     alignment: Alignment.center,
//                                                                     decoration: BoxDecoration(
//                                                                         color: AppTheme.skBorderColor2,
//                                                                         borderRadius:
//                                                                         BorderRadius.circular(
//                                                                             10.0),
//                                                                         border: Border.all(
//                                                                           color: Colors.white,
//                                                                           width: 2,
//                                                                         )),
//                                                                     child: Text(prodList2[i]
//                                                                         .split(
//                                                                         '-')[2], style: TextStyle(
//                                                                       fontSize: 11, fontWeight: FontWeight.w500,
//                                                                     )),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                             dismissal:
//                                                             SlidableDismissal(
//                                                               child:
//                                                               SlidableDrawerDismissal(),
//                                                               onDismissed:
//                                                                   (actionType) {
//                                                                 setState((){
//                                                                   mystate(() {
//                                                                     prodList2
//                                                                         .removeAt(
//                                                                         i);
//                                                                   });
//                                                                 });
//                                                               },
//                                                             ),
//                                                             secondaryActions: <
//                                                                 Widget>[
//                                                               IconSlideAction(
//                                                                 caption: 'Delete',
//                                                                 color: Colors.red,
//                                                                 icon:
//                                                                 Icons.delete,
//                                                                 onTap: () {
//                                                                   setState((){
//                                                                     mystate(() {
//                                                                       prodList2
//                                                                           .removeAt(
//                                                                           i);
//                                                                     });
//                                                                   });
//                                                                 },
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         );
//                                                       }
//                                                       return Container();
//                                                     },
//                                                   ),
//                                                 Slidable(
//                                                   key: UniqueKey(),
//                                                   actionPane:
//                                                   SlidableDrawerActionPane(),
//                                                   actionExtentRatio:
//                                                   0.25,
//
//                                                   child: Container(
//                                                     color: Colors.white,
//                                                     child: Column(
//                                                       children: [
//                                                         discount2 != 0.0 ? Container(
//                                                           child: isDiscount2 == 'percent' ?
//                                                           ListTile(
//                                                             title: Text('Discount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                                                             subtitle: Text('Percentage (' +  discountAmount2.toString() + '%)', style: TextStyle(
//                                                               fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
//                                                             )),
//                                                             trailing: Text('- MMK ' + (double.parse(TtlProdListPriceInit2()) - double.parse(TtlProdListPrice2())).toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//
//                                                           ) :  ListTile (
//                                                             title: Text('Discount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                                                             subtitle: Text('Amount applied', style: TextStyle(
//                                                               fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
//                                                             )),
//                                                             trailing: Text('- MMK ' + discount2.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                                                           ),
//                                                         ) : Container(),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   dismissal:
//                                                   SlidableDismissal(
//                                                     child: SlidableDrawerDismissal(),
//                                                     onDismissed:
//                                                         (actionType) {
//                                                       mystate(() {
//                                                         discountAmount2 = 0.0;
//                                                         discount2 = 0.0;
//                                                       });
//                                                     },
//                                                   ),
//                                                   secondaryActions: <
//                                                       Widget>[
//                                                     IconSlideAction(
//                                                       caption: 'Delete',
//                                                       color: Colors.red,
//                                                       icon:
//                                                       Icons.delete,
//                                                       onTap: () =>
//                                                           mystate(() {
//                                                             discountAmount2 = 0.0;
//                                                             discount2 =0.0;
//                                                           }),
//                                                     ),
//                                                   ],
//                                                 ),
//
//
//                                                 // orderLoading?Text('Loading'):Text('')
//                                               ],
//                                             )),
//                                       ),
//                                       Align(
//                                         alignment: Alignment.bottomCenter,
//                                         child: Padding(
//                                           padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 border: Border(
//                                                   top: BorderSide(
//                                                       color:
//                                                       AppTheme.skBorderColor2,
//                                                       width: 1.0),
//                                                 )),
//                                             width: double.infinity,
//                                             height: 158,
//                                             child: Column(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                               crossAxisAlignment:
//                                               CrossAxisAlignment.end,
//                                               children: [
//                                                 ListTile(
//                                                   title: Text(
//                                                     'Total sale',
//                                                     style: TextStyle(
//                                                         fontSize: 17,
//                                                         fontWeight:
//                                                         FontWeight
//                                                             .w500),
//                                                   ),
//                                                   subtitle: int.parse(totalItems2()) == 1? Text(totalItems2() + ' item',
//                                                       style: TextStyle(
//                                                         fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
//                                                       )) : Text(totalItems2() + ' items',
//                                                       style: TextStyle(
//                                                         fontSize: 12.5, fontWeight: FontWeight.w500, color: Colors.grey,
//                                                       )),
//                                                   trailing: Text('MMK '+
//                                                       TtlProdListPrice2().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
//                                                     style: TextStyle(
//                                                         fontSize: 17,
//                                                         fontWeight:
//                                                         FontWeight
//                                                             .w500),
//                                                   ),
//                                                 ),
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
//                                                   child: GestureDetector(
//                                                     onTap: () {
//                                                       setState(() {
//                                                         mystate(() {
//                                                           totalAmount2 = double.parse(TtlProdListPrice2());
//
//                                                         }); });
//
//                                                       print('totalAmount '+ totalAmount2.toString());
//                                                       _controller2.animateTo(1);
//                                                       sellDone = false;
//                                                     },
//                                                     child: Container(
//                                                       width: MediaQuery.of(context).size.width - 30,
//                                                       height: 55,
//                                                       decoration: BoxDecoration(
//                                                           borderRadius:
//                                                           BorderRadius.circular(10.0),
//                                                           color: AppTheme.themeColor),
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(
//                                                             top: 15.0,
//                                                             bottom: 15.0),
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                           children: [
//                                                             Expanded(
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                 child: Container(
//                                                                     child: Text(
//                                                                       'Checkout',
//                                                                       textAlign: TextAlign.center,
//                                                                       style: TextStyle(
//                                                                           fontSize: 18,
//                                                                           fontWeight: FontWeight.w600,
//                                                                           color: Colors.black
//                                                                       ),
//                                                                     )
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(20.0),
//                                       topRight: Radius.circular(20.0),
//                                     ),
//                                     color: Colors.white,
//                                   ),
//                                   child: Container(
//                                     width: double.infinity,
//                                     child: Stack(
//                                       children: [
//                                         Container(
//                                           width: double.infinity,
//                                           height: 71,
//                                           decoration: BoxDecoration(
//                                               border: Border(
//                                                   bottom: BorderSide(
//                                                       color: Colors.grey
//                                                           .withOpacity(0.3),
//                                                       width: 1.0))),
//                                           child: Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: 15.0,
//                                                 right: 15.0,
//                                                 top: 6),
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(merchantId.split('-')[1], style: TextStyle(
//                                                   fontWeight: FontWeight.w500,
//                                                   color: Colors.grey,
//                                                 )),
//                                                 SizedBox(height: 3.5),
//                                                 Text('Cash acceptance', style: TextStyle(
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 21
//                                                 )),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 71.0,
//                                               left: 0.0,
//                                               right: 0.0),
//                                           child: Container(
//                                               child: ListView(
//                                                 children: [
//                                                   SizedBox(
//                                                     height: 15,
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                                                     child: Column(
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           Container(
//                                                               decoration: BoxDecoration(
//                                                                   borderRadius: BorderRadius.all(
//                                                                     Radius.circular(10.0),
//                                                                   ),
//                                                                   border: Border.all(
//                                                                       color: Colors.grey.withOpacity(0.2),
//                                                                       width: 1.0),
//                                                                   color: AppTheme.lightBgColor),
//                                                               height:  100,
//                                                               width: MediaQuery.of(context).size.width,
//                                                               child: Column(
//                                                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                                                 mainAxisAlignment: MainAxisAlignment.center,
//                                                                 children: [
//                                                                   Text('Total sale', style: TextStyle(
//                                                                     fontSize: 20,
//                                                                     fontWeight: FontWeight.w500,
//                                                                     color: Colors.grey,
//                                                                   )),
//                                                                   SizedBox(height: 3),
//                                                                   Text('MMK ' + TtlProdListPrice2().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: TextStyle(
//                                                                     fontSize: 23, fontWeight: FontWeight.w500,
//                                                                   )),
//                                                                 ],
//                                                               )),
//                                                           SizedBox(height: 20),
//                                                           Text('MMK: Amount received', style: TextStyle(
//                                                             fontSize: 16, fontWeight: FontWeight.w500,
//                                                           )),
//                                                           SizedBox(height: 20),
//                                                           ButtonTheme(
//                                                             minWidth: double.infinity,
//                                                             //minWidth: 50,
//                                                             splashColor: AppTheme.buttonColor2,
//                                                             height: 50,
//                                                             child: FlatButton(
//                                                               color: AppTheme.buttonColor2,
//                                                               shape: RoundedRectangleBorder(
//                                                                 borderRadius: BorderRadius.circular(7.0),
//                                                                 side: BorderSide(
//                                                                   color: Colors.grey.withOpacity(0.85),
//                                                                 ),
//                                                               ),
//                                                               onPressed: () async {
//                                                                 setState(() {
//                                                                   mystate(() {
//                                                                     totalAmount2 =
//                                                                         double
//                                                                             .parse(
//                                                                             TtlProdListPrice2());
//                                                                     _textFieldController2
//                                                                         .text =
//                                                                         totalAmount2
//                                                                             .toString();
//                                                                     paidAmount2 =
//                                                                         totalAmount2;
//                                                                     if ((totalAmount2 -
//                                                                         paidAmount2)
//                                                                         .isNegative) {
//                                                                       debt2 = 0;
//                                                                     } else {
//                                                                       debt2 =
//                                                                       (totalAmount2 -
//                                                                           paidAmount2);
//                                                                     }
//                                                                     if ((paidAmount2 -
//                                                                         totalAmount2)
//                                                                         .isNegative) {
//                                                                       refund2 =
//                                                                       0;
//                                                                     } else {
//                                                                       refund2 =
//                                                                       (paidAmount2 -
//                                                                           totalAmount2);
//                                                                     }
//                                                                   });
//                                                                 });
//                                                               },
//                                                               child: Container(
//                                                                 child: Text( 'MMK ' +
//                                                                     TtlProdListPrice2().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
//                                                                   style: TextStyle(
//                                                                     fontWeight: FontWeight.bold,
//                                                                     fontSize: 16,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(height: 20),
//                                                           Text('(OR)', style: TextStyle(
//                                                             fontSize: 16, fontWeight: FontWeight.w500,
//                                                           )),
//                                                           SizedBox(height: 20),
//                                                           Text('Type other amount', style: TextStyle(
//                                                             fontSize: 16, fontWeight: FontWeight.w500,
//                                                           )),
//                                                           SizedBox(height: 20),
//                                                           TextField(
//                                                             decoration: InputDecoration(
//                                                               enabledBorder: const OutlineInputBorder(
//                                                                 // width: 0.0 produces a thin "hairline" border
//                                                                   borderSide: const BorderSide(
//                                                                       color: AppTheme.skBorderColor, width: 2.0),
//                                                                   borderRadius: BorderRadius.all(Radius.circular(10.0))),
//
//                                                               focusedBorder: const OutlineInputBorder(
//                                                                 // width: 0.0 produces a thin "hairline" border
//                                                                   borderSide: const BorderSide(
//                                                                       color: AppTheme.skThemeColor2, width: 2.0),
//                                                                   borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                                                               contentPadding: const EdgeInsets.only(
//                                                                   left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
//                                                               suffixText: 'MMK',
//                                                               suffixStyle: TextStyle(
//                                                                 color: Colors.grey,
//                                                                 fontSize: 12,
//                                                               ),
//                                                               labelStyle: TextStyle(
//                                                                 fontWeight: FontWeight.w500,
//                                                                 color: Colors.grey,
//                                                               ),
//                                                               // errorText: 'Error message',
//                                                               labelText: 'other  amount',
//                                                               floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                                               //filled: true,
//                                                               border: OutlineInputBorder(
//                                                                 borderRadius: BorderRadius.circular(10),
//                                                               ),
//                                                             ),
//                                                             keyboardType: TextInputType.number,
//                                                             onChanged: (value) {
//                                                               mystate(() {
//                                                                 totalAmount2 = double.parse(TtlProdListPrice2());
//                                                                 value != '' ? paidAmount2 = double.parse(value) : paidAmount2 = 0.0;
//                                                                 if((totalAmount2 - paidAmount2).isNegative){
//                                                                   debt2 = 0;
//                                                                 } else { debt2 = (totalAmount2 - paidAmount2);
//                                                                 }
//                                                                 if((paidAmount2 - totalAmount2).isNegative){
//                                                                   refund2 = 0;
//                                                                 } else { refund2 = (paidAmount2 - totalAmount2);
//                                                                 }
//                                                               });
//                                                             },
//                                                             controller: _textFieldController2,
//                                                           ),
//                                                         ]
//                                                     ),
//                                                   ),
//                                                   // orderLoading?Text('Loading'):Text('')
//                                                 ],
//                                               )),
//                                         ),
//                                         Align(
//                                           alignment: Alignment.bottomCenter,
//                                           child: Padding(
//                                             padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   border: Border(
//                                                     top: BorderSide(
//                                                         color:
//                                                         AppTheme.skBorderColor2,
//                                                         width: 1.0),
//                                                   )),
//                                               width: double.infinity,
//                                               height: 158,
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                                 crossAxisAlignment:
//                                                 CrossAxisAlignment.end,
//                                                 children: [
//                                                   debt2!= 0 ? ListTile(
//                                                     title: Text(
//                                                       'Debt amount',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                     trailing: Text('- MMK '+
//                                                         debt2.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ) : ListTile(
//                                                     title: Text(
//                                                       'Cash refund',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                     trailing: Text('MMK '+
//                                                         refund2.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 10),
//                                                   Padding(
//                                                       padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
//                                                       child: Row(
//                                                           children: [
//                                                             GestureDetector(
//                                                               onTap: () {
//                                                                 setState((){
//                                                                   mystate(() {
//                                                                     _controller2.animateTo(0);
//                                                                     _textFieldController2.clear();
//                                                                     paidAmount2 = 0;
//                                                                     debt2 = 0;
//                                                                     refund2 = 0;
//                                                                     totalAmount2 = double.parse(TtlProdListPrice2());
//                                                                   });
//                                                                 });
//                                                               },
//                                                               child: Container(
//                                                                 width: (MediaQuery.of(context).size.width - 45)/2,
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(
//                                                                     borderRadius:
//                                                                     BorderRadius.circular(10.0),
//                                                                     color: AppTheme.secButtonColor),
//                                                                 child: Padding(
//                                                                   padding: const EdgeInsets.only(
//                                                                       top: 15.0,
//                                                                       bottom: 15.0),
//                                                                   child: Row(
//                                                                     mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .center,
//                                                                     children: [
//                                                                       Expanded(
//                                                                         child: Padding(
//                                                                           padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                           child: Container(
//                                                                               child: Text(
//                                                                                 'Back',
//                                                                                 textAlign: TextAlign.center,
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 18,
//                                                                                     fontWeight: FontWeight.w600,
//                                                                                     color: Colors.black
//                                                                                 ),
//                                                                               )
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             Spacer(),
//                                                             GestureDetector(
//                                                               onTap: () async {
//                                                                 discountAmount2 = discount2;
//                                                                 subList = [];
//                                                                 DateTime now = DateTime.now();
//
//                                                                 CollectionReference daily_order = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders');
//                                                                 int length = 0;
//                                                                 print('order creating here2');
//
//                                                                 await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders').get().then((QuerySnapshot querySnapshot) async {
//                                                                   querySnapshot.docs.forEach((doc) {
//                                                                     length += int.parse(doc['daily_order'].length.toString());
//                                                                   });
//                                                                   length = 1000 + length + 1;
//                                                                   //Check new date or not
//                                                                   var dateExist = false;
//                                                                   var dateId = '';
//
//
//
//                                                                   for (String str in prodList2) {
//                                                                     // List<String> subSell = [];
//                                                                     subList.add(str.split('-')[0] + '-' + 'veriD' + '-' + 'buy0' + '-' + str.split('-')[2] +'-' + str.split('-')[1] + '-' + str.split('-')[4] +'-' + str.split('-')[2] + '-0-' + 'date');
//
//                                                                     List<String> subLink = [];
//                                                                     List<String> subName = [];
//                                                                     List<double> subStock = [];
//
//                                                                     var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(str.split('-')[0])
//                                                                         .get();
//
//                                                                     if (docSnapshot10.exists) {
//                                                                       Map<String, dynamic>? data10 = docSnapshot10.data();
//
//                                                                       for(int i = 0; i < int.parse(data10 ? ["sub_exist"]) + 1; i++) {
//                                                                         subLink.add(data10 ? ['sub' + (i+1).toString() + '_link']);
//                                                                         subName.add(data10 ? ['sub' + (i+1).toString() + '_name']);
//                                                                         print('inStock' + (i+1).toString());
//                                                                         subStock.add(double.parse((data10 ? ['inStock' + (i+1).toString()]).toString()));
//                                                                       }
//                                                                     }
//
//                                                                     print(subStock.toString());
//
//                                                                     if(str.split('-')[4]=='unit_name') {
//                                                                       await FirebaseFirestore.instance.collection('shops').doc(
//                                                                           shopId).collection('products').doc(
//                                                                           str.split('-')[0])
//                                                                           .update({
//                                                                         'inStock1': FieldValue.increment(double.parse(str.split('-')[2].toString())),
//                                                                         'buyPrice1': str.split('-')[1].toString(),
//                                                                       })
//                                                                           .then((value) => print("User Updated"))
//                                                                           .catchError((error) => print("Failed to update user: $error"));
//                                                                     }
//                                                                     else if (str.split('-')[4]=='sub1_name') {
//                                                                       await FirebaseFirestore.instance.collection('shops').doc(
//                                                                           shopId).collection('products').doc(
//                                                                           str.split('-')[0])
//                                                                           .update({
//                                                                         'inStock2': FieldValue.increment(double.parse(str.split('-')[2].toString())),
//                                                                         'buyPrice2': str.split('-')[1].toString(),
//                                                                       })
//                                                                           .then((value) => print("User Updated"))
//                                                                           .catchError((error) => print("Failed to update user: $error"));
//
//                                                                     } else if (str.split('-')[4]=='sub2_name') {
//                                                                       await FirebaseFirestore.instance.collection('shops').doc(
//                                                                           shopId).collection('products').doc(
//                                                                           str.split('-')[0])
//                                                                           .update({
//                                                                         'inStock3': FieldValue.increment(double.parse(str.split('-')[2].toString())),
//                                                                         'buyPrice3' : str.split('-')[1].toString(),
//                                                                       })
//                                                                           .then((value) => print("User Updated"))
//                                                                           .catchError((error) => print("Failed to update user: $error"));
//                                                                     }
//                                                                   }
//                                                                   await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders')
//                                                                   // FirebaseFirestore.instance.collection('space')
//                                                                       .where('date', isGreaterThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 00:00:00'))
//                                                                       .where('date', isLessThanOrEqualTo: DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-' + zeroToTen(now.month.toString()) + '-' + zeroToTen(now.day.toString()) + ' 23:59:59'))
//                                                                       .get()
//                                                                       .then((QuerySnapshot querySnapshot) {
//                                                                     querySnapshot.docs.forEach((doc) {
//                                                                       dateExist = true;
//                                                                       dateId = doc.id;
//                                                                     });
//
//                                                                     if (dateExist) {
//                                                                       daily_order.doc(dateId).update({
//                                                                         'daily_order': FieldValue.arrayUnion([now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice2() + '^' + merchantId.split('-')[0] + '^pf' + '^' + debt2.toString() + '^' + discountAmount2.toString() + disText2]),
//                                                                         'each_order' : FieldValue.arrayUnion([length.toString()])
//                                                                       }).then((value) async {
//                                                                         print('User updated');
//                                                                         setState(() {
//                                                                           orderLoading = false;
//                                                                         });
//
//                                                                         await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders').doc(dateId).collection('expansion')
//                                                                             .doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString())
//                                                                             .set({
//                                                                           'total': TtlProdListPrice2(),
//                                                                           'subs': subList,
//                                                                           'docId' : dateId,
//                                                                           'merchantId' : merchantId.split('-')[0],
//                                                                           'orderId' : length.toString(),
//                                                                           'debt' : debt2,
//                                                                           'deviceId' : deviceIdNum.toString() + '-',
//                                                                           'refund' : 'FALSE',
//                                                                           'discount' : discountAmount2.toString() + disText2,
//                                                                         }).then((value) {
//                                                                           print('order added');
//                                                                         });
//
//                                                                         if(merchantId.split('-')[0] != 'name') {
//
//                                                                           await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('merchants').doc(merchantId.split('-')[0]).collection('buyOrders').doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString())
//                                                                               .set({
//                                                                             'order_id': (now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString()),
//                                                                             'debt' : debt2,
//                                                                             'order_pid': dateId,
//                                                                             'refund' : 'FALSE',
//                                                                             'discount' : discountAmount2.toString() + disText2,
//                                                                             'total': TtlProdListPrice2(),
//                                                                             'deviceId' : deviceIdNum.toString() + '-',
//                                                                             'voucherId' : length.toString(),
//                                                                           }).then((value) {
//                                                                             print('cus order added');
//                                                                           }); }
//                                                                       });
//                                                                     } else {
//                                                                       daily_order.add({
//                                                                         'daily_order': [now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice2() + '^' + merchantId.split('-')[0] + '^pf' + '^' + debt2.toString() + '^' + discountAmount2.toString() + disText2],
//                                                                         // 'date': FieldValue.serverTimestamp(),
//                                                                         'date' : now,
//                                                                         'each_order' : FieldValue.arrayUnion([length.toString()])
//                                                                       }).then((value) async  {
//                                                                         print('order added');
//                                                                         await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrders').doc(value.id).collection('expansion').doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString())
//                                                                             .set({
//                                                                           'total': TtlProdListPrice2(),
//                                                                           'subs': subList,
//                                                                           'docId' : value.id,
//                                                                           'merchantId' : merchantId.split('-')[0],
//                                                                           'orderId' : length.toString(),
//                                                                           'debt' : debt2,
//                                                                           'deviceId' : deviceIdNum.toString() + '-',
//                                                                           'refund' : 'FALSE',
//                                                                           'discount' : discountAmount2.toString() + disText2,
//                                                                         }).then((value) {
//                                                                           print('order added');
//                                                                         });
//                                                                         if(merchantId.split('-')[0] != 'name') {
//                                                                           await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('merchants').doc(merchantId.split('-')[0]).collection('buyOrders').doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString()).set({
//                                                                             'order_id': (now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString()),
//                                                                             'debt' : debt2,
//                                                                             'order_pid': value.id,
//                                                                             'refund' : 'FALSE',
//                                                                             'discount' : discountAmount2.toString() + disText2,
//                                                                             'total': TtlProdListPrice2(),
//                                                                             'deviceId' : deviceIdNum.toString() + '-',
//                                                                             'voucherId' : length.toString(),
//                                                                           })
//                                                                               .then((
//                                                                               value) {
//                                                                             print(
//                                                                                 'cus order added');
//                                                                           });
//                                                                         }
//                                                                       });
//                                                                     }
//                                                                   });
//
//                                                                 }
//                                                                 );
//                                                                 // setState(() {
//                                                                 //   mystate(()  {
//                                                                 //     prodList2 = [];
//                                                                 //     discount = 0.0;
//                                                                 //     debt =0;
//                                                                 //     refund =0;
//                                                                 //     merchantId = 'name-name';
//                                                                 //   });
//                                                                 // });
//                                                                 // _controller.animateTo(0);
//                                                                 // _controller.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);
//
//                                                                 //_textFieldController2.clear();
//                                                                 Navigator.pop(context);
//                                                                 sellDone = true;
//                                                               },
//                                                               child: Container(
//                                                                 width: (MediaQuery.of(context).size.width - 45)/2,
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(
//                                                                     borderRadius:
//                                                                     BorderRadius.circular(10.0),
//                                                                     color: AppTheme.themeColor),
//                                                                 child: Padding(
//                                                                   padding: const EdgeInsets.only(
//                                                                       top: 15.0,
//                                                                       bottom: 15.0),
//                                                                   child: Row(
//                                                                     mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .center,
//                                                                     children: [
//                                                                       Expanded(
//                                                                         child: Padding(
//                                                                           padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                           child: Container(
//                                                                               child: Text(
//                                                                                 'Done',
//                                                                                 textAlign: TextAlign.center,
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 18,
//                                                                                     fontWeight: FontWeight.w600,
//                                                                                     color: Colors.black
//                                                                                 ),
//                                                                               )
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ]
//                                                       )
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
//                                   width: double.infinity,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(20.0),
//                                       topRight: Radius.circular(20.0),
//                                     ),
//                                     color: Colors.white,
//                                   ),
//                                   child: Container(
//                                     width: double.infinity,
//                                     child:
//                                     eachProd.length!=0 ? Stack(
//                                       children: [
//                                         Container(
//                                           width: double.infinity,
//                                           height: 71,
//                                           decoration: BoxDecoration(
//                                               border: Border(
//                                                   bottom: BorderSide(
//                                                       color: Colors.blue
//                                                           .withOpacity(0.1),
//                                                       width: 1.0))),
//                                           child:
//
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: 15.0,
//                                                 right: 15.0,
//                                                 top: 6),
//                                             child:
//                                             Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Text('MMK '+ salePrice, style: TextStyle(
//                                                       fontWeight: FontWeight.w500,
//                                                       color: Colors.grey,
//                                                     )),
//                                                     SizedBox(width: 5),
//                                                     if (unit == 'unit_name') Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,)
//                                                     else if(unit == 'sub1_name')Icon(SmartKyat_POS.prods1, size: 17, color: Colors.grey,)
//                                                     else if(unit == 'sub2_name') Icon(SmartKyat_POS.prods2, size: 17, color: Colors.grey,)
//                                                       else Icon( Icons.check, size: 17, color: Colors.grey,),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 3.5),
//                                                 Text(productName, style: TextStyle(
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 21
//                                                 )),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 85.0,
//                                               left: 15.0,
//                                               right: 15.0),
//                                           child: Container(
//                                               child: ListView(
//                                                 children: [
//                                                   Column(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//                                                       Text('QUANTITY', style: TextStyle(
//                                                         fontWeight: FontWeight.bold,
//                                                         fontSize: 14,
//                                                         letterSpacing: 2,
//                                                         color: Colors.grey,
//                                                       ),),
//                                                       SizedBox(height: 15),
//                                                       Row(
//                                                         children: [
//                                                           GestureDetector(
//                                                             onTap: () {
//                                                               mystate(() {
//                                                                 quantity2 = int.parse(myController.text) -1;
//                                                                 myController.text = quantity2.toString();
//                                                                 print('qqq' + quantity2.toString());
//                                                               });
//                                                             },
//                                                             child: Container(
//                                                               width: (MediaQuery.of(context).size.width - 60)/3,
//                                                               height: 55,
//                                                               decoration: BoxDecoration(
//                                                                   borderRadius:
//                                                                   BorderRadius.circular(10.0),
//                                                                   color: AppTheme.themeColor),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(
//                                                                     top: 15.0,
//                                                                     bottom: 15.0),
//                                                                 child: Row(
//                                                                   mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .center,
//                                                                   children: [
//                                                                     Expanded(
//                                                                       child: Padding(
//                                                                         padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                         child: Container(
//                                                                             child: Icon(
//                                                                               Icons.remove, size: 20,
//                                                                             )
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(width: 15),
//                                                           Container(
//                                                             width: (MediaQuery.of(context).size.width - 60)/3,
//                                                             height: 55,
//                                                             child: TextField(
//                                                               textAlign: TextAlign.center,
//                                                               decoration: InputDecoration(
//                                                                 enabledBorder: const OutlineInputBorder(
//                                                                   // width: 0.0 produces a thin "hairline" border
//                                                                     borderSide: const BorderSide(
//                                                                         color: AppTheme.skBorderColor, width: 2.0),
//                                                                     borderRadius: BorderRadius.all(Radius.circular(10.0))),
//
//                                                                 focusedBorder: const OutlineInputBorder(
//                                                                   // width: 0.0 produces a thin "hairline" border
//                                                                     borderSide: const BorderSide(
//                                                                         color: AppTheme.skThemeColor2, width: 2.0),
//                                                                     borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                                                                 contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//                                                                 floatingLabelBehavior: FloatingLabelBehavior.auto,
//                                                                 //filled: true,
//                                                                 border: OutlineInputBorder(
//                                                                   borderRadius: BorderRadius.circular(10),
//                                                                 ),
//                                                               ),
//                                                               keyboardType: TextInputType.number,
//                                                               onChanged: (value) {
//                                                                 setState(() {
//                                                                   quantity2 = int.parse(value);
//                                                                 });
//                                                               },
//                                                               controller: myController,
//                                                             ),
//                                                           ),
//                                                           SizedBox(width: 15),
//                                                           GestureDetector(
//                                                             onTap: () {
//                                                               setState(() {
//                                                                 mystate(() {
//                                                                   quantity2 = int.parse(myController.text) +1;
//                                                                   myController.text = quantity2.toString();
//                                                                   print('qqq' + quantity2.toString());
//                                                                 });
//                                                               });
//                                                             },
//                                                             child: Container(
//                                                               width: (MediaQuery.of(context).size.width - 60)/3,
//                                                               height: 55,
//                                                               decoration: BoxDecoration(
//                                                                   borderRadius:
//                                                                   BorderRadius.circular(10.0),
//                                                                   color: AppTheme.themeColor),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(
//                                                                     top: 15.0,
//                                                                     bottom: 15.0),
//                                                                 child: Row(
//                                                                   mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .center,
//                                                                   children: [
//                                                                     Expanded(
//                                                                       child: Padding(
//                                                                         padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                         child: Container(
//                                                                             child: Icon(
//                                                                               Icons.add, size: 20,
//                                                                             )
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       SizedBox(height: 15,),
//                                                       Text('MAIN UNIT PRICING', style: TextStyle(
//                                                         fontWeight: FontWeight.bold,
//                                                         fontSize: 14,
//                                                         letterSpacing: 2,
//                                                         color: Colors.grey,
//                                                       ),),
//                                                       SizedBox(height: 15,),
//                                                       // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                                                       //   stream: FirebaseFirestore
//                                                       //       .instance
//                                                       //       .collection('space')
//                                                       //       .doc(
//                                                       //       '0NHIS0Jbn26wsgCzVBKT')
//                                                       //       .collection('shops')
//                                                       //       .doc(
//                                                       //       shopId)
//                                                       //       .collection('products')
//                                                       //       .doc(eachProd.split('-')[0])
//                                                       //       .snapshots(),
//                                                       //   builder: (BuildContext context, snapshot2) {
//                                                       //     if (snapshot2.hasData) {
//                                                       // var output = snapshot2.data!.data();
//                                                       // // var prodName = output?['prod_name'];
//                                                       // var mainName = output?['unit_name'];
//                                                       // var sub1Name = output?['sub1_name'];
//                                                       // var sub2Name = output?['sub2_name'];
//                                                       // // var sub3Name = output?['sub3_name'];
//                                                       // var barcode = output?['bar_code'];
//                                                       // // var mainPrice = output?['unit_sell'];
//                                                       // // var sub1Price = output?['sub1_sell'];
//                                                       // // var sub2Price = output?['sub2_sell'];
//                                                       // // var sub3Price = output?['sub3_sell'];
//                                                       // // var sub1Unit = output?['sub1_link'];
//                                                       // // var sub2Unit = output?['sub2_link'];
//                                                       // // var sub3Unit = output?['sub3_link'];
//                                                       // // var subExist = output?['sub_exist'];
//                                                       // var mainLoss = output?['Loss1'].round();
//                                                       // var sub1Loss = output?['Loss2'].round();
//                                                       // var sub2Loss = output?['Loss3'].round();
//                                                       // var mainQty = output?['inStock1'].round();
//                                                       // var sub1Qty = output?['inStock2'].round();
//                                                       // var sub2Qty = output?['inStock3'].round();
//                                                       // var image = output?['img_1'];
//                                                       //return
//                                                       Container(
//                                                         height: 220,
//                                                         decoration: BoxDecoration(
//                                                           borderRadius: BorderRadius.circular(20.0),
//                                                           color: AppTheme.lightBgColor,
//                                                         ),
//                                                         child: Padding(
//                                                           padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                                                           child: Column(
//                                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                                             children: [
//                                                               Container(
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(border: Border(bottom: BorderSide(
//                                                                     color: Colors.grey
//                                                                         .withOpacity(0.2),
//                                                                     width: 1.0))),
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Text('Sell price', style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                     ),),
//                                                                     Spacer(),
//                                                                     Text('MMK ' + salePrice.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               Container(
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(
//                                                                     border: Border(
//                                                                         bottom: BorderSide(
//                                                                             color: Colors.grey
//                                                                                 .withOpacity(0.2),
//                                                                             width: 1.0))),
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Text('In stock', style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                     ),),
//                                                                     Spacer(),
//                                                                     eachProd.split('-')[4]== 'unit_name' ? Text(mainQty.toString() + ' ' + mainName, style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),) : eachProd.split('-')[4]== 'sub1_name'? Text( sub1Qty.toString() + ' ' + sub1Name, style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),) : Text(sub2Qty.toString() + ' ' + sub2Name, style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               Container(
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(
//                                                                     border: Border(
//                                                                         bottom: BorderSide(
//                                                                             color: Colors.grey
//                                                                                 .withOpacity(0.2),
//                                                                             width: 1.0))),
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Text('Loss', style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                     ),),
//                                                                     Spacer(),
//                                                                     eachProd.split('-')[4]== 'unit_name' ? Text(mainLoss.toString() + ' ' + mainName, style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),) : eachProd.split('-')[4]== 'sub1_name'? Text(sub1Loss.toString() + ' ' + sub1Name, style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),) : Text(sub2Loss.toString() + ' ' + sub2Name, style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               Container(
//                                                                 height: 55,
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Text('Barcode', style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                     ),),
//                                                                     Spacer(),
//                                                                     Text(barcode, style:
//                                                                     TextStyle(
//                                                                       fontSize: 15,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.grey,
//                                                                     ),),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       //     }
//                                                       //     return Container();
//                                                       //   },
//                                                       // ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               )),
//                                         ),
//                                         Align(
//                                           alignment: Alignment.bottomCenter,
//                                           child: Padding(
//                                             padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   border: Border(
//                                                     top: BorderSide(
//                                                         color:
//                                                         AppTheme.skBorderColor2,
//                                                         width: 1.0),
//                                                   )),
//                                               width: double.infinity,
//                                               height: 158,
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                                 crossAxisAlignment:
//                                                 CrossAxisAlignment.end,
//                                                 children: [
//                                                   ListTile(
//                                                     title: Text(
//                                                       'Total',
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                     trailing: Text('MMK '+
//                                                         (int.parse(myController.text) * int.parse(salePrice)).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
//                                                       style: TextStyle(
//                                                           fontSize: 17,
//                                                           fontWeight:
//                                                           FontWeight
//                                                               .w500),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 10),
//                                                   Padding(
//                                                       padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
//                                                       child: Row(
//                                                           children: [
//                                                             GestureDetector(
//                                                               onTap: () {
//                                                                 setState((){
//                                                                   mystate(() {
//                                                                     _controller2.animateTo(0);
//                                                                     _textFieldController2.clear();
//                                                                     paidAmount2 = 0;
//                                                                     debt2 = 0;
//                                                                     refund2 = 0;
//                                                                     totalAmount2 = double.parse(TtlProdListPrice2());
//                                                                   });
//                                                                 });
//                                                               },
//                                                               child: Container(
//                                                                 width: (MediaQuery.of(context).size.width - 45)/2,
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(
//                                                                     borderRadius:
//                                                                     BorderRadius.circular(10.0),
//                                                                     color: AppTheme.secButtonColor),
//                                                                 child: Padding(
//                                                                   padding: const EdgeInsets.only(
//                                                                       top: 15.0,
//                                                                       bottom: 15.0),
//                                                                   child: Row(
//                                                                     mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .center,
//                                                                     children: [
//                                                                       Expanded(
//                                                                         child: Padding(
//                                                                           padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                           child: Container(
//                                                                               child: Text(
//                                                                                 'Back',
//                                                                                 textAlign: TextAlign.center,
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 18,
//                                                                                     fontWeight: FontWeight.w600,
//                                                                                     color: Colors.black
//                                                                                 ),
//                                                                               )
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             Spacer(),
//                                                             GestureDetector(
//                                                               onTap: () {
//
//                                                                 print('eachProduct' +eachProd);
//                                                                 for (int j = 0; j < prodList2.length; j++)
//                                                                   if( prodList2[j].split('-')[0] == eachProd.split('-')[0] && prodList2[j].split('-')[4] == eachProd.split('-')[4]){
//                                                                     setState((){
//                                                                       mystate((){
//                                                                         eachProd = eachProd.split('-')[0] +'-' + eachProd.split('-')[1]+'-'+(quantity2.toString())+'-'+eachProd.split('-')[3]+ '-'+ eachProd.split('-')[4]+'-'+eachProd.split('-')[5]+'-'+eachProd.split('-')[6];
//                                                                         prodList2[j] = eachProd;
//                                                                       }); });
//                                                                     print('leepae' + prodList2[j]);
//                                                                   } else print('leelar');
//
//
//                                                                 _controller2.animateTo(0);
//                                                               },
//                                                               child: Container(
//                                                                 width: (MediaQuery.of(context).size.width - 45)/2,
//                                                                 height: 55,
//                                                                 decoration: BoxDecoration(
//                                                                     borderRadius:
//                                                                     BorderRadius.circular(10.0),
//                                                                     color: AppTheme.themeColor),
//                                                                 child: Padding(
//                                                                   padding: const EdgeInsets.only(
//                                                                       top: 15.0,
//                                                                       bottom: 15.0),
//                                                                   child: Row(
//                                                                     mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .center,
//                                                                     children: [
//                                                                       Expanded(
//                                                                         child: Padding(
//                                                                           padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
//                                                                           child: Container(
//                                                                               child: Text(
//                                                                                 'Done',
//                                                                                 textAlign: TextAlign.center,
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 18,
//                                                                                     fontWeight: FontWeight.w600,
//                                                                                     color: Colors.black
//                                                                                 ),
//                                                                               )
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ]
//                                                       )
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//
//                                       ],
//                                     ) : Container(),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 42,
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           child: Align(
//                             alignment: Alignment.center,
//                             child: Container(
//                               width: 50,
//                               height: 5,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(25.0),
//                                   ),
//                                   color: Colors.white.withOpacity(0.5)),
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         });
//   }
//
//
//   var counter = 0;
//   var orderLoading = false;
//
//   String total = 'T';
//   int disPercent = 0;
//   int disPercent2 =0;
//
//
//   Future<void> _saveImage(_data) async {
//     bool success = false;
//     try {
//       success = (await ImageSave.saveImage(_data, "demo.jpg", albumName: "SmartKyatPOS"))!;
//     } on PlatformException catch (e, s) {
//       print(e);
//       print(s);
//     }
//
//     print(success ? "Save to album success" : "Save to album failed");
//     // setState(() {
//     //   _result = success ? "Save to album success" : "Save to album failed";
//     // });
//   }
//
//   TtlProdListPriceInit()  {
//     double total = 0;
//     print(prodList.toString());
//     for (String str in prodList) {
//       total += double.parse(str.split('-')[2]) * int.parse(str.split('-')[4]);
//     }
//     return total.toString();
//   }
//
//   TtlProdListPriceInit2()  {
//     double total = 0;
//     print(prodList2.toString());
//     for (String str in prodList2) {
//       total += double.parse(str.split('-')[1]) * int.parse(str.split('-')[2]);
//     }
//     return total.toString();
//   }
//
//   TtlProdListPrice()  {
//     double total = 0;
//     print(prodList.toString());
//     for (String str in prodList) {
//       total += int.parse(str.split('-')[2]) * int.parse(str.split('-')[4]);
//       disPercent = (double.parse(total.toString()) *
//           (discountAmount / 100)).round();
//     }
//     if(isDiscount == 'percent'){
//       discountAmount = discount;
//       print(discountAmount.toString());
//       disText = '-p';
//       total = (double.parse(total.toString()) -
//           (double.parse(total.toString()) *
//               (discountAmount / 100)));
//     } else if(isDiscount == 'amount'){
//       discountAmount = discount;
//       disText ='-d';
//       total = (double.parse(total.toString()) - discountAmount);
//     } else {
//       disText = '';
//       discountAmount = 0.0;
//       total = double.parse(total.toString());
//     }
//     return total.toString();
//   }
//
//   TtlProdListPrice2()  {
//     double total = 0;
//     print(prodList2.toString());
//     for (String str in prodList2) {
//       total += int.parse(str.split('-')[1]) * int.parse(str.split('-')[2]);
//       disPercent2 = (double.parse(total.toString()) *
//           (discountAmount2 / 100)).round();
//     }
//     if(isDiscount2 == 'percent'){
//       discountAmount2 = discount2;
//       print(discountAmount2.toString());
//       disText2 = '-p';
//       total = (double.parse(total.toString()) -
//           (double.parse(total.toString()) *
//               (discountAmount2 / 100)));
//     } else if(isDiscount2 == 'amount'){
//       discountAmount2 = discount2;
//       disText2 ='-d';
//       total = (double.parse(total.toString()) - discountAmount2);
//     } else {
//       disText2 = '';
//       discountAmount2 = 0.0;
//       total = double.parse(total.toString());
//     }
//     return total.toString();
//   }
//
//
//   // TtlProdListPrice2() {
//   //   int total = 0;
//   //   //print(prodList.toString());
//   //   for (String str in prodList2) {
//   //     total += int.parse(str.split('-')[1]) * int.parse(str.split('-')[2]);
//   //   }
//   //   return total.toString();
//   // }
//   totalItems2() {
//     int total = 0;
//     //print(prodList.toString());
//     for (String str in prodList2) {
//       total += int.parse(str.split('-')[2]);
//     }
//     return total.toString();
//   }
//
//   totalItems() {
//     int total = 0;
//     //print(prodList.toString());
//     for (String str in prodList) {
//       total += int.parse(str.split('-')[4]);
//     }
//     return total.toString();
//   }
//   zeroToTen(String string) {
//     if (int.parse(string) > 9) {
//       return string;
//     } else {
//       return '0' + string;
//     }
//   }
//
//   selectedTab() {
//     if(_selectIndex==0) {
//       return Row(
//         children: [
//           Icon(
//             SmartKyat_POS.home,
//             size: 20,
//           ),
//           SizedBox(
//             width: 8,
//           ),
//           Container(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 5, top: 0.0),
//                 child: Text(
//                   'Home',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black),
//                 ),
//               )
//           )
//         ],
//       );
//     } else if(_selectIndex==1) {
//       return Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 1.0),
//             child: Icon(
//               SmartKyat_POS.product,
//               size: 21,
//             ),
//           ),
//           SizedBox(
//             width: 8,
//           ),
//           Container(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 5, top: 1.0),
//                 child: Text(
//                   'Product',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black),
//                 ),
//               )
//           )
//         ],
//       );
//     } else if(_selectIndex==2) {
//       return Row(
//         children: [
//           Icon(
//             SmartKyat_POS.order,
//             size: 23,
//           ),
//           SizedBox(
//             width: 8,
//           ),
//           Container(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 5, top: 1.0),
//                 child: Text(
//                   'Sale orders',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black),
//                 ),
//               )
//           )
//         ],
//       );
//     } else if(_selectIndex==3) {
//       return Row(
//         children: [
//           Icon(
//             SmartKyat_POS.order,
//             size: 23,
//           ),
//           SizedBox(
//             width: 8,
//           ),
//           Container(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 5, top: 1.0),
//                 child: Text(
//                   'Buy orders',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black),
//                 ),
//               )
//           )
//         ],
//       );
//     } else if(_selectIndex==4) {
//       return Row(
//         children: [
//           Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 7.0),
//                 child: Icon(
//                   SmartKyat_POS.customer1,
//                   size: 17.5,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 14.0, top: 11.0),
//                 child: Icon(
//                   SmartKyat_POS.customer2,
//                   size: 9,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 5.0, top: 5),
//                 child: Container(
//                   width: 8,
//                   height: 7.5,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: Colors.black),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 14.5, top: 7.5),
//                 child: Container(
//                   width: 5,
//                   height: 4.5,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: Colors.black),
//                 ),
//               )
//             ],
//           ),
//           SizedBox(
//             width: 8,
//           ),
//           Container(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 5, top: 1.0),
//                 child: Text(
//                   'Customers',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black),
//                 ),
//               )
//           )
//         ],
//       );
//     } else if(_selectIndex==5) {
//       return Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 1.0),
//             child: Icon(
//               SmartKyat_POS.merchant,
//               size: 20,
//             ),
//           ),
//           SizedBox(
//             width: 8,
//           ),
//           Container(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 5, top: 1.0),
//                 child: Text(
//                   'Merchants',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black),
//                 ),
//               )
//           )
//         ],
//       );
//     } else if(_selectIndex==6) {
//       return Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 1.0),
//             child: Icon(
//               SmartKyat_POS.setting,
//               size: 22,
//             ),
//           ),
//           SizedBox(
//             width: 8,
//           ),
//           Container(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 5, top: 1.0),
//                 child: Text(
//                   'Settings',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black),
//                 ),
//               )
//           )
//         ],
//       );
//     }
//   }
//
//   changeUnitName2Stock(String split) {
//     if(split == 'main') {
//       return 'inStock1';
//     } else {
//       return 'inStock' + (int.parse(split[3]) + 1).toString();
//     }
//   }
//
//   Future<void> addDateExist(id1, id2, dOrder , length) async {
//     print('CHECKING PRODSALE ORD');
//     //CollectionReference detail = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders').doc(id1).collection('detail');
//     CollectionReference daily = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders');
//     // CollectionReference cusOrder = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('customers').doc(customerId.split('-')[0]).collection('orders');
//     // print('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));
//
//     daily.doc(id1).update({
//       'daily_order': FieldValue.arrayUnion([dOrder.toString()]),
//       'each_order' : FieldValue.arrayUnion([length.toString()])})
//         .then((value) => print("User Updated"))
//         .catchError((error) => print("Failed to update user: $error"));
//
//     // detail.doc(id2).set({
//     //            'total': TtlProdListPrice(),
//     //            'debt' : debt,
//     //            'discount' : discountAmount.toString() + disText,
//     //            'docId' : id1,
//     //            'refund': 'FALSE',
//     //            'subs': subList,
//     //            'customerId' : customerId.split('-')[0],
//     //            'deviceId' : deviceIdNum.toString() + '-',
//     //            'orderId' : length.toString(),})
//     //     .then((value) => print("User Updated"))
//     //     .catchError((error) => print("Failed to update user: $error"));
//     //
//     // if(customerId.split('-')[0] != 'name') {
//     // cusOrder.doc(id2).set({
//     // 'order_id': id2,
//     // 'debt' : debt,
//     // 'order_pid': id1,
//     // 'refund' : 'FALSE',
//     // 'discount' : discountAmount.toString() + disText,
//     // 'total': TtlProdListPrice(),
//     // 'deviceId' : deviceIdNum.toString() + '-',
//     // 'voucherId' : length.toString(),})
//     //     .then((value) => print("User Updated"))
//     //     .catchError((error) => print("Failed to update user: $error")); }
//   }
//
//   Future<void> Detail(id1, id2 , length) async {
//     print('CHECKING PRODSALE ORD');
//     CollectionReference detail = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders').doc(id1).collection('detail');
//
//     detail.doc(id2).set({
//       'total': TtlProdListPrice(),
//       'debt' : debt,
//       'discount' : discountAmount.toString() + disText,
//       'docId' : id1,
//       'refund': 'FALSE',
//       'subs': subList,
//       'customerId' : customerId.split('-')[0],
//       'deviceId' : deviceIdNum.toString() + '-',
//       'orderId' : length.toString(),})
//         .then((value) => print("User Updated"))
//         .catchError((error) => print("Failed to update user: $error"));
//   }
//
//   Future<void> CusOrder(id1, id2 , length) async {
//     print('CHECKING PRODSALE ORD');
//     // CollectionReference detail = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders').doc(id1).collection('detail');
//     //  CollectionReference daily = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('orders');
//     CollectionReference cusOrder = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('customers').doc(customerId.split('-')[0]).collection('orders');
//     // print('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));
//
//     cusOrder.doc(id2).set({
//       'order_id': id2,
//       'debt' : debt,
//       'order_pid': id1,
//       'refund' : 'FALSE',
//       'discount' : discountAmount.toString() + disText,
//       'total': TtlProdListPrice(),
//       'deviceId' : deviceIdNum.toString() + '-',
//       'voucherId' : length.toString(),})
//         .then((value) => print("User Updated"))
//         .catchError((error) => print("Failed to update user: $error"));
//   }
//
//   Future<void> orderLengthIncrease(id) async {
//     print('CHECKING PRODSALE ORD');
//     CollectionReference users = await FirebaseFirestore.instance.collection('shops');
//
//     // print('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));
//
//     users
//         .doc(shopId)
//         .update({'orders_length': FieldValue.increment(1)})
//         .then((value) => print("User Updated"))
//         .catchError((error) => print("Failed to update user: $error"));
//   }
//
//
//   Future<void> prodSaleData(id, num) async {
//     print('CHECKING PRODSALE');
//     CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products');
//
//     // print('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));
//
//     users
//         .doc(id)
//         .update({'mainSellUnit': FieldValue.increment(double.parse(num.toString()))})
//         .then((value) => print("User Updated"))
//         .catchError((error) => print("Failed to update user: $error"));
//   }
//
//   Future<void> decStockFromInv(id, unit, num) async {
//     CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products');
//
//     // print('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));
//
//     users
//         .doc(id)
//         .update({changeUnitName2Stock(unit): FieldValue.increment(0 - (double.parse(num.toString())))})
//         .then((value) => print("User Updated"))
//         .catchError((error) => print("Failed to update user: $error"));
//   }
//
//   Future<void> incStockFromInv(id, unit, num) async {
//     CollectionReference users = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products');
//
//     // print('gg ' + str.split('-')[0] + ' ' + changeUnitName2Stock(str.split('-')[3]));
//
//     users
//         .doc(id)
//         .update({changeUnitName2Stock(unit): FieldValue.increment(double.parse(num.toString()))})
//         .then((value) => print("User Updated"))
//         .catchError((error) => print("Failed to update user: $error"));
//   }
//
//   Future<void> sub1Execution(subStock, subLink, id, num) async {
//     var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(id).get();
//     if (docSnapshot10.exists) {
//       Map<String, dynamic>? data10 = docSnapshot10.data();
//       subStock[1] = double.parse((data10 ? ['inStock2']).toString());
//       if(subStock[1] > double.parse(num)) {
//         decStockFromInv(id, 'sub1', num);
//       } else {
//         decStockFromInv(id, 'main', ((int.parse(num)  - subStock[1])/int.parse(subLink[0])).ceil());
//         incStockFromInv(id, 'sub1', ((int.parse(num)-subStock[1].round()) % int.parse(subLink[0])) == 0? 0: (int.parse(subLink[0]) - (int.parse(num)-subStock[1].round()) % int.parse(subLink[0])));
//         decStockFromInv(id, 'sub1', subStock[1]);
//       }
//     }
//   }
//
//   Future<void> sub2Execution(subStock, subLink, id, num) async {
//     var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(id).get();
//     if (docSnapshot10.exists) {
//       Map<String, dynamic>? data10 = docSnapshot10.data();
//       subStock[2] = double.parse((data10 ? ['inStock3']).toString());
//       if(subStock[2] > double.parse(num)) {
//         decStockFromInv(id, 'sub2', num);
//       } else {
//         await incStockFromInv(id, 'sub2', ((int.parse(num)-subStock[2].round()) % int.parse(subLink[1])) == 0? 0: (int.parse(subLink[1]) - (int.parse(num)-subStock[2].round()) % int.parse(subLink[1])));
//         await decStockFromInv(id, 'sub2', subStock[2]);
//         sub1Execution(subStock, subLink, id, ((int.parse(num)  - subStock[2])/int.parse(subLink[1])).ceil().toString());
//       }
//     }
//   }
//
//   todayToYearStart(DateTime now) {
//     DateTime yearStart = DateFormat("yyyy-MM-dd hh:mm:ss").parse(now.year.toString() + '-00-00 00:00:00');
//     print('DDDD ' + yearStart.toString());
//     return yearStart;
//   }
// }
//
// class FadeRoute extends PageRouteBuilder {
//   final Widget page;
//   @override
//   bool get opaque => false;
//   FadeRoute({required this.page})
//       : super(
//     pageBuilder: (
//         BuildContext context,
//         Animation<double> animation,
//         Animation<double> secondaryAnimation,
//         ) =>
//     page,
//     transitionsBuilder: (
//         BuildContext context,
//         Animation<double> animation,
//         Animation<double> secondaryAnimation,
//         Widget child,
//         ) =>
//         FadeTransition(
//           opacity: animation,
//           child: child,
//         ),
//     transitionDuration: Duration(milliseconds: 100),
//     reverseTransitionDuration: Duration(milliseconds: 150),
//   );
// }