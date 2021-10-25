// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:printing/printing.dart';
// import 'package:smartkyat_pos/fragments/subs/buy_list_info.dart';
// import 'package:smartkyat_pos/fragments/subs/order_info.dart';
// import 'package:smartkyat_pos/pages2/data.dart';
// import 'package:smartkyat_pos/pages2/examples.dart';
// import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
//
// import '../app_theme.dart';
//
// class TestFragment extends StatefulWidget {
//   TestFragment({Key? key}) : super(key: key);
//
//   @override
//   _TestFragmentState createState() => _TestFragmentState();
// }
//
// class _TestFragmentState extends State<TestFragment> with TickerProviderStateMixin,
//         AutomaticKeepAliveClientMixin<TestFragment> {
//   @override
//   bool get wantKeepAlive => true;
//   var sectionList;
//
//
//   int _tab = 0;
//   TabController? _tabController;
//
//   PrintingInfo? printingInfo;
//
//   var _data = const CustomData();
//   var _hasData = false;
//   var _pending = false;
//
//   @override
//   initState() {
//     super.initState();
//
//     _tabController = TabController(
//       vsync: this,
//       length: examples.length,
//       initialIndex: _tab,
//     );
//     _tabController!.addListener(() {
//       if (_tab != _tabController!.index) {
//         setState(() {
//           _tab = _tabController!.index;
//         });
//       }
//       if (examples[_tab].needsData && !_hasData && !_pending) {
//         _pending = true;
//         askName(context).then((value) {
//           if (value != null) {
//             setState(() {
//               _data = CustomData(name: value);
//               _hasData = true;
//               _pending = false;
//             });
//           }
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   Future<void> _saveAsFile(
//       BuildContext context,
//       LayoutCallback build,
//       PdfPageFormat pageFormat,
//       ) async {
//     final bytes = await build(pageFormat);
//
//     final appDocDir = await getApplicationDocumentsDirectory();
//     final appDocPath = appDocDir.path;
//     final file = File(appDocPath + '/' + 'document.pdf');
//     print('Save as file ${file.path} ...');
//     await file.writeAsBytes(bytes);
//     await OpenFile.open(file.path);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // CollectionReference daily_exps = ;
//
//     pw.RichText.debug = true;
//
//     if (_tabController == null) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     final actions = <PdfPreviewAction>[
//       if (!identical(0, 0.0))
//         PdfPreviewAction(
//           icon: const Icon(Icons.save),
//           onPressed: _saveAsFile,
//         )
//     ];
//
//     return Scaffold(
//       body: Container(
//         color: Colors.white,
//         child: SafeArea(
//           top: true,
//           bottom: true,
//           child: PdfPreview(
//             maxPageWidth: 700,
//             build: (format) => examples[_tab].builder(format, _data),
//             actions: actions,
//             onPrinted: _showPrintedToast,
//             onShared: _showSharedToast,
//           )
//         ),
//       ),
//     );
//   }
//
//   void _showPrintedToast(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Document printed successfully'),
//       ),
//     );
//   }
//
//   void _showSharedToast(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Document shared successfully'),
//       ),
//     );
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
//               document['merchant_name'].toString() +
//               '&' +
//               list[i].split('^')[3] +
//               '^' +
//               list[i].split('^')[4];
//         }
//       }
//       // print('changeData ' + document['customer_name'].toString() + list[0].toString());
//     }).toList();
//
//     // print('changeData ' + snpsht.da);
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
//     ExampleSection section = sectionList[sectionIndex];
//     return InkWell(
//         child: Container(
//             color: Colors.transparent,
//             alignment: Alignment.centerLeft,
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Container(
//                 color: Colors.white,
//                 width: double.infinity,
//                 height: 35,
//                 child: Padding(
//                   padding:
//                   const EdgeInsets.only(left: 15.0, top: 15, bottom: 0),
//                   child: Text(
//                     section.header.toUpperCase(),
//                     style: TextStyle(
//                         height: 0.8,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 1.2,
//                         color: Colors.grey),
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
//   //   //   // print('here ' + temp.toString());
//   //   //   //return temp;
//   //   //   // return gloTemp;
//   //   // });
//   //   // print('here2 ' + temp.toString());
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
//                                           print('clicked');
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
//   Future<String?> askName(BuildContext context) {
//     return showDialog<String>(
//         barrierDismissible: false,
//         context: context,
//         builder: (context) {
//           final controller = TextEditingController();
//
//           return AlertDialog(
//             title: const Text('Please type your name:'),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//             content: TextField(
//               decoration: const InputDecoration(hintText: '[your name]'),
//               controller: controller,
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   if (controller.text != '') {
//                     Navigator.pop(context, controller.text);
//                   }
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           );
//         });
//   }
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
//
//
//
// // print(item.split('^')[0].substring(0,8));
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
// // print('array removed');
// //
// // FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId)
// //
// //     .update({
// // 'daily_order': FieldValue.arrayUnion([item.split('^')[0]+'^'+item.split('^')[1]+'^total^name^fp'])
// // })
// //     .then((value) {
// // print('array updated');
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
// // //   print('array updated');
// // // });
// // // 2021081601575511001^1-1001^total^name^pf
// //
// // });
// // });
// // });
