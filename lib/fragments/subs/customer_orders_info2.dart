
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

import '../../app_theme.dart';
import 'customer_info.dart';
import 'order_info.dart';


class CustomerOrdersInfoSubs extends StatefulWidget {
  const CustomerOrdersInfoSubs({Key? key, required this.id, required this.shopId});
  final String id;
  final String shopId;

  @override
  _CustomerOrdersInfoSubsState createState() => _CustomerOrdersInfoSubsState();
}

class _CustomerOrdersInfoSubsState extends State<CustomerOrdersInfoSubs> {
  List<String> prodFieldsValue = [];
  static final _formKey = GlobalKey<FormState>();


  final cateScCtler = ScrollController();
  final _customScrollViewCtl = ScrollController();
  final _width = 10.0;
  int cateScIndex = 0;
  List<String> subList = [];

  var sectionList3;

  int limitToLast = 6;

  bool loadingDone = true;

  int ayinLength = 0;

  bool endOfResult = false;

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
                            stream: FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('order')
                            // .where('date', isLessThanOrEqualTo: lossDayStart())
                            // .where('date', isGreaterThanOrEqualTo: lossDayEnd())
                                .orderBy('date', descending: true)
                            .limit(limitToLast)
                                .snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              // loadingDone = false;
                              if(snapshot.hasData) {


                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection('shops').doc(widget.shopId).collection('order')
                                    // .where('date', isLessThanOrEqualTo: lossDayStart())
                                    // .where('date', isGreaterThanOrEqualTo: lossDayEnd())
                                        .orderBy('date', descending: false)
                                        .limit(1)
                                        .snapshots(),
                                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshotLast) {
                                    if(snapshotLast.hasData) {
                                      Future.delayed(const Duration(milliseconds: 1000), () {
                                        loadingDone = true;
                                      });
                                      // loadingDone = true;
                                      var sections = List<ExampleSection>.empty(growable: true);
                                      int docInc = 0;
                                      print('HHHEEEE' + snapshot.data!.docs.length.toString() + ' ');
                                      print('Last ' + snapshot.data!.docs[0].id.toString());


                                      // snapshot.data!.docs.map((document) async {
                                      //   document['date']
                                      // }).toList();


                                      if(docInc>0) {

                                      }

                                      //var ayinDoc = snapshot.data!.docs[0].data();



                                      if(snapshot.data!.docs.length>0) {
                                        Map<String, dynamic> data21 = snapshot.data!.docs[0].data()! as Map<String, dynamic>;
                                        var ayinDoc = data21['date'];



                                        print('here ' + ayinDoc.toDate().day.toString() + ' ' + ayinDoc.toString());

                                        List<String> itemsList = [data21['deviceId'] + data21['orderId'] + '^' + data21['deviceId'] + data21['orderId'] + '^' + data21['total'].toString() + '^' + data21['customerId'] + '^' + 'pf' + '^' + data21['debt'].toString() + '^' + data21['discount'].toString() + '^' + data21['date'].toDate().hour.toString() + '-' + data21['date'].toDate().minute.toString()];

                                        var section = ExampleSection()
                                          ..header = zeroToTen(data21['date'].toDate().month.toString()) + '-' + zeroToTen(data21['date'].toDate().day.toString())
                                        // ..items = List.generate(int.parse(document['length']), (index) => document.id)
                                        //   ..items = listCreation(document.id, document['data'], document).cast<String>()

                                        //   ..items = document['daily_order'].cast<String>()


                                          ..items = itemsList
                                        // ..items = orderItems(document.id)
                                          ..expanded = true;

                                        if(snapshot.data!.docs.length == 1) {
                                          sections.add(section);
                                        } else {
                                          for(int a = 1; a < snapshot.data!.docs.length; a++) {
                                            Map<String, dynamic> data21Loop = snapshot.data!.docs[a].data()! as Map<String, dynamic>;
                                            // var ayinDocLoo = data21Loop['date'];

                                            print('CCC ' + data21['date'].toDate().toString() + ' ' + data21Loop['date'].toDate().toString());
                                            if(!(data21['date'].toDate().day.toString() == data21Loop['date'].toDate().day.toString() && data21['date'].toDate().month.toString() == data21Loop['date'].toDate().month.toString())) {
                                              print('not equal');
                                              sections.add(section);
                                              itemsList = [];
                                              if(a == snapshot.data!.docs.length-1) {
                                                section = ExampleSection()
                                                  ..header = zeroToTen(data21Loop['date'].toDate().month.toString()) + '-' + zeroToTen(data21Loop['date'].toDate().day.toString())
                                                  ..items = [data21Loop['deviceId'] + data21Loop['orderId'] + '^' + data21Loop['deviceId'] + data21Loop['orderId'] + '^' + data21Loop['total'].toString() + '^' + data21Loop['customerId'] + '^' + 'pf' + '^' + data21Loop['debt'].toString() + '^' + data21Loop['discount'].toString() + '^' + data21Loop['date'].toDate().hour.toString() + '-' + data21Loop['date'].toDate().minute.toString()]
                                                // ..items = orderItems(document.id)
                                                  ..expanded = true;
                                                sections.add(section);
                                                break;
                                              }
                                            } else {
                                              // itemsList.add(data21Loop['title']);
                                              section = ExampleSection()
                                                ..header = zeroToTen(data21Loop['date'].toDate().month.toString()) + '-' + zeroToTen(data21Loop['date'].toDate().day.toString())
                                                ..items = itemsList
                                              // ..items = orderItems(document.id)
                                                ..expanded = true;
                                            }

                                            if(a == snapshot.data!.docs.length-1) {
                                              sections.add(section);
                                            }

                                            data21 = snapshot.data!.docs[a].data()! as Map<String, dynamic>;
                                            itemsList.add(data21Loop['deviceId'] + data21Loop['orderId'] + '^' + data21Loop['deviceId'] + data21Loop['orderId'] + '^' + data21Loop['total'].toString() + '^' + data21Loop['customerId'] + '^' + 'pf' + '^' + data21Loop['debt'].toString() + '^' + data21Loop['discount'].toString() + '^' + data21Loop['date'].toDate().hour.toString() + '-' + data21Loop['date'].toDate().minute.toString());
                                            section = ExampleSection()
                                              ..header = zeroToTen(data21Loop['date'].toDate().month.toString()) + '-' + zeroToTen(data21Loop['date'].toDate().day.toString())
                                            // ..items = List.generate(int.parse(document['length']), (index) => document.id)
                                            //   ..items = listCreation(document.id, document['data'], document).cast<String>()

                                            //   ..items = document['daily_order'].cast<String>()


                                              ..items = itemsList
                                            // ..items = orderItems(document.id)
                                              ..expanded = true;
                                          }
                                        }
                                      }


                                      sectionList3 = sections;
                                      return NotificationListener<ScrollUpdateNotification>(
                                        onNotification: (notification) {
                                          // _customScrollViewCtl.sc
                                          //How many pixels scrolled from pervious frame
                                          print('delta ' + notification.scrollDelta.toString());

                                          //List scroll position
                                          print('pixels ' + notification.metrics.pixels.toString() + ' ' + _customScrollViewCtl.position.maxScrollExtent.toString());

                                          if(loadingDone) {
                                            if(snapshot.data!.docs.length >= 6) {
                                              if(notification.metrics.pixels >= _customScrollViewCtl.position.maxScrollExtent) {
                                                print('on loading ' + limitToLast.toString());

                                                // setState(() {
                                                //   limitToLast += 6;
                                                //   loadingDone = false;
                                                // });
                                                if(ayinLength == snapshot.data!.docs.length) {
                                                  setState(() {
                                                    endOfResult = true;
                                                  });
                                                } else {
                                                  ayinLength = snapshot.data!.docs.length;
                                                  Future.delayed(const Duration(milliseconds: 1000), () {
                                                    setState(() {
                                                      limitToLast += 6;
                                                    });
                                                  });
                                                }

                                                loadingDone = false;

                                              }
                                            }

                                          }

                                          return true;
                                        },
                                        child: CustomScrollView(
                                          controller: _customScrollViewCtl,
                                          slivers: <Widget>[
                                            SliverAppBar(
                                              elevation: 0,
                                              backgroundColor: Colors.white,
                                              automaticallyImplyLeading: false,

                                              // Provide a standard title.

                                              // Allows the user to reveal the app bar if they begin scrolling
                                              // back up the list of items.
                                              floating: true,
                                              bottom: PreferredSize(                       // Add this code
                                                preferredSize: Size.fromHeight(-2.0),      // Add this code
                                                child: Container(),                           // Add this code
                                              ),
                                              flexibleSpace: Padding(
                                                padding: const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 0.0),
                                                child: Container(
                                                  height: 32,
                                                  width: MediaQuery.of(context).size.width,
                                                  // color: Colors.yellow,
                                                  child: Row(
                                                    children: [
                                                      // Row(
                                                      //   children: [
                                                      //     FlatButton(
                                                      //       padding: EdgeInsets.only(left: 10, right: 10),
                                                      //       color: AppTheme.secButtonColor,
                                                      //       shape: RoundedRectangleBorder(
                                                      //         borderRadius: BorderRadius.circular(8.0),
                                                      //         side: BorderSide(
                                                      //           color: AppTheme.skBorderColor2,
                                                      //         ),
                                                      //       ),
                                                      //       onPressed: () {
                                                      //         // _showDatePicker(OneContext().context);
                                                      //       },
                                                      //       child: Container(
                                                      //         child: Row(
                                                      //           // mainAxisAlignment: Main,
                                                      //           children: [
                                                      //             Padding(
                                                      //               padding: const EdgeInsets.only(right: 1.0),
                                                      //               child: Icon(
                                                      //                 Icons.calendar_view_day_rounded,
                                                      //                 size: 18,
                                                      //               ),
                                                      //             ),
                                                      //             Text(
                                                      //               'date',
                                                      //               textAlign: TextAlign.center,
                                                      //               style: TextStyle(
                                                      //                   fontSize: 14,
                                                      //                   fontWeight: FontWeight.w500,
                                                      //                   color: Colors.black),
                                                      //             ),
                                                      //           ],
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //     SizedBox(width: 12),
                                                      //     Container(
                                                      //       color: Colors.grey.withOpacity(0.2),
                                                      //       width: 1.5,
                                                      //       height: 30,
                                                      //     )
                                                      //   ],
                                                      // ),
                                                      Expanded(
                                                        child: ListView(
                                                          controller: cateScCtler,
                                                          scrollDirection: Axis.horizontal,
                                                          children: [
                                                            SizedBox(
                                                              width: 4,
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
                                                                    'Alls',
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
                                                                    'Unpaids',
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
                                                                    'Refunds',
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
                                                                    'Paids',
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
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),

                                                ),
                                              ),
                                              // Display a placeholder widget to visualize the shrinking size.
                                              // Make the initial height of the SliverAppBar larger than normal.
                                              expandedHeight: 20,
                                            ),
                                            SliverExpandableList(
                                              builder: SliverExpandableChildDelegate(
                                                sectionList: sectionList3,
                                                headerBuilder: _buildHeader,
                                                itemBuilder: (context, sectionIndex, itemIndex, index) {
                                                  String item = sectionList3[sectionIndex].items[itemIndex];
                                                  int length = sectionList3[sectionIndex].items.length;

                                                  return GestureDetector(
                                                    onTap: () {
                                                      print('Items'+item);
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //       builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {}, shopId: shopId.toString(),)),
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
                                                                            Text('#' + item.split('^')[1],
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
                                                                            // Text(convertToHour(item.split('^')[0]) + ':' + item.split('^')[0].substring(10,12) +' ' + convertToAMPM(item.split('^')[0]),
                                                                            //   style: TextStyle(
                                                                            //     fontSize: 14,
                                                                            //     fontWeight: FontWeight.w500,
                                                                            //     color: Colors.grey,
                                                                            //   ),
                                                                            // ),
                                                                            // Text(item.split('^')[7],
                                                                            //   style: TextStyle(
                                                                            //     fontSize: 14,
                                                                            //     fontWeight: FontWeight.w500,
                                                                            //     color: Colors.grey,
                                                                            //   ),
                                                                            // ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: 6,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(item.split('^')[3].split('&')[0], style: TextStyle(
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
                                                                      if(item.split('^')[5] == '0.0')
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

                                                                      if(item.split('^')[5] != '0.0' && double.parse(item.split('^')[2]) > double.parse(item.split('^')[5]))
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
                                                                      if(item.split('^')[5] != '0.0'  && double.parse(item.split('^')[2]) == double.parse(item.split('^')[5]))
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
                                                                      if(item.split('^')[4][0] == 'r')
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

                                                                      if(item.split('^')[4][0] == 's')
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
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 15.0, bottom: 5),
                                                          child: Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w500,
                                                                )),
                                                                SizedBox(width: 10),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(bottom: 2.0),
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_forward_ios_rounded,
                                                                    size: 16,
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.8),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );

                                                  // return Container(
                                                  //   child: Text(item)
                                                  // );
                                                },
                                              ),
                                            ),
                                            !endOfResult ? SliverAppBar(
                                              elevation: 0,
                                              toolbarHeight: 4,
                                              collapsedHeight: 4,
                                              backgroundColor: Colors.white,
                                              automaticallyImplyLeading: false,

                                              // Provide a standard title.

                                              // Allows the user to reveal the app bar if they begin scrolling
                                              // back up the list of items.
                                              floating: true,
                                              flexibleSpace: Container(
                                                // color: Colors.green,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 0.0, top: 0.0, bottom: 0.0, right: 0),
                                                  child: LinearProgressIndicator(color: Colors.transparent, valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.themeColor), backgroundColor: Colors.transparent,),
                                                ),
                                              ),
                                              // Display a placeholder widget to visualize the shrinking size.
                                              // Make the initial height of the SliverAppBar larger than normal.
                                              expandedHeight: 4,
                                            ): SliverAppBar(
                                              elevation: 0,
                                              toolbarHeight: 20,
                                              collapsedHeight: 20,
                                              backgroundColor: Colors.white,
                                              automaticallyImplyLeading: false,

                                              // Provide a standard title.

                                              // Allows the user to reveal the app bar if they begin scrolling
                                              // back up the list of items.
                                              floating: true,
                                              flexibleSpace: Container(
                                                // color: Colors.green,
                                                child: Padding(
                                                    padding: const EdgeInsets.only(left: 0.0, top: 0.0, bottom: 0.0, right: 0),
                                                    child: Center(child: Text('END OF RESULT'))
                                                ),
                                              ),
                                              // Display a placeholder widget to visualize the shrinking size.
                                              // Make the initial height of the SliverAppBar larger than normal.
                                              expandedHeight: 20,
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return Container();
                                  }
                                );
                              } else {
                                return Container();
                              }

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

  Widget _buildHeader(BuildContext context, int sectionIndex, int index) {
    ExampleSection section = sectionList3[sectionIndex];
    // print('section check '+ sectionList3[sectionIndex].items.length.toString());
    if(sectionList3[sectionIndex].items.length == 0) {
      return Container();
    }
    return InkWell(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                      color: AppTheme.skBorderColor2,
                      width: 1.0),
                )
            ),
            alignment: Alignment.centerLeft,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                height: 33,
                child: Padding(
                  // padding: const EdgeInsets.only(left: 15.0, top: 12, bottom: 0),
                  padding: const EdgeInsets.only(left: 15.0, top: 1, bottom: 0),
                  child: Row(
                    children: [
                      Text(
                        // "TODAY",
                        // checkTest(section.header),
                        convertToDate2(section.header.split('-')[0]) + ' ' + section.header.split('-')[1],
                        //covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                        style: TextStyle(
                            height: 0.8,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: Colors.black
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            // "#30",
                            '#' + sectionList3[sectionIndex].items.length.toString(),
                            // covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
                            style: TextStyle(
                              height: 0.8,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        onTap: () {

          //toggle section expand state
          // setState(() {
          //   section.setSectionExpanded(!section.isSectionExpanded());
          // });
        });
  }

  convertToDate2(String input) {
    switch (input) {
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


class ExampleSection implements ExpandableListSection<String> {
  //store expand state.
  late bool expanded;

  //return item model list.
  late List<String> items;

  //example header, optional
  late String header;

  @override
  List<String> getItems() {
    return items;
  }

  @override
  bool isSectionExpanded() {
    return expanded;
  }

  @override
  void setSectionExpanded(bool expanded) {
    this.expanded = expanded;
  }
}
