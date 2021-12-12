// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flash/flash.dart';
// import 'package:flutter/material.dart';
// import 'package:smartkyat_pos/fragments/customers_fragment.dart';
// import 'package:smartkyat_pos/fragments/home_fragment.dart';
// import 'package:smartkyat_pos/fragments/orders_fragment2.dart';
// import 'package:smartkyat_pos/fragments/products_fragment.dart';
// import 'package:smartkyat_pos/fragments/settings_fragment.dart';
// import 'package:smartkyat_pos/fragments/staff_fragment.dart';
// import 'package:smartkyat_pos/fragments/support_fragment.dart';
// import 'app_theme.dart';
// import 'tabItem.dart';
// import 'bottomNavigation.dart';
// import 'screens.dart';
//
// class App extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => AppState();
// }
//
// class AppState extends State<App> {
//   // this is static property so other widget throughout the app
//   // can access it simply by AppState.currentTab
//   static int currentTab = 0;
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   Future? store;
//   var deviceIdNum = 0;
//
//   // final drawerItems = [
//   //   new DrawerItem("Home", Icons.home_filled),
//   //   new DrawerItem("Orders", Icons.inbox),
//   //   new DrawerItem("Customers", Icons.person),
//   //   new DrawerItem("Products", Icons.tag),
//   //   new DrawerItem("Staff", Icons.person_add),
//   //   new DrawerItem("Setting", Icons.settings),
//   //   new DrawerItem("Support", Icons.support),
//   // ];
//
//
//   @override
//   void initState() {
//
//
//   }
//
//
//
//   addCounter() {
//     setState(() {
//       counter++;
//     });
//   }
//
//
//   AppState() {
//     // tabs.asMap().forEach((index, details) {
//     //   details.setIndex(index);
//     // });
//     // indexing is necessary for proper funcationality
//     // of determining which tab is active
//
//   }
//
//   // sets current tab index
//   // and update state
//   void _selectTab(int index) {
//     // if (index == currentTab) {
//     //   // pop to first route
//     //   // if the user taps on the active tab
//     //   tabs[index].key.currentState!.popUntil((route) => route.isFirst);
//     // } else {
//     //   // update the state
//     //   // in order to repaint
//     //   setState(() => currentTab = index);
//     // }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<TabItem> tabs = [
//
//       TabItem(
//         tabName: "Settings",
//         icon: Icons.settings,
//         page: HomeFragment(toggleCoinCallback: () {
//           addCounter();
//         }),
//       ),
//       TabItem(
//         tabName: "Home",
//         icon: Icons.home,
//         page: OrdersFragment(),
//       ),
//       TabItem(
//         tabName: "Settings",
//         icon: Icons.settings,
//         page: CustomersFragment(toggleCoinCallback2: (String str) {  }),
//       ),
//       TabItem(
//         tabName: "Settings",
//         icon: Icons.settings,
//         page: SupportFragment(),
//       ),
//       TabItem(
//         tabName: "Settings",
//         icon: Icons.settings,
//         page: StaffFragment(),
//       ),
//       TabItem(
//         tabName: "Settings",
//         icon: Icons.settings,
//         page: SettingsFragment(changeShopCallback: () {  },),
//       ),
//       TabItem(
//         tabName: "Settings",
//         icon: Icons.settings,
//         page: SupportFragment(),
//       ),];
//
//     tabs.asMap().forEach((index, details) {
//       details.setIndex(index);
//     });
//
//     // WillPopScope handle android back btn
//     return WillPopScope(
//       onWillPop: () async {
//         final isFirstRouteInCurrentTab =
//         !await tabs[currentTab].key.currentState!.maybePop();
//         if (isFirstRouteInCurrentTab) {
//           // if not on the 'main' tab
//           if (currentTab != 0) {
//             // select 'main' tab
//             // _selectTab(0);
//             // back button handled by app
//             return false;
//           }
//         }
//         // let system handle back button if we're on the first route
//         return isFirstRouteInCurrentTab;
//       },
//       // this is the base scaffold
//       // don't put appbar in here otherwise you might end up
//       // with multiple appbars on one screen
//       // eventually breaking the app
//       child: Scaffold(
//         key: _scaffoldKey,
//         drawer: new Drawer(
//           child: SafeArea(
//             top: true,
//             bottom: true,
//             child: new Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
//                   child: Row(
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               _selectTab(2);
//                               Navigator.pop(context, true);
//                             },
//                             child: Text(
//                               'Ethereals Shop',
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.w500),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               _selectTab(0);
//                               Navigator.pop(context, true);
//                             },
//                             child: Text(
//                               'Yangon',
//                               style: TextStyle(fontSize: 14),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 3,
//                           ),
//                           // FutureBuilder(
//                           //     future: store,
//                           //     builder: (context, snapshot) {
//                           //       return Text(
//                           //         snapshot.data.toString(),
//                           //         style: TextStyle(
//                           //           fontSize: 14,
//                           //           color: Colors.blue,
//                           //         ),
//                           //       );
//                           //     }
//                           // ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                     child: Padding(
//                       padding:
//                       const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                             border: Border(
//                                 bottom: BorderSide(
//                                     color: Colors.grey.withOpacity(0.3),
//                                     width: 1.0))),
//                       ),
//                     )),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//                   child: new Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context, true);
//                           if (0 == currentTab) {
//                             // pop to first route
//                             // if the user taps on the active tab
//                             tabs[0].key.currentState!.popUntil((route) => route.isFirst);
//                           } else {
//                             // update the state
//                             // in order to repaint
//                             setState(() => currentTab = 0);
//                           }
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                           child: new Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 color: Colors.transparent),
//                             height: 55,
//                             width: double.infinity,
//                             child: Row(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15.0, right: 10.0),
//                                   child: Icon(
//                                     Icons.home_filled,
//                                     size: 26,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Home',
//                                   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context, true);
//                           if (1 == currentTab) {
//                             // pop to first route
//                             // if the user taps on the active tab
//                             tabs[1].key.currentState!.popUntil((route) => route.isFirst);
//                           } else {
//                             // update the state
//                             // in order to repaint
//                             setState(() => currentTab = 1);
//                           }
//
//
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                           child: new Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 color: Colors.transparent),
//                             height: 55,
//                             width: double.infinity,
//                             child: Row(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15.0, right: 10.0),
//                                   child: Icon(
//                                     Icons.inbox,
//                                     size: 26,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Orders',
//                                   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context, true);
//                           if (2 == currentTab) {
//                             // pop to first route
//                             // if the user taps on the active tab
//                             tabs[2].key.currentState!.popUntil((route) => route.isFirst);
//                           } else {
//                             // update the state
//                             // in order to repaint
//                             setState(() => currentTab = 2);
//                           }
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                           child: new Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 color: Colors.transparent),
//                             height: 55,
//                             width: double.infinity,
//                             child: Row(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15.0, right: 10.0),
//                                   child: Icon(
//                                     Icons.person,
//                                     size: 26,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Customers',
//                                   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context, true);
//                           if (3 == currentTab) {
//                             // pop to first route
//                             // if the user taps on the active tab
//                             tabs[3].key.currentState!.popUntil((route) => route.isFirst);
//                           } else {
//                             // update the state
//                             // in order to repaint
//                             setState(() => currentTab = 3);
//                           }
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                           child: new Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 color: Colors.transparent),
//                             height: 55,
//                             width: double.infinity,
//                             child: Row(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15.0, right: 10.0),
//                                   child: Icon(
//                                     Icons.tag,
//                                     size: 26,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Products',
//                                   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context, true);
//                           if (4 == currentTab) {
//                             // pop to first route
//                             // if the user taps on the active tab
//                             tabs[4].key.currentState!.popUntil((route) => route.isFirst);
//                           } else {
//                             // update the state
//                             // in order to repaint
//                             setState(() => currentTab = 4);
//                           }
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                           child: new Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 color: Colors.transparent),
//                             height: 55,
//                             width: double.infinity,
//                             child: Row(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15.0, right: 10.0),
//                                   child: Icon(
//                                     Icons.person_add,
//                                     size: 26,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Staff',
//                                   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context, true);
//                           if (5 == currentTab) {
//                             // pop to first route
//                             // if the user taps on the active tab
//                             tabs[5].key.currentState!.popUntil((route) => route.isFirst);
//                           } else {
//                             // update the state
//                             // in order to repaint
//                             setState(() => currentTab = 5);
//                           }
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                           child: new Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 color: Colors.transparent),
//                             height: 55,
//                             width: double.infinity,
//                             child: Row(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15.0, right: 10.0),
//                                   child: Icon(
//                                     Icons.settings,
//                                     size: 26,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Settings',
//                                   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context, true);
//                           if (6 == currentTab) {
//                             // pop to first route
//                             // if the user taps on the active tab
//                             tabs[6].key.currentState!.popUntil((route) => route.isFirst);
//                           } else {
//                             // update the state
//                             // in order to repaint
//                             setState(() => currentTab = 6);
//                           }
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                           child: new Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 color: Colors.transparent),
//                             height: 55,
//                             width: double.infinity,
//                             child: Row(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15.0, right: 10.0),
//                                   child: Icon(
//                                     Icons.support,
//                                     size: 26,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Support',
//                                   style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                     ]
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // indexed stack shows only one child
//         body: IndexedStack(
//           index: currentTab,
//           children: tabs.map((e) => e.page).toList(),
//         ),
//         // Bottom navigation
//         bottomNavigationBar: Padding(
//           padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
//           child: Container(
//             color: Colors.white,
//             height: MediaQuery.of(context).size.width>900?57:157,
//             child: Column(
//               children: [
//                 MediaQuery.of(context).size.width>900?Container():Padding(
//                   padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//                   child: Container(
//                     height: 70,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border(
//                           top: BorderSide(
//                               color: Colors.grey, width: 1.0),
//                         )
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           addDailyExp(context);
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius:
//                             BorderRadius.circular(10.0),
//                             color: Colors.grey,
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Expanded(
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left:8.0, right: 8.0, bottom: 3.0),
//                                     child: Container(child:
//                                     Text(
//                                       'Go to cart',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.black
//                                       ),
//                                     )
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: 57,
//                   decoration: BoxDecoration(
//                       border: Border(
//                         top: BorderSide(
//                             color: Colors.grey, width: 1.0),
//                       )),
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(
//                             left: 15.0,
//                           ),
//                           child: GestureDetector(
//                               onTap: () {
//                                 _scaffoldKey.currentState!.openDrawer();
//                                 // Scaffold.of(context).openDrawer();
//                               },
//                               child: Icon(
//                                 Icons.home_filled,
//                                 size: 26,
//                               )),
//                         ),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () async {
//                               showFlash(
//                                 context: context,
//                                 duration: const Duration(seconds: 2),
//                                 persistent: false,
//                                 builder: (_, controller) {
//                                   return Flash(
//                                     controller: controller,
//                                     backgroundColor: Colors.transparent,
//                                     brightness: Brightness.light,
//                                     // boxShadows: [BoxShadow(blurRadius: 4)],
//                                     // barrierBlur: 3.0,
//                                     // barrierColor: Colors.black38,
//                                     barrierDismissible: true,
//                                     behavior: FlashBehavior.floating,
//                                     position: FlashPosition.top,
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(top: 10.0),
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                                         child: Container(
//                                           height: 56,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                             BorderRadius.circular(10.0),
//                                             color: Colors.green,
//                                           ),
//                                           child: FlashBar(
//                                             // title: Text('Title'),
//                                             content: Text('Hello world!'),
//                                             // // showProgressIndicator: true,
//                                             // primaryAction: TextButton(
//                                             //   onPressed: () => controller.dismiss(),
//                                             //   child: Text('DISMISS', style: TextStyle(color: Colors.amber)),
//                                             // ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                               //logger.info(result);
//                             },
//                             child: Container(
//                                 child: Text(
//                                   'Phyo Pyae Sohn',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize: 16.5,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.black.withOpacity(0.6)),
//                                 )
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                             right: 15.0,
//                           ),
//                           child: Icon(
//                             Icons.circle,
//                             color: Colors.green,
//                             size: 22,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   addDailyExp(priContext) {
//     // myController.clear();
//     showModalBottomSheet(
//         enableDrag:false,
//         isScrollControlled:true,
//         context: context,
//         builder: (BuildContext context) {
//           return Scaffold(
//             body: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               // mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Expanded(
//                   child: Container(
//                     child: Column(
//                       children: [
//                         Container(
//                           width: 70,
//                           height: 6,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(25.0),
//                               ),
//                               color: Colors.white.withOpacity(0.5)
//                           ),
//                         ),
//                         SizedBox(
//                           height: 14,
//                         ),
//                         Container(
//                           // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(15.0),
//                               topRight: Radius.circular(15.0),
//                             ),
//                             color: Colors.white,
//                           ),
//
//                           child: Container(
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: 85,
//                                   decoration: BoxDecoration(
//
//                                       border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.0))
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Container(
//                                           width: 35,
//                                           height: 35,
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.all(
//                                                 Radius.circular(5.0),
//                                               ),
//                                               color: Colors.grey.withOpacity(0.3)
//                                           ),
//                                           child: IconButton(
//                                             icon: Icon(
//                                               Icons.close,
//                                               size: 20,
//                                               color: Colors.black,
//                                             ),
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                             },
//
//                                           ),
//                                         ),
//                                         Text(
//                                           "Cart",
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 17,
//                                               fontFamily: 'capsulesans',
//                                               fontWeight: FontWeight.w600
//                                           ),
//                                           textAlign: TextAlign.left,
//                                         ),
//                                         Container(
//                                           width: 35,
//                                           height: 35,
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.all(
//                                                 Radius.circular(5.0),
//                                               ),
//                                               color: AppTheme.skThemeColor
//                                           ),
//                                           child: IconButton(
//                                             icon: Icon(
//                                               Icons.check,
//                                               size: 20,
//                                               color: Colors.black,
//                                             ),
//                                             onPressed: () {
//                                               ScaffoldMessenger.of(context).showSnackBar(
//                                                 const SnackBar(content: Text('Processing Data')),
//                                               );
//                                               // print(prodFieldsValue);
//
//                                               CollectionReference orders = FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc('GhitGLyZLoQekKhan9Xd').collection('detail');
//                                               orders
//                                                   .add({
//                                                 'cust_name': 'U Pyaung'
//                                               })
//                                                   .then((value) {
//                                                 print('order added');
//
//                                                 FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
//                                                 // FirebaseFirestore.instance.collection('space')
//                                                     .where('date', isEqualTo: 'saturday')
//                                                     .get()
//                                                     .then((QuerySnapshot querySnapshot) {
//                                                   // querySnapshot.docs.forEach((doc) {
//                                                   //   // spaceDocId = doc.id;
//                                                   // });some thing 2~IXFrkXcaIzgIbJJCcuu6^hay hay~QM1BYslqNxfeTKwn9vaT^working?~SxLgzSmAdv5Ni6P3lKfR^yeah its worked~V2lfzHGwHH0vZ9hu3Wek
//
//
//
//
//                                                   querySnapshot.docs.forEach((doc) {
//
//                                                     FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
//                                                         .doc(doc.id)
//                                                         .update({'data': doc['data']+'^U Pyaung~'+value.id})
//                                                         .then((value) => print("User Updated"))
//                                                         .catchError((error) => print("Failed to update user: $error"));
//
//                                                   });
//
//                                                 }).then((value) {
//                                                 });
//
//                                                 // Navigator.pop(context);
//                                               });
//                                             },
//
//                                           ),
//                                         )
//
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 checkoutCart()
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Align(
//                 //   alignment: Alignment.bottomCenter,
//                 //   child: Container(
//                 //     color: Colors.yellow,
//                 //     height: 100,
//                 //   ),
//                 // )
//               ],
//             ),
//           );
//
//         });
//   }
//
//   var counter = 0;
//   var orderLoading = false;
//
//   zeroToTen(String string) {
//     if(int.parse(string) > 9) {
//       return string;
//     } else {
//       return '0'+string;
//     }
//   }
//
//
//
//   checkoutCart() {
//     var width = MediaQuery.of(context).size.width>900?MediaQuery.of(context).size.width*(1.5/3.5):MediaQuery.of(context).size.width;
//     return Container(
//       height: MediaQuery.of(context).size.height-105,
//       width: double.infinity,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
//         child: Stack(
//           children: [
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     // addCounter();/z
//                   },
//                   child: Container(
//                     width: (width/2)-20,
//                     height: 56,
//                     decoration: BoxDecoration(
//                         borderRadius:
//                         BorderRadius.circular(10.0),
//                         color: Colors.grey.withOpacity(0.2)
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             child: GestureDetector(
//                               onTap: () {
//                                 DateTime now = DateTime.now();
//                                 CollectionReference daily_order = FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders');
//                                 var length = 0;
//                                 setState(() {
//                                   orderLoading = true;
//                                 });
//
//                                 print('order creating');
//
//
//                                 FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
//                                 // FirebaseFirestore.instance.collection('space')
//                                     .get()
//                                     .then((QuerySnapshot querySnapshot) {
//
//                                   querySnapshot.docs.forEach((doc) {
//                                     length += int.parse(doc['daily_order'].length.toString());
//                                   });
//                                   length=1000+length+1;
//
//
//                                   //Check new date or not
//                                   var dateExist = false;
//                                   var dateId = '';
//
//                                   FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
//                                   // FirebaseFirestore.instance.collection('space')
//                                       .where('date', isEqualTo: now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()))
//                                       .get()
//                                       .then((QuerySnapshot querySnapshot) {
//
//                                     querySnapshot.docs.forEach((doc) {
//                                       dateExist = true;
//                                       dateId = doc.id;
//                                     });
//
//                                     if(dateExist) {
//                                       daily_order
//                                           .doc(dateId).update({
//                                         'daily_order': FieldValue.arrayUnion([now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString()+'-'+length.toString() + '^total^name^pf'])
//                                       }).then((value) {
//                                         print('User updated');
//                                         setState(() {
//                                           orderLoading = false;
//                                         });
//
//
//                                         FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId).collection('detail')
//                                             .doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString())
//                                             .set({
//                                           'main': 'total',
//                                           'subs': ['name'],
//                                         })
//                                             .then((value) {
//                                           print('order added');
//                                         });
//                                       });
//                                     } else {
//                                       daily_order
//                                           .add({
//                                         'daily_order': [now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString()+'-'+length.toString() + '^total^name^pf'],
//                                         'date': now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString())
//                                       })
//                                           .then((value) {
//                                         print('order added');
//
//
//                                         FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(value.id).collection('detail')
//                                             .doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString())
//                                             .set({
//                                           'main': 'total',
//                                           'subs': ['name'],
//                                         })
//                                             .then((value) {
//                                           print('order added');
//                                         });
//                                       });
//                                     }
//
//
//
//
//
//
//
//                                   });
//
//
//
//
//                                 });
//
//
//
//
//
//
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left:8.0, right: 8.0, bottom: 3.0),
//                                 child: Container(child:
//                                 Text(
//                                   'Clear cart',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.black.withOpacity(0.6)
//                                   ),
//                                 )
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10.0,),
//                 Container(
//                   width: (width/2)-20,
//                   height: 56,
//                   decoration: BoxDecoration(
//                       borderRadius:
//                       BorderRadius.circular(10.0),
//                       color: Colors.grey.withOpacity(0.2)
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               DateTime now = DateTime.now();
//                               print(now.year.toString() + now.month.toString() + now.day.toString() + now.hour.toString() + now.minute.toString() + now.second.toString());
//
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.only(left:8.0, right: 8.0, bottom: 3.0),
//                               child: Container(child:
//                               Text(
//                                 'More actions',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black.withOpacity(0.6)
//                                 ),
//                               )
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 80.0),
//               child: Container(
//                   child: Column(
//                     children: [
//                       Text('Counter: ' + counter.toString()),
//                       orderLoading?Text('Loading'):Text('')
//                     ],
//                   )
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }