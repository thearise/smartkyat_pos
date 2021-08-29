

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smartkyat_pos/fragments/customers_fragment.dart';
import 'package:smartkyat_pos/fragments/home_fragment.dart';
import 'package:smartkyat_pos/fragments/orders_fragment.dart';
import 'package:smartkyat_pos/fragments/products_fragment.dart';
import 'package:smartkyat_pos/fragments/settings_fragment.dart';
import '../app_theme.dart';
import 'TabItem.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage>{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static int currentTab = 0;
  var deviceIdNum = 0;

  List<TabItem> tabs = [
  ];

  @override
  void initState() {

    // list tabs here


    WidgetsFlutterBinding.ensureInitialized();
    setState(() {
      tabs = [
        TabItem(
          tabName: "Champions",
          icon: Icon(
            Icons.add,
          ),
          page: HomeFragment(toggleCoinCallback: () {  },),
        ),
        TabItem(
          tabName: "Items",
          icon: Icon(
            Icons.add,
          ),
          page: OrdersFragment(),
        ),
        TabItem(
          tabName: "Settings",
          icon: Icon(
            Icons.add,
          ),
          page: CustomersFragment(),
        ),
        TabItem(
          tabName: "Settings",
          icon: Icon(
            Icons.add,
          ),
          page: ProductsFragment(toggleCoinCallback: () {  }, toggleCoinCallback2: addProduct),
        ),
      ];
    });

    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }







  // HomePageState() {
  //   // indexing is necessary for proper funcationality
  //   // of determining which tab is active
  //   tabs.asMap().forEach((index, details) {
  //     details.setIndex(index);
  //   });
  // }



  // sets current tab index
  // and update state
  void _selectTab(int index) {
    if (index == currentTab) {
      // pop to first route
      // if the user taps on the active tab
      tabs[index].key.currentState!.popUntil((route) => route.isFirst);
    } else {
      // update the state
      // in order to repaint
      setState(() => currentTab = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: new Drawer(
        child: SafeArea(
          top: true,
          bottom: true,
          child: new Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // MainFragmentState().changeState(1);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ethereals Shop',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Yangon',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.3),
                                  width: 1.0))),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                // child: new Column(children: drawerOptions),
                child: new Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectTab(0);
                          });

                          _scaffoldKey.currentState!.openEndDrawer();

                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: new Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.transparent),
                            height: 55,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                                  child: Icon(
                                    Icons.home_filled,
                                    size: 26,
                                  ),
                                ),
                                Text(
                                  'Home',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectTab(1);
                          });

                          _scaffoldKey.currentState!.openEndDrawer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: new Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.transparent),
                            height: 55,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                                  child: Icon(
                                    Icons.home_filled,
                                    size: 26,
                                  ),
                                ),
                                Text(
                                  'Orders',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectTab(2);
                          });

                          _scaffoldKey.currentState!.openEndDrawer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: new Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.transparent),
                            height: 55,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                                  child: Icon(
                                    Icons.home_filled,
                                    size: 26,
                                  ),
                                ),
                                Text(
                                  'Customers',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectTab(3);
                          });

                          _scaffoldKey.currentState!.openEndDrawer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: new Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.transparent),
                            height: 55,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                                  child: Icon(
                                    Icons.home_filled,
                                    size: 26,
                                  ),
                                ),
                                Text(
                                  'Products',
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ]
                ),
              ),
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
          !await tabs[currentTab].key.currentState!.maybePop();
          if (isFirstRouteInCurrentTab) {
            // if not on the 'main' tab
            if (currentTab != 0) {
              // select 'main' tab
              _selectTab(0);
              // back button handled by app
              return false;
            }
          }
          // let system handle back button if we're on the first route
          return isFirstRouteInCurrentTab;
        },
        // this is the base scaffold
        // don't put appbar in here otherwise you might end up
        // with multiple appbars on one screen
        // eventually breaking the app


        child: Scaffold(
            backgroundColor: Colors.yellow,
            // indexed stack shows only one child
            body: IndexedStack(
              index: currentTab,
              children: tabs.map((e) => e.page).toList(),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.width>900?57:142,
                child: Column(
                  children: [
                    MediaQuery.of(context).size.width>900?Container():Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 15.0),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(
                                  color: AppTheme.skBorderColor2, width: 1.0),
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              addDailyExp(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(10.0),
                                color: AppTheme.secButtonColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:8.0, right: 8.0, bottom: 3.0),
                                        child: Container(child:
                                        Text(
                                          'Go to cart',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(

                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                          ),
                                        )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 57,
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color: AppTheme.skBorderColor2, width: 1.0),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                              ),
                              child: GestureDetector(
                                  onTap: () {
                                    _scaffoldKey.currentState!.openDrawer();
                                  },
                                  child: Icon(
                                    Icons.home_filled,
                                    size: 26,
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                  child: Text(
                                    'Phyo Pyae Sohn',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6)),
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 15.0,
                              ),
                              child: Icon(
                                Icons.circle,
                                color: Colors.green,
                                size: 22,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            // Bottom navigation

        ),
      ),
    );




  }

  List<String> prodList = [];
  addProduct(data) {
    for(var i = 0; i<prodList.length; i++){
      if(prodList[i].split('-')[0]==data.split('-')[0] && prodList[i].split('-')[1]==data.split('-')[1] && prodList[i].split('-')[3]==data.split('-')[3]) {
        data = data.split('-')[0] + '-' +data.split('-')[1] + '-' + data.split('-')[2] + '-' +data.split('-')[3] + '-' + (int.parse(prodList[i].split('-')[4]) + 1).toString();
        prodList[i] = data;
        return;
      }
    }
    setState(() {
      prodList.add(data);
    });
    // print(data);
  }
  addDailyExp(priContext) {
    // myController.clear();
    showModalBottomSheet(
        enableDrag:false,
        isScrollControlled:true,
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                              color: Colors.white.withOpacity(0.5)
                          ),
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
                            child: Column(
                              children: [
                                Container(
                                  height: 85,
                                  decoration: BoxDecoration(

                                      border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.0))
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                              color: Colors.grey.withOpacity(0.3)
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              size: 15,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },

                                          ),
                                        ),
                                        Text(
                                          "Cart",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontFamily: 'capsulesans',
                                              fontWeight: FontWeight.w600
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Container(
                                          width: 35,
                                          height: 35,
                                          // decoration: BoxDecoration(
                                          //     borderRadius: BorderRadius.all(
                                          //       Radius.circular(5.0),
                                          //     ),
                                          //     color: AppTheme.skThemeColor
                                          // ),
                                          // child: IconButton(
                                          //   icon: Icon(
                                          //     Icons.check,
                                          //     size: 20,
                                          //     color: Colors.black,
                                          //   ),
                                          //   onPressed: () {
                                          //
                                          //   },
                                          //
                                          // ),
                                        )

                                      ],
                                    ),
                                  ),
                                ),
                                checkoutCart()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     color: Colors.yellow,
                //     height: 100,
                //   ),
                // )
              ],
            ),
          );

        });
  }


  var counter = 0;
  var orderLoading = false;

  checkoutCart() {
    var width = MediaQuery.of(context).size.width>900?MediaQuery.of(context).size.width*(1.5/3.5):MediaQuery.of(context).size.width;
    return Container(
      height: MediaQuery.of(context).size.height-105,
      width: double.infinity,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // addCounter();/z
                  },
                  child: Container(
                    width: (width/2)-22.5,
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10.0),
                        color: Colors.grey.withOpacity(0.2)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                DateTime now = DateTime.now();
                                CollectionReference daily_order = FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders');
                                var length = 0;
                                setState(() {
                                  orderLoading = true;
                                });

                                print('order creating');


                                FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
                                // FirebaseFirestore.instance.collection('space')
                                    .get()
                                    .then((QuerySnapshot querySnapshot) {

                                  querySnapshot.docs.forEach((doc) {
                                    length += int.parse(doc['daily_order'].length.toString());
                                  });
                                  length=1000+length+1;


                                  //Check new date or not
                                  var dateExist = false;
                                  var dateId = '';

                                  FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
                                  // FirebaseFirestore.instance.collection('space')
                                      .where('date', isEqualTo: now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()))
                                      .get()
                                      .then((QuerySnapshot querySnapshot) {

                                    querySnapshot.docs.forEach((doc) {
                                      dateExist = true;
                                      dateId = doc.id;
                                    });

                                    if(dateExist) {
                                      daily_order
                                          .doc(dateId).update({
                                        'daily_order': FieldValue.arrayUnion([now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString()+'-'+length.toString() + '^total^name^pf'])
                                      }).then((value) {
                                        print('User updated');
                                        setState(() {
                                          orderLoading = false;
                                        });


                                        FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId).collection('detail')
                                            .doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString())
                                            .set({
                                          'main': 'total',
                                          'subs': ['name'],
                                        })
                                            .then((value) {
                                          print('order added');
                                        });
                                      });
                                    } else {
                                      daily_order
                                          .add({
                                        'daily_order': [now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString()+'-'+length.toString() + '^total^name^pf'],
                                        'date': now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString())
                                      })
                                          .then((value) {
                                        print('order added');


                                        FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(value.id).collection('detail')
                                            .doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString())
                                            .set({
                                          'main': 'total',
                                          'subs': ['name'],
                                        })
                                            .then((value) {
                                          print('order added');
                                        });
                                      });
                                    }
                                  });
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left:8.0, right: 8.0, bottom: 3.0),
                                child: Container(child:
                                Text(
                                  'Clear cart2',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.6)
                                  ),
                                )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.0,),
                Container(
                  width: (width/2)-22.5,
                  height: 55,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(10.0),
                      color: Colors.grey.withOpacity(0.2)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              DateTime now = DateTime.now();
                              print(now.year.toString() + now.month.toString() + now.day.toString() + now.hour.toString() + now.minute.toString() + now.second.toString());

                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left:8.0, right: 8.0, bottom: 3.0),
                              child: Container(child:
                              Text(
                                'More actions',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(0.6)
                                ),
                              )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80.0, left: 0.0, right: 0.0),
            child: Container(
                child: ListView(
                  children: [

                    for(String str in prodList)
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('space')
                            .doc('0NHIS0Jbn26wsgCzVBKT')
                            .collection('shops')
                            .doc('PucvhZDuUz3XlkTgzcjb')
                            .collection('products')
                            .doc(str.split('-')[0])
                            .collection('versions')
                            .doc(str.split('-')[1])
                            .snapshots(),
                        builder: (BuildContext context, snapshot1) {
                          if(snapshot1.hasData) {
                            var output1 = snapshot1.data!.data();
                            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('space')
                                  .doc('0NHIS0Jbn26wsgCzVBKT')
                                  .collection('shops')
                                  .doc('PucvhZDuUz3XlkTgzcjb')
                                  .collection('products')
                                  .doc(str.split('-')[0])
                                  .snapshots(),
                              builder: (BuildContext context, snapshot2) {
                                if(snapshot2.hasData) {
                                  var output2 = snapshot2.data!.data();
                                  return Slidable(
                                    key: const ValueKey(1),
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,

                                    child: Container(
                                      color: Colors.white,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.indigoAccent,
                                          child: Text(str.split('-')[4]),
                                          foregroundColor: Colors.white,
                                        ),
                                        title: Text(
                                          output2?['prod_name'] + ' (' + output2?[str.split('-')[3]] + ')',
                                          style: TextStyle(
                                            height: 1
                                          ),
                                        ),
                                        subtitle: Text(str.split('-')[2] + ' MMK'),
                                        trailing: Text((int.parse(str.split('-')[2])*int.parse(str.split('-')[4])).toString()),
                                      ),
                                    ),
                                    dismissal: SlidableDismissal(
                                      child: SlidableDrawerDismissal(),
                                      onWillDismiss: (actionType) {
                                        print('here');
                                        return true;
                                      },
                                    ),
                                    secondaryActions: <Widget>[
                                      IconSlideAction(
                                        caption: 'Delete',
                                        color: Colors.red,
                                        icon: Icons.delete,
                                        onTap: () => print('Delete'),
                                      ),
                                    ],
                                  );
                                }
                                return Container();
                              },
                            );
                          }
                          return Container();
                        }
                      )


                    // orderLoading?Text('Loading'):Text('')
                  ],
                )
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: AppTheme.skBorderColor2, width: 1.0),
                  )
              ),
              width: double.infinity,
              height: 160,
              child: Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0, bottom: MediaQuery.of(context).padding.bottom + 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        Expanded(child: Container(),),
                        Text(
                          TtlProdListPrice(),
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );



                        // CollectionReference orders = FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc('GhitGLyZLoQekKhan9Xd').collection('detail');
                        // orders
                        //     .add({
                        //   'cust_name': 'U Pyaung'
                        // })
                        //     .then((value) {
                        //   print('order added');
                        //
                        //   FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
                        //   // FirebaseFirestore.instance.collection('space')
                        //       .where('date', isEqualTo: 'saturday')
                        //       .get()
                        //       .then((QuerySnapshot querySnapshot) {
                        //     // querySnapshot.docs.forEach((doc) {
                        //     //   // spaceDocId = doc.id;
                        //     // });some thing 2~IXFrkXcaIzgIbJJCcuu6^hay hay~QM1BYslqNxfeTKwn9vaT^working?~SxLgzSmAdv5Ni6P3lKfR^yeah its worked~V2lfzHGwHH0vZ9hu3Wek
                        //
                        //
                        //
                        //
                        //     querySnapshot.docs.forEach((doc) {
                        //
                        //       FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
                        //           .doc(doc.id)
                        //           .update({'data': doc['data']+'^U Pyaung~'+value.id})
                        //           .then((value) => print("User Updated"))
                        //           .catchError((error) => print("Failed to update user: $error"));
                        //
                        //     });
                        //
                        //   }).then((value) {
                        //   });
                        //
                        //   // Navigator.pop(context);
                        // });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width-30,
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(10.0),
                            color: AppTheme.skThemeColor2
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left:8.0, right: 8.0, bottom: 3.0),
                                  child: Container(
                                      child:
                                      Text(
                                        'Checkout',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  TtlProdListPrice() {
    int total = 0;
    for(String str in prodList) {
      total += int.parse(str.split('-')[2])*int.parse(str.split('-')[4]);
    }
    return total.toString();

  }

  zeroToTen(String string) {
    if(int.parse(string) > 9) {
      return string;
    } else {
      return '0'+string;
    }
  }



}
