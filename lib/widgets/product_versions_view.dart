import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/widgets/product_details_view.dart';

class ProductVersionView extends StatelessWidget {
  const ProductVersionView({Key? key}) : super(key: key);

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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                              return CustomerInfo(
                                  data['prod_name'],
                                  data['sale_price'],
                                  data['unit_qtity'],
                                  data['img_1']);
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

  CustomerInfo(
      this.customerName, this.customerAddress, this.customerPhone, this.image);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
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
                    child: image != ""
                        ? Image.network(
                            'https://hninsunyein.me/smartkyat_pos/api/uploads/$image',
                            fit: BoxFit.cover,
                            height: 70,
                            width: 70,
                          )
                        : Image.network(
                            'https://lh3.googleusercontent.com/proxy/i8fbQ2GzRUS0dJ1c0dARd8ADZ120vedmQjE46k7TQXFfQxmtchl4dF2OMwbVgTKmU0GV3CZ2xoIpgbBRSvt7k54S8q5CbfrNl8tOweIBHw',
                            fit: BoxFit.cover,
                            height: 70,
                            width: 70,
                          )),
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
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.blueGrey.withOpacity(0.8),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetailsView()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
