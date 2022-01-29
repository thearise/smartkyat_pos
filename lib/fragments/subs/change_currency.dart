import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:extended_image/extended_image.dart';
// import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';
import 'package:smartkyat_pos/pages2/home_page4.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_theme.dart';
import '../app_theme.dart';

class ChangeCurrency extends StatefulWidget {
  final _chgShopCB3;

  ChangeCurrency({required void changeShopCallback3()}) :
        _chgShopCB3 = changeShopCallback3;

  @override
  ChangeCurrencyState createState() => ChangeCurrencyState();
}

class ChangeCurrencyState extends State<ChangeCurrency>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ChangeCurrency>{
  String currencyType = 'Myanmar Kyat (MMK)';

  @override
  bool get wantKeepAlive => true;

  var _result;
  var _shop ;
  bool firstTime = true;

  List _testList = [
    {'no': 1, 'keyword': 'Myanmar Kyat (MMK)'},
    {'no': 2, 'keyword': 'US Dollar (USD)'},
  ];
  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];
  var _selectedTest;

  @override
  initState() {
    getCurrency().then((value) {
      setState(() {
        currencyType = value;
      });
    });
    _dropdownTestItems = buildDropdownTestItems(_testList);
    super.initState();
  }

  Future<String> getStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));

    var index = prefs.getString('store');
    print(index);
    if (index == null) {
      return 'idk';
    } else {
      return index;
    }
  }

  @override
  void dispose() {
    super.dispose();
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

  onChangeDropdownTests(selectedTest) {
    showOkCancelAlertDialog(
      context: context,
      title: 'Are you sure you want to change to ' + selectedTest['keyword'].toString() +'?',
      message: '\nThis action will restart the application',
      defaultType: OkCancelAlertDefaultType.cancel,
    ).then((result) async {
      if(result == OkCancelResult.ok) {
        setState(() {
          _selectedTest = selectedTest;
        });
        setCurrency(selectedTest['keyword'].toString()).then((_) {
          // widget._chgShopCB3();
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        });

      }
    }
    );

    print(selectedTest['keyword'].toString() + ({'no': 1, 'keyword': 'US Dollar (USD)'}).toString() + selectedTest.toString() + ' ' + selectedTest.runtimeType.toString() + ' __ ' + _selectedTest.runtimeType.toString());
  }

  // addShop(shopName) {
  //   CollectionReference spaces = FirebaseFirestore.instance.collection('space');
  //   var exist = false;
  //   var docId = '';
  //   var shopExist = false;
  //   FirebaseFirestore.instance
  //       .collection('space')
  //       .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       docId = doc.id;
  //       exist = true;
  //     });
  //
  //     if(exist) {
  //       print('space shi p thar');
  //
  //       FirebaseFirestore.instance
  //           .collection('space').doc(docId).collection('shops')
  //           .where('shop_name', isEqualTo: shopName)
  //           .get()
  //           .then((QuerySnapshot querySnapshot) {
  //         querySnapshot.docs.forEach((doc) {
  //           shopExist = true;
  //         });
  //
  //         if(shopExist) {
  //           print('shop already');
  //
  //         } else {
  //           CollectionReference shops = FirebaseFirestore.instance.collection('space').doc(docId).collection('shops');
  //           return shops
  //               .add({
  //             'shop_name': shopName
  //           })
  //               .then((value) {
  //             print('shop added');
  //           });
  //         }
  //       });
  //
  //
  //     } else {
  //       print('space mshi vuu');
  //       return spaces
  //           .add({
  //         'user_id': FirebaseAuth.instance.currentUser!.uid
  //       })
  //           .then((value) {
  //         CollectionReference shops = FirebaseFirestore.instance.collection('space').doc(value.id).collection('shops');
  //
  //         return shops
  //             .add({
  //           'shop_name': shopName
  //         })
  //             .then((value) {
  //           print('shop added');
  //         });
  //
  //       }).catchError((error) => print("Failed to add shop: $error"));
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: true,
        top: true,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 81,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1.0))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          width: 37,
                          height: 37,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(35.0),
                              ),
                              color: Colors.grey.withOpacity(0.3)),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 3.0),
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: 17,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Display',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Currency',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text('CHANGE CURRENCY', style: TextStyle(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,color: Colors.grey,
                          ),),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: DropdownBelow(
                            itemWidth: MediaQuery.of(context).size.width-30,
                            itemTextstyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                            boxTextstyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                            boxPadding: EdgeInsets.fromLTRB(15, 12, 13, 12),
                            boxWidth: double.infinity,
                            boxHeight: 50,
                            boxDecoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(10.0),
                                color: AppTheme.buttonColor2,
                                border: Border.all(width: 1, color: Colors.transparent)),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black,
                            ),
                            hint: Text(currencyType),
                            value: _selectedTest,
                            items: _dropdownTestItems,
                            onChanged: onChangeDropdownTests,
                          ),
                        ),
                        SizedBox(height: 13),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: RichText(
                            text: new TextSpan(
                              children: [
                                new TextSpan(
                                  text: 'This currency will be applied to your all financial amount display.',
                                  style: new TextStyle(
                                      fontSize: 12.5,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }

  // final _formKey = GlobalKey<FormState>();
  // // final auth = FirebaseAuth.instance;
  // final _accountName = TextEditingController();
  // final _email = TextEditingController();
  // final _shopName = TextEditingController();
  // final _address = TextEditingController();
  // final _phone = TextEditingController();

//   accountSetting(priContext) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         bottom: true,
//         top: true,
//         child: Form(
//           key: _formKey,
//           child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
//               // mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   height: 80,
//                   decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               color: Colors.grey.withOpacity(0.3),
//                               width: 1.0))),
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 18.0, right: 15.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 16),
//                           child: Container(
//                             width: 37,
//                             height: 37,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(35.0),
//                                 ),
//                                 color: Colors.grey.withOpacity(0.3)),
//                             child: Padding(
//                               padding: const EdgeInsets.only(right: 3.0),
//                               child: IconButton(
//                                   icon: Icon(
//                                     Icons.arrow_back_ios_rounded,
//                                     size: 17,
//                                     color: Colors.black,
//                                   ),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   }),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 16.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       'Information',
//                                       textAlign: TextAlign.right,
//                                       style: TextStyle(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w600,color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Text(
//                                   'Account settings',
//                                   textAlign: TextAlign.right,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w600,
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
//                 SizedBox(height: 15,),
//                 Expanded(
//                   child: ListView(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15.0,),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('INFORMATION', style: TextStyle(
//                               letterSpacing: 1.5,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,color: Colors.grey,
//                             ),),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 20.0),
//                               child: TextFormField(
//                                 //obscureText: _obscureText,
//                                 controller: _accountName,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return ' This field is required ';
//                                   }
//                                   return null;
//                                 },
//                                 style: TextStyle(
//                                   height: 0.95,
//                                 ),
//                                 decoration: InputDecoration(
//                                   enabledBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                       borderSide: const BorderSide(
//                                           color: AppTheme.skBorderColor,
//                                           width: 2.0),
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0))),
//
//                                   focusedBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                       borderSide: const BorderSide(
//                                           color: AppTheme.themeColor,
//                                           width: 2.0),
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0))),
//                                   contentPadding: const EdgeInsets.only(
//                                       left: 15.0,
//                                       right: 15.0,
//                                       top: 20.0,
//                                       bottom: 20.0),
//                                   suffixText: 'Required' ,
//                                   suffixStyle: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                     fontFamily: 'capsulesans',
//                                   ),
//                                   // errorText: wrongPassword,
//                                   errorStyle: TextStyle(
//                                       backgroundColor: Colors.white,
//                                       fontSize: 12,
//                                       fontFamily: 'capsulesans',
//                                       height: 0.1
//                                   ),
//                                   labelStyle: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                   ),
// // errorText: 'Error message',
//                                   labelText: 'Account name',
//                                   floatingLabelBehavior:
//                                   FloatingLabelBehavior.auto,
// //filled: true,
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 20.0),
//                               child: TextFormField(
//                                 //obscureText: _obscureText,
//                                 controller: _email,
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return ' This field is required ';
//                                   }
//                                   return null;
//                                 },
//                                 style: TextStyle(
//                                   height: 0.95,
//                                 ),
//                                 decoration: InputDecoration(
//                                   enabledBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                       borderSide: const BorderSide(
//                                           color: AppTheme.skBorderColor,
//                                           width: 2.0),
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0))),
//
//                                   focusedBorder: const OutlineInputBorder(
// // width: 0.0 produces a thin "hairline" border
//                                       borderSide: const BorderSide(
//                                           color: AppTheme.themeColor,
//                                           width: 2.0),
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(10.0))),
//                                   contentPadding: const EdgeInsets.only(
//                                       left: 15.0,
//                                       right: 15.0,
//                                       top: 20.0,
//                                       bottom: 20.0),
//                                   suffixText: 'Required' ,
//                                   suffixStyle: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                     fontFamily: 'capsulesans',
//                                   ),
//                                   //errorText: wrongPassword,
//                                   errorStyle: TextStyle(
//                                       backgroundColor: Colors.white,
//                                       fontSize: 12,
//                                       fontFamily: 'capsulesans',
//                                       height: 0.1
//                                   ),
//                                   labelStyle: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                   ),
// // errorText: 'Error message',
//                                   labelText: 'Email address',
//                                   floatingLabelBehavior:
//                                   FloatingLabelBehavior.auto,
// //filled: true,
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 30,),
//                             ButtonTheme(
//                               minWidth: MediaQuery.of(context).size.width,
//                               splashColor: Colors.transparent,
//                               height: 50,
//                               child: FlatButton(
//                                 color: AppTheme.themeColor,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                   BorderRadius.circular(10.0),
//                                   side: BorderSide(
//                                     color: AppTheme.themeColor,
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   if (_formKey.currentState!.validate()) {
//
//
//                                   }
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 5.0,
//                                       right: 5.0,
//                                       bottom: 2.0),
//                                   child: Container(
//                                     child: Text(
//                                       'Save and exit',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w600,
//                                           letterSpacing:-0.1
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ]
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//   addStaffPage() {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         bottom: true,
//         top: true,
//         child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
//             // mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Container(
//                 height: 80,
//                 decoration: BoxDecoration(
//                     border: Border(
//                         bottom: BorderSide(
//                             color: Colors.grey.withOpacity(0.3),
//                             width: 1.0))),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 18.0, right: 15.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 16),
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
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 16.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     'Information',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w600,color: Colors.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Text(
//                                 'Switch shop',
//                                 textAlign: TextAlign.right,
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: ListView(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 15.0),
//                             child: Text('CURRENT SHOP', style: TextStyle(
//                               letterSpacing: 1.5,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,color: Colors.grey,
//                             ),),
//                           ),
//                           SizedBox(height: 30,),
//                           ButtonTheme(
//                             minWidth: MediaQuery.of(context).size.width,
//                             splashColor: Colors.transparent,
//                             height: 50,
//                             child: FlatButton(
//                               color: AppTheme.buttonColor2,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                 BorderRadius.circular(10.0),
//                                 side: BorderSide(
//                                   color: AppTheme.buttonColor2,
//                                 ),
//                               ),
//                               onPressed: () async {
//                                 if (_formKey.currentState!.validate()) {
//
//
//                                 }
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 5.0,
//                                     right: 5.0,
//                                     bottom: 2.0),
//                                 child: Container(
//                                   child: Text(
//                                     'New shop',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w600,
//                                         letterSpacing:-0.1
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ]
//         ),
//       ),
//     );
//   }
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
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.close,
//                                           size: 20,
//                                           color: Colors.transparent,
//                                         ),
//                                         onPressed: () {
//                                         },
//
//                                       ),
//                                       Text(
//                                         "New Expense",
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 17,
//                                             fontFamily: 'capsulesans',
//                                             fontWeight: FontWeight.w600
//                                         ),
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
//
//                                       )
//
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
//
//         });
//   }

  setCurrency(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));
    prefs.setString('currency', id);
  }

  getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currency');
  }


}



