// import 'package:adaptive_dialog/adaptive_dialog.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flash/flash.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
//
// import '../app_theme.dart';
//
// class ProductAdjustment extends StatefulWidget {
//   const ProductAdjustment(
//       {Key? key, required this.subExist, required this.idString, required this.isEnglish, required this.mainProd,  required this.sub1Prod,  required this.sub2Prod, required this.shopId, required this.price,  required this.price1,  required this.price2 ,required this.fromSearch});
//   final String idString;
//   final String mainProd;
//   final String sub1Prod;
//   final String sub2Prod;
//   final String shopId;
//   final String price;
//   final String price1;
//   final String price2;
//   final String subExist;
//   final bool fromSearch;
//   final bool isEnglish;
//
//   @override
//   _ProductAdjustmentState createState() => _ProductAdjustmentState();
// }
//
// final _formKey = GlobalKey<FormState>();
//
// final mainDiff = TextEditingController();
// final sub1Diff = TextEditingController();
// final sub2Diff = TextEditingController();
// final sub1Amount = TextEditingController();
//
// late int codeDialog =0;
//
// var deviceIdNum;
//
// getDeviceId() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('device');
// }
//
// class _ProductAdjustmentState extends State<ProductAdjustment> {
//
//
//
//   String _getRegexString() =>
//       r'[0-9]+[,.]{0,1}[0-9]*';
//
//   String _getNum() =>
//       r'[0-9]';
//
//   String currencyUnit = 'MMK';
//   String textSetAddLoss = 'Add loss item';
//   String textSetLossInventory = 'LOSS IN INVENTORY';
//   String textSetLossQty = 'Quantity';
//   String textSetBuyPrice = 'Product difference';
//   String textSetSave = 'Save';
//   double mainPrice = 0;
//   double sub1Price = 0;
//   double sub2Price = 0;
//
//   getCurrency() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('currency');
//   }
//
//   @override
//   initState() {
//     mainDiff.text =  widget.mainProd.split('^')[3].toString();
//     sub1Diff.text =  widget.sub1Prod.split('^')[2].toString();
//     sub2Diff.text =  widget.sub2Prod.split('^')[2].toString();
//     mainPrice = double.parse(widget.price.toString());
//     sub1Price = double.parse(widget.price1.toString());
//     sub2Price = double.parse(widget.price2.toString());
//
//
//     if(widget.isEnglish == true) {
//
//       setState(() {
//         textSetAddLoss = 'Add loss item';
//         textSetLossInventory = 'LOSS IN INVENTORY';
//         textSetLossQty = 'Loss quantity';
//         textSetBuyPrice = 'Buy price';
//         textSetSave = 'Save';
//       });
//     } else {
//       setState(() {
//         textSetAddLoss = 'ဆုံးရှုံးပစ္စည်းထည့်ရန်';
//         textSetLossInventory = 'LOSS IN INVENTORY';
//         textSetLossQty = 'အရေအတွက်';
//         textSetBuyPrice = 'ဝယ်ဈေး';
//         textSetSave = 'သိမ်းဆည်းမည်';
//       });
//     }
//
//     getCurrency().then((value){
//       if(value == 'US Dollar (USD)') {
//         setState(() {
//           currencyUnit = 'USD';
//         });
//       } else if(value == 'Myanmar Kyat (MMK)') {
//         setState(() {
//           currencyUnit = 'MMK';
//         });
//       }
//     });
//    // priceAmount.text = widget.price.toString();
//     // TODO: implement initState
//     getDeviceId().then((value) {
//       deviceIdNum = value;
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     mainDiff.clear();
//     sub1Diff.clear();
//     sub2Diff.clear();
//     super.dispose();
//   }
//
//
//   bool firstTime = true;
//   double homeBotPadding = 0;
//   @override
//   Widget build(BuildContext context) {
//     final double scaleFactor = MediaQuery.of(context).textScaleFactor;
//     if(firstTime) {
//       homeBotPadding = MediaQuery.of(context).padding.bottom;
//       firstTime = false;
//     }
//
//
//     return Container(
//         color: Colors.white,
//         child: SafeArea(
//           top: true,
//           bottom: false,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 height: 81,
//                 decoration: BoxDecoration(
//                     border: Border(
//                         bottom: BorderSide(
//                             color: Colors.grey.withOpacity(0.3),
//                             width: 1.0))),
//                 child: Padding(
//                   padding:
//                   const EdgeInsets.only(left: 15.0, right: 15.0,),
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 0),
//                         child: Container(
//                           width: 37,
//                           height: 37,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(35.0),
//                               ),
//                               color: Colors.grey.withOpacity(0.3)),
//                           child: Padding(
//                             padding: const EdgeInsets.only(right: 3.0),
//                             child: IconButton(
//                                 icon: Icon(
//                                   Icons.arrow_back_ios_rounded,
//                                   size: 17,
//                                   color: Colors.black,
//                                 ),
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 }),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 widget.mainProd.split('^')[0].toString(), textScaleFactor: 1,
//                                 textAlign: TextAlign.right,
//                                 style: TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w500,
//                                     overflow: TextOverflow.ellipsis
//                                   // height: 1.5
//                                 ),
//                                 strutStyle: StrutStyle(
//                                   height: 1.4,
//                                   // fontSize:,
//                                   forceStrutHeight: true,
//                                 ),
//                               ),
//                               Text(
//                                   textSetAddLoss, textScaleFactor: 1,
//                                   textAlign: TextAlign.right,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                   strutStyle: StrutStyle(
//                                     height: widget.isEnglish? 1.4: 1.6,
//                                     forceStrutHeight: true,
//                                   )
//                               ),
//                             ],
//                           )
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: ListView(
//                   children: [
//                     Form(
//                       key: _formKey,
//                       child:  Stack(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   alignment: Alignment.topLeft,
//                                   padding: EdgeInsets.only(top: 15, left: 15, right: 15.0),
//                                   child: Text(
//                                       textSetLossInventory, textScaleFactor: 1,
//                                       style: TextStyle(
//                                           letterSpacing: 1.5,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14, color: Colors.grey,
//                                           height: 0.9
//                                       ),
//                                       strutStyle: StrutStyle(
//                                         height: widget.isEnglish? 1.4: 1.6,
//                                         forceStrutHeight: true,
//                                       )
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 15.0, top: 14),
//                                 child: Icon(widget.prodID.split('^')[3] == 'unit_name'? SmartKyat_POS.prodm: widget.prodID.split('^')[3] == 'sub1_name'? SmartKyat_POS.prods1: SmartKyat_POS.prods2, size: 16, color: Colors.grey),
//                               ),
//                             ],
//                           ),
//
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 15.0, right: 15.0, top: 45),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width:  MediaQuery.of(context).size.width > 900 ? ((MediaQuery.of(context).size.width * (2 / 3.5))  - 30) : MediaQuery.of(context).size.width - 30,
//                                   child: TextFormField(
//                                     controller: mainDiff,
//                                     keyboardType: TextInputType.numberWithOptions(decimal: false),
//                                     inputFormatters: <TextInputFormatter>[
//                                       FilteringTextInputFormatter.allow(RegExp(_getNum())),],
// // The validator receives the text that the user has entered.
//                                     validator: (value) {
//                                       if (value == null ||
//                                           value.isEmpty) {
//                                         return 'This field is required';
//                                       }
//                                       return null;
//                                     },
//                                     style: TextStyle(
//                                       height: 0.95, fontSize: 15/scaleFactor,
//                                     ),
//                                     decoration: InputDecoration(
//                                       enabledBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                           borderSide: const BorderSide(
//                                               color: AppTheme.skBorderColor,
//                                               width: 2.0),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10.0))),
//
//                                       focusedBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                           borderSide: const BorderSide(
//                                               color: AppTheme.themeColor,
//                                               width: 2.0),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10.0))),
//                                       contentPadding: const EdgeInsets.only(
//                                           left: 15.0,
//                                           right: 15.0,
//                                           top: 20.0,
//                                           bottom: 20.0),
//                                       // suffixText: 'Required',
//                                       suffixStyle: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 12/scaleFactor,
//                                         fontFamily: 'capsulesans',
//                                       ),
//                                       //errorText: wrongPassword,
//                                       errorStyle: TextStyle(
//                                           backgroundColor: Colors.white,
//                                           fontSize: 12/scaleFactor,
//                                           fontFamily: 'capsulesans',
//                                           height: 0.1
//                                       ),
//                                       labelStyle: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.black,
//                                       ),
// // errorText: 'Error message',
//                                       labelText: textSetLossQty,
//                                       floatingLabelBehavior:
//                                       FloatingLabelBehavior.auto,
// //filled: true
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 // Spacer(),
//                                 // Container(
//                                 //   width: MediaQuery.of(context).size.width > 900 ? ((MediaQuery.of(context).size.width * (2 / 3.5))  -
//                                 //       30) *
//                                 //       (1.41 / 4) : (MediaQuery.of(context).size.width -
//                                 //       30) *
//                                 //       (1.41 / 4),
//                                 //   child: Text(
//                                 //     mainName,
//                                 //     style: TextStyle(
//                                 //       fontSize: 16,
//                                 //       fontWeight: FontWeight.w500,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                               ],
//                             ),
//                           ),
//
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 15.0, right: 15.0, top: 118),
//                                child: Column(
//                                    children: [
//                                      Container(
//                                        alignment: Alignment.topLeft,
//                                        child: Text(
//                                            textSetLossInventory, textScaleFactor: 1,
//                                            style: TextStyle(
//                                                letterSpacing: 1.5,
//                                                fontWeight: FontWeight.bold,
//                                                fontSize: 14, color: Colors.grey,
//                                                height: 0.9
//                                            ),
//                                            strutStyle: StrutStyle(
//                                              height: widget.isEnglish? 1.4: 1.6,
//                                              forceStrutHeight: true,
//                                            )
//                                        ),
//                                      ),
//                                      SizedBox(height: 15,),
//                                      Container(
//                                        width:  MediaQuery.of(context).size.width > 900 ? ((MediaQuery.of(context).size.width * (2 / 3.5))  - 30) : MediaQuery.of(context).size.width - 30,
//                                        color: Colors.cyanAccent,
//                                        height: 52,
//                                        child: Center(
//                                          child: Text(
//                                    (double.parse(widget.prodID.split('^')[4].toString()) -  double.parse(mainDiff.text.toString())).toString(),
//                                          ),
//                                        ),
//                                      ),
//                                    ],
//                                ),
// //                             child: TextFormField(
// //                               controller: priceAmount,
// //                               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //                               inputFormatters: <TextInputFormatter>[
// //                                 FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
// // // The validator receives the text that the user has entered.
// //                               validator: (value) {
// //                                 if (value == null ||
// //                                     value.isEmpty) {
// //                                   return 'This field is required';
// //                                 }
// //                                 return null;
// //                               },
// //                               style: TextStyle(
// //                                 height: 0.95, fontSize: 15/scaleFactor,
// //                               ),
// //                               decoration: InputDecoration(
// //                                 enabledBorder: const OutlineInputBorder(
// // // width: 0.0 produces a thin "hairline" border
// //                                     borderSide: const BorderSide(
// //                                         color: AppTheme.skBorderColor,
// //                                         width: 2.0),
// //                                     borderRadius: BorderRadius.all(
// //                                         Radius.circular(10.0))),
// //
// //                                 focusedBorder: const OutlineInputBorder(
// // // width: 0.0 produces a thin "hairline" border
// //                                     borderSide: const BorderSide(
// //                                         color: AppTheme.themeColor,
// //                                         width: 2.0),
// //                                     borderRadius: BorderRadius.all(
// //                                         Radius.circular(10.0))),
// //                                 contentPadding: const EdgeInsets.only(
// //                                     left: 15.0,
// //                                     right: 15.0,
// //                                     top: 20.0,
// //                                     bottom: 20.0),
// //                                 // suffixText: 'Required',
// //                                 suffixStyle: TextStyle(
// //                                   color: Colors.grey,
// //                                   fontSize: 12/scaleFactor,
// //                                   fontFamily: 'capsulesans',
// //                                 ),
// //                                 //errorText: wrongPassword,
// //                                 errorStyle: TextStyle(
// //                                     backgroundColor: Colors.white,
// //                                     fontSize: 12/scaleFactor,
// //                                     fontFamily: 'capsulesans',
// //                                     height: 0.1
// //                                 ),
// //                                 labelStyle: TextStyle(
// //                                   fontWeight: FontWeight.w500,
// //                                   color: Colors.black,
// //                                 ),
// //                                 labelText: textSetBuyPrice,
// //                                 floatingLabelBehavior:
// //                                 FloatingLabelBehavior.auto,
// // //filled: true
// //                                 border: OutlineInputBorder(
// //                                   borderRadius: BorderRadius.circular(10),
// //                                 ),
// //                               ),
// //                             ),
//                           ),
//
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   alignment: Alignment.topLeft,
//                                   padding: EdgeInsets.only(top: 220, left: 15, right: 15.0),
//                                   child: Text(
//                                       'Sub1 Adjustment', textScaleFactor: 1,
//                                       style: TextStyle(
//                                           letterSpacing: 1.5,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14, color: Colors.grey,
//                                           height: 0.9
//                                       ),
//                                       strutStyle: StrutStyle(
//                                         height: widget.isEnglish? 1.4: 1.6,
//                                         forceStrutHeight: true,
//                                       )
//                                   ),
//                                 ),
//                               ),
//                               // Padding(
//                               //   padding: const EdgeInsets.only(right: 15.0, top: 220),
//                               //   child: Icon(widget.prodID.split('^')[3] == 'unit_name'? SmartKyat_POS.prodm: widget.prodID.split('^')[3] == 'sub1_name'? SmartKyat_POS.prods1: SmartKyat_POS.prods2, size: 16, color: Colors.grey),
//                               // ),
//                             ],
//                           ),
//
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 15.0, right: 15.0, top: 250),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width:  MediaQuery.of(context).size.width > 900 ? ((MediaQuery.of(context).size.width * (2 / 3.5))  - 30) : MediaQuery.of(context).size.width - 30,
//                                   child: TextFormField(
//                                     controller: mainDiff,
//                                     keyboardType: TextInputType.numberWithOptions(decimal: false),
//                                     inputFormatters: <TextInputFormatter>[
//                                       FilteringTextInputFormatter.allow(RegExp(_getNum())),],
// // The validator receives the text that the user has entered.
//                                     validator: (value) {
//                                       if (value == null ||
//                                           value.isEmpty) {
//                                         return 'This field is required';
//                                       }
//                                       return null;
//                                     },
//                                     style: TextStyle(
//                                       height: 0.95, fontSize: 15/scaleFactor,
//                                     ),
//                                     decoration: InputDecoration(
//                                       enabledBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                           borderSide: const BorderSide(
//                                               color: AppTheme.skBorderColor,
//                                               width: 2.0),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10.0))),
//
//                                       focusedBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                           borderSide: const BorderSide(
//                                               color: AppTheme.themeColor,
//                                               width: 2.0),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10.0))),
//                                       contentPadding: const EdgeInsets.only(
//                                           left: 15.0,
//                                           right: 15.0,
//                                           top: 20.0,
//                                           bottom: 20.0),
//                                       // suffixText: 'Required',
//                                       suffixStyle: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 12/scaleFactor,
//                                         fontFamily: 'capsulesans',
//                                       ),
//                                       //errorText: wrongPassword,
//                                       errorStyle: TextStyle(
//                                           backgroundColor: Colors.white,
//                                           fontSize: 12/scaleFactor,
//                                           fontFamily: 'capsulesans',
//                                           height: 0.1
//                                       ),
//                                       labelStyle: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.black,
//                                       ),
// // errorText: 'Error message',
//                                       labelText: 'Sub1 Qty',
//                                       floatingLabelBehavior:
//                                       FloatingLabelBehavior.auto,
// //filled: true
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 // Spacer(),
//                                 // Container(
//                                 //   width: MediaQuery.of(context).size.width > 900 ? ((MediaQuery.of(context).size.width * (2 / 3.5))  -
//                                 //       30) *
//                                 //       (1.41 / 4) : (MediaQuery.of(context).size.width -
//                                 //       30) *
//                                 //       (1.41 / 4),
//                                 //   child: Text(
//                                 //     mainName,
//                                 //     style: TextStyle(
//                                 //       fontSize: 16,
//                                 //       fontWeight: FontWeight.w500,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                               ],
//                             ),
//                           ),
//
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 15.0, right: 15.0, top: 320),
//                             child: Column(
//                               children: [
//                                 Container(
//                                   alignment: Alignment.topLeft,
//                                   child: Text(
//                                       'Sub1 Loss', textScaleFactor: 1,
//                                       style: TextStyle(
//                                           letterSpacing: 1.5,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 14, color: Colors.grey,
//                                           height: 0.9
//                                       ),
//                                       strutStyle: StrutStyle(
//                                         height: widget.isEnglish? 1.4: 1.6,
//                                         forceStrutHeight: true,
//                                       )
//                                   ),
//                                 ),
//                                 SizedBox(height: 15,),
//                                 Container(
//                                   width:  MediaQuery.of(context).size.width > 900 ? ((MediaQuery.of(context).size.width * (2 / 3.5))  - 30) : MediaQuery.of(context).size.width - 30,
//                                   color: Colors.cyanAccent,
//                                   height: 52,
//                                   child: Center(
//                                     child: Text(
//                                       (double.parse(widget.prodID.split('^')[4].toString()) -  double.parse(mainDiff.text.toString())).toString(),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
// //                             child: TextFormField(
// //                               controller: priceAmount,
// //                               keyboardType: TextInputType.numberWithOptions(decimal: true),
// //                               inputFormatters: <TextInputFormatter>[
// //                                 FilteringTextInputFormatter.allow(RegExp(_getRegexString())),],
// // // The validator receives the text that the user has entered.
// //                               validator: (value) {
// //                                 if (value == null ||
// //                                     value.isEmpty) {
// //                                   return 'This field is required';
// //                                 }
// //                                 return null;
// //                               },
// //                               style: TextStyle(
// //                                 height: 0.95, fontSize: 15/scaleFactor,
// //                               ),
// //                               decoration: InputDecoration(
// //                                 enabledBorder: const OutlineInputBorder(
// // // width: 0.0 produces a thin "hairline" border
// //                                     borderSide: const BorderSide(
// //                                         color: AppTheme.skBorderColor,
// //                                         width: 2.0),
// //                                     borderRadius: BorderRadius.all(
// //                                         Radius.circular(10.0))),
// //
// //                                 focusedBorder: const OutlineInputBorder(
// // // width: 0.0 produces a thin "hairline" border
// //                                     borderSide: const BorderSide(
// //                                         color: AppTheme.themeColor,
// //                                         width: 2.0),
// //                                     borderRadius: BorderRadius.all(
// //                                         Radius.circular(10.0))),
// //                                 contentPadding: const EdgeInsets.only(
// //                                     left: 15.0,
// //                                     right: 15.0,
// //                                     top: 20.0,
// //                                     bottom: 20.0),
// //                                 // suffixText: 'Required',
// //                                 suffixStyle: TextStyle(
// //                                   color: Colors.grey,
// //                                   fontSize: 12/scaleFactor,
// //                                   fontFamily: 'capsulesans',
// //                                 ),
// //                                 //errorText: wrongPassword,
// //                                 errorStyle: TextStyle(
// //                                     backgroundColor: Colors.white,
// //                                     fontSize: 12/scaleFactor,
// //                                     fontFamily: 'capsulesans',
// //                                     height: 0.1
// //                                 ),
// //                                 labelStyle: TextStyle(
// //                                   fontWeight: FontWeight.w500,
// //                                   color: Colors.black,
// //                                 ),
// //                                 labelText: textSetBuyPrice,
// //                                 floatingLabelBehavior:
// //                                 FloatingLabelBehavior.auto,
// // //filled: true
// //                                 border: OutlineInputBorder(
// //                                   borderRadius: BorderRadius.circular(10),
// //                                 ),
// //                               ),
// //                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                   ],
//                 ),
//
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width > 900 ? homeBotPadding + 20: homeBotPadding),
//                   child: Container(
//                     color: Colors.white,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 15.0, right: 15.0, left:15.0, bottom: 15.0),
//                       child: ButtonTheme(
//                         minWidth: MediaQuery.of(context).size.width,
//                         splashColor: Colors.transparent,
//                         height: 50,
//                         child: FlatButton(
//                           color: AppTheme.themeColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius:
//                             BorderRadius.circular(10.0),
//                             side: BorderSide(
//                               color: AppTheme.themeColor,
//                             ),
//                           ),
//                           onPressed: () async {
//                             if (_formKey.currentState!.validate()) {
//
//                               WriteBatch batch = FirebaseFirestore.instance.batch();
//
//                               DateTime now = DateTime.now();
//                               DocumentReference prodsDec = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('prodAdj').doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()));
//                               DocumentReference prodsInc = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('prodInc').doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()));
//
//                               showOkCancelAlertDialog(
//                                 context: context,
//                                 title: 'Confirmation alert',
//                                 message: 'Are you sure you want to add this product to loss products in inventory',
//                                 defaultType: OkCancelAlertDefaultType.cancel,
//                               ).then((result) async {
//                                 if(result == OkCancelResult.ok) {
//                                   double adjustAmt = 0;
//                                   adjustAmt = double.parse(
//                                       widget.prodID.split('^')[4].toString()) -
//                                       double.parse(mainDiff.text.toString());
//                                   if (widget.prodID.split('^')[3] ==
//                                       'unit_name') {
//                                     batch = await decStockFromInv(
//                                         batch, widget.prodID.split('^')[0],
//                                         'im', mainDiff.text.toString());
//
//
//                                     if (adjustAmt.isNegative) {
//                                       batch.set(
//                                         prodsDec,
//                                         {
//                                           'date': now,
//                                           'dec': {
//                                             zeroToTen(now.hour.toString())+ zeroToTen(now.minute.toString())+ zeroToTen(now.second.toString()) + '$deviceIdNum': {
//                                               'lm': FieldValue.increment(
//                                                   adjustAmt.abs()),
//                                               'rs': 1,
//                                               'dt': now,
//                                               'id': widget.prodID.split('^')[0]
//                                                   .toString(),
//                                             }
//                                           },
//                                         },SetOptions(merge: true),
//                                       );
//                                     } else {
//                                       batch.set(
//                                         prodsInc,
//                                         {
//                                           'date': now,
//                                           'inc': {
//                                             zeroToTen(now.hour.toString())+ zeroToTen(now.minute.toString())+ zeroToTen(now.second.toString()) + '$deviceIdNum': {
//                                               'lm': FieldValue.increment(
//                                                   adjustAmt),
//                                               'rs': 1,
//                                               'dt': now,
//                                               'id': widget.prodID.split('^')[0]
//                                                   .toString(),
//                                             }
//                                           },
//                                         },SetOptions(merge: true),
//                                       );
//                                     }
//                                     //  batch  = await updateLoss(batch, widget.prodID.split('^')[0], 'lm', mainDiff.text.toString());
//                                   }
//                                   else if (widget.prodID.split('^')[3] ==
//                                       'sub1_name') {
//                                     batch = await sub1Execution(
//                                         batch, widget.prodID.split('^')[4],
//                                         widget.prodID.split('^')[5],
//                                         widget.prodID.split('^')[0],
//                                         mainDiff.text.toString());
//                                     batch = await updateLoss(
//                                         batch, widget.prodID.split('^')[0],
//                                         'l1', mainDiff.text.toString());
//                                   }
//                                   else if (widget.prodID.split('^')[3] ==
//                                       'sub2_name') {
//                                     batch = await sub2Execution(
//                                         batch, widget.prodID.split('^')[4],
//                                         widget.prodID.split('^')[5],
//                                         widget.prodID.split('^')[0],
//                                         mainDiff.text.toString());
//                                     batch = await updateLoss(
//                                         batch, widget.prodID.split('^')[0],
//                                         'l2', mainDiff.text.toString());
//                                   }
//
//                                   if (adjustAmt.isNegative) {
//                                     DateTime ordCntDate = DateFormat(
//                                         "yyyy-MM-dd HH:mm:ss").parse(
//                                         now.year.toString() + '-' +
//                                             zeroToTen(now.month.toString()) +
//                                             '-' +
//                                             zeroToTen(now.day.toString()) +
//                                             ' 12:00:00');
//                                     double ttlmainDiff = 0.0;
//                                     ttlmainDiff = double.parse(
//                                         adjustAmt.abs().toString()) *
//                                         double.parse(
//                                             priceAmount.text.toString());
//                                     batch = await updateMonthlyData(batch,
//                                         now.year.toString() +
//                                             zeroToTen(now.month.toString()),
//                                         now.year.toString() +
//                                             zeroToTen(now.month.toString()) +
//                                             zeroToTen(now.day.toString()) +
//                                             'loss_cust',
//                                         ttlmainDiff.toString(), ordCntDate);
//                                     batch = await updateYearlyData(
//                                         batch, now.year.toString(),
//                                         now.year.toString() +
//                                             zeroToTen(now.month.toString()) +
//                                             'loss_cust',
//                                         ttlmainDiff.toString(), ordCntDate);
//                                   }
//                                     try {
//                                       batch.commit();
//                                       Navigator.pop(context);
//                                       smartKyatFlash('Success', 's');
//                                     } catch (error) {
//                                       Navigator.pop(context);
//                                       smartKyatFlash(
//                                           'Unknown error! Please try again later.',
//                                           'e');
//                                     }
//                                 }
//                               });
//
//                             }
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 5.0,
//                                 right: 5.0,
//                                 bottom: 2.0),
//                             child: Container(
//                               child: Text(
//                                   textSetSave, textScaleFactor: 1,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w500,
//                                       letterSpacing:-0.1
//                                   ),
//                                   strutStyle: StrutStyle(
//                                     height: widget.isEnglish? 1.4: 1.6,
//                                     forceStrutHeight: true,
//                                   )
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 color: Colors.white,
//                 height: MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding < 0? 0:  MediaQuery.of(context).viewInsets.bottom - 60 - homeBotPadding,
//               ),
//               widget.fromSearch?SizedBox(height: 65): SizedBox(height: 0)
//             ],
//           ),
//         )
//     );
//   }
//   // changeUnitName2Stock(String split) {
//   //   if(split == 'main') {
//   //     return 'inStock1';
//   //   } else {
//   //     return 'inStock' + (int.parse(split[3]) + 1).toString();
//   //   }
//   // }
//   zeroToTen(String string) {
//     if (int.parse(string) > 9) {
//       return string;
//     } else {
//       return '0' + string;
//     }
//   }
//
//   void smartKyatFlash(String text, String type) {
//     Widget widgetCon = Container();
//     Color bdColor = Color(0xffffffff);
//     Color bgColor = Color(0xffffffff);
//     if(type == 's') {
//       bdColor = Color(0xffB1D3B1);
//       bgColor = Color(0xffCFEEE0);
//       widgetCon = Container(
//         width: 18,
//         height: 18,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(
//               Radius.circular(35.0),
//             ),
//             color: Color(0xff419373)),
//         child: Padding(
//           padding: const EdgeInsets.only(right: 1.0),
//           child: Icon(
//             Icons.check_rounded,
//             size: 15,
//             color: Colors.white,
//           ),
//         ),
//       );
//     } else if(type == 'w') {
//       bdColor = Color(0xffF2E0BC);
//       bgColor = Color(0xffFCF4E2);
//       widgetCon = Container(
//         width: 18,
//         height: 18,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(
//               Radius.circular(35.0),
//             ),
//             color: Color(0xffF5C04A)),
//         child: Padding(
//           padding: const EdgeInsets.only(left: 6.0, top: 1.0),
//           child: Text('!', textScaleFactor: 1, style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
//           // child: Icon(
//           //   Icons.warning_rounded,
//           //   size: 15,
//           //   color: Colors.white,
//           // ),
//         ),
//       );
//     } else if(type == 'e') {
//       bdColor = Color(0xffEAD2C8);
//       bgColor = Color(0xffFAEEEC);
//       widgetCon = Container(
//         width: 18,
//         height: 18,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(
//               Radius.circular(35.0),
//             ),
//             color: Color(0xffE9625E)),
//         child: Padding(
//           padding: const EdgeInsets.only(left: 0),
//           child: Icon(
//             Icons.close_rounded,
//             size: 15,
//             color: Colors.white,
//           ),
//         ),
//       );
//     } else if(type == 'i') {
//       bdColor = Color(0xffBCCEEA);
//       bgColor = Color(0xffE8EEF9);
//       widgetCon = Container(
//         width: 18,
//         height: 18,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(
//               Radius.circular(35.0),
//             ),
//             color: Color(0xff4788E2)),
//         child: Padding(
//           padding: const EdgeInsets.only(left: 6.5, top: 1.5),
//           child: Text('i', textScaleFactor: 1, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white,)),
//           // child: Icon(
//           //   Icons.warning_rounded,
//           //   size: 15,
//           //   color: Colors.white,
//           // ),
//         ),
//       );
//     }
//     showFlash(
//       context: context,
//       duration: const Duration(milliseconds: 2500),
//       persistent: true,
//       transitionDuration: Duration(milliseconds: 300),
//       builder: (_, controller) {
//         return Flash(
//           controller: controller,
//           backgroundColor: Colors.transparent,
//           brightness: Brightness.light,
//           // boxShadows: [BoxShadow(blurRadius: 4)],
//           // barrierBlur: 3.0,
//           // barrierColor: Colors.black38,
//           barrierDismissible: true,
//           behavior: FlashBehavior.floating,
//           position: FlashPosition.top,
//           child: Padding(
//             padding: const EdgeInsets.only(
//                 top: 93.0, left: 15, right: 15),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(10.0),
//                 ),
//                 color: bgColor,
//                 border: Border.all(
//                     color: bdColor,
//                     width: 1.0
//                 ),
//               ),
//               child: ListTile(
//                 leading: Padding(
//                   padding: const EdgeInsets.only(top: 2.0),
//                   child: widgetCon,
//                 ),
//                 minLeadingWidth: 15,
//                 horizontalTitleGap: 10,
//                 minVerticalPadding: 0,
//                 title: Padding(
//                   padding: const EdgeInsets.only(top: 15, bottom: 16.3),
//                   child: Container(
//                     child: Text(text, textScaleFactor: 1, overflow: TextOverflow.visible, style: TextStyle(
//                         fontWeight: FontWeight.w400, fontSize: 15, height: 1.2)),
//                   ),
//                 ),
//                 // subtitle: Text('shit2'),
//                 // trailing: Text('GGG',
//                 //   style: TextStyle(
//                 //     fontSize: 16,
//                 //     fontWeight: FontWeight.w500,
//                 //   ),),
//               ),
//             ),
//           ),
//           // child: Padding(
//           //   padding: const EdgeInsets.only(
//           //       top: 93.0, left: 15, right: 15),
//           //   child: Container(
//           //     decoration: BoxDecoration(
//           //       borderRadius: BorderRadius.all(
//           //         Radius.circular(10.0),
//           //       ),
//           //       color: bgColor,
//           //       border: Border.all(
//           //           color: bdColor,
//           //           width: 1.0
//           //       ),
//           //     ),
//           //     child: Padding(
//           //         padding: const EdgeInsets.only(
//           //             top: 15.0, left: 10, right: 10, bottom: 15),
//           //         child: Row(
//           //           children: [
//           //             SizedBox(width: 5),
//           //             widgetCon,
//           //             SizedBox(width: 10),
//           //             Padding(
//           //               padding: const EdgeInsets.only(bottom: 2.5),
//           //               child: Container(
//           //                 child: Text(text, overflow: TextOverflow.visible, style: TextStyle(
//           //                     fontWeight: FontWeight.w400, fontSize: 14.5)),
//           //               ),
//           //             )
//           //           ],
//           //         )
//           //     ),
//           //   ),
//           // ),
//         );
//       },
//     );
//   }
//
//   updateLossMonthly(WriteBatch batch, id, field, price) {
//
//     DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_monthly').doc(id);
//
//     batch.update(documentReference, {
//       field : FieldValue.increment(double.parse(price.toString())),
//
//     });
//     return batch;
//   }
//
//   updateMonthlyData(WriteBatch batch, id, field1, price1, now) {
//     DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_monthly').doc(id);
//     // batch.update(documentReference, {
//     //   field1 : FieldValue.increment(double.parse(price1.toString())),
//     //   field2 : FieldValue.increment(double.parse(price2.toString())),
//     //
//     // });
//     batch.set(documentReference, {
//       field1.toString() : FieldValue.increment(double.parse(price1.toString())),
//       'date': now,
//     },SetOptions(merge: true));
//     return batch;
//   }
//
//   updateYearlyData(WriteBatch batch, id, field1, price1, now) {
//     DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_yearly').doc(id);
//     batch.set(documentReference, {
//       field1.toString() : FieldValue.increment(double.parse(price1.toString())),
//       'date': now,
//     },SetOptions(merge: true));
//     return batch;
//   }
//
//   updateLossYearly(WriteBatch batch, id, field, price) {
//
//     DocumentReference documentReference = FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('orders_yearly').doc(id);
//
//     batch.update(documentReference, {
//       field : FieldValue.increment(double.parse(price.toString())),
//
//     });
//     return batch;
//   }
//
//
//   updateLoss(WriteBatch batch, id, unit, num){
//
//     DocumentReference documentReference =FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr');
//
//     batch.update(documentReference, {'prods.$id.$unit': FieldValue.increment((double.parse(num.toString()))),});
//     return batch;
//   }
//
//   decStockFromInv(WriteBatch batch, id, unit, num) {
//     debugPrint('Double Check Sub1' + '$id.im');
//     DocumentReference documentReference =FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr');
//
//     batch.update(documentReference, {'prods.$id.$unit': double.parse(num.toString()),});
//
//     return batch;
//   }
//
//   incStockFromInv(WriteBatch batch, id, unit, num) {
//     DocumentReference documentReference =FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('collArr').doc('prodsArr');
//
//     batch.update(documentReference, {'prods.$id.$unit': FieldValue.increment((double.parse(num.toString()))),});
//     return batch;
//   }
//
//   sub1Execution(WriteBatch batch, subStock, subLink, id, num,) {
//     //var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(id).get();
//     if(double.parse(subStock) > double.parse(num)) {
//       batch = decStockFromInv(batch, id, 'i1', num);
//     } else {
//       batch = decStockFromInv(batch, id, 'im', ((double.parse(num)  - double.parse(subStock))/double.parse(subLink)).ceil());
//       batch = incStockFromInv(batch, id, 'i1', ((double.parse(num)- double.parse(subStock).round()) % double.parse(subLink)) == 0? 0: (double.parse(subLink) - (double.parse(num)-double.parse(subStock).round()) % double.parse(subLink)));
//       batch = decStockFromInv(batch, id, 'i1', subStock);
//     }
//     return batch;
//   }
//
//   sub2Execution(WriteBatch batch, subStock, subLink, id, num) {
//     //var docSnapshot10 = await FirebaseFirestore.instance.collection('shops').doc(shopId).collection('products').doc(id).get();
//     if(double.parse(subStock) > double.parse(num)) {
//       batch = decStockFromInv(batch, id, 'i2', num);
//     } else {
//       batch =  incStockFromInv(batch, id, 'i2', ((double.parse(num)-double.parse(subStock).round()) % double.parse(subLink)) == 0? 0: (double.parse(subLink) - (double.parse(num)-double.parse(subStock).round()) % double.parse(subLink)));
//       batch = decStockFromInv(batch, id, 'i2', subStock);
//       batch = sub1Execution(batch, subStock, subLink, id, ((double.parse(num)  - double.parse(subStock))/double.parse(subLink)).ceil().toString(),);
//     }
//
//     return batch;
//   }
// }
//
// await Navigator.push(
// context, MaterialPageRoute( builder: (context) => ProductAdjustment(fromSearch: widget.fromSearch, idString: widget.idString, mainProd: prodName + '^' + mainName.toString() +
// '^unit_name' + '^' + mainQty.toString(),  sub1Prod: sub1Name.toString() +
// '^sub1_name' + '^' + sub1Qty.toString() + '^' + sub1Unit.toString(),  sub2Prod: sub2Name.toString() +
// '^sub2_name' + '^' + sub2Qty.toString() + '^' + sub2Unit.toString(), subExist: subExist.toString(),  shopId: widget.shopId, price: buyPrice1.toString(), price1: buyPrice2.toString(), price2: buyPrice3.toString(), isEnglish: widget.isEnglish,
// )
// ));