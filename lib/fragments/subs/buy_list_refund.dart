import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fraction/fraction.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';

import '../../app_theme.dart';

class BuyListRefund extends StatefulWidget {
  final _callback;
  const BuyListRefund(
      {Key? key, required this.data, required void toggleCoinCallback()})
      : _callback = toggleCoinCallback;
  final String data;

  @override
  _BuyListRefundState createState() => _BuyListRefundState();
}

class _BuyListRefundState extends State<BuyListRefund>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<BuyListRefund> {
  @override
  bool get wantKeepAlive => true;
  var docId = '';
  List<int> refundItems = [];
  List<int> deffItems = [];
  @override
  initState() {
    var innerId = '';
    FirebaseFirestore.instance
        .collection('space')
        .doc('0NHIS0Jbn26wsgCzVBKT')
        .collection('shops')
        .doc('PucvhZDuUz3XlkTgzcjb')
        .collection('buyOrders')
        .where('date', isEqualTo: widget.data.split('^')[0].substring(0, 8))
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        innerId = doc.id;
      });
      setState(() {
        docId = innerId;
      });
      // return docId;
      // return Container();
    });

    super.initState();
  }

  bool initAttempt = false;
  int changedPrice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.3),
                                width: 1.0))),
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
                                size: 16,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                        Text(
                          widget.data.split('^')[1],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.check,
                              size: 20,
                              color: Colors.white,
                            ),
                            onPressed: () {}),
                      ],
                    ),
                  ),
                  // orderDateId(widget.data)
                  if (docId != null && docId != '')
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('space')
                            .doc('0NHIS0Jbn26wsgCzVBKT')
                            .collection('shops')
                            .doc('PucvhZDuUz3XlkTgzcjb')
                            .collection('buyOrders')
                            .doc(docId)
                            .collection('expansion')
                            .doc(widget.data.split('^')[0])
                            .snapshots(),
                        builder: (BuildContext context, snapshot2) {
                          if (snapshot2.hasData) {
                            var output1 = snapshot2.data!.data();
                            // print(output1?['subs'].toString());
                            List prodList = output1?['subs'];

                            if (!initAttempt) {
                              for (int i = 0; i < prodList.length; i++) {
                                // refundItems[i] = int.parse(prodList[i].split('-')[5]);
                                refundItems
                                    .add(int.parse(prodList[i].split('-')[6]));
                                deffItems
                                    .add(int.parse(prodList[i].split('-')[6]));
                              }
                              initAttempt = true;
                            }

                            return Container(
                              height: 300,
                              child: ListView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, right: 120.0, bottom: 20.0),
                                    child: ButtonTheme(
                                      //minWidth: 50,
                                      splashColor: Colors.transparent,
                                      height: 120,
                                      child: FlatButton(
                                        color: AppTheme.skThemeColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          side: BorderSide(
                                            color: AppTheme.skThemeColor,
                                          ),
                                        ),
                                        onPressed: () async {
                                          int total = 0;
                                          bool refund = false;
                                          for (int i = 0;
                                              i < refundItems.length;
                                              i++) {
                                            prodList[i] =
                                                prodList[i].split('-')[0] +
                                                    '-' +
                                                    prodList[i].split('-')[1] +
                                                    '-' +
                                                    prodList[i].split('-')[2] +
                                                    '-' +
                                                    prodList[i].split('-')[3] +
                                                    '-' +
                                                    prodList[i].split('-')[4] +
                                                    '-' +
                                                    prodList[i].split('-')[5] +
                                                    '-' +
                                                    refundItems[i].toString() +
                                                    '-' +
                                                    prodList[i].split('-')[7];
                                            total += (int.parse(prodList[i]
                                                        .split('-')[2]) -
                                                    refundItems[i]) *
                                                int.parse(
                                                    prodList[i].split('-')[1]);

                                            if (refundItems[i] > 0) {
                                              refund = true;
                                            }

                                            var collection = FirebaseFirestore
                                                .instance
                                                .collection('space')
                                                .doc('0NHIS0Jbn26wsgCzVBKT')
                                                .collection('shops')
                                                .doc('PucvhZDuUz3XlkTgzcjb')
                                                .collection('products')
                                                .doc(prodList[i].split('-')[0])
                                                .collection('versions');
                                            var docSnapshot = await collection
                                                .doc(prodList[i].split('-')[7])
                                                .get();
                                            if (docSnapshot.exists) {
                                              Map<String, dynamic>? data =
                                                  docSnapshot.data();
                                              var mainUnits =
                                                  data?['unit_qtity'];

                                              print('unit _name' + prodList[i]);
                                              if (prodList[i].split('-')[4] ==
                                                  'unit_name') {
                                                print('unit ' +
                                                    deffItems[i].toString() +
                                                    ' ' +
                                                    refundItems[i].toString() +
                                                    (deffItems[i] -
                                                            refundItems[i])
                                                        .toString());

                                                var docSnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('space')
                                                        .doc(
                                                            '0NHIS0Jbn26wsgCzVBKT')
                                                        .collection('shops')
                                                        .doc(
                                                            'PucvhZDuUz3XlkTgzcjb')
                                                        .collection('products')
                                                        .doc(prodList[i]
                                                            .split('-')[0])
                                                        .collection('versions')
                                                        .doc(prodList[i]
                                                            .split('-')[7])
                                                        .get();
                                                if (docSnapshot.exists) {
                                                  Map<String, dynamic>? data =
                                                      docSnapshot.data();
                                                  String value =
                                                      data?['unit_qtity'];
                                                  FirebaseFirestore.instance
                                                      .collection('space')
                                                      .doc(
                                                          '0NHIS0Jbn26wsgCzVBKT')
                                                      .collection('shops')
                                                      .doc(
                                                          'PucvhZDuUz3XlkTgzcjb')
                                                      .collection('products')
                                                      .doc(prodList[i]
                                                          .split('-')[0])
                                                      .collection('versions')
                                                      .doc(prodList[i]
                                                          .split('-')[7])
                                                      .update({
                                                    'unit_qtity': deffItems[
                                                    i] -
                                                        refundItems[
                                                        i] <
                                                        0
                                                        ? (int.parse(value) + (deffItems[i] - refundItems[i])).toString()
                                                        : (int.parse(value) + (deffItems[i] - refundItems[i])).toString()
                                                  })
                                                      .then((value) =>
                                                          print("User Updated"))
                                                      .catchError((error) => print(
                                                          "Failed to update user: $error"));
                                                }
                                              }
                                              //Call setState if needed.
                                            }
                                          }
                                          changedPrice = total;
                                          Navigator.pop(context);
                                          // prodList

                                          String data = widget.data;
                                          String dataRm = data.split('^')[0] +
                                              '^' +
                                              data.split('^')[1] +
                                              '^' +
                                              data.split('^')[2] +
                                              '^' +
                                              data.split('^')[3].split('&')[1] +
                                              '^' +
                                              data.split('^')[4];

                                          if (refund) {
                                            data = data.split('^')[0] +
                                                '^' +
                                                data.split('^')[1] +
                                                '^' +
                                                total.toString() +
                                                '^' +
                                                data
                                                    .split('^')[3]
                                                    .split('&')[1] +
                                                '^' +
                                                'r' +
                                                data.split('^')[4][1];
                                          } else {
                                            data = data.split('^')[0] +
                                                '^' +
                                                data.split('^')[1] +
                                                '^' +
                                                total.toString() +
                                                '^' +
                                                data
                                                    .split('^')[3]
                                                    .split('&')[1] +
                                                '^' +
                                                ' ' +
                                                data.split('^')[4][1];
                                          }

                                          print(data + dataRm);

                                          FirebaseFirestore.instance
                                              .collection('space')
                                              .doc('0NHIS0Jbn26wsgCzVBKT')
                                              .collection('shops')
                                              .doc('PucvhZDuUz3XlkTgzcjb')
                                              .collection('buyOrders')
                                              .doc(docId)
                                              .update({
                                            'daily_order':
                                                FieldValue.arrayRemove([dataRm])
                                          }).then((value) {
                                            print('array removed');

                                            FirebaseFirestore.instance
                                                .collection('space')
                                                .doc('0NHIS0Jbn26wsgCzVBKT')
                                                .collection('shops')
                                                .doc('PucvhZDuUz3XlkTgzcjb')
                                                .collection('buyOrders')
                                                .doc(docId)
                                                .update({
                                              'daily_order':
                                                  FieldValue.arrayUnion([data])
                                            }).then((value) {
                                              print('array updated');

                                              FirebaseFirestore.instance
                                                  .collection('space')
                                                  .doc('0NHIS0Jbn26wsgCzVBKT')
                                                  .collection('shops')
                                                  .doc('PucvhZDuUz3XlkTgzcjb')
                                                  .collection('buyOrders')
                                                  .doc(docId)
                                                  .collection('expansion')
                                                  .doc(data.split('^')[0])
                                                  .update({
                                                'subs': prodList
                                              }).then((value) =>
                                                      print('subs updated'));
                                            });
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 120.0),
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
                                                'Refund',
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
                                  for (int i = 0; i < prodList.length; i++)
                                    StreamBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection('space')
                                          .doc('0NHIS0Jbn26wsgCzVBKT')
                                          .collection('shops')
                                          .doc('PucvhZDuUz3XlkTgzcjb')
                                          .collection('products')
                                          .doc(prodList[i].split('-')[0])
                                          .snapshots(),
                                      builder:
                                          (BuildContext context, snapshot2) {
                                        if (snapshot2.hasData) {
                                          var output2 = snapshot2.data!.data();
                                          // int refundItems = int.parse(prodList[i].split('-')[5]);
                                          return Container(
                                            color: Colors.white,
                                            child: Row(
                                              children: [
                                                Text(
                                                  output2?['prod_name'] +
                                                      ' (' +
                                                      output2?[prodList[i]
                                                          .split('-')[4]] +
                                                      ')',
                                                ),
                                                Text(prodList[i].split('-')[1] +
                                                    ' MMK'),
                                                Text((int.parse(prodList[i]
                                                            .split('-')[1]) *
                                                        int.parse(prodList[i]
                                                            .split('-')[2]))
                                                    .toString()),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (refundItems[i] <= 0) {
                                                      } else {
                                                        refundItems[i] =
                                                            refundItems[i] - 1;
                                                      }

                                                      // refundItems = refundItems+1;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      '-',
                                                      style: TextStyle(
                                                          fontSize: 25),
                                                    ),
                                                  ),
                                                ),
                                                Text(refundItems[i].toString()),
                                                GestureDetector(
                                                  onTap: () {
                                                    // print('plus ' + (refundItems+1).toString());
                                                    setState(() {
                                                      // refundItems[i] = refundItems[i]+1;
                                                      if ((refundItems[i]) >=
                                                          int.parse(prodList[i]
                                                              .split('-')[2])) {
                                                      } else {
                                                        refundItems[i] =
                                                            refundItems[i] + 1;
                                                      }

                                                      // refundItems = refundItems+1;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      '+',
                                                      style: TextStyle(
                                                          fontSize: 25),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        return Container();
                                      },
                                    )

                                  // orderLoading?Text('Loading'):Text('')
                                ],
                              ),
                            );
                          }
                          return Container();
                        })
                ]),
          )),
    );
  }

}
