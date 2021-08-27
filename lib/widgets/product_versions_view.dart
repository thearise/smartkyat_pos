import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/widgets/product_details_view.dart';
import 'package:smartkyat_pos/widgets/version_detatils_view.dart';

late final String id;

class ProductVersionView extends StatefulWidget {
  const ProductVersionView({Key? key, required this.idString}) : super(key: key);

  final String idString;



  @override
  State<ProductVersionView> createState() => _ProductVersionViewState();
}

class _ProductVersionViewState extends State<ProductVersionView> {
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
                          'Product Versions',
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
                  StreamBuilder(
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
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              // index++;
                              // print(index.toString() + 'index');
                              // return ListTile(
                              //   title: Text(data['prod_name']),
                              // );
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.withOpacity(0.3), width: 1.0))),
                                child: Row(
                                  children: [
                                    CustomerInfo(
                                        data['date'],  data['sale_price'], data['unit_qtity'],
                                        '', document.id),
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                        color: Colors.blueGrey.withOpacity(0.8),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => VersionDetailsView(versionID: document.id.toString(), idString: widget.idString,)),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
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
                    '$customerPhone in stock',
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
