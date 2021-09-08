import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/widgets/product_details_view.dart';

import '../../app_theme.dart';

bool _isEnable = false;

class MerchantInfoSubs extends StatefulWidget {
  final _callback;
  const MerchantInfoSubs({Key? key, required this.id, required void toggleCoinCallback(String str)}) : _callback = toggleCoinCallback;
  final String id;

  @override
  _MerchantInfoSubsState createState() => _MerchantInfoSubsState();
}

class _MerchantInfoSubsState extends State<MerchantInfoSubs> {
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
                  .collection('merchants')
                  .doc(widget.id.toString())
                  .snapshots(),
              builder: (BuildContext context,snapshot2) {
                if (snapshot2.hasData) {
                  var output1 = snapshot2.data!.data();
                  var mainUnit = output1 ? ['merchant_name'];
                  return Column(
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
                            onPressed: () async {
                              // final result = await showModalActionSheet<String>(
                              //   context: context,
                              //   actions: [
                              //     SheetAction(
                              //       icon: Icons.info,
                              //       label: '1 ' + mainUnit,
                              //       key: widget.id.toString(),
                              //     ),
                              //   ],
                              // );
                              widget._callback(widget.id.toString() + '-' + output1 ? ['merchant_name']);
                            },
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
                                                mainUnit,
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
                                                'sps',
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
                                      ]
                                  ),
                                ),
                              ]
                          ),
                        ),
                      )
                    ],
                  );
                }
                return Container();
              }
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
