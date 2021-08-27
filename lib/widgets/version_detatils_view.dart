import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/widgets/product_details_view.dart';

import '../app_theme.dart';

bool _isEnable = false;

class VersionDetailsView extends StatefulWidget {
  const VersionDetailsView({Key? key, required this.versionID, required this.idString}) : super(key: key);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 70,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.3), width: 1.0))),
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
                      'Version Details',
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
              SizedBox(height: 20,),
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
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(right: 120.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                      onPressed: () {
                      },
                      child: Text('Edit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),),
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
                    .collection('versions')
                    .doc(widget.versionID)
                    .snapshots(),
                builder: (BuildContext context,snapshot1) {
                  if (snapshot1.hasData) {
              var output = snapshot1.data!.data();
              var quantity = output!['unit_qtity'];
              var sub1quantity= output!['sub1_unit'];
              var sub2quantity= output!['sub2_unit'];
              var sub3quantity = output!['sub3_unit'];
              var mainPrice= output!['sale_price'];
              var sub1price= output!['sub1_sale'];
              var sub2price= output!['sub2_sale'];
              var sub3price = output!['sub3_sale'];

              return  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('space')
                      .doc('0NHIS0Jbn26wsgCzVBKT')
                      .collection('shops')
                      .doc('PucvhZDuUz3XlkTgzcjb')
                      .collection('products')
                      .doc(widget.idString)
                       .snapshots(),
    builder: (BuildContext context,snapshot2) {
    if (snapshot2.hasData) {
      var output1 = snapshot2.data!.data();
      var mainUnit = output1!['unit_name'];
      var sub1Unit = output1!['sub1_name'];
      var sub2Unit = output1!['sub2_name'];
      var sub3Unit = output1!['sub3_name'];
      return Expanded(
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
                      child: Column(
                        children: [
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _productDetails('Merchant Name'),
                          SizedBox(height:15),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              quantity,
                              style: TextStyle(
                                fontSize: 15,
                                //fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height:15),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1.5,
                            color: Colors.grey.withOpacity(0.3)
                          ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _productDetails('Main Unit Quantity'),
                              SizedBox(height:15),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  '$quantity $mainUnit',
                                  style: TextStyle(
                                    fontSize: 15,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height:15),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 1.5,
                                  color: Colors.grey.withOpacity(0.3)
                              ),
                            ],
                          ),
                      SizedBox(
                        height: 20,
                      ),
                          sub1quantity != "" ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _productDetails('#1 Sub Unit Quantity'),
                              SizedBox(height:15),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  '$sub1quantity $sub1Unit',
                                  style: TextStyle(
                                    fontSize: 15,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height:15),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 1.5,
                                  color: Colors.grey.withOpacity(0.3)
                              ),
                              SizedBox(height: 20,),
                            ],
                          ) : Container(),
                          sub2quantity != "" ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _productDetails('#2 Sub Unit Quantity'),
                              SizedBox(height:15),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  '$sub2quantity $sub2Unit',
                                  style: TextStyle(
                                    fontSize: 15,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height:15),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 1.5,
                                  color: Colors.grey.withOpacity(0.3)
                              ),
                              SizedBox(height: 20,),
                            ],
                          ): Container(),
                          sub3quantity != "" ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _productDetails('#3 Sub Unit Quantity'),
                              SizedBox(height:15),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  '$sub3quantity $sub3Unit',
                                  style: TextStyle(
                                    fontSize: 15,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height:15),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 1.5,
                                  color: Colors.grey.withOpacity(0.3)
                              ),
                              SizedBox(height: 20,),
                            ],
                          ): Container(),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _productDetails('Main Unit Price'),
                              SizedBox(height:15),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  '$mainPrice MMK',
                                  style: TextStyle(
                                    fontSize: 15,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height:15),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 1.5,
                                  color: Colors.grey.withOpacity(0.3)
                              ),
                            ],
                          ),
                      SizedBox(
                        height: 25,
                      ),

                          sub1price != "" ?  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _productDetails('#1 Sub Unit Price'),
                              SizedBox(height:15),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  '$sub1price MMK',
                                  style: TextStyle(
                                    fontSize: 15,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height:15),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 1.5,
                                  color: Colors.grey.withOpacity(0.3)
                              ),
                              SizedBox(height: 20,),
                            ],
                          ) : Container(),
                          sub2price != "" ?  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _productDetails('#2 Sub Unit Price'),
                              SizedBox(height:15),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  '$sub2price MMK',
                                  style: TextStyle(
                                    fontSize: 15,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height:15),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 1.5,
                                  color: Colors.grey.withOpacity(0.3)
                              ),
                              SizedBox(height: 20,),
                            ],
                          ) : Container(),
                          sub3price != "" ?  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _productDetails('#3 Sub Unit Price'),
                              SizedBox(height:15),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  '$sub3price MMK',
                                  style: TextStyle(
                                    fontSize: 15,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height:15),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 1.5,
                                  color: Colors.grey.withOpacity(0.3)
                              ),
                              SizedBox(height: 20,),
                            ],
                          ) : Container(),
                      ]
                  ),
                  ),
                 ]
                ),
                ),
                    );
                 }
               return Center(child: CircularProgressIndicator());
                  }
              );
              }

              return Center(child: CircularProgressIndicator());
              },
              )
            ],
          ),
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
