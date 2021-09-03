import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/widgets/add_new_merchant.dart';

import '../app_theme.dart';
import 'customers_fragment.dart';

class MerchantFragment extends StatefulWidget {
  const MerchantFragment({Key? key}) : super(key: key);

  @override
  _MerchantFragmentState createState() => _MerchantFragmentState();
}

class _MerchantFragmentState extends State<MerchantFragment> {
  static List<String> merchFieldsValue = [];
  final _formKey = GlobalKey<FormState>();
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
                          top: 0.0, left: 15.0, right: 15.0),
                      child: ListView(children: [
                        GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Merchants',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )),
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddMerchant()),
                                    );
                                  },
                                  child: Text(
                                    'Add new merchant',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ))),
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
                                .collection('merchants')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document
                                          .data()! as Map<String, dynamic>;
                                      var name = data['merchant_name'];
                                      var phone = data['merchant_phone'];
                                      var address = data['merchant_address'];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                        width: 1.0))),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        SizedBox(height: 12),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          name,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        Text(
                                                          address,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors
                                                                .blueGrey
                                                                .withOpacity(
                                                                    1.0),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        Text(
                                                          phone,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors
                                                                .blueGrey
                                                                .withOpacity(
                                                                    1.0),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                        size: 16,
                                                        color: Colors.blueGrey
                                                            .withOpacity(0.8),
                                                      ),
                                                      onPressed: () {},
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                      );
                                    }).toList());
                              }
                              return Container();
                            })
                      ]),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom:
                        BorderSide(color: AppTheme.skBorderColor2, width: 1.0),
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 15.0, right: 15.0, bottom: 15),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                              ),
                              child: Icon(
                                Icons.search,
                                size: 26,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Container(
                                    child: Text(
                                  'Search',
                                  style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.6)),
                                )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // addDailyExp(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 15.0,
                                ),
                                child: Icon(
                                  Icons.bar_chart,
                                  color: Colors.green,
                                  size: 22,
                                ),
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
}
