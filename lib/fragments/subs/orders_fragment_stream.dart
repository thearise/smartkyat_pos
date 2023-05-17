// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
// import 'package:one_context/one_context.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
// import 'package:smartkyat_pos/fragments/subs/buy_list_info.dart';
// import 'package:smartkyat_pos/fragments/subs/customer_info.dart';
// import 'package:smartkyat_pos/fragments/subs/merchant_info.dart';
// import 'package:smartkyat_pos/fragments/subs/order_info.dart';
// import 'package:smartkyat_pos/pages2/home_page5.dart';
// import 'package:smartkyat_pos/widgets/product_details_view2.dart';
// import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
// import 'package:intl/intl.dart';
// import '../../app_theme.dart';
// import '../app_theme.dart';
//
// class OrdersFragmentStream extends StatefulWidget {
//   final _callback2;
//   final _callback3;
//   final _callback4;
//   final _callback5;
//   final _barcodeBtn;
//
//   OrdersFragmentStream(
//       {
//         required void toggleCoinCallback2(String str),
//         required void toggleCoinCallback3(String str),
//         required void toggleCoinCallback4(String str),
//         required void toggleCoinCallback5(String str),
//         required void barcodeBtn(),
//         // required Key key,
//       })
//       :
//         _callback2 = toggleCoinCallback2,
//         _callback3 = toggleCoinCallback3,
//         _callback4 = toggleCoinCallback4,
//         _callback5 = toggleCoinCallback5,
//         _barcodeBtn = barcodeBtn;
//         // super(key: key);
//
//   @override
//   OrdersFragmentStreamState createState() => OrdersFragmentStreamState();
// }
//
// class OrdersFragmentStreamState extends State<OrdersFragmentStream>
//     with
//         TickerProviderStateMixin,
//         AutomaticKeepAliveClientMixin<OrdersFragmentStream> {
//
//   String? shopId;
//   TextEditingController _searchController = TextEditingController();
//   bool loadingSearch = false;
//
//   FocusNode nodeFirst = FocusNode();
//
//   String searchProdCount = '0';
//
//   bool buySellerStatus = false;
//
//   @override
//   bool get wantKeepAlive => true;
//
//   var sectionList;
//   var sectionList1;
//   var sectionList2;
//   var sectionListNo;
//   String searchValue = '';
//   int slidingSearch = 0;
//   bool noSearchData = false;
//   bool searchingOverAll = false;
//   late TabController _controller;
//   late TabController tabController, subTabController;
//   String slidedText = 'Products^0';
//   String gloSearchText = '';
//   int gloSeaProLeng = 0;
//   var sectionList3;
//   int _sliding = 0;
//
//   Future<String> getStoreId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     // return(prefs.getString('store'));
//
//     var index = prefs.getString('store');
//     debugPrint(index);
//     if (index == null) {
//       return 'idk';
//     } else {
//       return index;
//     }
//   }
//
//   @override
//   initState() {
//     getStoreId().then((value) {
//       setState(() {
//         shopId = value;
//       });
//     });
//     _searchController.addListener((){
//       setState(() {
//         gloSearchText = _searchController.text;
//         searchValue = _searchController.text;
//       });
//       searchKeyChanged();
//       debugPrint(searchValue);
//     });
//     subTabController = TabController(length: 3, vsync: this);
//     slidingSearchCont();
//
//     var sections = List<ExampleSection>.empty(growable: true);
//     var section = ExampleSection()
//       ..header = ''
//     // ..items = List.generate(int.parse(document['length']), (index) => document.id)
//     //   ..items = listCreation(document.id, document['data'], document).cast<String>()
//
//     //   ..items = document['daily_order'].cast<String>()
//
//
//       ..items = ['']
//     // ..items = orderItems(document.id)
//       ..expanded = true;
//     sections.add(section);
//     sectionList = sections;
//     sectionList1 = sections;
//     sectionList2 = sections;
//     sectionListNo = sections;
//
//
//     nodeFirst.addListener(() {
//       if(nodeFirst.hasFocus) {
//         setState(() {
//           loadingSearch = true;
//         });
//       }
//     });
//     super.initState();
//   }
//
//   chgShopIdFrmHomePage() {
//     setState(() {
//       getStoreId().then((value) => shopId = value);
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   addProduct3(data) {
//     widget._callback3(data);
//   }
//
//   addProduct1(data) {
//     widget._callback2(data);
//   }
//
//   slidingSearchCont() {
//
//     if(slidingSearch == 0) {
//       debugPrint('gg0');
//       subTabController.animateTo(0, duration: Duration(milliseconds: 0), curve: Curves.ease);
//       setState(() {
//       });
//     } else if(slidingSearch == 1) {
//       debugPrint('gg1');
//       subTabController.animateTo(1, duration: Duration(milliseconds: 0), curve: Curves.ease);
//       setState(() {
//       });
//     } else if(slidingSearch == 2) {
//       debugPrint('gg2');
//       subTabController.animateTo(2, duration: Duration(milliseconds: 0), curve: Curves.ease);
//       setState(() {
//       });
//     }
//   }
//   addCustomer2Cart1(data) {
//     widget._callback4(data);
//   }
//   addMerchant2Cart(data) {
//     widget._callback5(data);
//   }
//
//   void closeSearch() {
//     _searchController.clear();
//     debugPrint('clicked testing ');
//     FocusScope.of(context).unfocus();
//     setState(() {
//       loadingSearch = false;
//     });
//   }
//   void unfocusSearch() {
//     debugPrint('clicked testing 2');
//     FocusScope.of(context).unfocus();
//   }
//
//   changeData3(list, snpsht) {
//     // list[0].toString()
//     snpsht.docs.map((document) async {
//       for (var i = 0; i < list.length; i++) {
//         if (document.id.toString() == list[i].split('^')[3]) {
//           list[i] = list[i].split('^')[0] +
//               '^' +
//               list[i].split('^')[1] +
//               '^' +
//               list[i].split('^')[2] +
//               '^' +
//               document['customer_name'].toString() +
//               '&' +
//               list[i].split('^')[3] +
//               '^' +
//               list[i].split('^')[4] +
//               '^' +
//               list[i].split('^')[5] +
//               '^' +
//               list[i].split('^')[6] +
//               '^' +
//               list[i].split('^')[7] +
//               '^' +
//               list[i].split('^')[8] +
//               '^' + 's'
//           ;
//         }
//       }
//       // debugPrint('changeData ' + document['customer_name'].toString() + list[0].toString());
//     }).toList();
//
//     // debugPrint('changeData ' + snpsht.da);
//     return list;
//   }
//
//
//   changeData4(list, snpsht) {
//     // list[0].toString()
//     snpsht.docs.map((document) async {
//       for (var i = 0; i < list.length; i++) {
//         if (document.id.toString() == list[i].split('^')[3]) {
//           list[i] = list[i].split('^')[0] +
//               '^' +
//               list[i].split('^')[1] +
//               '^' +
//               list[i].split('^')[2] +
//               '^' +
//               document['merchant_name'].toString() +
//               '&' +
//               list[i].split('^')[3] +
//               '^' +
//               list[i].split('^')[4] +
//               '^' +
//               list[i].split('^')[5] +
//               '^' +
//               list[i].split('^')[6] +
//               '^' +
//               list[i].split('^')[7] +
//               '^' +
//               list[i].split('^')[8] +
//               '^' + 'b'
//           ;
//
//         }
//       }
//       // debugPrint('changeData ' + document['customer_name'].toString() + list[0].toString());
//     }).toList();
//
//     // debugPrint('changeData ' + snpsht.da);
//     return list;
//   }
//
//   searchFocus() {
//
//     setState(() {
//       loadingSearch = true;
//     });
//   }
//
//   Widget _buildHeader4(BuildContext context, int sectionIndex, int index) {
//     ExampleSection section = sectionList[sectionIndex];
//     // if(sectionIndex == 0) {
//     //   return Container(
//     //     height: 0.1,
//     //   );
//     // }
//     return InkWell(
//         child: Container(
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border(
//                   bottom: BorderSide(
//                       color: AppTheme.skBorderColor2,
//                       width: 1.0),
//                 )
//             ),
//             alignment: Alignment.centerLeft,
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Container(
//                 width: double.infinity,
//                 height: 33,
//                 child: Padding(
//                   // padding: const EdgeInsets.only(left: 15.0, top: 12, bottom: 0),
//                   padding: const EdgeInsets.only(left: 15.0, top: 1, bottom: 0),
//                   child: Row(
//                     children: [
//                       Text(
//                         // "BUY ORDERS",
//                         'PRODUCTS',
//                         // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
//                         style: TextStyle(
//                             height: 0.8,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             letterSpacing: 1.2,
//                             color: Colors.black
//                         ),
//                       ),
//
//                       Spacer(),
//                       searchValue != '' ?
//                       Padding(
//                         padding: const EdgeInsets.only(right: 15.0),
//                         child: section.header != '' ? Text(
//                           section.header.split('^')[1],
//                           // '0',
//                           // '#' + sectionList[sectionIndex].items.length.toString(),
//                           // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
//                           style: TextStyle(
//                             height: 0.8,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             letterSpacing: 1.2,
//                             color: Colors.black,
//                           ),
//                           textAlign: TextAlign.right,
//                         ): Padding(
//                           padding: const EdgeInsets.only(bottom: 1.0),
//                           child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
//                               child: CupertinoActivityIndicator(radius: 8,)),
//                         ),
//                       ):
//                       Padding(
//                         padding: const EdgeInsets.only(right: 15.0),
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 1.0),
//                           child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
//                               child: CupertinoActivityIndicator(radius: 8,)),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             )),
//         onTap: () {
//           //toggle section expand state
//           // setState(() {
//           //   section.setSectionExpanded(!section.isSectionExpanded());
//           // });
//         });
//   }
//
//   Widget _buildHeader1(BuildContext context, int sectionIndex, int index) {
//     ExampleSection section = sectionList1[sectionIndex];
//     // if(sectionIndex == 0) {
//     //   return Container(
//     //     height: 0.1,
//     //   );
//     // }
//     return InkWell(
//         child: Container(
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border(
//                   bottom: BorderSide(
//                       color: AppTheme.skBorderColor2,
//                       width: 1.0),
//                 )
//             ),
//             alignment: Alignment.centerLeft,
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Container(
//                 width: double.infinity,
//                 height: 33,
//                 child: Padding(
//                   // padding: const EdgeInsets.only(left: 15.0, top: 12, bottom: 0),
//                   padding: const EdgeInsets.only(left: 15.0, top: 1, bottom: 0),
//                   child: Row(
//                     children: [
//                       Text(
//                         sectionIndex == 0 ? "BUYERS" : "SELLERS",
//                         // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
//                         style: TextStyle(
//                             height: 0.8,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             letterSpacing: 1.2,
//                             color: Colors.black
//                         ),
//                       ),
//                       Spacer(),
//                       searchValue != '' ?
//                       Padding(
//                         padding: const EdgeInsets.only(right: 15.0),
//                         child: section.header != '' ? Text(
//                           section.header.split('^')[1],
//                           // '0',
//                           // '#' + sectionList[sectionIndex].items.length.toString(),
//                           // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
//                           style: TextStyle(
//                             height: 0.8,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             letterSpacing: 1.2,
//                             color: Colors.black,
//                           ),
//                           textAlign: TextAlign.right,
//                         ): Padding(
//                           padding: const EdgeInsets.only(bottom: 1.0),
//                           child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
//                               child: CupertinoActivityIndicator(radius: 8,)),
//                         ),
//                       ):
//                       Padding(
//                         padding: const EdgeInsets.only(right: 15.0),
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 1.0),
//                           child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
//                               child: CupertinoActivityIndicator(radius: 8,)),
//                         ),
//                       )
//                       ,
//                     ],
//                   ),
//                 ),
//               ),
//             )),
//         onTap: () {
//           //toggle section expand state
//           // setState(() {
//           //   section.setSectionExpanded(!section.isSectionExpanded());
//           // });
//         });
//   }
//
//   Widget _buildHeader2(BuildContext context, int sectionIndex, int index) {
//     ExampleSection section = sectionList2[sectionIndex];
//     // if(sectionIndex == 0) {
//     //   return Container(
//     //     height: 0.1,
//     //   );
//     // }
//     return InkWell(
//         child: Container(
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border(
//                   bottom: BorderSide(
//                       color: AppTheme.skBorderColor2,
//                       width: 1.0),
//                 )
//             ),
//             alignment: Alignment.centerLeft,
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Container(
//                 width: double.infinity,
//                 height: 33,
//                 child: Padding(
//                   // padding: const EdgeInsets.only(left: 15.0, top: 12, bottom: 0),
//                   padding: const EdgeInsets.only(left: 15.0, top: 1, bottom: 0),
//                   child: Row(
//                     children: [
//                       Text(
//                         section.header == '' ? 'SALE ORDERS' : section.header.split('^')[0].toUpperCase(),
//                         // sectionIndex == 0 ? "SALE ORDERS" : "BUY ORDERS",
//                         // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
//                         style: TextStyle(
//                             height: 0.8,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             letterSpacing: 1.2,
//                             color: Colors.black
//                         ),
//                       ),
//                       Spacer(),
//                       searchValue != '' ?
//                       Padding(
//                         padding: const EdgeInsets.only(right: 15.0),
//                         child: buySellOrderHeaders(section.header),
//                       ):
//                       Padding(
//                         padding: const EdgeInsets.only(right: 15.0),
//                         child: Padding(
//                           padding: const EdgeInsets.only(bottom: 1.0),
//                           child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
//                               child: CupertinoActivityIndicator(radius: 8,)),
//                         ),
//                       )
//                       ,
//                     ],
//                   ),
//                 ),
//               ),
//             )),
//         onTap: () {
//           //toggle section expand state
//           // setState(() {
//           //   section.setSectionExpanded(!section.isSectionExpanded());
//           // });
//         });
//   }
//
//   Widget _buildHeader3(BuildContext context, int sectionIndex, int index) {
//     return Container(
//         height: 50,
//         child: Center(child: Text('Searching...'))
//     );
//   }
//
//   Future<void> searchKeyChanged() async {
//     setState(() {
//       searchingOverAll = true;
//     });
//
//     if(searchValue != '') {
//       if(slidingSearch == 2) {
//         if(searchValue.toLowerCase().contains('b')) {
//           if(searchValue.contains('-')) {
//             searchValue = searchValue.split('-')[1];
//           }
//           debugPrint('hereeee');
//           sectionList2 = List<ExampleSection>.empty(growable: true);
//
//           subTabController.animateTo(2, duration: Duration(microseconds: 0), curve: Curves.ease);
//
//           debugPrint("search " + searchValue);
//           String max = searchValue;
//           // sectionList = [];
//           List detailIdList = [];
//
//           setState(() {
//             var sections = List<ExampleSection>.empty(growable: true);
//
//             var init = ExampleSection()
//               ..header = ''
//               ..items = ['']
//               ..expanded = true;
//
//             // var buyOrders = ExampleSection()
//             //   ..header = 'Products'
//             //   ..items = ['']
//             //   ..expanded = true;
//             sections.add(init);
//             // sections.add(buyOrders);
//             sectionList2 = sections;
//           });
//
//           await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('buyOrder')
//               .where('orderId',  isEqualTo: searchValue)
//               .get()
//               .then((QuerySnapshot querySnapshot2) async {
//             if(querySnapshot2.docs.length == 0) {
//               setState(() {
//                 detailIdList = [];
//                 setState(() {
//                   var sections = List<ExampleSection>.empty(growable: true);
//
//                   var saleOrders = ExampleSection()
//                     ..header = 'Buy orders^' + 'GG'
//                     ..items = detailIdList.cast<String>()
//                     ..expanded = true;
//
//                   // var buyOrders = ExampleSection()
//                   //   ..header = 'Buy orders^' + 'GG'
//                   //   ..items = detailIdList.cast<String>()
//                   //   ..expanded = true;
//
//                   debugPrint('buy ord ' + detailIdList.length.toString());
//                   sections.add(saleOrders);
//                   // sections.add(buyOrders);
//                   sectionList2 = sections;
//                 });
//               });
//             }
//             querySnapshot2.docs.forEach((doc) {
//               setState(() {
//                 detailIdList.add(doc['deviceId'] + doc['orderId'] + '^' + doc['deviceId'] + doc['orderId'] + '^' + doc['total'].toString() + '^' + doc['merchantId'] + '^' + doc['refund'] + '^' + doc['debt'].toString() + '^' + doc['discount'].toString() + '^' + doc['date'].toDate().hour.toString() + '^' + doc['date'].toDate().minute.toString());
//               });
//             });
//
//             await FirebaseFirestore.instance.collection('shops').doc(
//                 shopId).collection('merchants')
//                 .get()
//                 .then((QuerySnapshot querySnapshot3) {
//               setState(() {
//
//                 // if(detailIdList.length == 0) {
//                 //   noSearchData = true;
//                 // } else {
//                 //   noSearchData = false;
//                 // }
//                 var sections = List<ExampleSection>.empty(growable: true);
//
//                 var saleOrders = ExampleSection()
//                   ..header = 'Buy orders^' + detailIdList.length.toString()
//                   ..items = changeData4(detailIdList.cast<String>(), querySnapshot3)
//                 // ..items = detailIdList.cast<String>()
//                   ..expanded = true;
//
//                 // var buyOrders = ExampleSection()
//                 //   ..header = 'Buy orders^' + detailIdList.length.toString()
//                 //   ..items = detailIdList.cast<String>()
//                 //   ..expanded = true;
//
//                 //  debugPrint('buy ord ' + detailIdList.length.toString());
//                 sections.add(saleOrders);
//                 // sections.add(buyOrders);
//                 sectionList2 = sections;
//               });
//             });
//           });
//         } else {
//           if(searchValue.contains('-')) {
//             searchValue = searchValue.split('-')[1];
//           }
//           debugPrint('hereeee');
//           sectionList2 = List<ExampleSection>.empty(growable: true);
//
//           subTabController.animateTo(2, duration: Duration(microseconds: 0), curve: Curves.ease);
//
//           debugPrint("search " + searchValue);
//           String max = searchValue;
//           // sectionList = [];
//           List detailIdList = [];
//
//           setState(() {
//             var sections = List<ExampleSection>.empty(growable: true);
//
//             var init = ExampleSection()
//               ..header = ''
//               ..items = ['']
//               ..expanded = true;
//
//             // var buyOrders = ExampleSection()
//             //   ..header = 'Products'
//             //   ..items = ['']
//             //   ..expanded = true;
//             sections.add(init);
//             // sections.add(buyOrders);
//             sectionList2 = sections;
//           });
//
//           await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('order')
//               .where('orderId',  isEqualTo: searchValue)
//               .get()
//               .then((QuerySnapshot querySnapshot2) async {
//             if(querySnapshot2.docs.length == 0) {
//               setState(() {
//                 detailIdList = [];
//                 setState(() {
//                   var sections = List<ExampleSection>.empty(growable: true);
//
//                   var saleOrders = ExampleSection()
//                     ..header = 'Sale orders^' + 'GG'
//                     ..items = detailIdList.cast<String>()
//                     ..expanded = true;
//
//                   // var buyOrders = ExampleSection()
//                   //   ..header = 'Buy orders^' + 'GG'
//                   //   ..items = detailIdList.cast<String>()
//                   //   ..expanded = true;
//
//                   debugPrint('sale ord ' + detailIdList.length.toString());
//                   sections.add(saleOrders);
//                   // sections.add(buyOrders);
//                   sectionList2 = sections;
//                 });
//               });
//             }
//             querySnapshot2.docs.forEach((doc) {
//
//               setState(() {
//                 detailIdList.add(doc['deviceId'] + doc['orderId'] + '^' + doc['deviceId'] + doc['orderId'] + '^' + doc['total'].toString() + '^' + doc['customerId'] + '^' + doc['refund'] + '^' + doc['debt'].toString() + '^' + doc['discount'].toString() + '^' + doc['date'].toDate().hour.toString() + '^' + doc['date'].toDate().minute.toString());
//               });
//             });
//
//             await FirebaseFirestore.instance.collection('shops').doc(
//                 shopId).collection('customers')
//                 .get()
//                 .then((QuerySnapshot querySnapshot3) {
//               setState(() {
//
//                 // if(detailIdList.length == 0) {
//                 //   noSearchData = true;
//                 // } else {
//                 //   noSearchData = false;
//                 // }
//                 var sections = List<ExampleSection>.empty(growable: true);
//
//                 var saleOrders = ExampleSection()
//                   ..header = 'Sale orders^' + detailIdList.length.toString()
//                   ..items = changeData3(detailIdList.cast<String>(), querySnapshot3)
//                 // ..items = detailIdList.cast<String>()
//                   ..expanded = true;
//
//                 // var buyOrders = ExampleSection()
//                 //   ..header = 'Buy orders^' + detailIdList.length.toString()
//                 //   ..items = detailIdList.cast<String>()
//                 //   ..expanded = true;
//
//                 // debugPrint('buy ord ' + detailIdList.length.toString());
//                 sections.add(saleOrders);
//                 // sections.add(buyOrders);
//                 sectionList2 = sections;
//               });
//             });
//           });
//         }
//
//
//         //BUY BUY BUY
//
//
//
//
//
//       } else if (slidingSearch == 1) {
//         sectionList1 = [];
//         subTabController.animateTo(1, duration: Duration(microseconds: 1), curve: Curves.ease);
//
//         setState(() {
//           var sections = List<ExampleSection>.empty(growable: true);
//
//           var init = ExampleSection()
//             ..header = ''
//             ..items = ['']
//             ..expanded = true;
//
//           // var buyOrders = ExampleSection()
//           //   ..header = 'Products'
//           //   ..items = ['']
//           //   ..expanded = true;
//           sections.add(init);
//           sections.add(init);
//           // sections.add(buyOrders);
//           sectionList1 = sections;
//         });
//         List<String> items = [];
//         List<String> items1 = [];
//
//         await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('customers')
//             .get()
//             .then((QuerySnapshot querySnapshot) {
//
//           String sps = '^sps^';
//           querySnapshot.docs.forEach((doc) {
//             if(doc.id != 'name' && doc['customer_name'].toString().toLowerCase().contains(searchValue.toLowerCase())) {
//               setState(() {
//                 items.add(doc.id + sps + doc['customer_name'] + sps + doc['customer_phone'] + sps + doc['customer_address']);
//               });
//
//               // debugPrint(doc['prod_name'].toString());
//             }
//           });
//
//           if(items.length == 0) {
//             setState(() {
//               noSearchData = true;
//             });
//           } else {
//             setState(() {
//               noSearchData = false;
//             });
//           }
//
//
//         });
//
//
//         await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('merchants')
//             .get()
//             .then((QuerySnapshot querySnapshot) {
//
//           String sps = '^sps^';
//           querySnapshot.docs.forEach((doc) {
//             if(doc.id != 'name' && doc['merchant_name'].toString().toLowerCase().contains(searchValue.toLowerCase())) {
//               setState(() {
//                 items1.add(doc.id + sps + doc['merchant_name'] + sps + doc['merchant_phone'] + sps + doc['merchant_address']);
//               });
//
//               // debugPrint(doc['prod_name'].toString());
//             }
//           });
//
//           if(items1.length == 0) {
//             setState(() {
//               noSearchData = true;
//             });
//           } else {
//             setState(() {
//               noSearchData = false;
//             });
//           }
//
//
//         });
//
//         setState(() {
//           var sections = List<ExampleSection>.empty(growable: true);
//           // var sections1 = List<ExampleSection>.empty(growable: true);
//
//           var init = ExampleSection()
//             ..header = 'Customers^' + items.length.toString()
//             ..items = items
//             ..expanded = true;
//
//           var init1 = ExampleSection()
//             ..header = 'Merchants^' + items1.length.toString()
//             ..items = items1
//             ..expanded = true;
//
//           // var buyOrders = ExampleSection()
//           //   ..header = 'Products'
//           //   ..items = ['']
//           //   ..expanded = true;
//           sections.add(init);
//           sections.add(init1);
//           // sections.add(buyOrders);
//           sectionList1 = sections;
//         });
//
//
//       } else {
//
//         subTabController.animateTo(0, duration: Duration(microseconds: 0), curve: Curves.ease);
//
//         setState(() {
//           var sections = List<ExampleSection>.empty(growable: true);
//
//           var init = ExampleSection()
//             ..header = ''
//             ..items = ['']
//             ..expanded = true;
//
//           sections.add(init);
//           // sections.add(buyOrders);
//           sectionList = sections;
//         });
//         List<String> items = [];
//
//         await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products')
//             .get()
//             .then((QuerySnapshot querySnapshot) {
//
//           String sps = '^sps^';
//           querySnapshot.docs.forEach((doc) {
//             if(doc['prod_name'].toString().toLowerCase().contains(searchValue.toLowerCase())) {
//               setState(() {
//                 items.add(doc.id + sps +
//                     doc['prod_name'] + sps +
//                     doc['img_1'] + sps +
//                     doc['unit_sell'] + '-' + doc['inStock1'].toString() + '-' + doc['unit_name'] + sps +
//                     doc['sub1_sell'] + '-' + doc['inStock2'].toString() + '-' + doc['sub1_name'] + sps +
//                     doc['sub2_sell'] + '-' + doc['inStock2'].toString() + '-' + doc['sub2_name']);
//               });
//
//               debugPrint(doc['prod_name'].toString());
//             }
//           });
//
//           if(items.length == 0) {
//             setState(() {
//               noSearchData = true;
//             });
//           } else {
//             setState(() {
//               noSearchData = false;
//             });
//           }
//
//
//         });
//
//         setState(() {
//           var sections = List<ExampleSection>.empty(growable: true);
//
//           var init = ExampleSection()
//             ..header = 'Products^' + items.length.toString()
//             ..items = items
//             ..expanded = true;
//
//           // var buyOrders = ExampleSection()
//           //   ..header = 'Products'
//           //   ..items = ['']
//           //   ..expanded = true;
//           sections.add(init);
//           // sections.add(buyOrders);
//           sectionList = sections;
//         });
//
//
//       }
//     } else {
//       setState(() {
//         noSearchData = true;
//       });
//     }
//     Future.delayed(const Duration(milliseconds: 500), () async {
//
//
//
//       Future.delayed(const Duration(milliseconds: 500), () {
//         setState(() {
//           searchingOverAll = false;
//         });
//       });
//     });
//
//   }
//
//
//   String slidedTextFun() {
//     if(slidingSearch == 1) {
//       return 'Buy/Sells';
//     } else if(slidingSearch == 2) {
//       return 'Buy orders';
//     }
//     return 'SOmething';
//   }
//
//   buySellOrderHeaders(String header) {
//
//     if(header.contains('GG')) {
//       return Text(
//         '0',
//         // '0',
//         // '#' + sectionList[sectionIndex].items.length.toString(),
//         // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
//         style: TextStyle(
//           height: 0.8,
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//           letterSpacing: 1.2,
//           color: Colors.black,
//         ),
//         textAlign: TextAlign.right,
//       );
//     } else {
//       return header != '' ? Text(
//         header.split('^')[1],
//         // '0',
//         // '#' + sectionList[sectionIndex].items.length.toString(),
//         // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
//         style: TextStyle(
//           height: 0.8,
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//           letterSpacing: 1.2,
//           color: Colors.black,
//         ),
//         textAlign: TextAlign.right,
//       ): Padding(
//         padding: const EdgeInsets.only(bottom: 1.0),
//         child: Theme(data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.light)),
//             child: CupertinoActivityIndicator(radius: 8,)),
//       );
//     }
//   }
//
//   Future<String> countDocuments(myDoc) async {
//     QuerySnapshot _myDoc = await myDoc.get();
//     List<DocumentSnapshot> _myDocCount = _myDoc.docs;
//     return _myDocCount.length.toString();
//   }
//
//   final cateScCtler = ScrollController();
//   final _width = 10.0;
//   int cateScIndex = 0;
//
//   zeroToTen(String string) {
//     if (int.parse(string) > 9) {
//       return string;
//     } else {
//       return '0' + string;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // CollectionReference daily_exps = ;
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         brightness: Brightness.light,
//         toolbarHeight: 0,
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Container(
//           color: Colors.white,
//           child: StreamBuilder(
//               stream: FirebaseFirestore.instance.collection('shops').doc(shopId).collection('order')
//                   .where('date', isLessThanOrEqualTo: lossDayStart())
//                   .where('date', isGreaterThanOrEqualTo: lossDayEnd())
//                   .orderBy('date', descending: true)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if(snapshot.hasData) {
//                   return StreamBuilder(
//                       stream: FirebaseFirestore.instance.collection('shops').doc(shopId).collection('customers').snapshots(),
//                       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot2) {
//                         if(snapshot2.hasData) {
//                           var sections = List<ExampleSection>.empty(growable: true);
//                           int docInc = 0;
//                           debugPrint('HHHEEEE' + snapshot.data!.docs.length.toString() + ' ');
//
//                           if(docInc>0) {
//
//                           }
//
//                           //var ayinDoc = snapshot.data!.docs[0].data();
//
//
//
//                           if(snapshot.data!.docs.length>0) {
//                             Map<String, dynamic> data21 = snapshot.data!.docs[0].data()! as Map<String, dynamic>;
//                             var ayinDoc = data21['date'];
//
//
//
//                             debugPrint('here ' + ayinDoc.toDate().day.toString() + ' ' + ayinDoc.toString());
//
//                             List<String> itemsList = [data21['deviceId'] + data21['orderId'] + '^' + data21['deviceId'] + data21['orderId'] + '^' + data21['total'].toString() + '^' + data21['customerId'] + '^' + data21['refund'] + '^' + data21['debt'].toString() + '^' + data21['discount'].toString() + '^' + data21['date'].toDate().hour.toString() + '^' + data21['date'].toDate().minute.toString()];
//
//                             var section = ExampleSection()
//                               ..header = zeroToTen(data21['date'].toDate().month.toString()) + '-' + zeroToTen(data21['date'].toDate().day.toString())
//                             // ..items = List.generate(int.parse(document['length']), (index) => document.id)
//                             //   ..items = listCreation(document.id, document['data'], document).cast<String>()
//
//                             //   ..items = document['daily_order'].cast<String>()
//
//
//                               ..items = modifyChangeData(changeData(itemsList, snapshot2)).cast<String>()
//                             // ..items = orderItems(document.id)
//                               ..expanded = true;
//
//                             if(snapshot.data!.docs.length == 1) {
//                               sections.add(section);
//                             } else {
//                               for(int a = 1; a < snapshot.data!.docs.length; a++) {
//                                 Map<String, dynamic> data21Loop = snapshot.data!.docs[a].data()! as Map<String, dynamic>;
//                                 // var ayinDocLoo = data21Loop['date'];
//
//                                 debugPrint('CCC HERE' + data21['date'].toDate().toString() + ' ' + data21Loop['date'].toDate().toString());
//                                 if(!(data21['date'].toDate().day.toString() == data21Loop['date'].toDate().day.toString() && data21['date'].toDate().month.toString() == data21Loop['date'].toDate().month.toString())) {
//                                   debugPrint('not equal');
//                                   sections.add(section);
//                                   itemsList = [];
//                                   if(a == snapshot.data!.docs.length-1) {
//                                     section = ExampleSection()
//                                       ..header = zeroToTen(data21Loop['date'].toDate().month.toString()) + '-' + zeroToTen(data21Loop['date'].toDate().day.toString())
//                                       ..items = modifyChangeData(changeData([data21Loop['deviceId'] + data21Loop['orderId'] + '^' + data21Loop['deviceId'] + data21Loop['orderId'] + '^' + data21Loop['total'].toString() + '^' + data21Loop['customerId'] + '^' + data21Loop['refund'].toString() + '^' + data21Loop['debt'].toString() + '^' + data21Loop['discount'].toString() + '^' + data21Loop['date'].toDate().hour.toString() + '^' + data21Loop['date'].toDate().minute.toString()], snapshot2)).cast<String>()
//                                     // ..items = orderItems(document.id)
//                                       ..expanded = true;
//                                     sections.add(section);
//                                     break;
//                                   }
//                                 } else {
//                                   // itemsList.add(data21Loop['title']);
//                                   section = ExampleSection()
//                                     ..header = zeroToTen(data21Loop['date'].toDate().month.toString()) + '-' + zeroToTen(data21Loop['date'].toDate().day.toString())
//                                     ..items = modifyChangeData(changeData(itemsList, snapshot2)).cast<String>()
//                                   // ..items = orderItems(document.id)
//                                     ..expanded = true;
//                                 }
//
//                                 if(a == snapshot.data!.docs.length-1) {
//                                   sections.add(section);
//                                 }
//
//                                 data21 = snapshot.data!.docs[a].data()! as Map<String, dynamic>;
//                                 itemsList.add(data21Loop['deviceId'] + data21Loop['orderId'] + '^' + data21Loop['deviceId'] + data21Loop['orderId'] + '^' + data21Loop['total'].toString() + '^' + data21Loop['customerId'] + '^' + data21Loop['refund'] + '^' + data21Loop['debt'].toString() + '^' + data21Loop['discount'].toString() + '^' + data21Loop['date'].toDate().hour.toString() + '^' + data21Loop['date'].toDate().minute.toString());
//                                 section = ExampleSection()
//                                   ..header = zeroToTen(data21Loop['date'].toDate().month.toString()) + '-' + zeroToTen(data21Loop['date'].toDate().day.toString())
//                                 // ..items = List.generate(int.parse(document['length']), (index) => document.id)
//                                 //   ..items = listCreation(document.id, document['data'], document).cast<String>()
//
//                                 //   ..items = document['daily_order'].cast<String>()
//
//
//                                   ..items = modifyChangeData(changeData(itemsList, snapshot2)).cast<String>()
//                                 // ..items = orderItems(document.id)
//                                   ..expanded = true;
//                               }
//                             }
//                           }
//
//
//                           sectionList3 = sections;
//
//                           return CustomScrollView(
//                             slivers: <Widget>[
//                               SliverAppBar(
//                                 elevation: 0,
//                                 backgroundColor: Colors.white,
//
//                                 // Provide a standard title.
//
//                                 // Allows the user to reveal the app bar if they begin scrolling
//                                 // back up the list of items.
//                                 floating: true,
//                                 bottom: PreferredSize(                       // Add this code
//                                   preferredSize: Size.fromHeight(-2.0),      // Add this code
//                                   child: Container(),                           // Add this code
//                                 ),
//                                 flexibleSpace: Padding(
//                                   padding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 0.0),
//                                   child: Container(
//                                     height: 32,
//                                     width: MediaQuery.of(context).size.width,
//                                     // color: Colors.yellow,
//                                     child: Row(
//                                       children: [
//                                         Row(
//                                           children: [
//                                             CustomFlatButton(
//                                               padding: EdgeInsets.only(left: 10, right: 10),
//                                               color: AppTheme.secButtonColor,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.circular(8.0),
//                                                 side: BorderSide(
//                                                   color: AppTheme.skBorderColor2,
//                                                 ),
//                                               ),
//                                               onPressed: () {
//                                                 _showDatePicker(OneContext().context);
//                                               },
//                                               child: Container(
//                                                 child: Row(
//                                                   // mainAxisAlignment: Main,
//                                                   children: [
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(right: 1.0),
//                                                       child: Icon(
//                                                         Icons.calendar_view_day_rounded,
//                                                         size: 18,
//                                                       ),
//                                                     ),
//                                                     Text(
//                                                       selectDaysCast(),
//                                                       textAlign: TextAlign.center,
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight: FontWeight.w500,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(width: 12),
//                                             Container(
//                                               color: Colors.grey.withOpacity(0.2),
//                                               width: 1.5,
//                                               height: 30,
//                                             )
//                                           ],
//                                         ),
//                                         Expanded(
//                                           child: ListView(
//                                             controller: cateScCtler,
//                                             scrollDirection: Axis.horizontal,
//                                             children: [
//                                               SizedBox(
//                                                 width: 4,
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(left: 4.0, right: 4.0),
//                                                 child: CustomFlatButton(
//                                                   minWidth: 0,
//                                                   padding: EdgeInsets.only(left: 12, right: 12),
//                                                   color: cateScIndex == 0 ? AppTheme.secButtonColor:Colors.white,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius: BorderRadius.circular(20.0),
//                                                     side: BorderSide(
//                                                       color: AppTheme.skBorderColor2,
//                                                     ),
//                                                   ),
//                                                   onPressed: () {
//                                                     _animateToIndex(0);
//                                                     setState(() {
//                                                       cateScIndex = 0;
//                                                     });
//                                                   },
//                                                   child: Container(
//                                                     child: Text(
//                                                       'Alls',
//                                                       textAlign: TextAlign.center,
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight: FontWeight.w500,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(left: 4.0, right: 6.0),
//                                                 child: CustomFlatButton(
//                                                   minWidth: 0,
//                                                   padding: EdgeInsets.only(left: 12, right: 12),
//                                                   color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius: BorderRadius.circular(20.0),
//                                                     side: BorderSide(
//                                                       color: AppTheme.skBorderColor2,
//                                                     ),
//                                                   ),
//                                                   onPressed: () {
//                                                     _animateToIndex(5.4);
//                                                     setState(() {
//                                                       cateScIndex = 1;
//                                                     });
//                                                   },
//                                                   child: Container(
//                                                     child: Text(
//                                                       'Unpaids',
//                                                       textAlign: TextAlign.center,
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight: FontWeight.w500,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(left: 4.0, right: 6.0),
//                                                 child: CustomFlatButton(
//                                                   minWidth: 0,
//                                                   padding: EdgeInsets.only(left: 12, right: 12),
//                                                   color: cateScIndex == 2 ? AppTheme.secButtonColor:Colors.white,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius: BorderRadius.circular(20.0),
//                                                     side: BorderSide(
//                                                       color: AppTheme.skBorderColor2,
//                                                     ),
//                                                   ),
//                                                   onPressed: () {
//                                                     _animateToIndex(16.4);
//                                                     setState(() {
//                                                       cateScIndex = 2;
//                                                     });
//                                                   },
//                                                   child: Container(
//                                                     child: Text(
//                                                       'Refunds',
//                                                       textAlign: TextAlign.center,
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight: FontWeight.w500,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(left: 4.0, right: 4.0),
//                                                 child: CustomFlatButton(
//                                                   minWidth: 0,
//                                                   padding: EdgeInsets.only(left: 12, right: 12),
//                                                   color: cateScIndex == 3 ? AppTheme.secButtonColor:Colors.white,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius: BorderRadius.circular(20.0),
//                                                     side: BorderSide(
//                                                       color: AppTheme.skBorderColor2,
//                                                     ),
//                                                   ),
//                                                   onPressed: () {
//                                                     _animateToIndex(20);
//                                                     setState(() {
//                                                       cateScIndex = 3;
//                                                     });
//                                                   },
//                                                   child: Container(
//                                                     child: Text(
//                                                       'Paids',
//                                                       textAlign: TextAlign.center,
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight: FontWeight.w500,
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 11,
//                                               )
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//
//                                   ),
//                                 ),
//                                 // Display a placeholder widget to visualize the shrinking size.
//                                 // Make the initial height of the SliverAppBar larger than normal.
//                                 expandedHeight: 20,
//                               ),
//                               SliverExpandableList(
//                                 builder: SliverExpandableChildDelegate(
//                                   sectionList: sectionList3,
//                                   headerBuilder: _buildHeader,
//                                   itemBuilder: (context, sectionIndex, itemIndex, index) {
//                                     String item = sectionList3[sectionIndex].items[itemIndex];
//                                     int length = sectionList3[sectionIndex].items.length;
//
//                                     return cateScIndex == 0 ? GestureDetector(
//                                       onTap: () {
//                                         debugPrint('Items'+item);
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {}, shopId: shopId.toString(), togG2Cart: () {  },)),
//                                         );
//                                       },
//                                       child: Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 0.0, right: 0.0),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   color: AppTheme.lightBgColor,
//                                                   border: Border(
//                                                     bottom: BorderSide(
//                                                         color: AppTheme.skBorderColor2,
//                                                         width: 1.0),
//                                                   )),
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(left: 1.0),
//                                                       child: Column(
//                                                         mainAxisAlignment: MainAxisAlignment.start,
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           Row(
//                                                             mainAxisAlignment: MainAxisAlignment.start,
//                                                             children: [
//                                                               Text('#' + item.split('^')[1],
//                                                                 style: TextStyle(
//                                                                     fontSize: 16,
//                                                                     fontWeight: FontWeight.w500
//                                                                 ),
//                                                               ),
//                                                               SizedBox(width: 8),
//                                                               Padding(
//                                                                 padding: const EdgeInsets.only(bottom: 1.0),
//                                                                 child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
//                                                               ),
//                                                               SizedBox(width: 4),
//                                                               Text(convertToHour(item.split('^')[7]) + ':' + item.split('^')[8] + ' ' + convertToAMPM(item.split('^')[7]),
//                                                                 style: TextStyle(
//                                                                   fontSize: 14,
//                                                                   fontWeight: FontWeight.w500,
//                                                                   color: Colors.grey,
//                                                                 ),
//                                                               ),
//                                                               // Text(item.split('^')[7] + ':' + item.split('^')[8] ,
//                                                               //   style: TextStyle(
//                                                               //     fontSize: 14,
//                                                               //     fontWeight: FontWeight.w500,
//                                                               //     color: Colors.grey,
//                                                               //   ),
//                                                               // ),
//                                                             ],
//                                                           ),
//                                                           SizedBox(
//                                                             height: 6,
//                                                           ),
//                                                           Row(
//                                                             children: [
//                                                               Text(item.split('^')[3].split('&')[0], style: TextStyle(
//                                                                 fontSize: 15,
//                                                                 fontWeight: FontWeight.w500,
//                                                                 color: Colors.grey,
//                                                               )),
//
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 8,
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         if(item.split('^')[5] == '0.0')
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 0.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeBgSuccess,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Paid',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.white
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                         if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 0.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeFgDangerLight,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Partially paid',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: AppTheme.badgeFgDanger
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 0.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeFgDanger,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Unpaid',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.white
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         if(item.split('^')[4] == 'TRUE')
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 6.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeBgSecond,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Refunded',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.white
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                         if(item.split('^')[4] == 'PART')
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 6.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeBgSecondLight,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
//                                                                 child: Text('Partially refunded',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: AppTheme.badgeBgSecond
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(right: 15.0, bottom: 5),
//                                             child: Align(
//                                               alignment: Alignment.centerRight,
//                                               child: Row(
//                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                 children: [
//                                                   Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight: FontWeight.w500,
//                                                   )),
//                                                   SizedBox(width: 10),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(bottom: 2.0),
//                                                     child: Icon(
//                                                       Icons
//                                                           .arrow_forward_ios_rounded,
//                                                       size: 16,
//                                                       color: Colors
//                                                           .blueGrey
//                                                           .withOpacity(
//                                                           0.8),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ) : cateScIndex == 1 && item.split('^')[5] != '0.0' ?
//                                     GestureDetector(
//                                       onTap: () {
//                                         debugPrint('Items'+item);
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {}, shopId: shopId.toString(), togG2Cart: () {  },)),
//                                         );
//                                       },
//                                       child: Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 0.0, right: 0.0),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   color: AppTheme.lightBgColor,
//                                                   border: Border(
//                                                     bottom: BorderSide(
//                                                         color: AppTheme.skBorderColor2,
//                                                         width: 1.0),
//                                                   )),
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(left: 1.0),
//                                                       child: Column(
//                                                         mainAxisAlignment: MainAxisAlignment.start,
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           Row(
//                                                             mainAxisAlignment: MainAxisAlignment.start,
//                                                             children: [
//                                                               Text('#' + item.split('^')[1],
//                                                                 style: TextStyle(
//                                                                     fontSize: 16,
//                                                                     fontWeight: FontWeight.w500
//                                                                 ),
//                                                               ),
//                                                               SizedBox(width: 8),
//                                                               Padding(
//                                                                 padding: const EdgeInsets.only(bottom: 1.0),
//                                                                 child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
//                                                               ),
//                                                               SizedBox(width: 4),
//                                                               Text(convertToHour(item.split('^')[7]) + ':' + item.split('^')[8] + ' ' + convertToAMPM(item.split('^')[7]),
//                                                                 style: TextStyle(
//                                                                   fontSize: 14,
//                                                                   fontWeight: FontWeight.w500,
//                                                                   color: Colors.grey,
//                                                                 ),
//                                                               ),
//                                                               // Text(item.split('^')[7] + ':' + item.split('^')[8] ,
//                                                               //   style: TextStyle(
//                                                               //     fontSize: 14,
//                                                               //     fontWeight: FontWeight.w500,
//                                                               //     color: Colors.grey,
//                                                               //   ),
//                                                               // ),
//                                                             ],
//                                                           ),
//                                                           SizedBox(
//                                                             height: 6,
//                                                           ),
//                                                           Row(
//                                                             children: [
//                                                               Text(item.split('^')[3].split('&')[0], style: TextStyle(
//                                                                 fontSize: 15,
//                                                                 fontWeight: FontWeight.w500,
//                                                                 color: Colors.grey,
//                                                               )),
//
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 8,
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         if(item.split('^')[5] == '0.0')
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 0.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeBgSuccess,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Paid',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.white
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                         if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 0.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeFgDangerLight,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Partially paid',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: AppTheme.badgeFgDanger
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 0.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeFgDanger,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Unpaid',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.white
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         if(item.split('^')[4] == 'TRUE')
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 6.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeBgSecond,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Refunded',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.white
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                         if(item.split('^')[4] == 'PART')
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 6.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeBgSecondLight,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
//                                                                 child: Text('Partially refunded',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: AppTheme.badgeBgSecond
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(right: 15.0, bottom: 5),
//                                             child: Align(
//                                               alignment: Alignment.centerRight,
//                                               child: Row(
//                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                 children: [
//                                                   Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight: FontWeight.w500,
//                                                   )),
//                                                   SizedBox(width: 10),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(bottom: 2.0),
//                                                     child: Icon(
//                                                       Icons
//                                                           .arrow_forward_ios_rounded,
//                                                       size: 16,
//                                                       color: Colors
//                                                           .blueGrey
//                                                           .withOpacity(
//                                                           0.8),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ) :
//                                     cateScIndex == 2 && item.split('^')[4] != 'FALSE' ? GestureDetector(
//                                       onTap: () {
//                                         debugPrint('Items'+item);
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {}, shopId: shopId.toString(), togG2Cart: () {  },)),
//                                         );
//                                       },
//                                       child: Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 0.0, right: 0.0),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   color: AppTheme.lightBgColor,
//                                                   border: Border(
//                                                     bottom: BorderSide(
//                                                         color: AppTheme.skBorderColor2,
//                                                         width: 1.0),
//                                                   )),
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(left: 1.0),
//                                                       child: Column(
//                                                         mainAxisAlignment: MainAxisAlignment.start,
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           Row(
//                                                             mainAxisAlignment: MainAxisAlignment.start,
//                                                             children: [
//                                                               Text('#' + item.split('^')[1],
//                                                                 style: TextStyle(
//                                                                     fontSize: 16,
//                                                                     fontWeight: FontWeight.w500
//                                                                 ),
//                                                               ),
//                                                               SizedBox(width: 8),
//                                                               Padding(
//                                                                 padding: const EdgeInsets.only(bottom: 1.0),
//                                                                 child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
//                                                               ),
//                                                               SizedBox(width: 4),
//                                                               Text(convertToHour(item.split('^')[7]) + ':' + item.split('^')[8] + ' ' + convertToAMPM(item.split('^')[7]),
//                                                                 style: TextStyle(
//                                                                   fontSize: 14,
//                                                                   fontWeight: FontWeight.w500,
//                                                                   color: Colors.grey,
//                                                                 ),
//                                                               ),
//                                                               // Text(item.split('^')[7] + ':' + item.split('^')[8] ,
//                                                               //   style: TextStyle(
//                                                               //     fontSize: 14,
//                                                               //     fontWeight: FontWeight.w500,
//                                                               //     color: Colors.grey,
//                                                               //   ),
//                                                               // ),
//                                                             ],
//                                                           ),
//                                                           SizedBox(
//                                                             height: 6,
//                                                           ),
//                                                           Row(
//                                                             children: [
//                                                               Text(item.split('^')[3].split('&')[0], style: TextStyle(
//                                                                 fontSize: 15,
//                                                                 fontWeight: FontWeight.w500,
//                                                                 color: Colors.grey,
//                                                               )),
//
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 8,
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         if(item.split('^')[5] == '0.0')
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 0.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeBgSuccess,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Paid',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.white
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                         if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 0.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeFgDangerLight,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Partially paid',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: AppTheme.badgeFgDanger
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 0.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeFgDanger,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Unpaid',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.white
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         if(item.split('^')[4] == 'TRUE')
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 6.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeBgSecond,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Refunded',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.white
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                         if(item.split('^')[4] == 'PART')
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 6.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeBgSecondLight,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
//                                                                 child: Text('Partially refunded',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: AppTheme.badgeBgSecond
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(right: 15.0, bottom: 5),
//                                             child: Align(
//                                               alignment: Alignment.centerRight,
//                                               child: Row(
//                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                 children: [
//                                                   Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight: FontWeight.w500,
//                                                   )),
//                                                   SizedBox(width: 10),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(bottom: 2.0),
//                                                     child: Icon(
//                                                       Icons
//                                                           .arrow_forward_ios_rounded,
//                                                       size: 16,
//                                                       color: Colors
//                                                           .blueGrey
//                                                           .withOpacity(
//                                                           0.8),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ) :
//                                     cateScIndex == 3 && item.split('^')[5] == '0.0' ? GestureDetector(
//                                       onTap: () {
//                                         debugPrint('Items'+item);
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {}, shopId: shopId.toString(), togG2Cart: () {  },)),
//                                         );
//                                       },
//                                       child: Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 0.0, right: 0.0),
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                   color: AppTheme.lightBgColor,
//                                                   border: Border(
//                                                     bottom: BorderSide(
//                                                         color: AppTheme.skBorderColor2,
//                                                         width: 1.0),
//                                                   )),
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
//                                                 child: Column(
//                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                                   children: [
//                                                     Padding(
//                                                       padding: const EdgeInsets.only(left: 1.0),
//                                                       child: Column(
//                                                         mainAxisAlignment: MainAxisAlignment.start,
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           Row(
//                                                             mainAxisAlignment: MainAxisAlignment.start,
//                                                             children: [
//                                                               Text('#' + item.split('^')[1],
//                                                                 style: TextStyle(
//                                                                     fontSize: 16,
//                                                                     fontWeight: FontWeight.w500
//                                                                 ),
//                                                               ),
//                                                               SizedBox(width: 8),
//                                                               Padding(
//                                                                 padding: const EdgeInsets.only(bottom: 1.0),
//                                                                 child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
//                                                               ),
//                                                               SizedBox(width: 4),
//                                                               Text(convertToHour(item.split('^')[7]) + ':' + item.split('^')[8] + ' ' + convertToAMPM(item.split('^')[7]),
//                                                                 style: TextStyle(
//                                                                   fontSize: 14,
//                                                                   fontWeight: FontWeight.w500,
//                                                                   color: Colors.grey,
//                                                                 ),
//                                                               ),
//                                                               // Text(item.split('^')[7] + ':' + item.split('^')[8] ,
//                                                               //   style: TextStyle(
//                                                               //     fontSize: 14,
//                                                               //     fontWeight: FontWeight.w500,
//                                                               //     color: Colors.grey,
//                                                               //   ),
//                                                               // ),
//                                                             ],
//                                                           ),
//                                                           SizedBox(
//                                                             height: 6,
//                                                           ),
//                                                           Row(
//                                                             children: [
//                                                               Text(item.split('^')[3].split('&')[0], style: TextStyle(
//                                                                 fontSize: 15,
//                                                                 fontWeight: FontWeight.w500,
//                                                                 color: Colors.grey,
//                                                               )),
//
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 8,
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         if(item.split('^')[5] == '0.0')
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 0.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeBgSuccess,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Paid',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.white
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                         if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 0.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeFgDangerLight,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Partially paid',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: AppTheme.badgeFgDanger
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 0.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeFgDanger,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Unpaid',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.white
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         if(item.split('^')[4] == 'TRUE')
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 6.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeBgSecond,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                                                 child: Text('Refunded',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: Colors.white
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                         if(item.split('^')[4] == 'PART')
//                                                           Padding(
//                                                             padding: const EdgeInsets.only(left: 6.0),
//                                                             child: Container(
//                                                               height: 21,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(20.0),
//                                                                 color: AppTheme.badgeBgSecondLight,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
//                                                                 child: Text('Partially refunded',
//                                                                   style: TextStyle(
//                                                                       fontSize: 13,
//                                                                       fontWeight: FontWeight.w500,
//                                                                       color: AppTheme.badgeBgSecond
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(right: 15.0, bottom: 5),
//                                             child: Align(
//                                               alignment: Alignment.centerRight,
//                                               child: Row(
//                                                 mainAxisAlignment: MainAxisAlignment.end,
//                                                 children: [
//                                                   Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
//                                                     fontSize: 15,
//                                                     fontWeight: FontWeight.w500,
//                                                   )),
//                                                   SizedBox(width: 10),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(bottom: 2.0),
//                                                     child: Icon(
//                                                       Icons
//                                                           .arrow_forward_ios_rounded,
//                                                       size: 16,
//                                                       color: Colors
//                                                           .blueGrey
//                                                           .withOpacity(
//                                                           0.8),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ) : Container();
//
//                                     // return Container(
//                                     //   child: Text(item)
//                                     // );
//                                   },
//                                 ),
//                               )
//                             ],
//                           );
//
//                         } else {
//                           return Container();
//                         }
//                       }
//                   );
//                 } else {
//                   return Container();
//                 }
//
//               }
//           ),
//         ),
//       ),
//     );
//   }
//
//   _animateToIndex(i) {
//     // debugPrint((_width * i).toString() + ' BBB ' + cateScCtler.offset.toString() + ' BBB ' + cateScCtler.position.maxScrollExtent.toString());
//     if((_width * i) > cateScCtler.position.maxScrollExtent) {
//       cateScCtler.animateTo(cateScCtler.position.maxScrollExtent, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
//     } else {
//       cateScCtler.animateTo(_width * i, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
//     }
//
//   }
//
//
//
//   covertToDayNum(String input) {
//     if(input[0]=='0') {
//       return input[1];
//     } else {
//       return input;
//     }
//   }
//
//   checkTest(String input) {
//     debugPrint("CHECK TEST " + input);
//   }
//
//   convertToAMPM(String input){
//     switch (input) {
//       case '0':
//         return 'AM';
//         break;
//       case '1':
//         return 'AM';
//         break;
//       case '2':
//         return 'AM';
//         break;
//       case '3':
//         return 'AM';
//         break;
//       case '4':
//         return 'AM';
//         break;
//       case '5':
//         return 'AM';
//         break;
//       case '6':
//         return 'AM';
//         break;
//       case '7':
//         return 'AM';
//         break;
//       case '8':
//         return 'AM';
//         break;
//       case '9':
//         return 'AM';
//         break;
//       case '10':
//         return 'AM';
//         break;
//       case '11':
//         return 'AM';
//         break;
//       case '12':
//         return 'PM';
//         break;
//       case '13':
//         return 'PM';
//         break;
//       case '14':
//         return 'PM';
//         break;
//       case '15':
//         return 'PM';
//         break;
//       case '16':
//         return 'PM';
//         break;
//       case '17':
//         return 'PM';
//         break;
//       case '18':
//         return 'PM';
//         break;
//       case '19':
//         return 'PM';
//         break;
//       case '20':
//         return 'PM';
//         break;
//       case '21':
//         return 'PM';
//         break;
//       case '22':
//         return 'PM';
//         break;
//       case '23':
//         return 'PM';
//         break;
//     }
//   }
//
//   convertToHour(String input){
//     switch (input) {
//       case '0':
//         return '00';
//         break;
//       case '1':
//         return '01';
//         break;
//       case '2':
//         return '02';
//         break;
//       case '3':
//         return '03';
//         break;
//       case '4':
//         return '04';
//         break;
//       case '5':
//         return '05';
//         break;
//       case '6':
//         return '06';
//         break;
//       case '7':
//         return '07';
//         break;
//       case '8':
//         return '08';
//         break;
//       case '9':
//         return '09';
//         break;
//       case '10':
//         return '10';
//         break;
//       case '11':
//         return '11';
//         break;
//       case '12':
//         return '12';
//         break;
//       case '13':
//         return '1';
//         break;
//       case '14':
//         return '2';
//         break;
//       case '15':
//         return '3';
//         break;
//       case '16':
//         return '4';
//         break;
//       case '17':
//         return '5';
//         break;
//       case '18':
//         return '6';
//         break;
//       case '19':
//         return '7';
//         break;
//       case '20':
//         return '8';
//         break;
//       case '21':
//         return '9';
//         break;
//       case '22':
//         return '10';
//         break;
//       case '23':
//         return '11';
//         break;
//     }
//   }
//
//   convertToDate(String input) {
//     switch (input.substring(4,6)) {
//       case '01':
//         return 'JANUARY';
//         break;
//       case '02':
//         return 'FEBRUARY';
//         break;
//       case '03':
//         return 'MARCH';
//         break;
//       case '04':
//         return 'APRIL';
//         break;
//       case '05':
//         return 'MAY';
//         break;
//       case '06':
//         return 'JUN';
//         break;
//       case '07':
//         return 'JULY';
//         break;
//       case '08':
//         return 'AUGUST';
//         break;
//       case '09':
//         return 'SEPTEMBER';
//         break;
//       case '10':
//         return 'OCTOBER';
//         break;
//       case '11':
//         return 'NOVEMBER';
//         break;
//       case '12':
//         return 'DECEMBER';
//         break;
//     }
//   }
//
//   convertToDate2(String input) {
//     switch (input) {
//       case '01':
//         return 'JANUARY';
//         break;
//       case '02':
//         return 'FEBRUARY';
//         break;
//       case '03':
//         return 'MARCH';
//         break;
//       case '04':
//         return 'APRIL';
//         break;
//       case '05':
//         return 'MAY';
//         break;
//       case '06':
//         return 'JUN';
//         break;
//       case '07':
//         return 'JULY';
//         break;
//       case '08':
//         return 'AUGUST';
//         break;
//       case '09':
//         return 'SEPTEMBER';
//         break;
//       case '10':
//         return 'OCTOBER';
//         break;
//       case '11':
//         return 'NOVEMBER';
//         break;
//       case '12':
//         return 'DECEMBER';
//         break;
//     }
//   }
//
//   modifyChangeData(list) {
//     List<String> newList = [];
//
//     for (int i = 0; i < list.length; i++) {
//       if(cateScIndex == 1) {
//         if(double.parse(list[i].split('^')[5]) > 0.0) {
//           newList.add(list[i]);
//         }
//       } else if(cateScIndex == 0) {
//         newList.add(list[i]);
//       }
//     }
//     return newList;
//   }
//
//   changeData(list, snpsht) {
//     // list[0].toString()
//     snpsht.data!.docs.map((document) async {
//       for (var i = 0; i < list.length; i++) {
//         if (document.id.toString() == list[i].split('^')[3]) {
//           list[i] = list[i].split('^')[0] +
//               '^' +
//               list[i].split('^')[1] +
//               '^' +
//               list[i].split('^')[2] +
//               '^' +
//               document['customer_name'].toString() +
//               '&' +
//               list[i].split('^')[3] +
//               '^' +
//               list[i].split('^')[4] +
//               '^' +
//               list[i].split('^')[5] +
//               '^' +
//               list[i].split('^')[6] +
//               '^' +
//               list[i].split('^')[7] +
//               '^' +
//               list[i].split('^')[8]
//           ;
//         }
//       }
//       // debugPrint('changeData ' + document['customer_name'].toString() + list[0].toString());
//     }).toList();
//
//     // debugPrint('changeData ' + snpsht.da);
//     return list;
//   }
//
//   changeData2(list, snpsht) {
//     // list[0].toString()
//     snpsht.data!.docs.map((document) async {
//       for (var i = 0; i < list.length; i++) {
//         if (document.id.toString() == list[i].split('^')[3]) {
//           list[i] = list[i].split('^')[0] +
//               '^' +
//               list[i].split('^')[1] +
//               '^' +
//               list[i].split('^')[2] +
//               '^' +
//               // document['customer_name'].toString() +
//               '&' +
//               list[i].split('^')[3] +
//               '^' +
//               list[i].split('^')[4];
//         }
//       }
//       // debugPrint('changeData ' + document['customer_name'].toString() + list[0].toString());
//     }).toList();
//
//     // debugPrint('changeData ' + snpsht.da);
//     return list;
//   }
//
//   sortList(list) {
//     var dlist = list;
//     dlist.sort();
//     var newList = List.from(dlist.reversed);
//     // dlist.sort((a, b) => b.compareTo(a));
//     return newList.cast<String>();
//     // list.sort(alphabetic('name'));
//   }
//
//   Widget _buildHeader(BuildContext context, int sectionIndex, int index) {
//     ExampleSection section = sectionList3[sectionIndex];
//     debugPrint('section check25 '+ sectionList3[sectionIndex].items.toString());
//     if(sectionList3[sectionIndex].items.length == 0) {
//       return Container();
//     }
//     for (String str in sectionList3[sectionIndex].items) {
//
//     }
//     return InkWell(
//         child: Container(
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border(
//                   bottom: BorderSide(
//                       color: AppTheme.skBorderColor2,
//                       width: 1.0),
//                 )
//             ),
//             alignment: Alignment.centerLeft,
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Container(
//                 width: double.infinity,
//                 height: 33,
//                 child: Padding(
//                   // padding: const EdgeInsets.only(left: 15.0, top: 12, bottom: 0),
//                   padding: const EdgeInsets.only(left: 15.0, top: 1, bottom: 0),
//                   child: Row(
//                     children: [
//                       Text(
//                         // "TODAY",
//                         // checkTest(section.header),
//                         convertToDate2(section.header.split('-')[0]) + ' ' + section.header.split('-')[1],
//                         //covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
//                         style: TextStyle(
//                             height: 0.8,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             letterSpacing: 1.2,
//                             color: Colors.black
//                         ),
//                       ),
//
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(right: 15.0),
//                           child: Text(
//                             // "#30",
//                             '#' + sectionList3[sectionIndex].items.length.toString(),
//                             // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
//                             style: TextStyle(
//                               height: 0.8,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               letterSpacing: 1.2,
//                               color: Colors.black,
//                             ),
//                             textAlign: TextAlign.right,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )),
//         onTap: () {
//
//           //toggle section expand state
//           // setState(() {
//           //   section.setSectionExpanded(!section.isSectionExpanded());
//           // });
//         });
//   }
//
//   List<String> gloTemp = [];
//
//   // listCreation(String id, data, document) {
//   //   List<String> temp = [];
//   //   // temp.add('add');
//   //   // temp.add('add2');UzZeGlXAnNfrH7icA1ki
//   //
//   //   // FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(id).collection('detail')
//   //   //     .get()
//   //   //     .then((QuerySnapshot querySnapshot) {
//   //   //   querySnapshot.docs.forEach((doc) {
//   //   //     temp.add(doc["cust_name"]);
//   //   //     // setState(() {
//   //   //     //   gloTemp = temp;
//   //   //     // });
//   //   //     // gloTemp = temp;
//   //   //   });
//   //   //
//   //   // }).then((value) {
//   //   //   // debugPrint('here ' + temp.toString());
//   //   //   //return temp;
//   //   //   // return gloTemp;
//   //   // });
//   //   // debugPrint('here2 ' + temp.toString());
//   //   // return gloTemp;
//   //
//   //
//   //   // for()
//   //   // var noExe = true;
//   //
//   //
//   //   temp = data.split('^');
//   //
//   // }
//
//   addDailyExp(priContext) {
//     // myController.clear();
//     showModalBottomSheet(
//         enableDrag: false,
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext context) {
//           return Scaffold(
//             resizeToAvoidBottomInset: false,
//             body: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               // mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   height: MediaQuery.of(priContext).padding.top,
//                 ),
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
//                               color: Colors.white.withOpacity(0.5)),
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
//                             width: 150,
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: 50,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(15.0),
//                                       topRight: Radius.circular(15.0),
//                                     ),
//                                     color: Colors.grey.withOpacity(0.1),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.close,
//                                           size: 20,
//                                           color: Colors.transparent,
//                                         ),
//                                         onPressed: () {},
//                                       ),
//                                       Text(
//                                         "New Expense",
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 17,
//                                             fontFamily: 'capsulesans',
//                                             fontWeight: FontWeight.w600),
//                                         textAlign: TextAlign.left,
//                                       ),
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.close,
//                                           size: 20,
//                                           color: Colors.black,
//                                         ),
//                                         onPressed: () {
//                                           Navigator.pop(context);
//                                           debugPrint('clicked');
//                                         },
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     color: Colors.yellow,
//                     height: 100,
//                   ),
//                 )
//               ],
//             ),
//           );
//         });
//   }
//
//   DateTime today = DateTime.now();
//   DateTime? _dateTime;
//   String _format = 'yyyy-MMMM';
//
//
//
//   void _showDatePicker(context) {
//     DatePicker.showDatePicker(
//       context,
//       onMonthChangeStartWithFirstDate: true,
//       pickerTheme: DateTimePickerTheme(
//         showTitle: false,
//         confirm: Text('Done', style: TextStyle(color: Colors.blue)),
//       ),
//       minDateTime: DateTime.parse('2010-05-12'),
//       // maxDateTime: DateTime.parse('2021-11-25'),
//       maxDateTime: DateTime.now().add(const Duration(days: 365)),
//       initialDateTime: today,
//       dateFormat: _format,
//       locale: DateTimePickerLocale.en_us,
//       onClose: () {
//         setState((){
//           _dateTime = _dateTime;
//           today = today;
//           // DateTime td = DateTime.now();
//           debugPrint('closed 1 ' + today.toString());
//           // debugPrint('closed 2 ' + td.toString());
//         });
//         // fetchOrders();
//       },
//       onCancel: () => debugPrint('onCancel'),
//       onChange: (dateTime, List<int> index) {
//         // setState(() {
//         today = dateTime;
//         _dateTime = dateTime;
//         // });
//
//
//       },
//       onConfirm: (dateTime, List<int> index) {
//         setState(() {
//           today = dateTime;
//           _dateTime = dateTime;
//         });
//       },
//     );
//   }
//
//   DateTime lossDayStart() {
//     // DateTime today = DateTime.now();
//     // DateTime yearStart = DateTime.now();
//     // DateTime tempDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
//     // today.
//     String endDateOfMonth = '31';
//     if(today.month.toString() == '9' || today.month.toString() == '4' || today.month.toString() == '6' || today.month.toString() == '11') {
//       endDateOfMonth = '30';
//     } else if(today.month.toString() == '2') {
//       endDateOfMonth = '29';
//     } else {
//       endDateOfMonth = '31';
//     }
//     DateTime yearStart = DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-' + zeroToTen(today.month.toString()) + '-' + endDateOfMonth + ' 23:59:59');
//     debugPrint('DDDD ' + yearStart.toString());
//     return yearStart;
//   }
//
//   lossDayEnd() {
//     // DateTime today = DateTime.now();
//     // DateTime yearStart = DateTime.now();
//     // DateTime tempDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(today.year.toString() + '-01-01 00:00:00');
//     // today.
//     DateTime notTday = today;
//     notTday = today;
//     DateTime yearStart = DateFormat("yyyy-MM-dd HH:mm:ss").parse(notTday.year.toString() + '-' + zeroToTen(notTday.month.toString()) + '-00 00:00:00');
//     debugPrint('DDDD ' + yearStart.toString());
//     return yearStart;
//
//   }
//
//   String selectDaysCast() {
//     debugPrint("TTT " + today.year.toString().length.toString());
//     // if(_sliding==0) {
//     // today.year.toString().substring(today.year.toString().length-2, today.year.toString().length
//     if(today.month == 9) {
//       return 'Sep, ' + today.year.toString();
//     } else if(today.month == 1) {
//       return 'Jan, ' + today.year.toString();
//     } else if(today.month == 2) {
//       return 'Feb, ' + today.year.toString();
//     } else if(today.month == 3) {
//       return 'Mar, ' + today.year.toString();
//     } else if(today.month == 4) {
//       return 'Apr, ' + today.year.toString();
//     } else if(today.month == 5) {
//       return 'May, ' + today.year.toString();
//     } else if(today.month == 6) {
//       return 'Jun, ' + today.year.toString();
//     } else if(today.month == 7) {
//       return 'Jul, ' + today.year.toString();
//     } else if(today.month == 8) {
//       return 'Aug, ' + today.year.toString();
//     } else if(today.month == 10) {
//       return 'Oct, ' + today.year.toString();
//     } else if(today.month == 11) {
//       return 'Nov, ' + today.year.toString();
//     } else if(today.month == 12) {
//       return 'Dec, ' + today.year.toString();
//     } else {
//       return '';
//     }
//
//   }
//
// // List<String> orderItems(String id) {}
// }
//
// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   _SliverAppBarDelegate(this._tabBar);
//
//   final Container _tabBar;
//
//   @override
//   double get minExtent => 101;
//   @override
//   double get maxExtent => 101;
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return new Container(
//       height: 200,
//       color: Colors.transparent,
//       child: _tabBar,
//     );
//   }
//
//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return false;
//   }
// }
//
// ///Section model example
// ///
// ///Section model must implements ExpandableListSection<T>, each section has
// ///expand state, sublist. "T" is the model of each item in the sublist.
// class ExampleSection implements ExpandableListSection<String> {
//   //store expand state.
//   late bool expanded;
//
//   //return item model list.
//   late List<String> items;
//
//   //example header, optional
//   late String header;
//
//   @override
//   List<String> getItems() {
//     return items;
//   }
//
//   @override
//   bool isSectionExpanded() {
//     return expanded;
//   }
//
//   @override
//   void setSectionExpanded(bool expanded) {
//     this.expanded = expanded;
//   }
// }
//
// // debugPrint(item.split('^')[0].substring(0,8));
// // var dateId = '';
// // FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
// // // FirebaseFirestore.instance.collection('space')
// // .where('date', isEqualTo: item.split('^')[0].substring(0,8))
// // .get()
// //     .then((QuerySnapshot querySnapshot) {
// // querySnapshot.docs.forEach((doc) {
// // dateId = doc.id;
// // FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId)
// //
// //     .update({
// // 'daily_order': FieldValue.arrayRemove([item])
// // })
// //     .then((value) {
// // debugPrint('array removed');
// //
// // FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId)
// //
// //     .update({
// // 'daily_order': FieldValue.arrayUnion([item.split('^')[0]+'^'+item.split('^')[1]+'^total^name^fp'])
// // })
// //     .then((value) {
// // debugPrint('array updated');
// // });
// //
// //
// // // FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId).collection('detail')
// // // .doc(item.split('^')[0])
// // //
// // //     .update({
// // //   'daily_order': FieldValue.arrayUnion([item.split('^')[0]+'^'+item.split('^')[1]+'^total^name^fp'])
// // // })
// // //     .then((value) {
// // //   debugPrint('array updated');
// // // });
// // // 2021081601575511001^1-1001^total^name^pf
// //
// // });
// // });
// // });
