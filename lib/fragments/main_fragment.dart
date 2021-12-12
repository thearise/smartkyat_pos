// import 'package:flutter/material.dart';
// import 'package:smartkyat_pos/fragments/home_fragment.dart';
// import 'package:smartkyat_pos/fragments/orders_fragment2.dart';
// import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
// import '../app_theme.dart';
//
// class MainFragment extends StatefulWidget {
//   final _callback;
//
//   MainFragment( {required void toggleCoinCallback() } ) :
//         _callback = toggleCoinCallback;
//   @override
//   MainFragmentState createState() => MainFragmentState();
//
// // HomeFragment({Key? key, required void toggleCoinCallback()}) : super(key: key);
// //
// // @override
// // _HomeFragmentState createState() => _HomeFragmentState();
// }
//
// class MainFragmentState extends State<MainFragment>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<MainFragment>{
//   @override
//   bool get wantKeepAlive => true;
//   int mainIndex = 0;
//   @override
//   initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   changeState(index) {
//     setState(() {
//       mainIndex=index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.white,
//         child: SafeArea(
//           top: true,
//           bottom: true,
//           child: Row(
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width > 900
//                     ? MediaQuery.of(context).size.width * (2 / 3.5)
//                     : MediaQuery.of(context).size.width,
//                 child: Stack(
//                   children: [
//                     mainIndex == 0? HomeFragment(toggleCoinCallback: () {}):OrdersFragment(),
//                     Align(
//                       alignment: Alignment.topCenter,
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                             top: 10.0, left: 15.0, right: 15.0),
//                         child: GestureDetector(
//                           onTap: () {
//                             addDailyExp(context);
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 color: Colors.grey.withOpacity(0.2)),
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 15.0, bottom: 15.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                       left: 15.0,
//                                     ),
//                                     child: Icon(
//                                       Icons.search,
//                                       size: 26,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(left:8.0, right: 8.0, bottom: 3.0),
//                                       child: Container(child:
//                                       TextField(
//                                         decoration: InputDecoration(
//                                             border: OutlineInputBorder(),
//                                             hintText: 'Enter a search term'
//                                         ),
//                                       ),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                       right: 15.0,
//                                     ),
//                                     child: Icon(
//                                       Icons.bar_chart,
//                                       color: Colors.green,
//                                       size: 22,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               MediaQuery.of(context).size.width > 900
//                   ? Padding(
//                 padding: const EdgeInsets.only(top: 10.0, bottom: 57.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       border: Border(
//                           left: BorderSide(
//                               color: Colors.grey.withOpacity(0.3),
//                               width: 1.0))),
//                   width: MediaQuery.of(context).size.width * (1.5 / 3.5),
//                 ),
//               )
//                   : Container()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   addDailyExp(priContext) {
//     //  final _formKey = GlobalKey<FormState>();
//     // myController.clear();
//     showModalBottomSheet(
//         enableDrag: false,
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext context) {
//           return Scaffold(
//             body: SafeArea(
//               top: true,
//               bottom: true,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 // mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     height: MediaQuery.of(priContext).padding.top,
//                   ),
//                   Expanded(
//                     child: Container(
//                       child: Column(
//                         children: [
//                           Container(
//                             width: 70,
//                             height: 6,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(25.0),
//                                 ),
//                                 color: Colors.white.withOpacity(0.5)),
//                           ),
//                           SizedBox(
//                             height: 14,
//                           ),
//                           Container(
//                             // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(15.0),
//                                 topRight: Radius.circular(15.0),
//                               ),
//                               color: Colors.white,
//                             ),
//
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: 85,
//                                   decoration: BoxDecoration(
//                                       border: Border(
//                                           bottom: BorderSide(
//                                               color:
//                                               Colors.grey.withOpacity(0.3),
//                                               width: 1.0))),
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(
//                                         left: 15.0, right: 15.0, top: 20.0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Container(
//                                           width: 35,
//                                           height: 35,
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.all(
//                                                 Radius.circular(5.0),
//                                               ),
//                                               color:
//                                               Colors.grey.withOpacity(0.3)),
//                                           child: IconButton(
//                                             icon: Icon(
//                                               Icons.close,
//                                               size: 20,
//                                               color: Colors.black,
//                                             ),
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                             },
//                                           ),
//                                         ),
//                                         Text(
//                                           "Add new product",
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 17,
//                                               fontFamily: 'capsulesans',
//                                               fontWeight: FontWeight.w600),
//                                           textAlign: TextAlign.left,
//                                         ),
//                                         Container(
//                                           width: 35,
//                                           height: 35,
//                                           decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.all(
//                                                 Radius.circular(5.0),
//                                               ),
//                                               color: AppTheme.skThemeColor),
//                                           child: IconButton(
//                                             icon: Icon(
//                                               Icons.check,
//                                               size: 20,
//                                               color: Colors.black,
//                                             ),
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                             },
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   alignment: Alignment.topLeft,
//                                   padding: EdgeInsets.only(top: 20, left: 15),
//                                   child: Text(
//                                     "PRODUCT INFORMATION",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 13,
//                                       letterSpacing: 2,
//                                       color: Colors.brown,
//                                     ),
//                                   ),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.only(left: 15),
//                                       height: 130,
//                                       width: 150,
//                                       child: Image.network(
//                                         'http://www.hmofficesolutions.com/media/4252/royal-d.jpg',
//                                         fit: BoxFit.fill,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 20,
//                                     ),
//                                     Container(
//                                       width: 200,
//                                       child: Text(
//                                         "Add images to show customers product details and features",
//                                         style: TextStyle(
//                                           color: Colors.amberAccent,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     SizedBox(
//                                       //height: 200,
//                                       width: 380,
//                                       child: TextFormField(
//                                         // The validator receives the text that the user has entered.
//                                         validator: (value) {
//                                           if (value == null ||
//                                               value.isEmpty) {
//                                             return 'This field is required';
//                                           }
//                                           return null;
//                                         },
//                                         decoration: InputDecoration(
//                                           suffixText: 'Required',
//                                           // errorText: 'Error message',
//                                           labelText: 'First Name',
//                                           floatingLabelBehavior:
//                                           FloatingLabelBehavior.auto,
//                                           //filled: true,
//                                           border: OutlineInputBorder(
//                                             borderRadius:
//                                             BorderRadius.circular(10),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                     SizedBox(
//                                       //height: 200,
//                                       width: 380,
//                                       child: TextFormField(
//                                         // The validator receives the text that the user has entered.
//                                         decoration: InputDecoration(
//                                           labelText: 'Last Name',
//                                           floatingLabelBehavior:
//                                           FloatingLabelBehavior.auto,
//                                           //filled: true,
//                                           border: OutlineInputBorder(
//                                             borderRadius:
//                                             BorderRadius.circular(10),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
