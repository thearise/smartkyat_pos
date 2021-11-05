import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/subs/buy_list_info.dart';
import 'package:smartkyat_pos/fragments/subs/order_info.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';

class OrdersFragment extends StatefulWidget {
  OrdersFragment({Key? key}) : super(key: key);

  @override
  _OrdersFragmentState createState() => _OrdersFragmentState();
}

class _OrdersFragmentState extends State<OrdersFragment>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<OrdersFragment> {
  @override
  bool get wantKeepAlive => true;
  var sectionList;
  int _sliding = 0;
  late TabController _controller;
  @override
  initState() {
    _controller = new TabController(length: 2, vsync: this);

    _controller.addListener((){
      print('my index is'+ _controller.index.toString());
      if(_controller.index.toString()=='1') {
        setState(() {
          _sliding = 1;
        });
      } else {
        setState(() {
          _sliding = 0;
        });
      }
    });
    print(convertToDate('20210904').toString());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final cateScCtler = ScrollController();
  final _width = 10.0;
  int cateScIndex = 0;

  @override
  Widget build(BuildContext context) {
    // CollectionReference daily_exps = ;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          top: true,
          bottom: true,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  // padding: const EdgeInsets.only(top: 138.0),
                  padding: const EdgeInsets.only(top: 81.0),
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _controller,
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').orderBy('date', descending: true).snapshots(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if(snapshot.hasData) {
                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('customers').snapshots(),
                                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                                        if(snapshot2.hasData) {
                                          var sections = List<ExampleSection>.empty(growable: true);
                                          // snapshot.data!.docs.map((document) {
                                          // }).toList();

                                          snapshot.data!.docs.map((document) async {

                                            // print('herre ' + document.id);
                                            var section = ExampleSection()
                                              ..header = document['date']
                                            // ..items = List.generate(int.parse(document['length']), (index) => document.id)
                                            //   ..items = listCreation(document.id, document['data'], document).cast<String>()

                                            //   ..items = document['daily_order'].cast<String>()


                                              ..items = sortList(changeData(document['daily_order'].cast<String>(), snapshot2))
                                            // ..items = orderItems(document.id)
                                              ..expanded = true;
                                            sections.add(section);
                                          }).toList();
                                          sectionList = sections;

                                          return CustomScrollView(
                                            slivers: <Widget>[
                                              SliverAppBar(
                                                elevation: 0,
                                                backgroundColor: Colors.white,

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
                                                        Row(
                                                          children: [
                                                            FlatButton(
                                                              padding: EdgeInsets.only(left: 10, right: 10),
                                                              color: AppTheme.secButtonColor,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8.0),
                                                                side: BorderSide(
                                                                  color: AppTheme.skBorderColor2,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                // widget._callback();
                                                              },
                                                              child: Container(
                                                                child: Row(
                                                                  // mainAxisAlignment: Main,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(right: 1.0),
                                                                      child: Icon(
                                                                        Icons.calendar_view_day_rounded,
                                                                        size: 18,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ' Sep, 2021',
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 12),
                                                            Container(
                                                              color: Colors.grey.withOpacity(0.2),
                                                              width: 1.5,
                                                              height: 30,
                                                            )
                                                          ],
                                                        ),
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
                                                  sectionList: sectionList,
                                                  headerBuilder: _buildHeader,
                                                  itemBuilder: (context, sectionIndex, itemIndex, index) {
                                                    String item = sectionList[sectionIndex].items[itemIndex];
                                                    int length = sectionList[sectionIndex].items.length;

                                                    if(itemIndex == length-1) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          // print(item.split('^')[1]);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {})),
                                                          );
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
                                                                                Text(convertToHour(item.split('^')[0]) + ':' + item.split('^')[0].substring(10,12) +' ' + convertToAMPM(item.split('^')[0]),
                                                                                  style: TextStyle(
                                                                                    fontSize: 13,
                                                                                    fontWeight: FontWeight.w400,
                                                                                    color: Colors.grey,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            // Padding(
                                                                            //   padding: const EdgeInsets.only(top: 8.0, bottom: 3.0),
                                                                            //   child: Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2)),
                                                                            // ),
                                                                            SizedBox(
                                                                              height: 6,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text(item.split('^')[3].split('&')[0],
                                                                                  style: TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.grey,
                                                                                  ),),

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
                                                              padding: const EdgeInsets.only(right: 15.0, bottom: 1),
                                                              child: Align(
                                                                alignment: Alignment.centerRight,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Text('MMK ' + double.parse(item.split('^')[2]).toStringAsFixed(2), style: TextStyle(
                                                                      fontSize: 15,fontWeight: FontWeight.w500,
                                                                    )),
                                                                    SizedBox(width: 10),
                                                                    Icon(
                                                                      Icons
                                                                          .arrow_forward_ios_rounded,
                                                                      size: 16,
                                                                      color: Colors
                                                                          .blueGrey
                                                                          .withOpacity(
                                                                          0.8),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                    return GestureDetector(
                                                      onTap: () {
                                                        print('Items'+item);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => OrderInfoSub(data: item, toggleCoinCallback: () {})),
                                                        );
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
                                                                              Text(convertToHour(item.split('^')[0]) + ':' + item.split('^')[0].substring(10,12) +' ' + convertToAMPM(item.split('^')[0]),
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
                                                            padding: const EdgeInsets.only(right: 15.0, bottom: 1),
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
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_forward_ios_rounded,
                                                                    size: 16,
                                                                    color: Colors
                                                                        .blueGrey
                                                                        .withOpacity(
                                                                        0.8),
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
                                              )
                                            ],
                                          );

                                        } else {
                                          return Container();
                                        }
                                      }
                                  );
                                } else {
                                  return Container();
                                }

                              }
                          )
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-MediaQuery.of(context).padding.bottom,
                        width: MediaQuery.of(context).size.width,
                        color: AppTheme.lightBgColor,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('space')
                                .doc('0NHIS0Jbn26wsgCzVBKT')
                                .collection('shops')
                                .doc('PucvhZDuUz3XlkTgzcjb')
                                .collection('buyOrders')
                                .orderBy('date', descending: true)
                                .snapshots(),
                            builder:
                                (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('space')
                                        .doc('0NHIS0Jbn26wsgCzVBKT')
                                        .collection('shops')
                                        .doc('PucvhZDuUz3XlkTgzcjb')
                                        .collection('merchants')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot2) {
                                      if (snapshot2.hasData) {
                                        var sections = List<ExampleSection>.empty(
                                            growable: true);
                                        // snapshot.data!.docs.map((document) {
                                        // }).toList();

                                        snapshot.data!.docs.map((document) async {
                                          // print('herre ' + document.id);
                                          var section = ExampleSection()
                                            ..header = document['date']
                                          // ..items = List.generate(int.parse(document['length']), (index) => document.id)
                                          //   ..items = listCreation(document.id, document['data'], document).cast<String>()
                                            ..items = sortList(changeData2(
                                                document['daily_order']
                                                    .cast<String>(),
                                                snapshot2))
                                          //   ..items = document['daily_order'].cast<String>()
                                            ..expanded = true;
                                          sections.add(section);
                                        }).toList();
                                        sectionList = sections;

                                        return CustomScrollView(
                                          slivers: <Widget>[
                                            SliverExpandableList(
                                              builder:
                                              SliverExpandableChildDelegate(
                                                sectionList: sectionList,
                                                headerBuilder: _buildHeader,
                                                itemBuilder: (context, sectionIndex,
                                                    itemIndex, index) {
                                                  String item =
                                                  sectionList[sectionIndex]
                                                      .items[itemIndex];
                                                  int length =
                                                      sectionList[sectionIndex]
                                                          .items
                                                          .length;

                                                  // CollectionReference daily_exps_inner = FirebaseFirestore.instance
                                                  //     .collection('users')
                                                  //     .doc(FirebaseAuth.instance.currentUser!.uid)
                                                  //     .collection('daily_exp').doc('2021').collection('month').doc('july').collection('day').doc(item).collection('expenses');

                                                  // StreamBuilder(
                                                  //   stream: daily_exps_inner.snapshots(),
                                                  //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot3) {
                                                  //     if(snapshot3.hasData) {
                                                  //
                                                  //     } else {
                                                  //       return Container();
                                                  //     }
                                                  //   },
                                                  // )
                                                  if (itemIndex == length - 1) {
                                                    return Column(
                                                      children: [
                                                        Container(
                                                          color: Colors.white,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              // print(item.split('^')[1]);
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        BuyListInfo(
                                                                            data:
                                                                            item,
                                                                            toggleCoinCallback:
                                                                                () {})),
                                                              );
                                                            },
                                                            child: ListTile(
                                                              // leading: CircleAvatar(
                                                              //   child: Text("$index"),
                                                              // ),
                                                              // title: Text(item.split('^')[1]),
                                                                title: Column(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(item
                                                                        .split('^')[1]),
                                                                    Text(item
                                                                        .split('^')[2]),
                                                                    Row(
                                                                      children: [
                                                                        Text(item
                                                                            .split(
                                                                            '^')[3]
                                                                            .split(
                                                                            '&')[0]),
                                                                        if (item.split(
                                                                            '^')[
                                                                        4][0] ==
                                                                            'r')
                                                                          Text(
                                                                              ' Refunded')
                                                                      ],
                                                                    ),
                                                                    // Text(item,
                                                                    //   style: TextStyle(
                                                                    //     fontSize: 10
                                                                    //   ),
                                                                    // ),
                                                                  ],
                                                                )),
                                                          ),
                                                        ),
                                                        Container(
                                                          color: Colors.white,
                                                          width: double.infinity,
                                                          height: 15,
                                                        )
                                                      ],
                                                    );
                                                  }
                                                  return Container(
                                                    color: Colors.white,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        // print(item.split('^')[1]);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BuyListInfo(
                                                                      data: item,
                                                                      toggleCoinCallback:
                                                                          () {})),
                                                        );
                                                      },
                                                      child: ListTile(
                                                        // leading: CircleAvatar(
                                                        //   child: Text("$index"),
                                                        // ),
                                                        // title: Text(item.split('^')[1]),
                                                          title: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(item.split('^')[1]),
                                                              Text(item.split('^')[2]),
                                                              Row(
                                                                children: [
                                                                  Text(item
                                                                      .split('^')[3]
                                                                      .split('&')[0]),
                                                                  if (item.split('^')[4]
                                                                  [0] ==
                                                                      'r')
                                                                    Text(' Refunded')
                                                                ],
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        );
                                      } else {
                                        return Container();
                                      }
                                    });
                              } else {
                                return Container();
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(
                                color: AppTheme.skBorderColor2,
                                width: 1.0),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 15.0, right: 15.0, bottom: 15),
                        child: GestureDetector(
                          onTap: () {
                            // addDailyExp(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: AppTheme.secButtonColor,
                            ),
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 11.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20.0,
                                    ),
                                    child: Icon(
                                      SmartKyat_POS.search,
                                      size: 17,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          bottom: 1.0),
                                      child: Container(
                                          child: Text(
                                            'Search',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          )
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 18.0,
                                    ),
                                    // child: Icon(
                                    //   SmartKyat_POS.barcode,
                                    //   color: Colors.Colors.black,
                                    //   size: 25,
                                    // ),
                                    child: Container(
                                        child: Image.asset('assets/system/barcode.png', height: 28,)
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       border: Border(
                    //         bottom: BorderSide(
                    //           // color: AppTheme.skBorderColor2,
                    //             color: Colors.white,
                    //             width: 1.0),
                    //       )),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 15.0, right: 15.0),
                    //           child: SizedBox(
                    //             width: double.infinity,
                    //             child: CupertinoSlidingSegmentedControl(
                    //                 children: {
                    //                   0: Text('Sale orders'),
                    //                   1: Text('Buy orders'),
                    //                 },
                    //                 groupValue: _sliding,
                    //                 onValueChanged: (newValue) {
                    //                   setState(() {
                    //                     _sliding = int.parse(newValue.toString());
                    //                   });
                    //                   if(int.parse(newValue.toString()) == 1) {
                    //                     _controller.animateTo(1);
                    //                   } else {
                    //                     _controller.animateTo(0);
                    //                   }
                    //                 }),
                    //           ),
                    //         ),
                    //       ),
                    //       // Container(
                    //       //   width: 100,
                    //       // )
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  changeData(list, snpsht) {
    // list[0].toString()
    snpsht.data!.docs.map((document) async {
      for (var i = 0; i < list.length; i++) {
        if (document.id.toString() == list[i].split('^')[3]) {
          list[i] = list[i].split('^')[0] +
              '^' +
              list[i].split('^')[1] +
              '^' +
              list[i].split('^')[2] +
              '^' +
              document['customer_name'].toString() +
              '&' +
              list[i].split('^')[3] +
              '^' +
              list[i].split('^')[4] +
              '^' +
              list[i].split('^')[5] +
              '^' +
              list[i].split('^')[6]
          ;
        }
      }
      // print('changeData ' + document['customer_name'].toString() + list[0].toString());
    }).toList();

    // print('changeData ' + snpsht.da);
    return list;
  }

  changeData2(list, snpsht) {
    // list[0].toString()
    snpsht.data!.docs.map((document) async {
      for (var i = 0; i < list.length; i++) {
        if (document.id.toString() == list[i].split('^')[3]) {
          list[i] = list[i].split('^')[0] +
              '^' +
              list[i].split('^')[1] +
              '^' +
              list[i].split('^')[2] +
              '^' +
              // document['customer_name'].toString() +
              '&' +
              list[i].split('^')[3] +
              '^' +
              list[i].split('^')[4];
        }
      }
      // print('changeData ' + document['customer_name'].toString() + list[0].toString());
    }).toList();

    // print('changeData ' + snpsht.da);
    return list;
  }

  sortList(list) {
    var dlist = list;
    dlist.sort();
    var newList = List.from(dlist.reversed);
    // dlist.sort((a, b) => b.compareTo(a));
    return newList.cast<String>();
    // list.sort(alphabetic('name'));
  }

  Widget _buildHeader(BuildContext context, int sectionIndex, int index) {
    ExampleSection section = sectionList[sectionIndex];
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
                        covertToDayNum(section.header.substring(6,8)) + ' ' + convertToDate(section.header.toUpperCase()),
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
                            '#' + sectionList[sectionIndex].items.length.toString(),
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

  List<String> gloTemp = [];

  // listCreation(String id, data, document) {
  //   List<String> temp = [];
  //   // temp.add('add');
  //   // temp.add('add2');UzZeGlXAnNfrH7icA1ki
  //
  //   // FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(id).collection('detail')
  //   //     .get()
  //   //     .then((QuerySnapshot querySnapshot) {
  //   //   querySnapshot.docs.forEach((doc) {
  //   //     temp.add(doc["cust_name"]);
  //   //     // setState(() {
  //   //     //   gloTemp = temp;
  //   //     // });
  //   //     // gloTemp = temp;
  //   //   });
  //   //
  //   // }).then((value) {
  //   //   // print('here ' + temp.toString());
  //   //   //return temp;
  //   //   // return gloTemp;
  //   // });
  //   // print('here2 ' + temp.toString());
  //   // return gloTemp;
  //
  //
  //   // for()
  //   // var noExe = true;
  //
  //
  //   temp = data.split('^');
  //
  // }

  addDailyExp(priContext) {
    // myController.clear();
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
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

// List<String> orderItems(String id) {}
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final Container _tabBar;

  @override
  double get minExtent => 101;
  @override
  double get maxExtent => 101;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      height: 200,
      color: Colors.transparent,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

///Section model example
///
///Section model must implements ExpandableListSection<T>, each section has
///expand state, sublist. "T" is the model of each item in the sublist.
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

// print(item.split('^')[0].substring(0,8));
// var dateId = '';
// FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
// // FirebaseFirestore.instance.collection('space')
// .where('date', isEqualTo: item.split('^')[0].substring(0,8))
// .get()
//     .then((QuerySnapshot querySnapshot) {
// querySnapshot.docs.forEach((doc) {
// dateId = doc.id;
// FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId)
//
//     .update({
// 'daily_order': FieldValue.arrayRemove([item])
// })
//     .then((value) {
// print('array removed');
//
// FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId)
//
//     .update({
// 'daily_order': FieldValue.arrayUnion([item.split('^')[0]+'^'+item.split('^')[1]+'^total^name^fp'])
// })
//     .then((value) {
// print('array updated');
// });
//
//
// // FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId).collection('detail')
// // .doc(item.split('^')[0])
// //
// //     .update({
// //   'daily_order': FieldValue.arrayUnion([item.split('^')[0]+'^'+item.split('^')[1]+'^total^name^fp'])
// // })
// //     .then((value) {
// //   print('array updated');
// // });
// // 2021081601575511001^1-1001^total^name^pf
//
// });
// });
// });
