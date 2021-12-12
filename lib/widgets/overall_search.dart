// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:smartkyat_pos/fragments/orders_fragment2.dart';
// import 'package:smartkyat_pos/fragments/subs/customer_info.dart';
// import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
//
// import '../app_theme.dart';
//
// class OverAllSearch extends StatefulWidget {
//   const OverAllSearch({Key? key, required this.data, required this.docId}) : super(key: key);
//   final String data;
//   final String docId;
//   @override
//   _OverAllSearchState createState() => _OverAllSearchState();
// }
//
// class _OverAllSearchState extends State<OverAllSearch> {
//   double paidAmount = 0;
//   double refund = 0;
//   double debtAmount =0;
//   TextEditingController _textFieldController = TextEditingController();
//
//   @override
//   void dispose() {
//     // Clean up the controller when the Widget is disposed
//     _textFieldController.dispose();
//     super.dispose();
//   }
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   bool loadingSearch = false;
//   var sectionList;
//   var sectionListNo;
//   String searchValue = '';
//   int slidingSearch = 0;
//   bool noSearchData = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.topCenter,
//       child: Container(
//         decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border(
//               top: BorderSide(
//                   color: AppTheme.skBorderColor2,
// // color: Colors.transparent,
//                   width: 1.0),
//             )),
//         child: CustomScrollView(
//           slivers: <Widget>[
//             SliverAppBar(
//               elevation: 0,
//               backgroundColor: Colors.white,
//
// // Provide a standard title.
//
// // Allows the user to reveal the app bar if they begin scrolling
// // back up the list of items.
//               floating: true,
//               bottom: PreferredSize(                       // Add this code
//                 preferredSize: Size.fromHeight(-1),      // Add this code
//                 child: Container(),                           // Add this code
//               ),
//               flexibleSpace: Padding(
//                 padding: const EdgeInsets.only(left: 0.0, top: 0.5, bottom: 0.0),
//                 child: Container(
//                   height: 58,
//                   width: MediaQuery.of(context).size.width,
// // color: Colors.yellow,
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border(
//                           bottom: BorderSide(
// // color: AppTheme.skBorderColor2,
//                               color: Colors.white,
//                               width: 1.0),
//                         )),
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border(
//                             bottom: BorderSide(
// // color: AppTheme.skBorderColor2,
//                                 color: Colors.white,
//                                 width: 1.0),
//                           )),
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 12.0, bottom: 8.5, left: 15.0, right: 15.0),
//                         child: SizedBox(
//                           width: double.infinity,
//                           child: CupertinoSlidingSegmentedControl(
//                               children: {
//                                 0: Text('Products'),
//                                 1: Text('Buy/sellers'),
//                                 2: Text('Orders'),
//                               },
//                               groupValue: slidingSearch,
//                               onValueChanged: (newValue) {
//                                 setState(() {
//                                   slidingSearch = int.parse(newValue.toString());
//                                 });
//                                 FocusScope.of(context).unfocus();
//                                 searchValue = _searchController.text;
//                                 searchKeyChanged();
//                               }),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                 ),
//               ),
// // Display a placeholder widget to visualize the shrinking size.
// // Make the initial height of the SliverAppBar larger than normal.
//               expandedHeight: 20,
//             ),
//             if(noSearchData)
//               SliverExpandableList(
//                 builder: SliverExpandableChildDelegate(
//                   sectionList: sectionListNo,
//                   headerBuilder: _buildHeader2,
//                   itemBuilder: (context, sectionIndex, itemIndex, index) {
//                     String item = sectionListNo[sectionIndex].items[itemIndex];
//                     int length = sectionListNo[sectionIndex].items.length;
//                     return Container(
//                       height: 0.1,
//                     );
//                   },
//                 ),
//               ),
//             if(!noSearchData)
//               SliverExpandableList(
//                 builder: SliverExpandableChildDelegate(
//                   sectionList: sectionList,
//                   headerBuilder: _buildHeader,
//                   itemBuilder: (context, sectionIndex, itemIndex, index) {
//                     String item = sectionList[sectionIndex].items[itemIndex];
//                     int length = sectionList[sectionIndex].items.length;
//                     if(sectionIndex == 0) {
//                       return Container(
//                         height: 0.1,
//                       );
// // return SliverFillRemaining(
// //   child: new Container(
// //     color: Colors.red,
// //   ),
// // );
//                     }
//
//                     if(slidingSearch == 0 && item.contains('^sps^')) {
//                       return GestureDetector(
//                         onTap: () {
// // Navigator.push(
// //   context,
// //   MaterialPageRoute(
// //       builder: (context) => ProductDetailsView2(
// //           idString: version, toggleCoinCallback:
// //       addProduct1, toggleCoinCallback3: addProduct3)),);
//                         },
//                         child: Padding(
//                           padding:
//                           EdgeInsets.only(top: index == 0? 10.0: 20.0),
//                           child: Container(
//                             width: MediaQuery.of(context)
//                                 .size
//                                 .width,
//                             decoration: BoxDecoration(
//                                 border: Border(
//                                     bottom: index == length-1 ?
//                                     BorderSide(
//                                         color: Colors.transparent,
//                                         width: 1.0) :
//
//                                     BorderSide(
//                                         color: Colors.grey
//                                             .withOpacity(0.3),
//                                         width: 1.0)
//                                 )),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Column(
//                                         children: [
//                                           ClipRRect(
//                                               borderRadius:
//                                               BorderRadius
//                                                   .circular(
//                                                   5.0),
//                                               child: item.split('^sps^')[2] != ""
//                                                   ? CachedNetworkImage(
//                                                 imageUrl:
//                                                 'https://riftplus.me/smartkyat_pos/api/uploads/' +
//                                                     item.split('^sps^')[2],
//                                                 width: 75,
//                                                 height: 75,
// // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
//                                                 errorWidget: (context,
//                                                     url,
//                                                     error) =>
//                                                     Icon(Icons
//                                                         .error),
//                                                 fadeInDuration:
//                                                 Duration(
//                                                     milliseconds:
//                                                     100),
//                                                 fadeOutDuration:
//                                                 Duration(
//                                                     milliseconds:
//                                                     10),
//                                                 fadeInCurve:
//                                                 Curves
//                                                     .bounceIn,
//                                                 fit: BoxFit
//                                                     .cover,
//                                               )
//                                                   : CachedNetworkImage(
//                                                 imageUrl:
//                                                 'https://riftplus.me/smartkyat_pos/api/uploads/shark1.jpg',
//                                                 width: 75,
//                                                 height: 75,
// // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
//                                                 errorWidget: (context,
//                                                     url,
//                                                     error) =>
//                                                     Icon(Icons
//                                                         .error),
//                                                 fadeInDuration:
//                                                 Duration(
//                                                     milliseconds:
//                                                     100),
//                                                 fadeOutDuration:
//                                                 Duration(
//                                                     milliseconds:
//                                                     10),
//                                                 fadeInCurve:
//                                                 Curves
//                                                     .bounceIn,
//                                                 fit: BoxFit
//                                                     .cover,
//                                               )),
//                                         ],
//                                       ),
//                                       SizedBox(
//                                         width: 15,
//                                       ),
//                                       Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment
//                                             .start,
//                                         children: [
//                                           Text(
//                                             item.split('^sps^')[1],
//                                             style: TextStyle(
//                                               fontSize: 18,
//                                               fontWeight:
//                                               FontWeight.w500,
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 'MMK ' + item.split('^sps^')[3].split('-')[0],
//                                                 style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight:
//                                                   FontWeight.w500,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 item.split('^sps^')[4].split('-')[2] != '' && item.split('^sps^')[5].split('-')[2] == '' ? ' - ' + item.split('^sps^')[4].split('-')[0] : item.split('^sps^')[4].split('-')[2] != '' && item.split('^sps^')[5].split('-')[2] != '' ? ' - ' + item.split('^sps^')[5].split('-')[0] : '',
//                                                 style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight:
//                                                   FontWeight.w500,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: 2,
//                                           ),
//                                           Row(
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                       item.split('^sps^')[3].split('-')[1].toString()+ ' '  + item.split('^sps^')[3].split('-')[2] + ' ', style: TextStyle(
//                                                     fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
//                                                   )),
//                                                   Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
// // sub1Name != '' ? Text(' | ', style: TextStyle(
// //   fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
// // )) : Text(''),
//                                                 ],
//                                               ),
//
//                                               item.split('^sps^')[4].split('-')[2] != '' && item.split('^sps^')[5].split('-')[2] == ''?
//                                               Text(
//                                                   '  (+1 Sub item)', style: TextStyle(
//                                                 fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
//                                               )) : item.split('^sps^')[4].split('-')[2] != '' && item.split('^sps^')[5].split('-')[2] != '' ? Text(
//                                                   '  (+2 Sub items)', style: TextStyle(
//                                                 fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
//                                               )): Container(),
//
// // StreamBuilder(
// //     stream: FirebaseFirestore
// //         .instance
// //         .collection(
// //         'space')
// //         .doc(
// //         '0NHIS0Jbn26wsgCzVBKT')
// //         .collection(
// //         'shops')
// //         .doc(
// //         'PucvhZDuUz3XlkTgzcjb')
// //         .collection(
// //         'products')
// //         .doc(version)
// //         .collection(
// //         'versions')
// //         .where('type',
// //         isEqualTo:
// //         'sub3')
// //         .snapshots(),
// //     builder: (BuildContext
// //     context,
// //         AsyncSnapshot<
// //             QuerySnapshot>
// //         snapshot5) {
// //       if (snapshot5
// //           .hasData) {
// //         int quantity3 =
// //         0;
// //         var sub3Quantity;
// //         snapshot5
// //             .data!
// //             .docs
// //             .map((DocumentSnapshot
// //         document) {
// //           Map<String,
// //               dynamic>
// //           data4 =
// //           document.data()! as Map<
// //               String,
// //               dynamic>;
// //           if (data4[
// //           'unit_qtity'] !=
// //               '') {
// //             quantity3 +=
// //                 int.parse(
// //                     data4['unit_qtity']);
// //             sub3Quantity =
// //                 quantity3
// //                     .toString();
// //           } else
// //             return Container();
// //         }).toList();
// //         // print(sub1Quantity);
// //         // print(mainQuantity);
// //         if (sub3Quantity !=
// //             null) {
// //           return Text(
// //               '$sub3Quantity $sub3Name');
// //         }
// //         return Container();
// //       }
// //       return Container();
// //     }),
//                                             ],
//                                           ),
//
// // Text(
// //   'MMK',
// //   style:
// //       TextStyle(
// //     fontSize: 14,
// //     fontWeight: FontWeight.w400,
// //     color: Colors.blueGrey.withOpacity(1.0),
// //   ),
// // ),
// // SizedBox(
// //   height:
// //       7,
// // ),
// // Text(
// //   '55',
// //   style:
// //       TextStyle(
// //     fontSize: 14,
// //     fontWeight: FontWeight.w400,
// //     color: Colors.blueGrey.withOpacity(1.0),
// //   ),
// // ),
//                                         ],
//                                       ),
// // Padding(
// //   padding:
// //       const EdgeInsets.only(
// //           bottom: 20.0),
// //   child: IconButton(
// //     icon: Icon(
// //       Icons
// //           .arrow_forward_ios_rounded,
// //       size: 16,
// //       color: Colors.blueGrey
// //           .withOpacity(0.8),
// //     ),
// //     onPressed: () {
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //             builder: (context) => ProductDetailsView(
// //                 idString: version, toggleCoinCallback:
// //             addProduct1, toggleCoinCallback3: addProduct3)),);
// //     },
// //   ),
// // ),
//                                       Spacer(),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.only(
//                                             bottom: 12.0),
//                                         child: Icon(
//                                           Icons
//                                               .arrow_forward_ios_rounded,
//                                           size: 16,
//                                           color: Colors.blueGrey
//                                               .withOpacity(0.8),
//                                         ),),
//                                     ],
//                                   ),
//                                   SizedBox(height: 20),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     } else if(slidingSearch == 1 && item.contains('^sps^')) {
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (
//                                     context) =>
//                                     CustomerInfoSubs(
//                                         id: item.split('^sps^')[0], toggleCoinCallback: (String str) {  },)),
//                           );
//                         },
//                         child: Padding(
//                           padding:
//                           EdgeInsets.only(
//                               top: index == 0
//                                   ? 10.0
//                                   : 15.0),
//                           child: Container(
//                             width: MediaQuery
//                                 .of(context)
//                                 .size
//                                 .width,
//                             decoration: BoxDecoration(
//                                 border: Border(
//                                     bottom: index ==
//                                         length -
//                                             1
//                                         ?
//                                     BorderSide(
//                                         color: Colors.transparent,
//                                         width: 1.0)
//                                         :
//
//                                     BorderSide(
//                                         color: Colors.grey
//                                             .withOpacity(
//                                             0.3),
//                                         width: 1.0)
//                                 )),
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets
//                                       .only(
//                                       bottom: 18.0),
//                                   child: ListTile(
//                                     title: Text(
//                                       item.split('^sps^')[1].toString(),
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight:
//                                         FontWeight
//                                             .w500,
//                                       ),),
//                                     subtitle: Padding(
//                                       padding: const EdgeInsets
//                                           .only(
//                                           top: 8.0),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment
//                                             .start,
//                                         children: [
//                                           Text(
//                                               item.split('^sps^')[2].toString(),
//                                               style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight
//                                                     .w500,
//                                                 color: Colors.grey,
//                                               )),
//                                           SizedBox(
//                                             height: 5,),
//                                           Text(
//                                               item.split('^sps^')[3].toString(),
//                                               style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight
//                                                     .w500,
//                                                 color: Colors.grey,
//                                               )),
//                                         ],
//                                       ),
//                                     ),
//                                     trailing: Padding(
//                                       padding: const EdgeInsets
//                                           .only(
//                                           top: 10.0),
//                                       child: Container(
//                                         child: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             StreamBuilder(
//                                                 stream: FirebaseFirestore.instance
//                                                     .collection('space')
//                                                     .doc('0NHIS0Jbn26wsgCzVBKT')
//                                                     .collection('shops')
//                                                     .doc('PucvhZDuUz3XlkTgzcjb')
//                                                     .collection('customers')
//                                                     .doc(item.split('^sps^')[0].toString())
//                                                     .collection('orders')
//                                                     .where('debt', isGreaterThan: 0)
//                                                     .snapshots(),
//                                                 builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
// // orderList[index] = 0;
//                                                   int orderLength = 0;
//                                                   int i = 0;
//                                                   if(snapshot2.hasData) {
//                                                     return snapshot2.data!.docs.length > 0? Container(
//                                                       height: 21,
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(20.0),
//                                                         color: AppTheme.badgeFgDanger,
//                                                       ),
//                                                       child: Padding(
//                                                         padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
//                                                         child: Text(snapshot2.data!.docs.length.toString() + ' unpaid',
//                                                           style: TextStyle(
//                                                               fontSize: 13,
//                                                               fontWeight: FontWeight.w500,
//                                                               color: Colors.white
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ): Container(
//                                                     );
// // int quantity = 0;
// // snapshot2.data!.docs.map((DocumentSnapshot document2) {
// //   Map<String, dynamic> data2 = document2.data()! as Map<String, dynamic>;
// //   orders = data2['daily_order'];
// //   quantity += int.parse(orders.length.toString());
// //
// //   return Text(snapshot2.data!.docs[index].id);
// // }).toList();
//                                                   }
//                                                   return Container();
//                                                 }
//                                             ),
//
// // Container(
// //   height: 21,
// //   decoration: BoxDecoration(
// //     borderRadius: BorderRadius.circular(20.0),
// //     color: AppTheme.badgeFgDanger,
// //   ),
// //   child: Padding(
// //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
// //     child: Text(unpaidCount(index).toString() + ' unpaid',
// //       style: TextStyle(
// //           fontSize: 13,
// //           fontWeight: FontWeight.w500,
// //           color: Colors.white
// //       ),
// //     ),
// //   ),
// // ),
//
// // Text(orderList.toString()),
//
// // Container(
// //   height: 21,
// //   decoration: BoxDecoration(
// //     borderRadius: BorderRadius.circular(20.0),
// //     color: AppTheme.badgeFgDanger,
// //   ),
// //   child: Padding(
// //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
// //     child: Text('2 unpaid',
// //       style: TextStyle(
// //           fontSize: 13,
// //           fontWeight: FontWeight.w500,
// //           color: Colors.white
// //       ),
// //     ),
// //   ),
// // )
//
// // Container(
// //   height: 21,
// //   decoration: BoxDecoration(
// //     borderRadius: BorderRadius.circular(20.0),
// //     color: AppTheme.badgeFgDanger,
// //   ),
// //   child: Padding(
// //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
// //     child: Text(unpaidCount(index).toString() + ' unpaid',
// //       style: TextStyle(
// //           fontSize: 13,
// //           fontWeight: FontWeight.w500,
// //           color: Colors.white
// //       ),
// //     ),
// //   ),
// // ),
//                                             SizedBox(
//                                                 width: 12),
//                                             Padding(
//                                               padding: const EdgeInsets.only(top: 2.0),
//                                               child: Icon(
//                                                 Icons
//                                                     .arrow_forward_ios_rounded,
//                                                 size: 16,
//                                                 color: Colors
//                                                     .Colors.blueGrey
//                                                     .withOpacity(
//                                                     0.8),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//
//                                   ),
//                                 )
//
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }
//                     return GestureDetector(
//                       onTap: () {
//                         print('Items'+item);
// // Navigator.push(
// //   context,
// //   MaterialPageRoute(
// //       builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {})),
// // );
//                       },
//                       child: Stack(
//                         alignment: Alignment.center,
//
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 0.0, right: 0.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: AppTheme.lightBgColor,
//                                   border: Border(
//                                     bottom: BorderSide(
//                                         color: AppTheme.skBorderColor2,
//                                         width: 1.0),
//                                   )),
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 1.0),
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             children: [
//                                               Text('#Text',
//                                                 style: TextStyle(
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight.w500
//                                                 ),
//                                               ),
//                                               SizedBox(width: 8),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(bottom: 1.0),
//                                                 child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
//                                               ),
//                                               SizedBox(width: 4),
//                                               Text('Text1',
//                                                 style: TextStyle(
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w500,
//                                                   color: Colors.grey,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: 6,
//                                           ),
//                                           Row(
//                                             children: [
//                                               Text('Text2', style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.grey,
//                                               )),
//
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 8,
//                                     ),
//                                     Row(
//                                       children: [
// // if(item.split('^')[5] == '0.0')
//                                         Padding(
//                                           padding: const EdgeInsets.only(right: 6.0),
//                                           child: Container(
//                                             height: 21,
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(20.0),
//                                               color: AppTheme.badgeBgSuccess,
//                                             ),
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
//                                               child: Text('Paid',
//                                                 style: TextStyle(
//                                                     fontSize: 13,
//                                                     fontWeight: FontWeight.w500,
//                                                     color: Colors.white
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//
// // if(item.split('^')[5] != '0.0')
// //   Padding(
// //     padding: const EdgeInsets.only(right: 6.0),
// //     child: Container(
// //       height: 21,
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(20.0),
// //         color: AppTheme.badgeFgDanger,
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
// //         child: Text('Unpaid',
// //           style: TextStyle(
// //               fontSize: 13,
// //               fontWeight: FontWeight.w500,
// //               color: Colors.white
// //           ),
// //         ),
// //       ),
// //     ),
// //   ),
//
// // if(item.split('^')[4][0] == 'r')
// //   Padding(
// //     padding: const EdgeInsets.only(right: 6.0),
// //     child: Container(
// //       height: 21,
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(20.0),
// //         color: AppTheme.badgeBgSecond,
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
// //         child: Text('Refunded',
// //           style: TextStyle(
// //               fontSize: 13,
// //               fontWeight: FontWeight.w500,
// //               color: Colors.white
// //           ),
// //         ),
// //       ),
// //     ),
// //   ),
//
// // if(item.split('^')[4][0] == 's')
// //   Padding(
// //     padding: const EdgeInsets.only(right: 6.0),
// //     child: Container(
// //       height: 21,
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(20.0),
// //         color: AppTheme.badgeBgSecond,
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
// //         child: Text('Partially refunded',
// //           style: TextStyle(
// //               fontSize: 13,
// //               fontWeight: FontWeight.w500,
// //               color: Colors.white
// //           ),
// //         ),
// //       ),
// //     ),
// //   ),
//
//
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 15.0, bottom: 1),
//                             child: Align(
//                               alignment: Alignment.centerRight,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Text('MMK ', style: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w500,
//                                   )),
//                                   SizedBox(width: 10),
//                                   Icon(
//                                     Icons
//                                         .arrow_forward_ios_rounded,
//                                     size: 16,
//                                     color: Colors.blueGrey.withOpacity(0.8),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildHeader(BuildContext context, int sectionIndex, int index) {
//     ExampleSection section = sectionList[sectionIndex];
//     if(sectionIndex == 0) {
//       return Container(
//         height: 0.1,
//       );
//     }
//     return InkWell(
//         child: Container(
//             decoration: BoxDecoration(
//                 color: Colors.Colors.white,
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
//                         section.header.split('^')[0].toUpperCase(),
//                         // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
//                         style: TextStyle(
//                             height: 0.8,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 1.2,
//                             color: Colors.Colors.black
//                         ),
//                       ),
//
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(right: 15.0),
//                           child: Text(
//                             section.header.split('^')[1],
//                             // '#' + sectionList[sectionIndex].items.length.toString(),
//                             // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
//                             style: TextStyle(
//                               height: 0.8,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               letterSpacing: 1.2,
//                               color: Colors.Colors.black,
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
//           //toggle section expand state
//           // setState(() {
//           //   section.setSectionExpanded(!section.isSectionExpanded());
//           // });
//         });
//   }
//
//   Widget _buildHeader2(BuildContext context, int sectionIndex, int index) {
//     if(searchValue == '') {
//       return Container(
//           height: 50,
//           child: Center(child: Text('Search any word'))
//       );
//     }
//     return Container(
//         height: 50,
//         child: Center(child: Text('No data found'))
//     );
//   }
//
//   Future<void> searchKeyChanged() async {
//     if(searchValue != '') {
//       if(slidingSearch == 2) {
//         print("search " + searchValue);
//         String max = searchValue;
//         // sectionList = [];
//         List detailIdList = [];
//         await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
//         // FirebaseFirestore.instance.collection('space')
//             .where('each_order',  arrayContains: max)
//             .limit(1)
//             .get()
//             .then((QuerySnapshot querySnapshot1) {
//
//           if(querySnapshot1.docs.length == 0) {
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
//           querySnapshot1.docs.forEach((doc) async {
//
//             await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(doc.id).collection('detail')
//                 .where('orderId',  isEqualTo: max)
//                 .get()
//                 .then((QuerySnapshot querySnapshot2) {
//
//               if(querySnapshot2.docs.length == 0) {
//                 setState(() {
//                   noSearchData = true;
//                 });
//               } else {
//                 setState(() {
//                   noSearchData = false;
//                 });
//               }
//               querySnapshot2.docs.forEach((doc) {
//
//                 setState(() {
//                   detailIdList.add(doc.id);
//                 });
//               });
//
//
//               setState(() {
//
//                 // if(detailIdList.length == 0) {
//                 //   noSearchData = true;
//                 // } else {
//                 //   noSearchData = false;
//                 // }
//                 var sections = List<ExampleSection>.empty(growable: true);
//
//                 var init = ExampleSection()
//                   ..header = ''
//                   ..items = ['']
//                   ..expanded = true;
//
//                 var buyOrders = ExampleSection()
//                   ..header = 'Buy Orders^' + detailIdList.length.toString()
//                   ..items = detailIdList.cast<String>()
//                   ..expanded = true;
//
//                 var sellOrders = ExampleSection()
//                   ..header = 'Sell Orders^' + detailIdList.length.toString()
//                   ..items = detailIdList.cast<String>()
//                   ..expanded = true;
//
//                 print('buy ord ' + detailIdList.length.toString());
//                 sections.add(init);
//                 sections.add(buyOrders);
//                 sections.add(sellOrders);
//                 sectionList = sections;
//               });
//             });
//           });
//
//
//         });
//
//
//
//
//
//       } else if (slidingSearch == 1) {
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
//           // sections.add(buyOrders);
//           sectionList = sections;
//         });
//         List<String> items = [];
//
//         await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('customers')
//             .get()
//             .then((QuerySnapshot querySnapshot) {
//
//           String sps = '^sps^';
//           querySnapshot.docs.forEach((doc) {
//             if(doc['customer_name'].toString().toLowerCase().contains(searchValue.toLowerCase())) {
//               setState(() {
//                 items.add(doc.id + sps + doc['customer_name'] + sps + doc['customer_phone'] + sps + doc['customer_address']);
//               });
//
//               // print(doc['prod_name'].toString());
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
//             ..header = 'Customers^' + items.length.toString()
//             ..items = items
//             ..expanded = true;
//
//           // var buyOrders = ExampleSection()
//           //   ..header = 'Products'
//           //   ..items = ['']
//           //   ..expanded = true;
//           sections.add(init);
//           // sections.add(buyOrders);
//           sectionList.add(init);
//         });
//
//
//       } else {
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
//           // sections.add(buyOrders);
//           sectionList = sections;
//         });
//         List<String> items = [];
//
//         await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products')
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
//               print(doc['prod_name'].toString());
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
//           sectionList.add(init);
//         });
//
//
//       }
//     } else {
//       setState(() {
//         noSearchData = true;
//       });
//     }
//   }
// }
//
//
//
//
//
