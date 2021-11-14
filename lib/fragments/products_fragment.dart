import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/pages2/home_page3.dart';
import 'package:smartkyat_pos/pages2/multi_assets_page.dart';
import 'package:smartkyat_pos/pages2/single_assets_page.dart';
import 'package:smartkyat_pos/widgets/add_new_category_button.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
import 'package:smartkyat_pos/widgets/fill_product.dart';
import 'package:smartkyat_pos/widgets/product_details_view.dart';
import 'package:smartkyat_pos/widgets/version_detatils_view.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:smartkyat_pos/widgets/product_versions_view.dart';

import '../app_theme.dart';
import 'subs/product_info.dart';

class ProductsFragment extends StatefulWidget {
  final _callback;
  final _callback2;
  final _callback3;

  ProductsFragment(
      {required void toggleCoinCallback(),
        required void toggleCoinCallback2(String str),
        required void toggleCoinCallback3(String str)})
      : _callback = toggleCoinCallback,
        _callback2 = toggleCoinCallback2,
        _callback3 = toggleCoinCallback3;
  @override
  ProductsFragmentState createState() => ProductsFragmentState();
}

class ProductsFragmentState extends State<ProductsFragment>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ProductsFragment> {
  String? shopId;

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    HomePageState().getStoreId().then((value) => shopId = value);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  closeNewProduct() {
    Navigator.pop(context);
  }

  addProduct3(data) {
    widget._callback3(data);
  }

  addProduct1(data) {
    widget._callback2(data);
  }

  Future<String> countDocuments(myDoc) async {
    QuerySnapshot _myDoc = await myDoc.get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    return _myDocCount.length.toString();
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
                              .collection('products')
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if(snapshot.hasData) {
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
                                                    widget._callback();
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
                                                          'New item',
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
                                            var image = data['img_1'];
                                            var prodName = data['prod_name'];
                                            var mainName = data['unit_name'];
                                            var sub1Name = data['sub1_name'];
                                            var sub2Name = data['sub2_name'];
                                            var mainsPrice = data['unit_sell'];
                                            var mainQty = data['inStock1'].round();
                                            var sub1Qty = data['inStock2'].round();
                                            var sub2Qty = data['inStock3'].round();
                                            var sub1Price = data['sub1_sell'];
                                            var sub2Price = data['sub2_sell'];
                                            var version = snapshot.data!.docs[index].id;
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ProductDetailsView2(
                                                          idString: version, toggleCoinCallback:
                                                      addProduct1, toggleCoinCallback3: addProduct3, shopId: shopId.toString(),)),);
                                              },
                                              child: Padding(
                                                padding:
                                                EdgeInsets.only(top: index == 0? 10.0: 19.0),
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
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            ClipRRect(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    5.0),
                                                                child: image != ""
                                                                    ? CachedNetworkImage(
                                                                  imageUrl:
                                                                  'https://riftplus.me/smartkyat_pos/api/uploads/' +
                                                                      image,
                                                                  width: 75,
                                                                  height: 75,
                                                                  // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                  errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                      Icon(Icons
                                                                          .error),
                                                                  fadeInDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                      100),
                                                                  fadeOutDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                      10),
                                                                  fadeInCurve:
                                                                  Curves
                                                                      .bounceIn,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                                    : CachedNetworkImage(
                                                                  imageUrl:
                                                                  'https://riftplus.me/smartkyat_pos/api/uploads/shark1.jpg'
                                                                  ,
                                                                  width: 75,
                                                                  height: 75,
                                                                  // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                                  errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                      Icon(Icons
                                                                          .error),
                                                                  fadeInDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                      100),
                                                                  fadeOutDuration:
                                                                  Duration(
                                                                      milliseconds:
                                                                      10),
                                                                  fadeInCurve:
                                                                  Curves
                                                                      .bounceIn,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 2,
                                                            ),
                                                            Text(
                                                              prodName,
                                                              style: TextStyle(
                                                                height: 1,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                FontWeight.w500,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 12,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'MMK ' + mainsPrice,
                                                                  style: TextStyle(
                                                                    height: 1.3,
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                    FontWeight.w500,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  sub1Name != '' && sub2Name == '' ? ' - ' + sub1Price : sub1Name != '' && sub2Name != '' ? ' - ' + sub2Price : '',
                                                                  style: TextStyle(
                                                                    height: 1.3,
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                    FontWeight.w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 2,
                                                            ),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                    mainQty.toString()+ ' '  + mainName + ' ',
                                                                    textScaleFactor: 1.0,
                                                                    style: TextStyle(
                                                                      height: 1.3,
                                                                      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                                                                    )),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 2.0),
                                                                  child: Icon( SmartKyat_POS.prodm, size: 17, color: Colors.grey,),
                                                                ),

                                                                sub1Name != '' && sub2Name == ''?
                                                                Text(
                                                                    '  +1 Sub item',
                                                                    textScaleFactor: 1.0,
                                                                    style: TextStyle(
                                                                      height: 1.3,
                                                                      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                                                                    )) : sub1Name != '' && sub2Name != '' ? Text(
                                                                    '  +2 Sub items',
                                                                    textScaleFactor: 1.0,
                                                                    style: TextStyle(
                                                                      height: 1.3,
                                                                      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey,
                                                                    )): Container(),

                                                                // StreamBuilder(
                                                                //     stream: FirebaseFirestore
                                                                //         .instance
                                                                //         .collection(
                                                                //         'space')
                                                                //         .doc(
                                                                //         '0NHIS0Jbn26wsgCzVBKT')
                                                                //         .collection(
                                                                //         'shops')
                                                                //         .doc(
                                                                //         'PucvhZDuUz3XlkTgzcjb')
                                                                //         .collection(
                                                                //         'products')
                                                                //         .doc(version)
                                                                //         .collection(
                                                                //         'versions')
                                                                //         .where('type',
                                                                //         isEqualTo:
                                                                //         'sub3')
                                                                //         .snapshots(),
                                                                //     builder: (BuildContext
                                                                //     context,
                                                                //         AsyncSnapshot<
                                                                //             QuerySnapshot>
                                                                //         snapshot5) {
                                                                //       if (snapshot5
                                                                //           .hasData) {
                                                                //         int quantity3 =
                                                                //         0;
                                                                //         var sub3Quantity;
                                                                //         snapshot5
                                                                //             .data!
                                                                //             .docs
                                                                //             .map((DocumentSnapshot
                                                                //         document) {
                                                                //           Map<String,
                                                                //               dynamic>
                                                                //           data4 =
                                                                //           document.data()! as Map<
                                                                //               String,
                                                                //               dynamic>;
                                                                //           if (data4[
                                                                //           'unit_qtity'] !=
                                                                //               '') {
                                                                //             quantity3 +=
                                                                //                 int.parse(
                                                                //                     data4['unit_qtity']);
                                                                //             sub3Quantity =
                                                                //                 quantity3
                                                                //                     .toString();
                                                                //           } else
                                                                //             return Container();
                                                                //         }).toList();
                                                                //         // print(sub1Quantity);
                                                                //         // print(mainQuantity);
                                                                //         if (sub3Quantity !=
                                                                //             null) {
                                                                //           return Text(
                                                                //               '$sub3Quantity $sub3Name');
                                                                //         }
                                                                //         return Container();
                                                                //       }
                                                                //       return Container();
                                                                //     }),
                                                              ],
                                                            ),

                                                            // Text(
                                                            //   'MMK',
                                                            //   style:
                                                            //       TextStyle(
                                                            //     fontSize: 14,
                                                            //     fontWeight: FontWeight.w400,
                                                            //     color: Colors.blueGrey.withOpacity(1.0),
                                                            //   ),
                                                            // ),
                                                            // SizedBox(
                                                            //   height:
                                                            //       7,
                                                            // ),
                                                            // Text(
                                                            //   '55',
                                                            //   style:
                                                            //       TextStyle(
                                                            //     fontSize: 14,
                                                            //     fontWeight: FontWeight.w400,
                                                            //     color: Colors.blueGrey.withOpacity(1.0),
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                        // Padding(
                                                        //   padding:
                                                        //       const EdgeInsets.only(
                                                        //           bottom: 20.0),
                                                        //   child: IconButton(
                                                        //     icon: Icon(
                                                        //       Icons
                                                        //           .arrow_forward_ios_rounded,
                                                        //       size: 16,
                                                        //       color: Colors.blueGrey
                                                        //           .withOpacity(0.8),
                                                        //     ),
                                                        //     onPressed: () {
                                                        //       Navigator.push(
                                                        //         context,
                                                        //         MaterialPageRoute(
                                                        //             builder: (context) => ProductDetailsView(
                                                        //                 idString: version, toggleCoinCallback:
                                                        //             addProduct1, toggleCoinCallback3: addProduct3)),);
                                                        //     },
                                                        //   ),
                                                        // ),
                                                        Spacer(),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              bottom: 6.0),
                                                          child: Icon(
                                                            Icons
                                                                .arrow_forward_ios_rounded,
                                                            size: 16,
                                                            color: Colors.blueGrey
                                                                .withOpacity(0.8),
                                                          ),),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      // Builds 1000 ListTiles
                                      childCount: snapshot.data!.docs.length,
                                    ),
                                  ),
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
                                            height: 1.3,
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

  addNewProd2(priContext) {
    final List<String> prodFieldsValue = [];
    final _formKey = GlobalKey<FormState>();
    // myController.clear();
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleAssetPage(toggleCoinCallback: closeNewProduct);
        });
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
  //                 SizedBox(
  //                   height: 15,
  //                 ),
  //                 Container(
  //                   height: 85,
  //                   decoration: BoxDecoration(
  //                       border: Border(
  //                           bottom: BorderSide(
  //                               color:
  //                               AppTheme.skBorderColor,
  //                               width: 2.0))),
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(
  //                         left: 15.0, right: 15.0, top: 20.0),
  //                     child: Row(
  //                       mainAxisAlignment:
  //                       MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Container(
  //                           width: 35,
  //                           height: 35,
  //                           decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.all(
  //                                 Radius.circular(5.0),
  //                               ),
  //                               color:
  //                               Colors.grey.withOpacity(0.3)),
  //                           child: IconButton(
  //                             icon: Icon(
  //                               Icons.close,
  //                               size: 20,
  //                               color: Colors.black,
  //                             ),
  //                             onPressed: () {
  //                               if (_formKey.currentState!.validate() || !_formKey.currentState!.validate()) {
  //
  //                                 if(prodFieldsValue.length>0) {
  //                                   showOkCancelAlertDialog(
  //                                     context: context,
  //                                     title: 'Are you sure?',
  //                                     message: 'You added data in some inputs.',
  //                                     defaultType: OkCancelAlertDefaultType.cancel,
  //                                   ).then((result) {
  //                                     if(result == OkCancelResult.ok) {
  //                                       Navigator.pop(context);
  //                                     }
  //                                   });
  //
  //                                 } else {
  //                                   Navigator.pop(context);
  //                                 }
  //                               }
  //
  //
  //                             },
  //                           ),
  //                         ),
  //                         Text(
  //                           "Add new product",
  //                           style: TextStyle(
  //                               color: Colors.black,
  //                               fontSize: 17,
  //                               fontFamily: 'capsulesans',
  //                               fontWeight: FontWeight.w600),
  //                           textAlign: TextAlign.left,
  //                         ),
  //                         Container(
  //                           width: 35,
  //                           height: 35,
  //                           decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.all(
  //                                 Radius.circular(5.0),
  //                               ),
  //                               color: AppTheme.skThemeColor2),
  //                           child: IconButton(
  //                             icon: Icon(
  //                               Icons.check,
  //                               size: 20,
  //                               color: Colors.white,
  //                             ),
  //                             onPressed: () {
  //                               List<AssetEntity> assets = <AssetEntity>[];
  //                               MultiAssetsPageState().pageMultiGlo();
  //                               // print(assets.length.toString());
  //
  //
  //                               // if (_formKey.currentState!.validate()) {
  //                               //   // If the form is valid, display a snackbar. In the real world,
  //                               //   // you'd often call a server or save the information in a database.
  //                               //   ScaffoldMessenger.of(context).showSnackBar(
  //                               //     const SnackBar(content: Text('Processing Data')),
  //                               //   );
  //                               //   // print(prodFieldsValue);
  //                               //
  //                               //   CollectionReference spaces = FirebaseFirestore.instance.collection('space');
  //                               //   var prodExist = false;
  //                               //   var spaceDocId = '';
  //                               //   FirebaseFirestore.instance
  //                               //       .collection('space')
  //                               //       .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //                               //       .get()
  //                               //       .then((QuerySnapshot querySnapshot) {
  //                               //     querySnapshot.docs.forEach((doc) {
  //                               //       spaceDocId = doc.id;
  //                               //     });
  //                               //
  //                               //     print('space shi p thar');
  //                               //     getStoreId().then((String result2) {
  //                               //       print('store id ' + result2.toString());
  //                               //
  //                               //       FirebaseFirestore.instance
  //                               //           .collection('space').doc(spaceDocId).collection('shops').doc(result2).collection('products')
  //                               //           .where('prod_name', isEqualTo: prodFieldsValue[0])
  //                               //           .get()
  //                               //           .then((QuerySnapshot querySnapshot) async {
  //                               //         querySnapshot.docs.forEach((doc) {
  //                               //           prodExist = true;
  //                               //         });
  //                               //
  //                               //         if(prodExist) {
  //                               //           print('product already');
  //                               //           var result = await showOkAlertDialog(
  //                               //               context: context,
  //                               //               title: 'Warning',
  //                               //               message: 'Product name already!',
  //                               //               okLabel: 'OK',
  //                               //           );
  //                               //
  //                               //         } else {
  //                               //           CollectionReference shops = FirebaseFirestore.instance.collection('space').doc(spaceDocId).collection('shops').doc(result2).collection('products');
  //                               //           return shops
  //                               //               .add({
  //                               //             'prod_name': prodFieldsValue[0]
  //                               //           })
  //                               //               .then((value) {
  //                               //             print('product added');
  //                               //
  //                               //             Navigator.pop(context);
  //                               //           });
  //                               //         }
  //                               //       });
  //                               //     });
  //                               //   });
  //                               // }
  //
  //                             },
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Container(
  //                     child: ListView(
  //                       children: [
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
  //
  //
  //                                 // Row(
  //                                 //   mainAxisAlignment: MainAxisAlignment.start,
  //                                 //   children: [
  //                                 //     Container(
  //                                 //       padding: EdgeInsets.only(left: 15),
  //                                 //       height: 130,
  //                                 //       width: 150,
  //                                 //       child: Image.network(
  //                                 //         'http://www.hmofficesolutions.com/media/4252/royal-d.jpg',
  //                                 //         fit: BoxFit.fill,
  //                                 //       ),
  //                                 //     ),
  //                                 //     SizedBox(
  //                                 //       width: 20,
  //                                 //     ),
  //                                 //     Container(
  //                                 //       width: 200,
  //                                 //       child: Expanded(
  //                                 //           child: Text(
  //                                 //             "Add images to show customers product details and features",
  //                                 //             style: TextStyle(
  //                                 //               color: Colors.amberAccent,
  //                                 //               fontSize: 15,
  //                                 //               fontWeight: FontWeight.w500,
  //                                 //             ),
  //                                 //           )),
  //                                 //     ),
  //                                 //   ],
  //                                 // ),
  //
  //
  //                                 Container(
  //                                   alignment: Alignment.topLeft,
  //                                   padding: EdgeInsets.only(top: 20, left: 15),
  //                                   child: Text(
  //                                     "PRODUCT INFORMATION",
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
  //                                 Container(
  //                                   height: 200,
  //                                   // child: MultiAssetsPage(toggleCoinCallback: closeNewProduct)
  //                                   // child: MultiAssetsPage(),
  //                                   child: SingleAssetPage(toggleCoinCallback: closeNewProduct),
  //                                 ),
  //                                 // Container(height: 500,
  //                                 // child: MultiAssetsPage(),),
  //
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(left: 15.0, right: 15.0),
  //                                   child: TextFormField(
  //                                     // The validator receives the text that the user has entered.
  //                                     validator: (value) {
  //                                       if (value == null ||
  //                                           value.isEmpty) {
  //                                         return 'This field is required';
  //                                       }
  //                                       prodFieldsValue.add(value);
  //                                       return null;
  //                                     },
  //                                     decoration: InputDecoration(
  //                                       enabledBorder: const OutlineInputBorder(
  //                                         // width: 0.0 produces a thin "hairline" border
  //                                         borderSide: const BorderSide(color: AppTheme.skBorderColor, width: 2.0),
  //                                         borderRadius: BorderRadius.all(Radius.circular(10.0))
  //                                       ),
  //
  //                                       focusedBorder: const OutlineInputBorder(
  //                                         // width: 0.0 produces a thin "hairline" border
  //                                           borderSide: const BorderSide(color: AppTheme.skThemeColor2, width: 2.0),
  //                                           borderRadius: BorderRadius.all(Radius.circular(10.0))
  //                                       ),
  //                                       contentPadding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
  //                                       suffixText: 'Required',
  //                                       suffixStyle: TextStyle(
  //                                         color: Colors.grey,
  //                                         fontSize: 12,
  //                                         fontFamily: 'capsulesans',),
  //                                       labelStyle: TextStyle(
  //                                         fontWeight: FontWeight.w500,
  //                                         color: Colors.black,
  //                                       ),
  //                                       // errorText: 'Error message',
  //                                       labelText: 'Product name',
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
  //                                   height: 10,
  //                                 ),
  //                                 Container(
  //                                   alignment: Alignment.topLeft,
  //                                   padding: EdgeInsets.only(top: 20, left: 15),
  //                                   child: Text(
  //                                     "PRODUCT PRICING",
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
  //                                   padding: const EdgeInsets.only(left: 15.0, right: 15.0),
  //                                   child: TextFormField(
  //                                     // The validator receives the text that the user has entered.
  //                                     validator: (value) {
  //                                       if (value == null ||
  //                                           value.isEmpty) {
  //                                         return 'This field is required';
  //                                       }
  //                                       prodFieldsValue.add(value);
  //                                       return null;
  //                                     },
  //                                     decoration: InputDecoration(
  //                                       contentPadding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 20.0),
  //                                       suffixText: 'Required',
  //                                       suffixStyle: TextStyle(
  //                                         color: Colors.grey,
  //                                         fontSize: 12,
  //                                         fontFamily: 'capsulesans',),
  //                                       labelStyle: TextStyle(
  //                                         fontWeight: FontWeight.w500,
  //                                         color: Colors.black,
  //                                       ),
  //                                       // errorText: 'Error message',
  //                                       labelText: 'Sale price',
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
  //                                   padding: const EdgeInsets.only(left: 15.0, right: 15.0),
  //                                   child: TextFormField(
  //                                     // The validator receives the text that the user has entered.
  //                                     validator: (value) {
  //                                       if (value == null ||
  //                                           value.isEmpty) {
  //                                         return 'This field is required';
  //                                       }
  //                                       prodFieldsValue.add(value);
  //                                       return null;
  //                                     },
  //                                     decoration: InputDecoration(
  //                                       contentPadding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 20.0),
  //                                       suffixText: 'Required',
  //                                       suffixStyle: TextStyle(
  //                                         color: Colors.grey,
  //                                         fontSize: 12,
  //                                         fontFamily: 'capsulesans',),
  //                                       labelStyle: TextStyle(
  //                                         fontWeight: FontWeight.w500,
  //                                         color: Colors.black,
  //                                       ),
  //                                       // errorText: 'Error message',
  //                                       labelText: 'Cost',
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

  Future<String> getStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));

    var index = prefs.getString('store');
    if (index == null) {
      return 'idk';
    } else {
      return index;
    }
  }
}

class SubUnit extends StatefulWidget {
  @override
  State<SubUnit> createState() => _SubUnitState();
}

class _SubUnitState extends State<SubUnit> {
  final List<String> prodFieldsValue = [];

  var nameTECs = <TextEditingController>[];

  var ageTECs = <TextEditingController>[];

  var jobTECs = <TextEditingController>[];

  var cards = <Padding>[];

  Padding createCard() {
    var nameController = TextEditingController();
    var ageController = TextEditingController();
    var jobController = TextEditingController();
    nameTECs.add(nameController);
    ageTECs.add(ageController);
    jobTECs.add(jobController);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  "#${cards.length + 1} SUB UNIT QUANTITY",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 2,
                    color: Colors.grey,
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(top: 15),
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      cards.length--;
                      cards.remove(cards);
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                width: (MediaQuery.of(context).size.width - 30) / 1.74,
                child: TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    prodFieldsValue.add(value);
                    return null;
                  },
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
                    contentPadding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                    suffixText: 'Required',
                    suffixStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'capsulesans',
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    // errorText: 'Error message',
                    labelText: 'Units / main unit',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: (MediaQuery.of(context).size.width - 30) / 2.9,
                child: TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    prodFieldsValue.add(value);
                    return null;
                  },
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
                    contentPadding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                    suffixText: 'Required',
                    suffixStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'capsulesans',
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    // errorText: 'Error message',
                    labelText: 'Unit name',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    //filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              prodFieldsValue.add(value);
              return null;
            },
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
              contentPadding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
              suffixText: 'MMK',
              suffixStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 12,
                //fontFamily: 'capsulesans',
              ),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              // errorText: 'Error message',
              labelText: 'Sale price',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              //filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: ButtonTheme(
            splashColor: AppTheme.buttonColor2,
            minWidth: MediaQuery.of(context).size.width,
            height: 61,
            child: RaisedButton(
              color: AppTheme.buttonColor2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                  side: BorderSide(
                    color: AppTheme.buttonColor2,
                  )),
              onPressed: () {
                if (cards.length == 3) {
                  print('Cards limit reached');
                } else
                  setState(() => cards.add(createCard()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New sub unit?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.add_box_rounded),
                ],
              ),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int index) {
            return cards[index];
          },
        ),
      ],
    );
  }
}
