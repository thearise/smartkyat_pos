
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';

import '../../app_theme.dart';


class CustomerOrdersInfoSubs extends StatefulWidget {
  const CustomerOrdersInfoSubs({Key? key, required this.id});
  final String id;

  @override
  _CustomerOrdersInfoSubsState createState() => _CustomerOrdersInfoSubsState();
}

class _CustomerOrdersInfoSubsState extends State<CustomerOrdersInfoSubs> {
  List<String> prodFieldsValue = [];
  static final _formKey = GlobalKey<FormState>();


  final cateScCtler = ScrollController();
  final _width = 10.0;
  int cateScIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('space')
                .doc('0NHIS0Jbn26wsgCzVBKT')
                .collection('shops')
                .doc('PucvhZDuUz3XlkTgzcjb')
                .collection('customers')
                .doc(widget.id.toString())
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                var output = snapshot.data!.data();
                var customerName = output?['customer_name'];
                var address = output?['customer_address'];
                var phone = output?['customer_phone'];
                return Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1.0))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Container(
                                  width: 37,
                                  height: 37,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(35.0),
                                      ),
                                      color: Colors.grey.withOpacity(0.3)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 3.0),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back_ios_rounded,
                                          size: 17,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            address,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        customerName,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('space')
                                .doc('0NHIS0Jbn26wsgCzVBKT')
                                .collection('shops')
                                .doc('PucvhZDuUz3XlkTgzcjb')
                                .collection('customers')
                                .doc(widget.id)
                                .collection('orders')
                                .snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if(snapshot.hasData) {
                                // for(int i = 0; i < snapshot.data!.docs.length; i++) {
                                // }
                                return CustomScrollView(
                                  slivers: [
                                    // Add the app bar to the CustomScrollView.
                                    SliverAppBar(
                                      automaticallyImplyLeading: false,
                                      elevation: 0,
                                      backgroundColor: Colors.white,
                                      // Provide a standard title.

                                      // Allows the user to reveal the app bar if they begin scrolling
                                      // back up the list of items.
                                      floating: true,
                                      flexibleSpace: Padding(
                                        padding: const EdgeInsets.only(left: 0.0, top: 12.0, bottom: 12.0),
                                        child: Container(
                                          height: 32,
                                          width: MediaQuery.of(context).size.width,
                                          // color: Colors.yellow,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: ListView(
                                                  controller: cateScCtler,
                                                  scrollDirection: Axis.horizontal,
                                                  children: [
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                                      child: FlatButton(
                                                        minWidth: 0,
                                                        padding: EdgeInsets.only(left: 12, right: 12),
                                                        color: cateScIndex == 0 ? AppTheme.secButtonColor:Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20.0),
                                                          side: BorderSide(
                                                            color: AppTheme.skBorderColor2,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _animateToIndex(0);
                                                          setState(() {
                                                            cateScIndex = 0;
                                                          });
                                                        },
                                                        child: Container(
                                                          child: Text(
                                                            'All',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                                                      child: FlatButton(
                                                        minWidth: 0,
                                                        padding: EdgeInsets.only(left: 12, right: 12),
                                                        color: cateScIndex == 1 ? AppTheme.secButtonColor:Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20.0),
                                                          side: BorderSide(
                                                            color: AppTheme.skBorderColor2,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _animateToIndex(5.4);
                                                          setState(() {
                                                            cateScIndex = 1;
                                                          });
                                                        },
                                                        child: Container(
                                                          child: Text(
                                                            'Low stocks',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 4.0, right: 6.0),
                                                      child: FlatButton(
                                                        minWidth: 0,
                                                        padding: EdgeInsets.only(left: 12, right: 12),
                                                        color: cateScIndex == 2 ? AppTheme.secButtonColor:Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20.0),
                                                          side: BorderSide(
                                                            color: AppTheme.skBorderColor2,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _animateToIndex(16.4);
                                                          setState(() {
                                                            cateScIndex = 2;
                                                          });
                                                        },
                                                        child: Container(
                                                          child: Text(
                                                            'Best sales',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                                                      child: FlatButton(
                                                        minWidth: 0,
                                                        padding: EdgeInsets.only(left: 12, right: 12),
                                                        color: cateScIndex == 3 ? AppTheme.secButtonColor:Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20.0),
                                                          side: BorderSide(
                                                            color: AppTheme.skBorderColor2,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _animateToIndex(20);
                                                          setState(() {
                                                            cateScIndex = 3;
                                                          });
                                                        },
                                                        child: Container(
                                                          child: Text(
                                                            'Low sales',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 11,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Display a placeholder widget to visualize the shrinking size.
                                      // Make the initial height of the SliverAppBar larger than normal.
                                      expandedHeight: 20,
                                    ),
                                    // Next, create a SliverList
                                    SliverList(
                                      // Use a delegate to build items as they're scrolled on screen.
                                      delegate: SliverChildBuilderDelegate(
                                        // The builder function returns a ListTile with a title that
                                        // displays the index of the current item.
                                            (context, index) {
                                          Map<String, dynamic> dataP = snapshot.data!.docs[index]
                                              .data()! as Map<String, dynamic>;
                                          var version = snapshot.data!.docs[index].id;
                                          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('space')
                                                  .doc('0NHIS0Jbn26wsgCzVBKT')
                                                  .collection('shops')
                                                  .doc('PucvhZDuUz3XlkTgzcjb')
                                                  .collection('orders')
                                                  .doc(dataP['order_pid'])
                                                  .collection('detail')
                                                  .doc(dataP['order_id'])
                                                  .snapshots(),
                                              builder: (BuildContext context, snapshot3) {

                                                if(snapshot3.hasData) {
                                                  var output3 = snapshot3.data!.data();
                                                  // var image = output2?['img_1'];
                                                  var orderId = output3?['debt'];

                                                  return GestureDetector(
                                                    onTap: () {
                                                      print('Items' + orderId);
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //       builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {})),
                                                      // );
                                                    },
                                                    child: Stack(
                                                      alignment: Alignment.center,

                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: AppTheme.lightBgColor,
                                                                border: Border(
                                                                  bottom: BorderSide(
                                                                      color: AppTheme.skBorderColor2,
                                                                      width: 1.0),
                                                                )),
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 14.0),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left: 1.0),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            Text('#' + orderId.toString(),
                                                                              style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w500
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 8),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(bottom: 1.0),
                                                                              child: Icon(Icons.access_time, size: 15, color: Colors.grey,),
                                                                            ),
                                                                            SizedBox(width: 4),
                                                                            Text('Text1',
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w500,
                                                                                color: Colors.grey,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: 6,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text('Text2', style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.grey,
                                                                            )),

                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      // if(item.split('^')[5] == '0.0')
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(right: 6.0),
                                                                        child: Container(
                                                                          height: 21,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(20.0),
                                                                            color: AppTheme.badgeBgSuccess,
                                                                          ),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                                            child: Text('Paid',
                                                                              style: TextStyle(
                                                                                  fontSize: 13,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: Colors.white
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      // if(item.split('^')[5] != '0.0')
                                                                      //   Padding(
                                                                      //     padding: const EdgeInsets.only(right: 6.0),
                                                                      //     child: Container(
                                                                      //       height: 21,
                                                                      //       decoration: BoxDecoration(
                                                                      //         borderRadius: BorderRadius.circular(20.0),
                                                                      //         color: AppTheme.badgeFgDanger,
                                                                      //       ),
                                                                      //       child: Padding(
                                                                      //         padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                                      //         child: Text('Unpaid',
                                                                      //           style: TextStyle(
                                                                      //               fontSize: 13,
                                                                      //               fontWeight: FontWeight.w500,
                                                                      //               color: Colors.Colors.white
                                                                      //           ),
                                                                      //         ),
                                                                      //       ),
                                                                      //     ),
                                                                      //   ),

                                                                      // if(item.split('^')[4][0] == 'r')
                                                                      //   Padding(
                                                                      //     padding: const EdgeInsets.only(right: 6.0),
                                                                      //     child: Container(
                                                                      //       height: 21,
                                                                      //       decoration: BoxDecoration(
                                                                      //         borderRadius: BorderRadius.circular(20.0),
                                                                      //         color: AppTheme.badgeBgSecond,
                                                                      //       ),
                                                                      //       child: Padding(
                                                                      //         padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                                      //         child: Text('Refunded',
                                                                      //           style: TextStyle(
                                                                      //               fontSize: 13,
                                                                      //               fontWeight: FontWeight.w500,
                                                                      //               color: Colors.Colors.white
                                                                      //           ),
                                                                      //         ),
                                                                      //       ),
                                                                      //     ),
                                                                      //   ),

                                                                      // if(item.split('^')[4][0] == 's')
                                                                      //   Padding(
                                                                      //     padding: const EdgeInsets.only(right: 6.0),
                                                                      //     child: Container(
                                                                      //       height: 21,
                                                                      //       decoration: BoxDecoration(
                                                                      //         borderRadius: BorderRadius.circular(20.0),
                                                                      //         color: AppTheme.badgeBgSecond,
                                                                      //       ),
                                                                      //       child: Padding(
                                                                      //         padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
                                                                      //         child: Text('Partially refunded',
                                                                      //           style: TextStyle(
                                                                      //               fontSize: 13,
                                                                      //               fontWeight: FontWeight.w500,
                                                                      //               color: Colors.Colors.white
                                                                      //           ),
                                                                      //         ),
                                                                      //       ),
                                                                      //     ),
                                                                      //   ),


                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 15.0, bottom: 1),
                                                          child: Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Text('MMK ', style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w500,
                                                                )),
                                                                SizedBox(width: 10),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_rounded,
                                                                  size: 16,
                                                                  color: Colors.blueGrey.withOpacity(0.8),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }
                                                return Container();
                                              }
                                          );
                                        },
                                        // Builds 1000 ListTiles
                                        childCount: snapshot.data!.docs.length,
                                      ),
                                    )
                                  ],
                                );
                              }
                              return Container();
                            }
                        ),
                      )

                    ]
                );
              }
              return Container();
            }),
      ),
    );
  }

  _animateToIndex(i) {
    // print((_width * i).toString() + ' BBB ' + cateScCtler.offset.toString() + ' BBB ' + cateScCtler.position.maxScrollExtent.toString());
    if((_width * i) > cateScCtler.position.maxScrollExtent) {
      cateScCtler.animateTo(cateScCtler.position.maxScrollExtent, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    } else {
      cateScCtler.animateTo(_width * i, duration: Duration(microseconds: 100000), curve: Curves.fastOutSlowIn);
    }

  }
}






zeroToTen(String string) {
  if (int.parse(string) > 9) {
    return string;
  } else {
    return '0' + string;
  }
}
