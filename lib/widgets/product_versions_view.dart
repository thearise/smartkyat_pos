import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:smartkyat_pos/widgets/fill_product.dart';
import 'package:smartkyat_pos/widgets/product_details_view2.dart';
import 'package:smartkyat_pos/widgets/version_detatils_view.dart';
import 'package:fraction/fraction.dart';

// late final String id;

class ProductVersionView extends StatefulWidget {
  final _callback;
  final _callback3;

  ProductVersionView(
      {Key? key,
      required this.idString,
      required void toggleCoinCallback(String str),
  required void toggleCoinCallback3(String str)})
      : _callback = toggleCoinCallback,
  _callback3= toggleCoinCallback3;

  final String idString;

  @override
  State<ProductVersionView> createState() => _ProductVersionViewState();
}

class _ProductVersionViewState extends State<ProductVersionView> {
  addProduct2(data) {
    widget._callback(data);
  }
  addProduct3(data) {
    widget._callback3(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                                var output = snapshot2.data!.data();
                                var prodName = output?['prod_name'];
                                return Text(
                                  '$prodName Versions',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              return Container();
                            }),
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
                                Icons.add,
                                size: 16,
                                color: Colors.black,
                              ),
                              onPressed: () {

                              }),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('space')
                          .doc('0NHIS0Jbn26wsgCzVBKT')
                          .collection('shops')
                          .doc('PucvhZDuUz3XlkTgzcjb')
                          .collection('products')
                          .doc(widget.idString)
                          .snapshots(),
                      builder: (BuildContext context, snapshot1) {
                        if (snapshot1.hasData) {
                          var output = snapshot1.data!.data();
                          var image = output?['img_1'];
                          var mainName = output?['unit_name'];
                          var sub1Name = output?['sub1_name'];
                          var sub2Name = output?['sub2_name'];
                          var sub3Name = output?['sub3_name'];
                          return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('space')
                                  .doc('0NHIS0Jbn26wsgCzVBKT')
                                  .collection('shops')
                                  .doc('PucvhZDuUz3XlkTgzcjb')
                                  .collection('products')
                                  .doc(widget.idString)
                                  .collection('versions')
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
                                      var date = data['date'];
                                      var price = data["sale_price"];
                                      var mainQuantity =
                                          data['unit_qtity'].split(' ')[0];
                                      var subQuantity =
                                          data['unit_qtity'].split(' ')[1];
                                      var sub1Quantity = data['sub1_unit'];
                                      var sub2Quantity = data['sub2_unit'];
                                      var sub3Quantity = data['sub3_unit'];
                                      inStock() {
                                        if (sub1Quantity != '' &&
                                            sub2Quantity == '' &&
                                            sub3Quantity == '') {
                                          return Text(
                                            mainQuantity +
                                                ' $mainName ' +
                                                'and ' +
                                                ((Fraction.fromString(
                                                                subQuantity) *
                                                            Fraction.fromString(
                                                                sub1Quantity +
                                                                    '/1'))
                                                        .toDouble()
                                                        .round())
                                                    .toString() +
                                                ' $sub1Name',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blueGrey
                                                  .withOpacity(1.0),
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
                                                ((Fraction.fromString(
                                                                subQuantity) *
                                                            Fraction.fromString(
                                                                sub1Quantity +
                                                                    '/1'))
                                                        .toDouble()
                                                        .round())
                                                    .toString() +
                                                ' $sub1Name and ' +
                                                ((Fraction.fromString(
                                                                subQuantity) *
                                                            Fraction.fromString(
                                                                sub2Quantity +
                                                                    '/1'))
                                                        .toDouble()
                                                        .round())
                                                    .toString() +
                                                ' $sub2Name',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blueGrey
                                                  .withOpacity(1.0),
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
                                                ((Fraction.fromString(
                                                                subQuantity) *
                                                            Fraction.fromString(
                                                                sub1Quantity +
                                                                    '/1'))
                                                        .toDouble()
                                                        .round())
                                                    .toString() +
                                                ' $sub1Name, ' +
                                                ((Fraction.fromString(
                                                                subQuantity) *
                                                            Fraction.fromString(
                                                                sub2Quantity +
                                                                    '/1'))
                                                        .toDouble()
                                                        .round())
                                                    .toString() +
                                                ' $sub2Name' +
                                                ' and ' +
                                                ((Fraction.fromString(
                                                                subQuantity) *
                                                            Fraction.fromString(
                                                                sub3Quantity +
                                                                    '/1'))
                                                        .toDouble()
                                                        .round())
                                                    .toString() +
                                                ' $sub3Name',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blueGrey
                                                  .withOpacity(1.0),
                                            ),
                                          );
                                        }
                                        return Text(
                                          '$mainQuantity $mainName in Stock',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.blueGrey
                                                .withOpacity(1.0),
                                          ),
                                        );
                                      }

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
                                                        ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child: image != ""
                                                                ? CachedNetworkImage(
                                                                    imageUrl:
                                                                        'https://hninsunyein.me/smartkyat_pos/api/uploads/$image',
                                                                    width: 70,
                                                                    height: 70,
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
                                                                        'https://fdn.gsmarena.com/imgroot/news/21/04/oneplus-watch-update/-1200/gsmarena_002.jpg',
                                                                    width: 70,
                                                                    height: 70,
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
                                                          date,
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
                                                          '$price MMK',
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
                                                        inStock(),
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
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => VersionDetailsView(
                                                                  versionID:
                                                                      document
                                                                          .id
                                                                          .toString(),
                                                                  idString: widget
                                                                      .idString,
                                                                  toggleCoinCallback:
                                                                      addProduct2)),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                      );
                                    }).toList(),
                                  );
                                  // int quantity = 0;
                                  //
                                  // snapshot.data!.docs
                                  //     .map((DocumentSnapshot document) {
                                  //       Map<String, dynamic> data = document
                                  //           .data()! as Map<String, dynamic>;
                                  //       quantity += int.parse(data['sub1_unit']);
                                  // });
                                  //
                                  // return Text(quantity.toString());
                                }
                                return Container();
                              });
                        }
                        return Container();
                      })
                ]),
          )),
    );
  }
}

class CustomerInfo extends StatelessWidget {
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final String image;
  final String id;

  CustomerInfo(
      this.customerName, this.customerAddress, this.customerPhone, this.image, this.id);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        onTap: (){
          print(id.toString());
        },
        child: Container(
          child: Row(
            children: [
              Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: image != "" ? CachedNetworkImage(
                        imageUrl: 'https://hninsunyein.me/smartkyat_pos/api/uploads/$image',
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
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                 'MMK $customerAddress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.blueGrey.withOpacity(1.0),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    customerPhone.toString(),
                    // customerPhone.substring(0,2) == '0 ' ?MixedFraction.fromString(customerPhone).toString() + ' in stock':Fraction.fromString(customerPhone).toString() + ' in stock',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.blueGrey.withOpacity(1.0),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
