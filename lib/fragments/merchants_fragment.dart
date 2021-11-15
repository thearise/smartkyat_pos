import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/subs/merchant_info.dart';
import 'package:smartkyat_pos/pages2/home_page3.dart';
import 'package:smartkyat_pos/widgets/add_new_merchant.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';

import '../app_theme.dart';

class MerchantsFragment extends StatefulWidget {
  final _callback3;

  MerchantsFragment( {required void toggleCoinCallback3(String str), Key? key} ) :
        _callback3 = toggleCoinCallback3, super(key: key);
  @override
  MerchantsFragmentState createState() => MerchantsFragmentState();
}

class MerchantsFragmentState extends State<MerchantsFragment> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<MerchantsFragment>{
  String? shopId;

  @override
  bool get wantKeepAlive => true;

  List<List> orderList = [];
  var orders;
  var docId;
  var innerId;

  @override
  initState() {
    HomePageState().getStoreId().then((value) => shopId = value);
    super.initState();
  }

  chgShopIdFrmHomePage() {
    setState(() {
      HomePageState().getStoreId().then((value) => shopId = value);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  addMerchant2Cart(data) {
    widget._callback3(data);
  }

  final cateScCtler = ScrollController();
  final _width = 10.0;
  int cateScIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          top: true,
          bottom: true,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 81.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom -
                        100,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, left: 0.0, right: 0.0),


                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('shops')
                              .doc(shopId)
                              .collection('merchants')
                              .where('merchant_name', isNotEqualTo: 'Unknown')
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if(snapshot.hasData) {
                              orderList = [];
                              for(int i = 0; i < snapshot.data!.docs.length; i++) {
                                // setState(() {
                                orderList.add([]);
                                // });
                              }
                              return CustomScrollView(
                                slivers: [
                                  // Add the app bar to the CustomScrollView.
                                  SliverAppBar(
                                    elevation: 0,
                                    backgroundColor: Colors.white,
                                    // Provide a standard title.

                                    // Allows the user to reveal the app bar if they begin scrolling
                                    // back up the list of items.
                                    floating: true,
                                    flexibleSpace: Padding(
                                      padding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 12.0),
                                      child: Container(
                                        height: 32,
                                        width: MediaQuery.of(context).size.width,
                                        // color: Colors.yellow,
                                        child: Row(
                                          children: [
                                            Row(
                                              children: [
                                                FlatButton(
                                                  padding: EdgeInsets.only(left: 10, right: 10),
                                                  color: AppTheme.secButtonColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    side: BorderSide(
                                                      color: AppTheme.skBorderColor2,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => AddMerchant(),)
                                                    );
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      // mainAxisAlignment: Main,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 6.0),
                                                          child: Icon(
                                                            SmartKyat_POS.add_plus,
                                                            size: 17,
                                                          ),
                                                        ),
                                                        Text(
                                                          'New Merchant',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Container(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  width: 1.5,
                                                  height: 30,
                                                )
                                              ],
                                            ),
                                            Expanded(
                                              child: ListView(
                                                controller: cateScCtler,
                                                scrollDirection: Axis.horizontal,
                                                children: [
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                                    child: FlatButton(
                                                      minWidth: 0,
                                                      padding: EdgeInsets.only(left: 12, right: 12),
                                                      color: cateScIndex == 0 ? AppTheme.secButtonColor:Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                        side: BorderSide(
                                                          color: AppTheme.skBorderColor2,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _animateToIndex(0);
                                                        setState(() {
                                                          cateScIndex = 0;
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Text(
                                                          'All',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                                                    child: FlatButton(
                                                      minWidth: 0,
                                                      padding: EdgeInsets.only(left: 12, right: 12),
                                                      color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                        side: BorderSide(
                                                          color: AppTheme.skBorderColor2,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _animateToIndex(5.4);
                                                        setState(() {
                                                          cateScIndex = 1;
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Text(
                                                          'Low stocks',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                                                    child: FlatButton(
                                                      minWidth: 0,
                                                      padding: EdgeInsets.only(left: 12, right: 12),
                                                      color: cateScIndex == 2 ? AppTheme.secButtonColor:Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                        side: BorderSide(
                                                          color: AppTheme.skBorderColor2,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _animateToIndex(16.4);
                                                        setState(() {
                                                          cateScIndex = 2;
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Text(
                                                          'Best sales',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                                    child: FlatButton(
                                                      minWidth: 0,
                                                      padding: EdgeInsets.only(left: 12, right: 12),
                                                      color: cateScIndex == 3 ? AppTheme.secButtonColor:Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                        side: BorderSide(
                                                          color: AppTheme.skBorderColor2,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _animateToIndex(20);
                                                        setState(() {
                                                          cateScIndex = 3;
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Text(
                                                          'Low sales',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 11,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),

                                      ),
                                    ),
                                    // Display a placeholder widget to visualize the shrinking size.
                                    // Make the initial height of the SliverAppBar larger than normal.
                                    expandedHeight: 20,
                                  ),
                                  // Next, create a SliverList
                                  SliverList(
                                    // Use a delegate to build items as they're scrolled on screen.
                                    delegate: SliverChildBuilderDelegate(
                                      // The builder function returns a ListTile with a title that
                                      // displays the index of the current item.
                                          (context, index) {
                                        Map<String, dynamic> data = snapshot.data!.docs[index]
                                            .data()! as Map<String, dynamic>;
                                        var version = snapshot.data!.docs[index].id;

                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (
                                                      context) =>
                                                      MerchantInfoSubs(
                                                          id: version,
                                                          toggleCoinCallback: addMerchant2Cart, shopId: shopId.toString(),)),
                                            );
                                          },
                                          child: Padding(
                                            padding:
                                            EdgeInsets.only(top: index == 0? 10.0: 15.0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: index == snapshot.data!.docs.length-1 ?
                                                      BorderSide(
                                                          color: Colors.transparent,
                                                          width: 1.0) :

                                                      BorderSide(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          width: 1.0)
                                                  )),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 12.0),
                                                    child: ListTile(
                                                      title: Text(data['merchant_name'],style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                      ),),
                                                      subtitle: Padding(
                                                        padding: const EdgeInsets.only(top: 8.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(data['merchant_address'], style: TextStyle(
                                                              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                                                            )),
                                                            SizedBox(height: 5,),
                                                            Text(data['merchant_phone'], style: TextStyle(
                                                              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                                                            )),
                                                          ],
                                                        ),
                                                      ),
                                                      trailing: Padding(
                                                        padding: const EdgeInsets.only(top: 8.0),
                                                        child: Container(
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              StreamBuilder(
                                                                  stream: FirebaseFirestore.instance
                                                                      .collection('shops')
                                                                      .doc(shopId)
                                                                      .collection('merchants')
                                                                      .doc(snapshot.data!.docs[index].id)
                                                                      .collection('buyOrders')
                                                                      .where('debt', isGreaterThan: 0)
                                                                      .snapshots(),
                                                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                                                    // orderList[index] = 0;
                                                                    int orderLength = 0;
                                                                    int i = 0;
                                                                    if(snapshot2.hasData) {
                                                                      return snapshot2.data!.docs.length > 0? Container(
                                                                        height: 21,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(20.0),
                                                                          color: AppTheme.badgeFgDanger,
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                                                          child: Text(snapshot2.data!.docs.length.toString() + ' unpaid',
                                                                            style: TextStyle(
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.white
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ): Container(
                                                                      );
                                                                      // int quantity = 0;
                                                                      // snapshot2.data!.docs.map((DocumentSnapshot document2) {
                                                                      //   Map<String, dynamic> data2 = document2.data()! as Map<String, dynamic>;
                                                                      //   orders = data2['daily_order'];
                                                                      //   quantity += int.parse(orders.length.toString());
                                                                      //
                                                                      //   return Text(snapshot2.data!.docs[index].id);
                                                                      // }).toList();
                                                                    }
                                                                    return Container();
                                                                  }
                                                              ),

                                                              // Container(
                                                              //   height: 21,
                                                              //   decoration: BoxDecoration(
                                                              //     borderRadius: BorderRadius.circular(20.0),
                                                              //     color: AppTheme.badgeFgDanger,
                                                              //   ),
                                                              //   child: Padding(
                                                              //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                                              //     child: Text(unpaidCount(index).toString() + ' unpaid',
                                                              //       style: TextStyle(
                                                              //           fontSize: 13,
                                                              //           fontWeight: FontWeight.w500,
                                                              //           color: Colors.white
                                                              //       ),
                                                              //     ),
                                                              //   ),
                                                              // ),

                                                              // Text(orderList.toString()),

                                                              // Container(
                                                              //   height: 21,
                                                              //   decoration: BoxDecoration(
                                                              //     borderRadius: BorderRadius.circular(20.0),
                                                              //     color: AppTheme.badgeFgDanger,
                                                              //   ),
                                                              //   child: Padding(
                                                              //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                                              //     child: Text('2 unpaid',
                                                              //       style: TextStyle(
                                                              //           fontSize: 13,
                                                              //           fontWeight: FontWeight.w500,
                                                              //           color: Colors.white
                                                              //       ),
                                                              //     ),
                                                              //   ),
                                                              // )

                                                              // Container(
                                                              //   height: 21,
                                                              //   decoration: BoxDecoration(
                                                              //     borderRadius: BorderRadius.circular(20.0),
                                                              //     color: AppTheme.badgeFgDanger,
                                                              //   ),
                                                              //   child: Padding(
                                                              //     padding: const EdgeInsets.only(top: 2, left: 12.0, right: 12.0),
                                                              //     child: Text(unpaidCount(index).toString() + ' unpaid',
                                                              //       style: TextStyle(
                                                              //           fontSize: 13,
                                                              //           fontWeight: FontWeight.w500,
                                                              //           color: Colors.white
                                                              //       ),
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                              SizedBox(
                                                                  width: 12),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 2.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_rounded,
                                                                  size: 16,
                                                                  color: Colors
                                                                      .blueGrey
                                                                      .withOpacity(
                                                                      0.8),
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
                                        );
                                      },
                                      // Builds 1000 ListTiles
                                      childCount: snapshot.data!.docs.length,
                                    ),
                                  )
                                ],
                              );
                            }
                            return Container();
                          }
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                            color: AppTheme.skBorderColor2,
                            width: 1.0),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 15.0, right: 15.0, bottom: 15),
                    child: GestureDetector(
                      onTap: () {
                        // addDailyExp(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: AppTheme.secButtonColor,
                        ),
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 11.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                ),
                                child: Icon(
                                  SmartKyat_POS.search,
                                  size: 17,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      bottom: 1.0),
                                  child: Container(
                                      child: Text(
                                        'Search',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      )
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 18.0,
                                ),
                                // child: Icon(
                                //   SmartKyat_POS.barcode,
                                //   color: Colors.Colors.black,
                                //   size: 25,
                                // ),
                                child: Container(
                                    child: Image.asset('assets/system/barcode.png', height: 28,)
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  _animateToIndex(i) {
    // print((_width * i).toString() + ' BBB ' + cateScCtler.offset.toString() + ' BBB ' + cateScCtler.position.maxScrollExtent.toString());
    if((_width * i) > cateScCtler.position.maxScrollExtent) {
      cateScCtler.animateTo(cateScCtler.position.maxScrollExtent, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    } else {
      cateScCtler.animateTo(_width * i, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    }

  }

  // addNewProd(priContext) {
  //   final List<String> prodFieldsValue = [];
  //   final _formKey = GlobalKey<FormState>();
  //   // myController.clear();
  //   showModalBottomSheet(
  //       enableDrag: false,
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Scaffold(
  //           body: SafeArea(
  //             top: true,
  //             bottom: true,
  //             child: Column(
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
  //                           child: Form(
  //                             key: _formKey,
  //                             child: Column(
  //                               children: [
  //                                 Container(
  //                                   height: 85,
  //                                   decoration: BoxDecoration(
  //                                       border: Border(
  //                                           bottom: BorderSide(
  //                                               color: Colors.grey
  //                                                   .withOpacity(0.3),
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
  //                                               color: Colors.grey
  //                                                   .withOpacity(0.3)),
  //                                           child: IconButton(
  //                                             icon: Icon(
  //                                               Icons.close,
  //                                               size: 20,
  //                                               color: Colors.black,
  //                                             ),
  //                                             onPressed: () {
  //                                               if (_formKey.currentState!
  //                                                   .validate() ||
  //                                                   !_formKey.currentState!
  //                                                       .validate()) {
  //                                                 if (prodFieldsValue.length >
  //                                                     0) {
  //                                                   showOkCancelAlertDialog(
  //                                                     context: context,
  //                                                     title: 'Are you sure?',
  //                                                     message:
  //                                                     'You added data in some inputs.',
  //                                                     defaultType:
  //                                                     OkCancelAlertDefaultType
  //                                                         .cancel,
  //                                                   ).then((result) {
  //                                                     if (result ==
  //                                                         OkCancelResult.ok) {
  //                                                       Navigator.pop(context);
  //                                                     }
  //                                                   });
  //                                                 } else {
  //                                                   Navigator.pop(context);
  //                                                 }
  //                                               }
  //                                             },
  //                                           ),
  //                                         ),
  //                                         Text(
  //                                           "Add new merchant",
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
  //                                               if (_formKey.currentState!
  //                                                   .validate()) {
  //                                                 // If the form is valid, display a snackbar. In the real world,
  //                                                 // you'd often call a server or save the information in a database.
  //                                                 ScaffoldMessenger.of(context)
  //                                                     .showSnackBar(
  //                                                   const SnackBar(
  //                                                       content: Text(
  //                                                           'Processing Data')),
  //                                                 );
  //                                                 // print(prodFieldsValue);
  //
  //                                                 CollectionReference spaces =
  //                                                 FirebaseFirestore.instance
  //                                                     .collection('space');
  //                                                 var prodExist = false;
  //                                                 var spaceDocId = '';
  //                                                 FirebaseFirestore.instance
  //                                                     .collection('space')
  //                                                     .where('user_id',
  //                                                     isEqualTo:
  //                                                     FirebaseAuth
  //                                                         .instance
  //                                                         .currentUser!
  //                                                         .uid)
  //                                                     .get()
  //                                                     .then((QuerySnapshot
  //                                                 querySnapshot) {
  //                                                   querySnapshot.docs
  //                                                       .forEach((doc) {
  //                                                     spaceDocId = doc.id;
  //                                                   });
  //
  //                                                   print('space shi p thar');
  //                                                   getStoreId()
  //                                                       .then((String result2) {
  //                                                     print('store id ' +
  //                                                         result2.toString());
  //
  //                                                     FirebaseFirestore.instance
  //                                                         .collection('space')
  //                                                         .doc(spaceDocId)
  //                                                         .collection('shops')
  //                                                         .doc(result2)
  //                                                         .collection(
  //                                                         'merchant')
  //                                                         .where(
  //                                                         'merchant_name',
  //                                                         isEqualTo:
  //                                                         prodFieldsValue[
  //                                                         0])
  //                                                         .get()
  //                                                         .then((QuerySnapshot
  //                                                     querySnapshot) async {
  //                                                       querySnapshot.docs
  //                                                           .forEach((doc) {
  //                                                         prodExist = true;
  //                                                       });
  //
  //                                                       if (prodExist) {
  //                                                         print(
  //                                                             'product already');
  //                                                         var result =
  //                                                         await showOkAlertDialog(
  //                                                           context: context,
  //                                                           title: 'Warning',
  //                                                           message:
  //                                                           'Product name already!',
  //                                                           okLabel: 'OK',
  //                                                         );
  //                                                       } else {
  //                                                         CollectionReference
  //                                                         shops =
  //                                                         FirebaseFirestore
  //                                                             .instance
  //                                                             .collection(
  //                                                             'space')
  //                                                             .doc(
  //                                                             spaceDocId)
  //                                                             .collection(
  //                                                             'shops')
  //                                                             .doc(result2)
  //                                                             .collection(
  //                                                             'merchants');
  //                                                         return shops.add({
  //                                                           'merchant_name':
  //                                                           prodFieldsValue[
  //                                                           0],
  //                                                           'merchant_address':
  //                                                           prodFieldsValue[
  //                                                           1],
  //                                                           'merchant_phone':
  //                                                           prodFieldsValue[
  //                                                           2]
  //                                                         }).then((value) {
  //                                                           print(
  //                                                               'product added');
  //
  //                                                           Navigator.pop(
  //                                                               context);
  //                                                         });
  //                                                       }
  //                                                     });
  //                                                   });
  //                                                 });
  //                                               }
  //                                             },
  //                                           ),
  //                                         )
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //
  //                                 Container(
  //                                   alignment: Alignment.topLeft,
  //                                   padding: EdgeInsets.only(top: 20, left: 15),
  //                                   child: Text(
  //                                     "CONTACT INFORMATION",
  //                                     style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                       fontSize: 13,
  //                                       letterSpacing: 2,
  //                                       color: Colors.grey,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 16,
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(
  //                                       left: 15.0, right: 15.0),
  //                                   child: TextFormField(
  //                                     // The validator receives the text that the user has entered.
  //                                     validator: (value) {
  //                                       if (value == null || value.isEmpty) {
  //                                         return 'This field is required';
  //                                       }
  //                                       prodFieldsValue.add(value);
  //                                       return null;
  //                                     },
  //                                     decoration: InputDecoration(
  //                                       contentPadding: const EdgeInsets.only(
  //                                           left: 15.0,
  //                                           right: 15.0,
  //                                           top: 20.0,
  //                                           bottom: 20.0),
  //                                       suffixText: 'Required',
  //                                       suffixStyle: TextStyle(
  //                                         color: Colors.grey,
  //                                         fontSize: 12,
  //                                         fontFamily: 'capsulesans',
  //                                       ),
  //                                       labelStyle: TextStyle(
  //                                         fontWeight: FontWeight.w500,
  //                                         color: Colors.black,
  //                                       ),
  //                                       // errorText: 'Error message',
  //                                       labelText: 'First name',
  //                                       floatingLabelBehavior:
  //                                       FloatingLabelBehavior.auto,
  //                                       //filled: true,
  //                                       border: OutlineInputBorder(
  //                                         borderRadius:
  //                                         BorderRadius.circular(10),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 16,
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(
  //                                       left: 15.0, right: 15.0),
  //                                   child: TextFormField(
  //                                     // The validator receives the text that the user has entered.
  //                                     validator: (value) {
  //                                       if (value == null || value.isEmpty) {
  //                                         return 'This field is required';
  //                                       }
  //                                       prodFieldsValue.add(value);
  //                                       return null;
  //                                     },
  //                                     decoration: InputDecoration(
  //                                       contentPadding: const EdgeInsets.only(
  //                                           left: 15.0,
  //                                           right: 15.0,
  //                                           top: 20.0,
  //                                           bottom: 20.0),
  //                                       suffixText: 'Required',
  //                                       suffixStyle: TextStyle(
  //                                         color: Colors.grey,
  //                                         fontSize: 12,
  //                                         fontFamily: 'capsulesans',
  //                                       ),
  //                                       labelStyle: TextStyle(
  //                                         fontWeight: FontWeight.w500,
  //                                         color: Colors.black,
  //                                       ),
  //                                       // errorText: 'Error message',
  //                                       labelText: 'Address',
  //                                       floatingLabelBehavior:
  //                                       FloatingLabelBehavior.auto,
  //                                       //filled: true,
  //                                       border: OutlineInputBorder(
  //                                         borderRadius:
  //                                         BorderRadius.circular(10),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 16,
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(
  //                                       left: 15.0, right: 15.0),
  //                                   child: TextFormField(
  //                                     // The validator receives the text that the user has entered.
  //                                     validator: (value) {
  //                                       if (value == null || value.isEmpty) {
  //                                         return 'This field is required';
  //                                       }
  //                                       prodFieldsValue.add(value);
  //                                       return null;
  //                                     },
  //                                     decoration: InputDecoration(
  //                                       contentPadding: const EdgeInsets.only(
  //                                           left: 15.0,
  //                                           right: 15.0,
  //                                           top: 20.0,
  //                                           bottom: 20.0),
  //                                       suffixText: 'Required',
  //                                       suffixStyle: TextStyle(
  //                                         color: Colors.grey,
  //                                         fontSize: 12,
  //                                         fontFamily: 'capsulesans',
  //                                       ),
  //                                       labelStyle: TextStyle(
  //                                         fontWeight: FontWeight.w500,
  //                                         color: Colors.black,
  //                                       ),
  //                                       // errorText: 'Error message',
  //                                       labelText: 'Phone number',
  //                                       floatingLabelBehavior:
  //                                       FloatingLabelBehavior.auto,
  //                                       //filled: true,
  //                                       border: OutlineInputBorder(
  //                                         borderRadius:
  //                                         BorderRadius.circular(10),
  //                                       ),
  //                                     ),
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
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
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

setStoreId(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // return(prefs.getString('store'));

  prefs.setString('store', id);
}
