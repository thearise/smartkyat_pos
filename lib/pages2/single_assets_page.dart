///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020-05-31 21:17
///
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ai_awesome_message/ai_awesome_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/widgets/barcode_scanner.dart';
import 'package:smartkyat_pos/widgets2/method_list_view.dart';
import 'package:smartkyat_pos/widgets2/selected_assets_list_view.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'package:async/async.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show AssetEntity;

import '../app_theme.dart';
import '../constants/page_mixin.dart';
import '../constants/picker_method.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SingleAssetPage extends StatefulWidget {
  final _callback;

  SingleAssetPage({required void toggleCoinCallback()})
      : _callback = toggleCoinCallback;
  @override
  _SingleAssetPageState createState() => _SingleAssetPageState();
}

class _SingleAssetPageState extends State<SingleAssetPage> {
  final ValueNotifier<bool> isDisplayingDetail = ValueNotifier<bool>(true);
  List<AssetEntity> assets = <AssetEntity>[];

  var nameTECs = <TextEditingController>[];
  var ageTECs = <TextEditingController>[];
  var jobTECs = <TextEditingController>[];
  var priceTECs = <TextEditingController>[];
  var cards = <Padding>[];
  static List<String> prodFieldsValue = [];
  final _formKey = GlobalKey<FormState>();

  final pnameCtrl = TextEditingController();
  final bcodeCtrl = TextEditingController();
  final munitCtrl = TextEditingController();
  final mnameCtrl = TextEditingController();
  final msaleCtrl = TextEditingController();
  final mcostCtrl = TextEditingController();

  bool prodAdding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            top: true,
            bottom: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
// mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 85,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppTheme.skBorderColor, width: 2.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              color: Colors.grey.withOpacity(0.3)),
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              if (pnameCtrl.text.length > 0 ||
                                  mcostCtrl.text.length > 0 ||
                                  msaleCtrl.text.length > 0 ||
                                  munitCtrl.text.length > 0 ||
                                  mnameCtrl.text.length > 0 ||
                                  bcodeCtrl.text.length > 0) {
                                showOkCancelAlertDialog(
                                  context: context,
                                  title: 'Are you sure?',
                                  message: 'You added data in some inputs.',
                                  defaultType: OkCancelAlertDefaultType.cancel,
                                ).then((result) {
                                  if (result == OkCancelResult.ok) {
                                    Navigator.pop(context);
                                  }
                                });
                              } else {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                        Text(
                          "Add new product",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontFamily: 'capsulesans',
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              color: AppTheme.skThemeColor2),
                          child: IconButton(
                            icon: Icon(
                              Icons.check,
                              size: 20,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              prodFieldsValue = [];

// List<AssetEntity> assets = <AssetEntity>[];
// MultiAssetsPageState().pageMultiGlo();
// print(assets.length.toString());

                              if (_formKey.currentState!.validate()) {
                                DateTime now = DateTime.now();
                                setState(() {
                                  prodAdding = true;
                                });
                                print('validate ' + prodFieldsValue.toString());

                                List<PersonEntry> entries = [];

                                print('shit ' + entries.toString());

                                print('here ' + assets.length.toString());
                                photoUploadCount = 0;
                                var photoArray = ['', '', '', '', ''];

                                var prodExist = false;
                                var spaceDocId = '';

                                FirebaseFirestore.instance
                                    .collection('space')
                                    .where('user_id',
                                        isEqualTo: 'aHHin46ulpdoxOGh6kav8EDE4xn2')
                                    .get()
                                    .then((QuerySnapshot querySnapshot) {
                                  querySnapshot.docs.forEach((doc) {
                                    spaceDocId = doc.id;
                                  });

                                  print('space shi p thar');
                                  getStoreId().then((String result2) {
                                    print('store id ' + result2.toString());

                                    FirebaseFirestore.instance
                                        .collection('space')
                                        .doc('0NHIS0Jbn26wsgCzVBKT')
                                        .collection('shops')
                                        .doc('PucvhZDuUz3XlkTgzcjb')
                                        .collection('products')
                                        .where('prod_name',
                                            isEqualTo: prodFieldsValue[0])
                                        .get()
                                        .then((QuerySnapshot
                                            querySnapshot) async {
                                      querySnapshot.docs.forEach((doc) {
                                        prodExist = true;
                                      });

                                      if (prodExist) {
                                        print('product already');
                                        var result = await showOkAlertDialog(
                                          context: context,
                                          title: 'Warning',
                                          message: 'Product name already!',
                                          okLabel: 'OK',
                                        );
                                        setState(() {
                                          prodAdding = false;
                                        });
                                      } else {
                                        for (int i = 0;
                                            i < assets.length;
                                            i++) {
                                          AssetEntity asset =
                                              assets.elementAt(i);
                                          asset.originFile.then((value) async {
                                            addProduct(value!).then((value) {
                                              photoArray[i] = value.toString();
                                              photoUploaded(
                                                  assets.length, photoArray);
                                            });
                                          });
                                        }

                                        if (assets.length == 0) {
                                          var subUnitFieldValue = [
                                            '',
                                            '',
                                            '',
                                            '',
                                            '',
                                            '',
                                            '',
                                            '',
                                            '',
                                            '',
                                            '',
                                            '',
                                          ];
                                          int j = -1;
                                          for (int i = 0;
                                              i < cards.length;
                                              i++) {
                                            subUnitFieldValue[++j] =
                                                nameTECs[i].text;
                                            subUnitFieldValue[++j] =
                                                ageTECs[i].text;
                                            subUnitFieldValue[++j] =
                                                jobTECs[i].text;
                                            subUnitFieldValue[++j] =
                                                priceTECs[i].text;
                                            // var name = nameTECs[i].text;
                                            // var age = ageTECs[i].text;
                                            // var job = jobTECs[i].text;
                                            // entries.add(PersonEntry(name, age, job));
                                          }
                                          print('gg nothing' +
                                              subUnitFieldValue.toString());

                                          CollectionReference spaces =
                                              FirebaseFirestore.instance
                                                  .collection('space');
                                          var prodExist = false;
                                          var spaceDocId = '';
                                          FirebaseFirestore.instance
                                              .collection('space')
                                              .where('user_id',
                                                  isEqualTo: 'aHHin46ulpdoxOGh6kav8EDE4xn2')
                                              .get()
                                              .then((QuerySnapshot
                                                  querySnapshot) {
                                            querySnapshot.docs.forEach((doc) {
                                              spaceDocId = doc.id;
                                            });

                                            print('space shi p thar');
                                            getStoreId().then((String result2) {
                                              print('store id ' +
                                                  result2.toString());

                                              FirebaseFirestore.instance
                                                  .collection('space')
                                                  .doc('0NHIS0Jbn26wsgCzVBKT')
                                                  .collection('shops')
                                                  .doc('PucvhZDuUz3XlkTgzcjb')
                                                  .collection('products')
                                                  .where('prod_name',
                                                      isEqualTo:
                                                          prodFieldsValue[0])
                                                  .get()
                                                  .then((QuerySnapshot
                                                      querySnapshot) async {
                                                querySnapshot.docs
                                                    .forEach((doc) {
                                                  prodExist = true;
                                                });

                                                if (prodExist) {
                                                  print('product already');
                                                  var result =
                                                      await showOkAlertDialog(
                                                    context: context,
                                                    title: 'Warning',
                                                    message:
                                                        'Product name already!',
                                                    okLabel: 'OK',
                                                  );
                                                } else {
                                                  CollectionReference shops =
                                                      FirebaseFirestore.instance
                                                          .collection('space')
                                                          .doc(
                                                              '0NHIS0Jbn26wsgCzVBKT')
                                                          .collection('shops')
                                                          .doc(
                                                              'PucvhZDuUz3XlkTgzcjb')
                                                          .collection(
                                                              'products');
                                                  return shops.add({
                                                    'prod_name':
                                                        prodFieldsValue[0],
                                                    'bar_code':
                                                        prodFieldsValue[1],
                                                    'unit_name':
                                                        prodFieldsValue[3],
                                                    'main_sprice':
                                                        prodFieldsValue[5],
                                                    'sub1_unit':
                                                    subUnitFieldValue[0],
                                                    'sub1_name':
                                                        subUnitFieldValue[1],
                                                    'sub1_sprice':
                                                        subUnitFieldValue[2],
                                                    'sub2_unit':
                                                    subUnitFieldValue[4],
                                                    'sub2_name':
                                                        subUnitFieldValue[5],
                                                    'sub2_sprice':
                                                        subUnitFieldValue[6],
                                                    'sub3_unit':
                                                    subUnitFieldValue[8],
                                                    'sub3_name':
                                                        subUnitFieldValue[9],
                                                    'sub3_sprice':
                                                        subUnitFieldValue[10],

                                                    // 'unit_qtity': prodFieldsValue[2],
                                                    // 'unit_name': prodFieldsValue[3],
                                                    // 'buy_price': prodFieldsValue[4],
                                                    // 'sale_price': prodFieldsValue[5],
                                                    // 'sub1_unit': subUnitFieldValue[0],
                                                    // 'sub1_name': subUnitFieldValue[1],
                                                    // 'sub1_sale': subUnitFieldValue[2],
                                                    // 'sub2_unit': subUnitFieldValue[3],
                                                    // 'sub2_name': subUnitFieldValue[4],
                                                    // 'sub2_sale': subUnitFieldValue[5],
                                                    // 'sub3_unit': subUnitFieldValue[6],
                                                    // 'sub3_name': subUnitFieldValue[7],
                                                    // 'sub3_sale': subUnitFieldValue[8],
                                                    'img_1': '',
                                                    'img_2': '',
                                                    'img_3': '',
                                                    'img_4': '',
                                                    'img_5': '',
                                                  }).then((value) {
                                                    print('product added');
                                                    // setState(() {
                                                    //   prodAdding = false;
                                                    // });
                                                    FirebaseFirestore.instance
                                                        .collection('space')
                                                        .doc(
                                                            '0NHIS0Jbn26wsgCzVBKT')
                                                        .collection('shops')
                                                        .doc(
                                                            'PucvhZDuUz3XlkTgzcjb')
                                                        .collection('products')
                                                        .doc(value.id)
                                                        .collection('versions')
                                                        .add({
                                                      'date': zeroToTen(now.day
                                                              .toString()) +
                                                          zeroToTen(now.month
                                                              .toString()) +
                                                          zeroToTen(now.year
                                                              .toString()),
                                                      'unit_qtity':
                                                          prodFieldsValue[2],
                                                      'buy_price':
                                                          prodFieldsValue[4],
                                                      'type': 'main',
                                                    }).then((value) {
                                                      print('product added 2');
                                                    });
                                                    print('sub1'+ prodFieldsValue[4]);
                                                    print('unit1'+ subUnitFieldValue[0]);
                                                    print('unit2'+ subUnitFieldValue[8]);
                                                    print('unit3'+ subUnitFieldValue[4]);
                                                    // var sub1Buy=double.parse(prodFieldsValue[4]) / double.parse(subUnitFieldValue[0]);
                                                    // var sub2Buy=double.parse(prodFieldsValue[4]) / double.parse(subUnitFieldValue[4]);
                                                    // var sub3Buy=double.parse(prodFieldsValue[4]) / double.parse(subUnitFieldValue[8]);



                                                    FirebaseFirestore.instance
                                                        .collection('space')
                                                        .doc(
                                                            '0NHIS0Jbn26wsgCzVBKT')
                                                        .collection('shops')
                                                        .doc(
                                                            'PucvhZDuUz3XlkTgzcjb')
                                                        .collection('products')
                                                        .doc(value.id)
                                                        .collection('versions')
                                                        .add({
                                                      'date': zeroToTen(now.day
                                                              .toString()) +
                                                          zeroToTen(now.month
                                                              .toString()) +
                                                          zeroToTen(now.year
                                                              .toString()),
                                                      // 'unit_qtity':
                                                      // prodFieldsValue[2] +
                                                      // ' 0',
                                                      // prodFieldsValue[4],
                                                      // 'sale_price':
                                                      // prodFieldsValue[5],
                                                      'unit_qtity':
                                                          subUnitFieldValue[3],
                                                      'buy_price': '0',
                                                      'type': 'sub1',
                                                    }).then((value) {
                                                      print('product added 3');

                                                    });

                                                    FirebaseFirestore.instance
                                                        .collection('space')
                                                        .doc('0NHIS0Jbn26wsgCzVBKT')
                                                        .collection('shops')
                                                        .doc('PucvhZDuUz3XlkTgzcjb')
                                                        .collection('products')
                                                        .doc(value.id)
                                                        .collection('versions')
                                                        .add({
                                                      'date': zeroToTen(now.day.toString()) + zeroToTen(now.month.toString()) + zeroToTen(now.year.toString()),
                                                      'unit_qtity': subUnitFieldValue[7],
                                                      'buy_price': '0',
                                                      'type': 'sub2',
                                                    }).then((value) {
                                                      print('product added 4');
                                                    });

                                                    FirebaseFirestore.instance.collection('space')
                                                        .doc('0NHIS0Jbn26wsgCzVBKT')
                                                        .collection('shops')
                                                        .doc('PucvhZDuUz3XlkTgzcjb')
                                                        .collection('products')
                                                        .doc(value.id)
                                                        .collection('versions')
                                                        .add({
                                                      'date': zeroToTen(now.day
                                                              .toString()) +
                                                          zeroToTen(now.month
                                                              .toString()) +
                                                          zeroToTen(now.year
                                                              .toString()),
                                                      'unit_qtity':
                                                          subUnitFieldValue[11],
                                                      'buy_price': '0',
                                                      'type': 'sub3',
                                                    }).then((value) {
                                                      print('product added 5');
                                                      setState(() {
                                                        prodAdding = false;
                                                      });

                                                      Navigator.pop(context);

                                                      showFlash(
                                                        context: context,
                                                        duration:
                                                            const Duration(
                                                                seconds: 2),
                                                        persistent: true,
                                                        builder:
                                                            (_, controller) {
                                                          return Flash(
                                                            controller:
                                                                controller,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            brightness:
                                                                Brightness
                                                                    .light,
                                                            // boxShadows: [BoxShadow(blurRadius: 4)],
                                                            // barrierBlur: 3.0,
                                                            // barrierColor: Colors.black38,
                                                            barrierDismissible:
                                                                true,
                                                            behavior:
                                                                FlashBehavior
                                                                    .floating,
                                                            position:
                                                                FlashPosition
                                                                    .top,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          80.0),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: 15.0,
                                                                    right:
                                                                        15.0),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  child:
                                                                      FlashBar(
                                                                    title: Text(
                                                                        'Title'),
                                                                    content: Text(
                                                                        'Hello world!'),
                                                                    // showProgressIndicator: true,
                                                                    primaryAction:
                                                                        TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              controller.dismiss(),
                                                                      child: Text(
                                                                          'DISMISS',
                                                                          style:
                                                                              TextStyle(color: Colors.amber)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    });

                                                    // FirebaseFirestore.instance.collection('space').doc(spaceDocId).collection('shops').doc(result2).collection('products').doc(value.id).collection('units')
                                                    // .add({
                                                    //   'prod_name': prodFieldsValue[0]
                                                    // }).then((value) {
                                                    //   print('product added 2');
                                                    // });

                                                    // Navigator.pop(context);
                                                  });
                                                }
                                              });
                                            });
                                          });
                                        }
                                      }
                                    });
                                  });
                                });
                              }

// print('here ' + nameController.text.toString());
// Navigator.pop(context, entries);

// if (_formKey.currentState!.validate()) {
//   // If the form is valid, display a snackbar. In the real world,
//   // you'd often call a server or save the information in a database.
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(content: Text('Processing Data')),
//   );
//   // print(prodFieldsValue);
//
//   CollectionReference spaces = FirebaseFirestore.instance.collection('space');
//   var prodExist = false;
//   var spaceDocId = '';
//   FirebaseFirestore.instance
//       .collection('space')
//       .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//       .get()
//       .then((QuerySnapshot querySnapshot) {
//     querySnapshot.docs.forEach((doc) {
//       spaceDocId = doc.id;
//     });
//
//     print('space shi p thar');
//     getStoreId().then((String result2) {
//       print('store id ' + result2.toString());
//
//       FirebaseFirestore.instance
//           .collection('space').doc(spaceDocId).collection('shops').doc(result2).collection('products')
//           .where('prod_name', isEqualTo: prodFieldsValue[0])
//           .get()
//           .then((QuerySnapshot querySnapshot) async {
//         querySnapshot.docs.forEach((doc) {
//           prodExist = true;
//         });
//
//         if(prodExist) {
//           print('product already');
//           var result = await showOkAlertDialog(
//               context: context,
//               title: 'Warning',
//               message: 'Product name already!',
//               okLabel: 'OK',
//           );
//
//         } else {
//           CollectionReference shops = FirebaseFirestore.instance.collection('space').doc(spaceDocId).collection('shops').doc(result2).collection('products');
//           return shops
//               .add({
//             'prod_name': prodFieldsValue[0]
//           })
//               .then((value) {
//             print('product added');
//
//             Navigator.pop(context);
//           });
//         }
//       });
//     });
//   });
// }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ListView(
                      children: [
                        Container(
// height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            color: Colors.white,
                          ),

                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
// Row(
//   mainAxisAlignment: MainAxisAlignment.start,
//   children: [
//     Container(
//       padding: EdgeInsets.only(left: 15),
//       height: 130,
//       width: 150,
//       child: Image.network(
//         'http://www.hmofficesolutions.com/media/4252/royal-d.jpg',
//         fit: BoxFit.fill,
//       ),
//     ),
//     SizedBox(
//       width: 20,
//     ),
//     Container(
//       width: 200,
//       child: Expanded(
//           child: Text(
//             "Add images to show customers product details and features",
//             style: TextStyle(
//               color: Colors.amberAccent,
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//             ),
//           )),
//     ),
//   ],
// ),

                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(top: 20, left: 15),
                                  child: Text(
                                    "PRODUCT INFORMATION",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      letterSpacing: 2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),

                                Container(
                                  height: assets.isNotEmpty ? 200 : 100,
                                  child: Column(
                                    children: [
                                      if (assets.isNotEmpty)
                                        GestureDetector(
                                          onTap: () {
                                            widget._callback();
                                            print('_waitUntilDone ' +
                                                assets.length.toString());
                                          },
                                          child: SelectedAssetsListView(
                                            assets: assets,
                                            isDisplayingDetail:
                                                isDisplayingDetail,
                                            onResult: onResult,
                                            onRemoveAsset: removeAsset,
                                          ),
                                        ),
                                      Expanded(
                                        child: MethodListView(
                                          pickMethods: [
                                            PickMethod.cameraAndStay(
                                              maxAssetsCount: 5,
                                            ),
                                          ],
                                          onSelectMethod: selectAssets,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: TextFormField(
// The validator receives the text that the user has entered.
                                    controller: pnameCtrl,
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
                                              color: AppTheme.skBorderColor,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),

                                      focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                          borderSide: const BorderSide(
                                              color: AppTheme.skThemeColor2,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      contentPadding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          top: 18.0,
                                          bottom: 18.0),
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
                                      labelText: 'Product name',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
//filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(top: 20, left: 15),
                                  child: Text(
                                    "OTHER INFORMATION",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      letterSpacing: 2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: TextFormField(
                                    controller: bcodeCtrl,
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
                                              color: AppTheme.skBorderColor,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),

                                      focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                          borderSide: const BorderSide(
                                              color: AppTheme.skThemeColor2,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      contentPadding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          top: 18.0,
                                          bottom: 18.0),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.bar_chart,
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                        onPressed: () async {
                                          print("Barcode");
                                          var code = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    QRViewExample()),
                                          );
                                          bcodeCtrl.text = code;
                                          print('bar bar ' + code);
                                        },
                                      ),
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
                                      labelText: 'Barcode',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
//filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.only(top: 20, left: 15),
                                  child: Text(
                                    "MAIN UNIT QUANTITY",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      letterSpacing: 2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    30) *
                                                (2.41 / 4),
                                        // child: TextField(
                                        //     controller: nameController,
                                        //     decoration: InputDecoration(labelText: 'Full Name')
                                        // ),
                                        child: TextFormField(
                                          controller: munitCtrl,
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
                                            enabledBorder:
                                                const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                    borderSide:
                                                        const BorderSide(
                                                            color: AppTheme
                                                                .skBorderColor,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),

                                            focusedBorder:
                                                const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                                    borderSide:
                                                        const BorderSide(
                                                            color: AppTheme
                                                                .skThemeColor2,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 15.0,
                                                    right: 15.0,
                                                    top: 18.0,
                                                    bottom: 18.0),
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
                                            labelText: 'Unit quantity',
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
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    30) *
                                                (1.41 / 4),
                                        child: TextFormField(
                                          controller: mnameCtrl,
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
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    // width: 0.0 produces a thin "hairline" border
                                                    borderSide:
                                                        const BorderSide(
                                                            color: AppTheme
                                                                .skBorderColor,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),

                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    // width: 0.0 produces a thin "hairline" border
                                                    borderSide:
                                                        const BorderSide(
                                                            color: AppTheme
                                                                .skThemeColor2,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 15.0,
                                                    right: 15.0,
                                                    top: 18.0,
                                                    bottom: 18.0),
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
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: TextFormField(
                                    controller: msaleCtrl,
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
                                              color: AppTheme.skBorderColor,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),

                                      focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                          borderSide: const BorderSide(
                                              color: AppTheme.skThemeColor2,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      contentPadding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          top: 18.0,
                                          bottom: 18.0),
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
                                      labelText: 'Buy price',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
//filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: TextFormField(
                                    controller: mcostCtrl,
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
                                              color: AppTheme.skBorderColor,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),

                                      focusedBorder: const OutlineInputBorder(
// width: 0.0 produces a thin "hairline" border
                                          borderSide: const BorderSide(
                                              color: AppTheme.skThemeColor2,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      contentPadding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          top: 18.0,
                                          bottom: 18.0),
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: ButtonTheme(
                                          splashColor: Colors.transparent,
                                          minWidth:
                                              MediaQuery.of(context).size.width,
                                          height: 54,
                                          child: FlatButton(
                                            color: AppTheme.secButtonColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            onPressed: (){
                                              if (cards.length == 3) {
                                                print('Cards limit reached');
                                              } else
                                                setState(() =>
                                                    cards.add(createCard()));
                                            },
                                            child: Text(
                                              'Add sub unit',
                                              style: TextStyle(
                                                fontSize: 16.5,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        )
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: cards.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return cards[index];
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          prodAdding
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey.withOpacity(0.5),
                  child: Center(
                      child: Theme(
                          data: ThemeData(
                              cupertinoOverrideTheme: CupertinoThemeData(
                                  brightness: Brightness.light)),
                          child: CupertinoActivityIndicator(
                            radius: 20,
                          ))),
                )
              : Container(),
        ],
      ),
    );
    return Column(
      children: <Widget>[
        if (assets.isNotEmpty)
          GestureDetector(
            onTap: () {
              widget._callback();

              // _waitUntilDone();
              print('_waitUntilDone ' + assets.length.toString());
            },
            child: SelectedAssetsListView(
              assets: assets,
              isDisplayingDetail: isDisplayingDetail,
              onResult: onResult,
              onRemoveAsset: removeAsset,
            ),
          ),
        Expanded(
          child: MethodListView(
            pickMethods: [
              PickMethod.cameraAndStay(
                maxAssetsCount: 5,
              ),
            ],
            onSelectMethod: selectAssets,
          ),
        ),
      ],
    );
  }

  int photoUploadCount = 0;

  zeroToTen(String string) {
    if (int.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
  }

  photoUploaded(length, photoArray) {
    print('upload ' + photoUploadCount.toString());
    photoUploadCount++;

    if (length == photoUploadCount) {
      print('all fking done' + photoArray.toString());

      var subUnitFieldValue = ['', '', '', '', '', '', '', '', '', '', '', ''];
      int j = -1;
      for (int i = 0; i < cards.length; i++) {
        subUnitFieldValue[++j] = nameTECs[i].text;
        subUnitFieldValue[++j] = ageTECs[i].text;
        subUnitFieldValue[++j] = jobTECs[i].text;
        subUnitFieldValue[++j] =
            priceTECs[i].text; // var name = nameTECs[i].text;
        // var age = ageTECs[i].text;
        // var job = jobTECs[i].text;
        // entries.add(PersonEntry(name, age, job));
      }
      print('gg nothing' + subUnitFieldValue.toString());
      setState(() {
        prodAdding = true;
      });

      CollectionReference spaces =
          FirebaseFirestore.instance.collection('space');
      var prodExist = false;
      var spaceDocId = '';
      FirebaseFirestore.instance
          .collection('space')
          .where('user_id', isEqualTo: 'aHHin46ulpdoxOGh6kav8EDE4xn2')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          spaceDocId = doc.id;
        });

        print('space shi p thar');
        getStoreId().then((String result2) {
          print('store id ' + result2.toString());

          FirebaseFirestore.instance
              .collection('space')
              .doc(spaceDocId)
              .collection('shops')
              .doc(result2)
              .collection('products')
              .where('prod_name', isEqualTo: prodFieldsValue[0])
              .get()
              .then((QuerySnapshot querySnapshot) async {
            querySnapshot.docs.forEach((doc) {
              prodExist = true;
            });

            if (prodExist) {
              print('product already');
              var result = await showOkAlertDialog(
                context: context,
                title: 'Warning',
                message: 'Product name already!',
                okLabel: 'OK',
              );
            } else {
              CollectionReference shops = FirebaseFirestore.instance
                  .collection('space')
                  .doc(spaceDocId)
                  .collection('shops')
                  .doc(result2)
                  .collection('products');
              return shops.add({
                'prod_name': prodFieldsValue[0],
                'bar_code': prodFieldsValue[1],
                'unit_qtity': prodFieldsValue[2],
                'unit_name': prodFieldsValue[3],
                'buy_price': prodFieldsValue[4],
                'sale_price': prodFieldsValue[5],
                'sub1_unit': subUnitFieldValue[0],
                'sub1_name': subUnitFieldValue[1],
                'sub1_sale': subUnitFieldValue[2],
                'sub2_unit': subUnitFieldValue[3],
                'sub2_name': subUnitFieldValue[4],
                'sub2_sale': subUnitFieldValue[5],
                'sub3_unit': subUnitFieldValue[6],
                'sub3_name': subUnitFieldValue[7],
                'sub3_sale': subUnitFieldValue[8],
                'sub1_qtity': subUnitFieldValue[9],
                'sub2_qtity': subUnitFieldValue[10],
                'sub3_qtity': subUnitFieldValue[11],
                'img_1': photoArray[0],
                'img_2': photoArray[1],
                'img_3': photoArray[2],
                'img_4': photoArray[3],
                'img_5': photoArray[4],
              }).then((value) {
                print('product added');
                setState(() {
                  prodAdding = false;
                });

                Navigator.pop(context);

                // FirebaseFirestore.instance.collection('space').doc(spaceDocId).collection('shops').doc(result2).collection('products').doc(value.id).collection('units')
                // .add({
                //   'prod_name': prodFieldsValue[0]
                // }).then((value) {
                //   print('product added 2');
                // });

                // Navigator.pop(context);
              });
            }
          });
        });
      });

      // prodFieldsValue = [];
    }
  }

  Future addProduct(File imageFile) async {
// ignore: deprecated_member_use
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri =
        Uri.parse("https://hninsunyein.me/smartkyat_pos/api/images_upload.php");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: Path.basename(imageFile.path));

    request.files.add(multipartFile);
    // request.fields['productname'] = controllerName.text;
    // request.fields['productprice'] = controllerPrice.text;
    // request.fields['producttype'] = controllerType.text;
    // request.fields['product_owner'] = globals.restaurantId;

    var respond = await request.send();
    final respStr = await respond.stream.bytesToString();
    if (respond.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
    print('her ' + respStr.toString());
    return respStr.toString();
  }

  Padding createCard() {
    var nameController = TextEditingController();
    var ageController = TextEditingController();
    var jobController = TextEditingController();
    var priceController = TextEditingController();
    priceTECs.add(priceController);
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
            height: 16,
          ),
          Row(
            children: [
              Container(
                width: (MediaQuery.of(context).size.width - 30) * (2.41 / 4),
                // child: TextField(
                //     controller: nameController,
                //     decoration: InputDecoration(labelText: 'Full Name')
                // ),
                child: TextFormField(
                  controller: nameController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    // prodFieldsValue.add(value);
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
                width: (MediaQuery.of(context).size.width - 30) * (1.41 / 4),
                child: TextFormField(
                  controller: ageController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    // prodFieldsValue.add(value);
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
            controller: priceController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              // prodFieldsValue.add(value);
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
              //suffixText: 'MMK',
              // suffixStyle: TextStyle(
              //   fontWeight: FontWeight.w500,
              //   color: Colors.grey,
              //   fontSize: 12,
              //   //fontFamily: 'capsulesans',
              // ),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              // errorText: 'Error message',
              labelText: 'Unit Quantity',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              //filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          TextFormField(
            controller: jobController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              // prodFieldsValue.add(value);
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

  void removeAsset(int index) {
    assets.removeAt(index);
    if (assets.isEmpty) {
      isDisplayingDetail.value = true;
    }
    setState(() {});
  }

  void onResult(List<AssetEntity>? result) {
    if (result != null && result != assets) {
      assets = List<AssetEntity>.from(result);
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> selectAssets(PickMethod model) async {
    final List<AssetEntity>? result = await model.method(context, assets);
    if (result != null) {
      assets = List<AssetEntity>.from(result);
      if (mounted) {
        setState(() {});
      }
    }
  }
  addSubUnit() {
    return Scaffold(
      body: Stack(
          children: [
            SafeArea(
              top: true,
              bottom: true, child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    height: 85,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: AppTheme.skBorderColor, width: 2.0))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                                color: Colors.grey.withOpacity(0.3)),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 20,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Text(
                            "Add new product",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: 'capsulesans',
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                          ),
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),),
                                color: AppTheme.skThemeColor2),
                            child: IconButton(
                                icon: Icon(
                                  Icons.check,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                onPressed: () {}),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
            ),
          ]
      ),
    );
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

  pickMethods() {
    return <PickMethod>[
      // PickMethod.image(maxAssetsCount),
      // PickMethod.video(maxAssetsCount),
      // PickMethod.audio(maxAssetsCount),
      // PickMethod.camera(
      //   maxAssetsCount: maxAssetsCount,
      //   handleResult: (BuildContext context, AssetEntity result) =>
      //       Navigator.of(context).pop(<AssetEntity>[...assets, result]),
      // ),

      PickMethod.cameraAndStay(
        maxAssetsCount: 5,
      ),

      // PickMethod.common(maxAssetsCount),
      // PickMethod.threeItemsGrid(maxAssetsCount),
      // PickMethod.customFilterOptions(maxAssetsCount),
      // PickMethod.prependItem(maxAssetsCount),
      // PickMethod(
      //   icon: '🎭',
      //   name: 'WeChat Moment',
      //   description: 'Pick assets like the WeChat Moment pattern.',
      //   method: (BuildContext context, List<AssetEntity> assets) {
      //     return AssetPicker.pickAssets(
      //       context,
      //       maxAssets: maxAssetsCount,
      //       specialPickerType: SpecialPickerType.wechatMoment,
      //     );
      //   },
      // ),
      // PickMethod.noPreview(maxAssetsCount),
      // PickMethod.keepScrollOffset(
      //   provider: () => keepScrollProvider,
      //   delegate: () => keepScrollDelegate!,
      //   onPermission: (PermissionState state) {
      //     keepScrollDelegate ??= DefaultAssetPickerBuilderDelegate(
      //       provider: keepScrollProvider,
      //       initialPermission: state,
      //       keepScrollOffset: true,
      //     );
      //   },
      //   onLongPress: () {
      //     keepScrollProvider.dispose();
      //     keepScrollProvider = DefaultAssetPickerProvider();
      //     keepScrollDelegate?.dispose();
      //     keepScrollDelegate = null;
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Resources have been released')),
      //     );
      //   },
      // ),
      // PickMethod(
      //   icon: '🎚',
      //   name: 'Custom image preview thumb size',
      //   description: 'You can reduce the thumb size to get faster load speed.',
      //   method: (BuildContext context, List<AssetEntity> assets) {
      //     return AssetPicker.pickAssets(
      //       context,
      //       maxAssets: maxAssetsCount,
      //       selectedAssets: assets,
      //       requestType: RequestType.image,
      //       previewThumbSize: const <int>[150, 150],
      //       gridThumbSize: 80,
      //     );
      //   },
      // ),
    ];
  }
}

class PersonEntry {
  final String name;
  final String age;
  final String studyJob;

  PersonEntry(this.name, this.age, this.studyJob);
  @override
  String toString() {
    return 'Person: name= $name, age= $age, study job= $studyJob';
  }
}

// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(App());
// }
//
// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Home(),
//     );
//   }
// }
//
// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: RaisedButton(
//           child: Text('Add entries'),
//           onPressed: () async {
//             List<PersonEntry> persons = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => SOF(),
//               ),
//             );
//             if (persons != null) persons.forEach(print);
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class SOF extends StatefulWidget {
//   @override
//   _SOFState createState() => _SOFState();
// }
//
// class _SOFState extends State<SOF> {
//   var nameTECs = <TextEditingController>[];
//   var ageTECs = <TextEditingController>[];
//   var jobTECs = <TextEditingController>[];
//   var cards = <Card>[];
//
//   Card createCard() {
//     var nameController = TextEditingController();
//     var ageController = TextEditingController();
//     var jobController = TextEditingController();
//     nameTECs.add(nameController);
//     ageTECs.add(ageController);
//     jobTECs.add(jobController);
//     return Card(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Text('Person ${cards.length + 1}'),
//           TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Full Name')),
//           TextField(
//               controller: ageController,
//               decoration: InputDecoration(labelText: 'Age')),
//           TextField(
//               controller: jobController,
//               decoration: InputDecoration(labelText: 'Study/ job')),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     cards.add(createCard());
//   }
//
//   _onDone() {
//     List<PersonEntry> entries = [];
//     for (int i = 0; i < cards.length; i++) {
//       var name = nameTECs[i].text;
//       var age = ageTECs[i].text;
//       var job = jobTECs[i].text;
//       entries.add(PersonEntry(name, age, job));
//     }
//     Navigator.pop(context, entries);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               itemCount: cards.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return cards[index];
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: RaisedButton(
//               child: Text('add new'),
//               onPressed: () => setState(() => cards.add(createCard())),
//             ),
//           )
//         ],
//       ),
//       floatingActionButton:
//       FloatingActionButton(child: Icon(Icons.done), onPressed: _onDone),
//     );
//   }
// }
//
// class PersonEntry {
//   final String name;
//   final String age;
//   final String studyJob;
//
//   PersonEntry(this.name, this.age, this.studyJob);
//   @override
//   String toString() {
//     return 'Person: name= $name, age= $age, study job= $studyJob';
//   }
// }
