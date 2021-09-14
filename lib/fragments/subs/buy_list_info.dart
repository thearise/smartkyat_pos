import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smartkyat_pos/fragments/choose_store_fragment.dart';

import '../../app_theme.dart';
import 'buy_list_refund.dart';

class BuyListInfo extends StatefulWidget {
  final _callback;
  const BuyListInfo(
      {Key? key, required this.data, required void toggleCoinCallback()})
      : _callback = toggleCoinCallback;
  final String data;

  @override
  _BuyListInfoState createState() => _BuyListInfoState();
}

class _BuyListInfoState extends State<BuyListInfo>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<BuyListInfo> {
  @override
  bool get wantKeepAlive => true;
  var docId = '';

  @override
  initState() {
    var innerId = '';
    FirebaseFirestore.instance
        .collection('space')
        .doc('0NHIS0Jbn26wsgCzVBKT')
        .collection('shops')
        .doc('PucvhZDuUz3XlkTgzcjb')
        .collection('buyOrders')
        // FirebaseFirestore.instance.collection('space')
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

  // Future orderDateId(data) async {
  //   // var docId = '';
  //   FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
  //   // FirebaseFirestore.instance.collection('space')
  //       .where('date', isEqualTo: data.split('^')[0].substring(0,8))
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //       querySnapshot.docs.forEach((doc) {
  //         docId = doc.id;
  //       });
  //       return docId;
  //     // return Container();
  //   });
  // }

  int totalPrice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(//crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisAlignment: MainAxisAlignment.end,
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
                        totalPrice = 0;
                        print(totalPrice.toString() +
                            'totalPrice ' +
                            prodList.toString());
                        for (String str in prodList) {
                          totalPrice += int.parse(str.split('-')[1]) *
                              (int.parse(str.split('-')[2]) -
                                  int.parse(str.split('-')[6]));
                        }
                        return Container(
                          height: 520,
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
                                      borderRadius: BorderRadius.circular(7.0),
                                      side: BorderSide(
                                        color: AppTheme.skThemeColor,
                                      ),
                                    ),
                                    onPressed: () async {
                                      var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BuyListRefund(
                                                data: widget.data
                                                        .split('^')[0] +
                                                    '^' +
                                                    widget.data.split('^')[1] +
                                                    '^' +
                                                    totalPrice.toString() +
                                                    '^' +
                                                    widget.data.split('^')[3] +
                                                    '^' +
                                                    widget.data.split('^')[4],
                                                toggleCoinCallback: () {})),
                                      );
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
                              Text(totalPrice.toString()),

                              StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: FirebaseFirestore.instance
                                      .collection('space')
                                      .doc('0NHIS0Jbn26wsgCzVBKT')
                                      .collection('shops')
                                      .doc('PucvhZDuUz3XlkTgzcjb')
                                      .collection('merchants')
                                      .doc(widget.data
                                          .split('^')[3]
                                          .split('&')[1])
                                      .snapshots(),
                                  builder: (BuildContext context, snapshot2) {
                                    if (snapshot2.hasData) {
                                      var output1 = snapshot2.data!.data();
                                      var mainUnit = output1?['merchant_name'];
                                      return Text(mainUnit.toString());
                                    }
                                    return Container();
                                  }),

                              for (int i = 0; i < prodList.length; i++)
                                if (prodList[i].split('-')[2] !=
                                    prodList[i].split('-')[6])
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
                                    builder: (BuildContext context, snapshot2) {
                                      if (snapshot2.hasData) {
                                        var output2 = snapshot2.data!.data();

                                        return Slidable(
                                          key: UniqueKey(),
                                          actionPane:
                                              SlidableDrawerActionPane(),
                                          actionExtentRatio: 0.25,
                                          child: Container(
                                            color: Colors.white,
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    Colors.indigoAccent,
                                                child: Text((int.parse(
                                                            prodList[i].split(
                                                                '-')[2]) -
                                                        int.parse(prodList[i]
                                                            .split('-')[6]))
                                                    .toString()),
                                                foregroundColor: Colors.white,
                                              ),
                                              title: Text(
                                                output2?['prod_name'] +
                                                    ' (' +
                                                    output2?[prodList[i]
                                                        .split('-')[4]] +
                                                    ')',
                                                style: TextStyle(height: 1),
                                              ),
                                              subtitle: Text(
                                                  prodList[i].split('-')[1] +
                                                      ' MMK'),
                                              trailing: Text((int.parse(
                                                          prodList[i]
                                                              .split('-')[1]) *
                                                      (int.parse(prodList[i]
                                                              .split('-')[2]) -
                                                          int.parse(prodList[i]
                                                              .split('-')[6])))
                                                  .toString()),
                                            ),
                                          ),
                                          dismissal: SlidableDismissal(
                                            child: SlidableDrawerDismissal(),
                                            onDismissed: (actionType) {
                                              // print('here');
                                              // int tt = 0;
                                              // prodList.removeAt(i);
                                              // for(String str in prodList) {
                                              //   tt += int.parse(str.split('-')[2])*int.parse(str.split('-')[4]);
                                              // }
                                              // // return total.toString();
                                              //
                                              // mystate(() {
                                              //   total = tt.toString();
                                              // });

                                              // mystate(() {
                                              //   prodList.removeAt(i);
                                              // });
                                            },
                                          ),
                                          secondaryActions: <Widget>[
                                            IconSlideAction(
                                              caption: 'Delete',
                                              color: Colors.red,
                                              icon: Icons.delete,
                                              onTap: () {},
                                            ),
                                          ],
                                        );
                                      }
                                      return Container();
                                    },
                                  ),

                              Text('Returns'),

                              for (int i = 0; i < prodList.length; i++)
                                if (prodList[i].split('-')[6] != '0')
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
                                    builder: (BuildContext context, snapshot2) {
                                      if (snapshot2.hasData) {
                                        var output2 = snapshot2.data!.data();
                                        return Slidable(
                                          key: UniqueKey(),
                                          actionPane:
                                              SlidableDrawerActionPane(),
                                          actionExtentRatio: 0.25,
                                          child: Container(
                                            color: Colors.white,
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    Colors.indigoAccent,
                                                child: Text(
                                                    prodList[i].split('-')[6]),
                                                foregroundColor: Colors.white,
                                              ),
                                              title: Text(
                                                output2?['prod_name'] +
                                                    ' (' +
                                                    output2?[prodList[i]
                                                        .split('-')[4]] +
                                                    ')',
                                                style: TextStyle(height: 1),
                                              ),
                                              subtitle: Text(
                                                  prodList[i].split('-')[1] +
                                                      ' MMK'),
                                              trailing: Text((int.parse(
                                                          prodList[i]
                                                              .split('-')[1]) *
                                                      int.parse(prodList[i]
                                                          .split('-')[6]))
                                                  .toString()),
                                            ),
                                          ),
                                          dismissal: SlidableDismissal(
                                            child: SlidableDrawerDismissal(),
                                            onDismissed: (actionType) {
                                              // print('here');
                                              // int tt = 0;
                                              // prodList.removeAt(i);
                                              // for(String str in prodList) {
                                              //   tt += int.parse(str.split('-')[2])*int.parse(str.split('-')[4]);
                                              // }
                                              // // return total.toString();
                                              //
                                              // mystate(() {
                                              //   total = tt.toString();
                                              // });

                                              // mystate(() {
                                              //   prodList.removeAt(i);
                                              // });
                                            },
                                          ),
                                          secondaryActions: <Widget>[
                                            IconSlideAction(
                                              caption: 'Delete',
                                              color: Colors.red,
                                              icon: Icons.delete,
                                              onTap: () {},
                                            ),
                                          ],
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

              // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              //     stream: FirebaseFirestore.instance
              //         .collection('space')
              //         .doc('0NHIS0Jbn26wsgCzVBKT')
              //         .collection('shops')
              //         .doc('PucvhZDuUz3XlkTgzcjb')
              //         .collection('products')
              //         .doc(widget.idString)
              //         .snapshots(),
              //     builder: (BuildContext context,snapshot2) {
              //       if (snapshot2.hasData) {
              //         var output1 = snapshot2.data!.data();
              //         var mainUnit = output1 ? ['unit_name'];
              //         var sub1Unit = output1 ? ['sub1_name'];
              //         var sub2Unit = output1 ? ['sub2_name'];
              //         var sub3Unit = output1 ? ['sub3_name'];
              //         return Column(
              //           crossAxisAlignment: CrossAxisAlignment.stretch,
              //           children: [
              //             Container(
              //               height: 70,
              //               decoration: BoxDecoration(
              //                   border: Border(
              //                       bottom: BorderSide(
              //                           color: Colors.grey.withOpacity(0.3), width: 1.0))),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Container(
              //                     width: 35,
              //                     height: 35,
              //                     decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.all(
              //                           Radius.circular(5.0),
              //                         ),
              //                         color: Colors.grey.withOpacity(0.3)),
              //                     child: IconButton(
              //                         icon: Icon(
              //                           Icons.arrow_back_ios_rounded,
              //                           size: 16,
              //                           color: Colors.black,
              //                         ),
              //                         onPressed: () {
              //                           Navigator.pop(context);
              //                         }),
              //                   ),
              //                   Text(
              //                     'Version Details',
              //                     style: TextStyle(
              //                       fontSize: 20,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                   ),
              //                   Container(
              //                     width: 35,
              //                     height: 35,
              //                     decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.all(
              //                           Radius.circular(5.0),
              //                         ),
              //                         color: AppTheme.skThemeColor2),
              //                     child: IconButton(
              //                         icon: Icon(
              //                           Icons.check,
              //                           size: 20,
              //                           color: Colors.white,
              //                         ),
              //                         onPressed: () {
              //                           Navigator.pop(context);
              //                         }),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             SizedBox(height: 20,),
              //             Padding(
              //               padding: const EdgeInsets.only(right: 120.0),
              //               child: ButtonTheme(
              //                 //minWidth: 50,
              //                 splashColor: Colors.transparent,
              //                 height: 120,
              //                 child: FlatButton(
              //                   color: AppTheme.skThemeColor,
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(7.0),
              //                     side: BorderSide(
              //                       color: AppTheme.skThemeColor,
              //                     ),
              //                   ),
              //                   onPressed: () async {
              //                     final result = await showModalActionSheet<String>(
              //                       context: context,
              //                       actions: [
              //                         SheetAction(
              //                           icon: Icons.info,
              //                           label: '1 ' + mainUnit,
              //                           key: widget.idString + '-' + widget.versionID + '-' + mainPrice + '-unit_name-1',
              //                         ),
              //                         if(sub1Unit!='')
              //                           SheetAction(
              //                             icon: Icons.info,
              //                             label: '1 ' + sub1Unit,
              //                             key: widget.idString + '-' + widget.versionID + '-' + sub1Price + '-sub1_name-1',
              //                           ),
              //                         if(sub2Unit!='')
              //                           SheetAction(
              //                             icon: Icons.info,
              //                             label: '1 ' + sub2Unit,
              //                             key: widget.idString + '-' + widget.versionID + '-' + sub2Price + '-sub2_name-1',
              //                           ),
              //                         if(sub3Unit!='')
              //                           SheetAction(
              //                             icon: Icons.info,
              //                             label: '1 ' + sub3Unit,
              //                             key: widget.idString + '-' + widget.versionID + '-' + sub3Price + '-sub3_name-1',
              //                           ),
              //                       ],
              //                     );
              //                     widget._callback(result.toString());
              //                   },
              //                   child: Padding(
              //                     padding: const EdgeInsets.only(right: 120.0),
              //                     child: Column(
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: [
              //                         Icon(
              //                           Icons.add,
              //                           size: 40,
              //                         ),
              //                         SizedBox(
              //                           height: 20,
              //                         ),
              //                         Text(
              //                           'Add to cart',
              //                           style: TextStyle(
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 18,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             Container(
              //               alignment: Alignment.topRight,
              //               child: TextButton(
              //                 onPressed: () {
              //                 },
              //                 child: Text('Edit',
              //                   style: TextStyle(
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 16,
              //                   ),),
              //               ),
              //             ),
              //             Expanded(
              //               child: Container(
              //                 child: ListView(
              //                     children: [
              //                       Container(
              //                         // height: MediaQuery.of(priContext).size.height - MediaQuery.of(priContext).padding.top - 20 - 100,
              //                         width: double.infinity,
              //                         decoration: BoxDecoration(
              //                           borderRadius: BorderRadius.only(
              //                             topLeft: Radius.circular(15.0),
              //                             topRight: Radius.circular(15.0),
              //                           ),
              //                           color: Colors.white,
              //                         ),
              //                         child: Column(
              //                             children: [
              //                               Container(
              //                                 alignment: Alignment.topLeft,
              //                                 child: Text(
              //                                   "MERCHANT",
              //                                   style: TextStyle(
              //                                     fontWeight: FontWeight.bold,
              //                                     fontSize: 16,
              //                                     letterSpacing: 2,
              //                                     color: Colors.grey,
              //                                   ),
              //                                 ),
              //                               ),
              //                               SizedBox(
              //                                 height: 20,
              //                               ),
              //                               Column(
              //                                 crossAxisAlignment: CrossAxisAlignment.start,
              //                                 children: [
              //                                   _productDetails('Merchant Name'),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                     width: MediaQuery.of(context).size.width,
              //                                     child: Text(
              //                                       quantity,
              //                                       style: TextStyle(
              //                                         fontSize: 15,
              //                                         //fontWeight: FontWeight.w500,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                       width: MediaQuery.of(context).size.width,
              //                                       height: 1.5,
              //                                       color: Colors.grey.withOpacity(0.3)
              //                                   ),
              //                                 ],
              //                               ),
              //                               SizedBox(
              //                                 height: 20,
              //                               ),
              //                               Container(
              //                                 alignment: Alignment.topLeft,
              //                                 child: Text(
              //                                   "QUANTITY",
              //                                   style: TextStyle(
              //                                     fontWeight: FontWeight.bold,
              //                                     fontSize: 16,
              //                                     letterSpacing: 2,
              //                                     color: Colors.grey,
              //                                   ),
              //                                 ),
              //                               ),
              //                               SizedBox(
              //                                 height: 20,
              //                               ),
              //                               Column(
              //                                 crossAxisAlignment: CrossAxisAlignment.start,
              //                                 children: [
              //                                   _productDetails('Main Unit Quantity'),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                     width: MediaQuery.of(context).size.width,
              //                                     child: Text(
              //                                       '$quantity $mainUnit',
              //                                       style: TextStyle(
              //                                         fontSize: 15,
              //                                         //fontWeight: FontWeight.w500,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                       width: MediaQuery.of(context).size.width,
              //                                       height: 1.5,
              //                                       color: Colors.grey.withOpacity(0.3)
              //                                   ),
              //                                 ],
              //                               ),
              //                               SizedBox(
              //                                 height: 20,
              //                               ),
              //                               sub1quantity != "" ? Column(
              //                                 crossAxisAlignment: CrossAxisAlignment.start,
              //                                 children: [
              //                                   _productDetails('#1 Sub Unit Quantity'),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                     width: MediaQuery.of(context).size.width,
              //                                     child: Text(
              //                                       '$sub1quantity $sub1Unit',
              //                                       style: TextStyle(
              //                                         fontSize: 15,
              //                                         //fontWeight: FontWeight.w500,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                       width: MediaQuery.of(context).size.width,
              //                                       height: 1.5,
              //                                       color: Colors.grey.withOpacity(0.3)
              //                                   ),
              //                                   SizedBox(height: 20,),
              //                                 ],
              //                               ) : Container(),
              //                               sub2quantity != "" ? Column(
              //                                 crossAxisAlignment: CrossAxisAlignment.start,
              //                                 children: [
              //                                   _productDetails('#2 Sub Unit Quantity'),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                     width: MediaQuery.of(context).size.width,
              //                                     child: Text(
              //                                       '$sub2quantity $sub2Unit',
              //                                       style: TextStyle(
              //                                         fontSize: 15,
              //                                         //fontWeight: FontWeight.w500,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                       width: MediaQuery.of(context).size.width,
              //                                       height: 1.5,
              //                                       color: Colors.grey.withOpacity(0.3)
              //                                   ),
              //                                   SizedBox(height: 20,),
              //                                 ],
              //                               ): Container(),
              //                               sub3quantity != "" ? Column(
              //                                 crossAxisAlignment: CrossAxisAlignment.start,
              //                                 children: [
              //                                   _productDetails('#3 Sub Unit Quantity'),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                     width: MediaQuery.of(context).size.width,
              //                                     child: Text(
              //                                       '$sub3quantity $sub3Unit',
              //                                       style: TextStyle(
              //                                         fontSize: 15,
              //                                         //fontWeight: FontWeight.w500,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                       width: MediaQuery.of(context).size.width,
              //                                       height: 1.5,
              //                                       color: Colors.grey.withOpacity(0.3)
              //                                   ),
              //                                   SizedBox(height: 20,),
              //                                 ],
              //                               ): Container(),
              //                               Container(
              //                                 alignment: Alignment.topLeft,
              //                                 child: Text(
              //                                   "PRICING",
              //                                   style: TextStyle(
              //                                     fontWeight: FontWeight.bold,
              //                                     fontSize: 16,
              //                                     letterSpacing: 2,
              //                                     color: Colors.grey,
              //                                   ),
              //                                 ),
              //                               ),
              //                               SizedBox(
              //                                 height: 25,
              //                               ),
              //                               Column(
              //                                 crossAxisAlignment: CrossAxisAlignment.start,
              //                                 children: [
              //                                   _productDetails('Main Unit Price'),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                     width: MediaQuery.of(context).size.width,
              //                                     child: Text(
              //                                       '$mainPrice MMK',
              //                                       style: TextStyle(
              //                                         fontSize: 15,
              //                                         //fontWeight: FontWeight.w500,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                       width: MediaQuery.of(context).size.width,
              //                                       height: 1.5,
              //                                       color: Colors.grey.withOpacity(0.3)
              //                                   ),
              //                                 ],
              //                               ),
              //                               SizedBox(
              //                                 height: 25,
              //                               ),
              //
              //                               sub1Price != "" ?  Column(
              //                                 crossAxisAlignment: CrossAxisAlignment.start,
              //                                 children: [
              //                                   _productDetails('#1 Sub Unit Price'),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                     width: MediaQuery.of(context).size.width,
              //                                     child: Text(
              //                                       '$sub1Price MMK',
              //                                       style: TextStyle(
              //                                         fontSize: 15,
              //                                         //fontWeight: FontWeight.w500,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                       width: MediaQuery.of(context).size.width,
              //                                       height: 1.5,
              //                                       color: Colors.grey.withOpacity(0.3)
              //                                   ),
              //                                   SizedBox(height: 20,),
              //                                 ],
              //                               ) : Container(),
              //                               sub2Price != "" ?  Column(
              //                                 crossAxisAlignment: CrossAxisAlignment.start,
              //                                 children: [
              //                                   _productDetails('#2 Sub Unit Price'),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                     width: MediaQuery.of(context).size.width,
              //                                     child: Text(
              //                                       '$sub2Price MMK',
              //                                       style: TextStyle(
              //                                         fontSize: 15,
              //                                         //fontWeight: FontWeight.w500,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                       width: MediaQuery.of(context).size.width,
              //                                       height: 1.5,
              //                                       color: Colors.grey.withOpacity(0.3)
              //                                   ),
              //                                   SizedBox(height: 20,),
              //                                 ],
              //                               ) : Container(),
              //                               sub3Price != "" ?  Column(
              //                                 crossAxisAlignment: CrossAxisAlignment.start,
              //                                 children: [
              //                                   _productDetails('#3 Sub Unit Price'),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                     width: MediaQuery.of(context).size.width,
              //                                     child: Text(
              //                                       '$sub3Price MMK',
              //                                       style: TextStyle(
              //                                         fontSize: 15,
              //                                         //fontWeight: FontWeight.w500,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   SizedBox(height:15),
              //                                   Container(
              //                                       width: MediaQuery.of(context).size.width,
              //                                       height: 1.5,
              //                                       color: Colors.grey.withOpacity(0.3)
              //                                   ),
              //                                   SizedBox(height: 20,),
              //                                 ],
              //                               ) : Container(),
              //                             ]
              //                         ),
              //                       ),
              //                     ]
              //                 ),
              //               ),
              //             )
              //           ],
              //         );
              //       }
              //       return Container();
              //     }
              // )
            ]),
          )),
    );
  }

  addDailyExp(priContext) {
    // myController.clear();
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: MediaQuery.of(priContext).padding.top,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                              color: Colors.white.withOpacity(0.5)),
                        ),
                        SizedBox(
                          height: 14,
                        ),
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

                          child: Container(
                            width: 150,
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                    ),
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.transparent,
                                        ),
                                        onPressed: () {},
                                      ),
                                      Text(
                                        "New Expense",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontFamily: 'capsulesans',
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.left,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          print('clicked');
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.yellow,
                    height: 100,
                  ),
                )
              ],
            ),
          );
        });
  }
}
