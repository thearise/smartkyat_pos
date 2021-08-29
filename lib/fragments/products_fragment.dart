import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:smartkyat_pos/pages/home_page.dart';
import 'package:smartkyat_pos/pages2/multi_assets_page.dart';
import 'package:smartkyat_pos/pages2/single_assets_page.dart';
import 'package:smartkyat_pos/widgets/add_new_category_button.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
import 'package:smartkyat_pos/widgets/version_detatils_view.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:smartkyat_pos/widgets/product_details_view.dart';
import 'package:smartkyat_pos/widgets/product_versions_view.dart';

import '../app_theme.dart';
import 'subs/product_info.dart';

class ProductsFragment extends StatefulWidget {
  final _callback;
  final _callback2;

  ProductsFragment( {required void toggleCoinCallback(), required void toggleCoinCallback2(String str)} ) :
        _callback = toggleCoinCallback, _callback2 = toggleCoinCallback2;
  @override
  ProductsFragmentState createState() => ProductsFragmentState();
}

class ProductsFragmentState extends State<ProductsFragment> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ProductsFragment>{
  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  closeNewProduct() {
    Navigator.pop(context);
  }

  addProduct1(data) {
    widget._callback2(data);
  }

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
                    height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom-100,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0, left: 15.0, right: 15.0),
                      // child: ListView(
                      //   children: [
                      //     CustomerInfo('Phyo Pyae Sohn', 'Monywa', '(+959)794335708'),
                      //     CustomerInfo('Shwe Pyi Soe', 'Magway', '(+959)589764241'),
                      //     CustomerInfo('Sabai', 'Monywa', '(+959)766376767'),
                      //     CustomerInfo('Kabyar', 'Monywa', '(+959)751133553'),
                      //   ],
                      // )


                      child: ListView(
                        children: [
                          GestureDetector(
                            onTap: () {
                              widget._callback2('data');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Text('Products',
                                  style: TextStyle(fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: ButtonTheme(
                              splashColor: Colors.transparent,
                              minWidth: MediaQuery.of(context).size.width,
                              height: 55,
                              child: FlatButton(
                                color: AppTheme.skThemeColor2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                    color: AppTheme.skThemeColor2,
                                  ),
                                ),
                                onPressed: () {
                                  widget._callback();
                                },
                                child: Text(
                                  'Add new product',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('space')
                                  .doc('0NHIS0Jbn26wsgCzVBKT')
                                  .collection('shops')
                                  .doc('PucvhZDuUz3XlkTgzcjb')
                                  .collection('products')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  return ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                      Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                      // index++;
                                      // print(index.toString() + 'index');
                                      // return ListTile(
                                      //   title: Text(data['prod_name']),
                                      // );
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 16.0),
                                        child: GestureDetector(
                                          onTap: (){
                                            // print(id.toString());
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.grey.withOpacity(0.3), width: 1.0))),
                                            child: Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    ClipRRect(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        child: data['img_1'] != "" ? CachedNetworkImage(
                                                          imageUrl: 'https://hninsunyein.me/smartkyat_pos/api/uploads/' + data['img_1'],
                                                          width: 70,
                                                          height: 70,
                                                          // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                                          fadeInDuration: Duration(milliseconds: 100),
                                                          fadeOutDuration: Duration(milliseconds: 10),
                                                          fadeInCurve: Curves.bounceIn,
                                                          fit: BoxFit.cover,
                                                        ) : CachedNetworkImage(
                                                          imageUrl: 'https://fdn.gsmarena.com/imgroot/news/21/04/oneplus-watch-update/-1200/gsmarena_002.jpg',
                                                          width: 70,
                                                          height: 70,
                                                          // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
                                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                                          fadeInDuration: Duration(milliseconds: 100),
                                                          fadeOutDuration: Duration(milliseconds: 10),
                                                          fadeInCurve: Curves.bounceIn,
                                                          fit: BoxFit.cover,
                                                        )
                                                    ),
                                                    SizedBox(height: 12),
                                                  ],
                                                ),
                                                SizedBox(width: 20,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'customerName',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 7,
                                                    ),
                                                    Text(
                                                      'MMK customerAddress',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: Colors.blueGrey.withOpacity(1.0),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 7,
                                                    ),
                                                    Text(
                                                      'customerPhone in stock',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: Colors.blueGrey.withOpacity(1.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 20.0),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.arrow_forward_ios_rounded,
                                                      size: 16,
                                                      color: Colors.blueGrey.withOpacity(0.8),
                                                    ), onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductVersionView(idString: document.id, toggleCoinCallback: addProduct1)),
                                                    );
                                                  },
                                                  ),
                                                ),
                                                Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 20.0),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.arrow_forward_ios_rounded,
                                                      size: 16,
                                                      color: Colors.blueGrey.withOpacity(0.8),
                                                    ), onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetailsView()),
                                                    );
                                                  },
                                                  ),
                                                ),
                                              ],

                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                                return Container();
                              }
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: AppTheme.skBorderColor2, width: 1.0),
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0, bottom: 15),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10.0),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:15.0,),
                              child: Icon(Icons.search, size: 26,),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left:8.0, right: 8.0),
                                child: Container(child:
                                Text(
                                  'Search',
                                  style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.6)
                                  ),
                                )
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // addDailyExp(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right:15.0,),
                                child: Icon(Icons.bar_chart, color: Colors.green, size: 22,),
                              ),
                            )
                          ],
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
    if(index == null) {
      return 'idk';
    } else {
      return index;
    }
  }
}

// class CustomerInfo extends StatelessWidget {
//   final String customerName;
//   final String customerAddress;
//   final String customerPhone;
//   final String image;
//   final String id;
//   CustomerInfo(this.customerName, this.customerAddress, this.customerPhone, this.image,this.id);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16.0),
//       child: GestureDetector(
//         onTap: (){
//           print(id.toString());
//         },
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//               border: Border(
//                   bottom: BorderSide(
//                       color: Colors.grey.withOpacity(0.3), width: 1.0))),
//           child: Row(
//             children: [
//               Column(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8.0),
//                       child: image != "" ? CachedNetworkImage(
//                         imageUrl: 'https://hninsunyein.me/smartkyat_pos/api/uploads/$image',
//                         width: 70,
//                         height: 70,
//                         // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
//                         errorWidget: (context, url, error) => Icon(Icons.error),
//                         fadeInDuration: Duration(milliseconds: 100),
//                         fadeOutDuration: Duration(milliseconds: 10),
//                         fadeInCurve: Curves.bounceIn,
//                         fit: BoxFit.cover,
//                       ) : CachedNetworkImage(
//                         imageUrl: 'https://fdn.gsmarena.com/imgroot/news/21/04/oneplus-watch-update/-1200/gsmarena_002.jpg',
//                         width: 70,
//                         height: 70,
//                         // placeholder: (context, url) => Image(image: AssetImage('assets/images/system/black-square.png')),
//                         errorWidget: (context, url, error) => Icon(Icons.error),
//                         fadeInDuration: Duration(milliseconds: 100),
//                         fadeOutDuration: Duration(milliseconds: 10),
//                         fadeInCurve: Curves.bounceIn,
//                         fit: BoxFit.cover,
//                       )
//                   ),
//                   SizedBox(height: 12),
//                 ],
//               ),
//               SizedBox(width: 20,),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     customerName,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 7,
//                   ),
//                   Text(
//                     'MMK $customerAddress',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.blueGrey.withOpacity(1.0),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 7,
//                   ),
//                   Text(
//                     '$customerPhone in stock',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.blueGrey.withOpacity(1.0),
//                     ),
//                     ),
//                   ],
//                 ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 20.0),
//                 child: IconButton(
//                   icon: Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     size: 16,
//                     color: Colors.blueGrey.withOpacity(0.8),
//                   ), onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             ProductVersionView(idString: id, toggleCoinCallback: addProduct1)),
//                   );
//                 },
//                 ),
//               ),
//                 Spacer(),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 20.0),
//                 child: IconButton(
//                   icon: Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     size: 16,
//                     color: Colors.blueGrey.withOpacity(0.8),
//                   ), onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             ProductDetailsView()),
//                   );
//                 },
//                 ),
//               ),
//               ],
//
//             ),
//           ),
//       ),
//       );
//   }
// }

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
                  icon: Icon(Icons.close,
                    size: 20,
                    color: Colors.blue,),
                  onPressed: (){
                    setState(() {
                      cards.length--;
                      cards.remove(cards);});
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
                width: (MediaQuery.of(context).size.width-30)/1.74,
                child: TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'This field is required';
                    }
                    prodFieldsValue.add(value);
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                        borderSide: const BorderSide(color: AppTheme.skBorderColor, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),

                    focusedBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                        borderSide: const BorderSide(color: AppTheme.skThemeColor2, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    contentPadding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                    suffixText: 'Required',
                    suffixStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'capsulesans',),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    // errorText: 'Error message',
                    labelText: 'Units / main unit',
                    floatingLabelBehavior:
                    FloatingLabelBehavior.auto,
                    //filled: true,
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: (MediaQuery.of(context).size.width-30)/2.9,
                child: TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'This field is required';
                    }
                    prodFieldsValue.add(value);
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                        borderSide: const BorderSide(color: AppTheme.skBorderColor, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),

                    focusedBorder: const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                        borderSide: const BorderSide(color: AppTheme.skThemeColor2, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    contentPadding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
                    suffixText: 'Required',
                    suffixStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'capsulesans',),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    // errorText: 'Error message',
                    labelText: 'Unit name',
                    floatingLabelBehavior:
                    FloatingLabelBehavior.auto,
                    //filled: true,
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10),
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
              if (value == null ||
                  value.isEmpty) {
                return 'This field is required';
              }
              prodFieldsValue.add(value);
              return null;
            },
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(color: AppTheme.skBorderColor, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),

              focusedBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(color: AppTheme.skThemeColor2, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
              ),
              contentPadding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 18.0, bottom: 18.0),
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
              floatingLabelBehavior:
              FloatingLabelBehavior.auto,
              //filled: true,
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(10),
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