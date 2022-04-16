import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:smartkyat_pos/widgets/product_details_view2.dart';

import '../app_theme.dart';

bool _isEnable = false;

class VersionDetailsView extends StatefulWidget {
  final _callback;
  const VersionDetailsView(
      {Key? key,
        required this.versionID,
        required this.idString,
        required void toggleCoinCallback(String str)})
      : _callback = toggleCoinCallback;
  final String versionID;
  final String idString;

  @override
  _VersionDetailsViewState createState() => _VersionDetailsViewState();
}

class _VersionDetailsViewState extends State<VersionDetailsView> {
  List<String> prodFieldsValue = [];
  static final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('space')
                  .doc('0NHIS0Jbn26wsgCzVBKT')
                  .collection('shops')
                  .doc('PucvhZDuUz3XlkTgzcjb')
                  .collection('products')
                  .doc(widget.idString)
                  .collection('versions')
                  .doc(widget.versionID)
                  .snapshots(),
              builder: (BuildContext context, snapshot1) {
                if (snapshot1.hasData) {
                  var output = snapshot1.data!.data();
                  var date = output?['date'];
                  var mainQuantity = output?['unit_qtity'].split(' ')[0];
                  var sub1Quantity = output?['sub1_unit'];
                  var sub2Quantity = output?['sub2_unit'];
                  var sub3Quantity = output?['sub3_unit'];
                  var mainPrice = output?['sale_price'];
                  var sub1Price = output?['sub1_sale'];
                  var sub2Price = output?['sub2_sale'];
                  var sub3Price = output?['sub3_sale'];
                  var subQuantity = output?['unit_qtity'].split(' ')[1];

                  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('space')
                          .doc('0NHIS0Jbn26wsgCzVBKT')
                          .collection('shops')
                          .doc('PucvhZDuUz3XlkTgzcjb')
                          .collection('products')
                          .doc(widget.idString)
                          .snapshots(),
                      builder: (BuildContext context, snapshot2) {
                        if (snapshot2.hasData) {
                          var output1 = snapshot2.data!.data();
                          var mainName = output1?['unit_name'];
                          var sub1Name = output1?['sub1_name'];
                          var sub2Name = output1?['sub2_name'];
                          var sub3Name = output1?['sub3_name'];
                          var prodName = output1?['prod_name'];

                          inStock() {
                            if (sub1Quantity != '' &&
                                sub2Quantity == '' &&
                                sub3Quantity == '') {
                              return Text(
                                mainQuantity +
                                    ' $mainName ' +
                                    'and ' +
                                    ((Fraction.fromString(subQuantity) *
                                        Fraction.fromString(
                                            sub1Quantity + '/1'))
                                        .toDouble()
                                        .round())
                                        .toString() +
                                    ' $sub1Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blueGrey.withOpacity(1.0),
                                ),
                              );
                            }
                            if (sub1Quantity != '' &&
                                sub2Quantity != '' &&
                                sub3Quantity == '') {
                              return Text(
                                mainQuantity +
                                    ' $mainName' +
                                    ', ' +
                                    ((Fraction.fromString(subQuantity) *
                                        Fraction.fromString(
                                            sub1Quantity + '/1'))
                                        .toDouble()
                                        .round())
                                        .toString() +
                                    ' $sub1Name and ' +
                                    ((Fraction.fromString(subQuantity) *
                                        Fraction.fromString(
                                            sub2Quantity + '/1'))
                                        .toDouble()
                                        .round())
                                        .toString() +
                                    ' $sub2Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blueGrey.withOpacity(1.0),
                                ),
                              );
                            }
                            if (sub1Quantity != '' &&
                                sub2Quantity != '' &&
                                sub3Quantity != '') {
                              return Text(
                                mainQuantity +
                                    ' $mainName' +
                                    ', ' +
                                    ((Fraction.fromString(subQuantity) *
                                        Fraction.fromString(
                                            sub1Quantity + '/1'))
                                        .toDouble()
                                        .round())
                                        .toString() +
                                    ' $sub1Name, ' +
                                    ((Fraction.fromString(subQuantity) *
                                        Fraction.fromString(
                                            sub2Quantity + '/1'))
                                        .toDouble()
                                        .round())
                                        .toString() +
                                    ' $sub2Name' +
                                    'and ' +
                                    ((Fraction.fromString(subQuantity) *
                                        Fraction.fromString(
                                            sub3Quantity + '/1'))
                                        .toDouble()
                                        .round())
                                        .toString() +
                                    ' $sub3Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blueGrey.withOpacity(1.0),
                                ),
                              );
                            }
                            return Text(
                              '$mainQuantity $mainName in Stock',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.blueGrey.withOpacity(1.0),
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.withOpacity(0.3),
                                            width: 1.0))),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
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
                                            size: 16,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                    ),
                                    Text(
                                      '$prodName ($date)',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                            Navigator.pop(context);
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 120.0),
                                child: ButtonTheme(
                                  //minWidth: 50,
                                  splashColor: Colors.transparent,
                                  height: 120,
                                  child: FlatButton(
                                    color: AppTheme.skThemeColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      side: BorderSide(
                                        color: AppTheme.skThemeColor,
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (sub1Name == '') {
                                        widget._callback(widget.idString +
                                            '-' +
                                            widget.versionID +
                                            '-' +
                                            mainPrice +
                                            '-unit_name-1'.toString());
                                      } else {
                                        final result =
                                        await showModalActionSheet<String>(
                                          context: context,
                                          actions: [
                                            SheetAction(
                                              icon: Icons.info,
                                              label: '1 ' + mainName,
                                              key: widget.idString +
                                                  '-' +
                                                  widget.versionID +
                                                  '-' +
                                                  mainPrice +
                                                  '-unit_name-1',
                                            ),
                                            if (sub1Price != '')
                                              SheetAction(
                                                icon: Icons.info,
                                                label: '1 ' + sub1Name,
                                                key: widget.idString +
                                                    '-' +
                                                    widget.versionID +
                                                    '-' +
                                                    sub1Price +
                                                    '-sub1_name-1',
                                              ),
                                            if (sub2Price != '')
                                              SheetAction(
                                                icon: Icons.info,
                                                label: '1 ' + sub2Name,
                                                key: widget.idString +
                                                    '-' +
                                                    widget.versionID +
                                                    '-' +
                                                    sub2Price +
                                                    '-sub2_name-1',
                                              ),
                                            if (sub3Price != '')
                                              SheetAction(
                                                icon: Icons.info,
                                                label: '1 ' + sub3Name,
                                                key: widget.idString +
                                                    '-' +
                                                    widget.versionID +
                                                    '-' +
                                                    sub3Price +
                                                    '-sub3_name-1',
                                              ),
                                          ],
                                        );

                                        widget._callback(result.toString());
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(right: 120.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            size: 40,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Add to cart',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: ListView(children: [
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
                                      child: Column(children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "MERCHANT",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 2,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            _productDetails('Merchant Name'),
                                            SizedBox(height: 15),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                'Shwe Shwe',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "QUANTITY",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 2,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            _productDetails(
                                                'Main Unit Quantity'),
                                            SizedBox(height: 15),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: inStock(),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        sub1Quantity != ""
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            _productDetails(
                                                '#1 Sub Unit Quantity'),
                                            SizedBox(height: 15),
                                            Container(
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                '$sub1Quantity $sub1Name',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                                width:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                            : Container(),
                                        sub2Quantity != ""
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            _productDetails(
                                                '#2 Sub Unit Quantity'),
                                            SizedBox(height: 15),
                                            Container(
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                '$sub2Quantity $sub2Name',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                                width:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                            : Container(),
                                        sub3Quantity != ""
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            _productDetails(
                                                '#3 Sub Unit Quantity'),
                                            SizedBox(height: 15),
                                            Container(
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                '$sub3Quantity $sub3Name',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                                width:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                            : Container(),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "PRICING",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 2,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            _productDetails('Main Unit Price'),
                                            SizedBox(height: 15),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                '$mainPrice MMK',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        sub1Price != ""
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            _productDetails(
                                                '#1 Sub Unit Price'),
                                            SizedBox(height: 15),
                                            Container(
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                '$sub1Price MMK',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                                width:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                            : Container(),
                                        sub2Price != ""
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            _productDetails(
                                                '#2 Sub Unit Price'),
                                            SizedBox(height: 15),
                                            Container(
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                '$sub2Price MMK',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                                width:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                            : Container(),
                                        sub3Price != ""
                                            ? Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            _productDetails(
                                                '#3 Sub Unit Price'),
                                            SizedBox(height: 15),
                                            Container(
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                '$sub3Price MMK',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  color: Colors.blueGrey
                                                      .withOpacity(1.0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                                width:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1.5,
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        )
                                            : Container(),
                                      ]),
                                    ),
                                  ]),
                                ),
                              )
                            ],
                          );
                        }
                        return Container();
                      });
                }
                return Container();
              }),
        ),
      ),
    );
  }
}

class _productDetails extends StatelessWidget {
  late final String title_text;
  _productDetails(this.title_text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        title_text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          // letterSpacing: 2,
          color: Colors.black,
        ),
      ),
    );
  }
}

// for(String str in prodList) Slidable(
// key: const ValueKey(1),
// actionPane: SlidableDrawerActionPane(),
// actionExtentRatio: 0.25,
//
// child: FutureBuilder<DocumentSnapshot>(
// future: FirebaseFirestore.instance
//     .collection('space')
// .doc('0NHIS0Jbn26wsgCzVBKT')
// .collection('shops')
// .doc('PucvhZDuUz3XlkTgzcjb')
// .collection('products')
// .doc(str.split('-')[0]).get(),
// builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
// if(snapshot.hasData) {
// Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
// //return Text("Full Name: ${data['prod_name']}");
// return Container(
// color: Colors.white,
// child: ListTile(
// leading: CircleAvatar(
// backgroundColor: Colors.indigoAccent,
// child: Text(str.split('-')[4]),
// foregroundColor: Colors.white,
// ),
// title: Text(data['prod_name']),
// subtitle: Text(str.split('-')[2] + ' MMK'),
// ),
// );
// }
// return Container();
// },
// ),
//
// // actions: <Widget>[
// //   IconSlideAction(
// //     caption: 'Archive',
// //     color: Colors.blue,
// //     icon: Icons.archive,
// //     onTap: () => print('Archive'),
// //   ),
// //   IconSlideAction(
// //     caption: 'Share',
// //     color: Colors.indigo,
// //     icon: Icons.share,
// //     onTap: () => print('Share'),
// //   ),
// // ],
// dismissal: SlidableDismissal(
// child: SlidableDrawerDismissal(),
// onWillDismiss: (actionType) {
// print('here');
// return true;
// },
// ),
// secondaryActions: <Widget>[
// IconSlideAction(
// caption: 'Delete',
// color: Colors.red,
// icon: Icons.delete,
// onTap: () => print('Delete'),
// ),
// ],
// )
