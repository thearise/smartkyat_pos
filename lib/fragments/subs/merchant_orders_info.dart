
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/subs/buy_list_info.dart';

import '../../app_theme.dart';
import 'customer_info.dart';
import 'order_info.dart';


class MerchantOrdersInfoSubs extends StatefulWidget {
  const MerchantOrdersInfoSubs({Key? key, required this.id, required this.shopId});
  final String id;
  final String shopId;

  @override
  _MerchantOrdersInfoSubsState createState() => _MerchantOrdersInfoSubsState();
}

class _MerchantOrdersInfoSubsState extends State<MerchantOrdersInfoSubs> {
  List<String> prodFieldsValue = [];
  static final _formKey = GlobalKey<FormState>();


  final cateScCtler = ScrollController();
  final _width = 10.0;
  int cateScIndex = 0;
  List<String> subList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('shops')
                .doc(widget.shopId)
                .collection('merchants')
                .doc(widget.id.toString())
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                var output = snapshot.data!.data();
                var customerName = output?['merchant_name'];
                var address = output?['merchant_address'];
                var phone = output?['merchant_phone'];
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
                                .collection('shops')
                                .doc(widget.shopId)
                                .collection('merchants')
                                .doc(widget.id)
                                .collection('buyOrders')
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
                                            (context, index) {
                                          Map<String, dynamic> dataP = snapshot.data!.docs[index]
                                              .data()! as Map<String, dynamic>;
                                          var version = snapshot.data!.docs[index].id;
                                          var orderId = dataP['order_id'];
                                          var voucherId = dataP['voucherId'];
                                          var deviceIdNum = dataP['deviceId'];
                                          var debt = dataP['debt'];
                                          var refund = dataP['refund'];
                                          var total = dataP['total'];
                                          var discount = dataP['discount'];
                                          String Refd = 'pf';

                                          if(dataP['refund'] == 'TRUE') {
                                            Refd = 'rf';
                                          }
                                          if(dataP['refund'] == 'PART') {
                                            Refd = 'sf';
                                          }
                                          String items = orderId.toString() + '^' + deviceIdNum.toString() + voucherId.toString() +'^'+ total.toString() +'^'+ customerName.toString() +'&' +widget.id.toString() +'^'+ Refd+'^'+ debt.toString() + '^' + discount.toString();;

                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => BuyListInfo(data: items, toggleCoinCallback: () {},
                                                      shopId: widget.shopId.toString(),)),);
                                              print('Items');
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
                                                                    Text('#' + deviceIdNum.toString() + voucherId,
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
                                                                    Text(convertToHour(orderId.toString()) + ':' + orderId.toString().substring(10,12) +' ' + convertToAMPM(orderId.toString()),
                                                                      style: TextStyle(
                                                                        fontSize: 13,
                                                                        fontWeight: FontWeight.w400,
                                                                        color: Colors.grey,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 6,
                                                                ),

                                                                Text(customerName, style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.grey,
                                                                )),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Row(
                                                            children: [
                                                              if(debt == 0)
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 0.0),
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
                                                              if(debt != 0 && double.parse(total.toString()) > double.parse(debt.toString()))
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 0.0),
                                                                  child: Container(
                                                                    height: 21,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                      color: AppTheme.badgeFgDangerLight,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                                      child: Text('Partially paid',
                                                                        style: TextStyle(
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: AppTheme.badgeFgDanger
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              if(debt != 0 && double.parse(total.toString()) == double.parse(debt.toString()))
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 0.0),
                                                                  child: Container(
                                                                    height: 21,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                      color: AppTheme.badgeFgDanger,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                                      child: Text('Unpaid',
                                                                        style: TextStyle(
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: Colors.white
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              if(refund == 'TRUE')
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 6.0),
                                                                  child: Container(
                                                                    height: 21,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                      color: AppTheme.badgeBgSecond,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(top: 2.5, left: 12.0, right: 12.0),
                                                                      child: Text('Refunded',
                                                                        style: TextStyle(
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: Colors.white
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                              if(refund == 'PART')
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left: 6.0),
                                                                  child: Container(
                                                                    height: 21,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                      color: AppTheme.badgeBgSecondLight,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(top: 2.0, left: 13.0, right: 13.0),
                                                                      child: Text('Partially refunded',
                                                                        style: TextStyle(
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: AppTheme.badgeBgSecond
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                            ],
                                                          ),

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
                                                        Text('MMK '+ total.toString(), style: TextStyle(
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

  covertToDayNum(String input) {
    if(input[0]=='0') {
      return input[1];
    } else {
      return input;
    }
  }

  convertToAMPM(String input){
    switch (input.substring(8,10)) {
      case '00':
        return 'AM';
        break;
      case '01':
        return 'AM';
        break;
      case '02':
        return 'AM';
        break;
      case '03':
        return 'AM';
        break;
      case '04':
        return 'AM';
        break;
      case '05':
        return 'AM';
        break;
      case '06':
        return 'AM';
        break;
      case '07':
        return 'AM';
        break;
      case '08':
        return 'AM';
        break;
      case '09':
        return 'AM';
        break;
      case '10':
        return 'AM';
        break;
      case '11':
        return 'AM';
        break;
      case '12':
        return 'PM';
        break;
      case '13':
        return 'PM';
        break;
      case '14':
        return 'PM';
        break;
      case '15':
        return 'PM';
        break;
      case '16':
        return 'PM';
        break;
      case '17':
        return 'PM';
        break;
      case '18':
        return 'PM';
        break;
      case '19':
        return 'PM';
        break;
      case '20':
        return 'PM';
        break;
      case '21':
        return 'PM';
        break;
      case '22':
        return 'PM';
        break;
      case '23':
        return 'PM';
        break;
    }
  }

  convertToHour(String input){
    switch (input.substring(8,10)) {
      case '00':
        return '12';
        break;
      case '01':
        return '1';
        break;
      case '02':
        return '2';
        break;
      case '03':
        return '3';
        break;
      case '04':
        return '4';
        break;
      case '05':
        return '5';
        break;
      case '06':
        return '6';
        break;
      case '07':
        return '7';
        break;
      case '08':
        return '8';
        break;
      case '09':
        return '9';
        break;
      case '10':
        return '10';
        break;
      case '11':
        return '11';
        break;
      case '12':
        return '12';
        break;
      case '13':
        return '1';
        break;
      case '14':
        return '2';
        break;
      case '15':
        return '3';
        break;
      case '16':
        return '4';
        break;
      case '17':
        return '5';
        break;
      case '18':
        return '6';
        break;
      case '19':
        return '7';
        break;
      case '20':
        return '8';
        break;
      case '21':
        return '9';
        break;
      case '22':
        return '10';
        break;
      case '23':
        return '11';
        break;
    }
  }

  convertToDate(String input) {
    switch (input.substring(4,6)) {
      case '01':
        return 'JANUARY';
        break;
      case '02':
        return 'FEBRUARY';
        break;
      case '03':
        return 'MARCH';
        break;
      case '04':
        return 'APRIL';
        break;
      case '05':
        return 'MAY';
        break;
      case '06':
        return 'JUN';
        break;
      case '07':
        return 'JULY';
        break;
      case '08':
        return 'AUGUST';
        break;
      case '09':
        return 'SEPTEMBER';
        break;
      case '10':
        return 'OCTOBER';
        break;
      case '11':
        return 'NOVEMBER';
        break;
      case '12':
        return 'DECEMBER';
        break;
    }
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
