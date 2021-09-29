import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fraction/fraction.dart';
import 'package:smartkyat_pos/fragments/buy_list_fragment.dart';
import 'package:smartkyat_pos/fonts_dart/smart_kyat__p_o_s_icons.dart';
import 'package:smartkyat_pos/fragments/customers_fragment.dart';
import 'package:smartkyat_pos/fragments/home_fragment.dart';
import 'package:smartkyat_pos/fragments/merchants_fragment.dart';
import 'package:smartkyat_pos/fragments/orders_fragment.dart';
import 'package:smartkyat_pos/fragments/products_fragment.dart';
import 'package:smartkyat_pos/fragments/settings_fragment.dart';
import 'package:smartkyat_pos/pages2/single_assets_page.dart';
import '../app_theme.dart';
import 'TabItem.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static int currentTab = 0;
  var deviceIdNum = 0;

  List<TabItem> tabs = [];

  Animation<double>? _rotationAnimation;
  Color _fabColor = Colors.blue;
  void handleSlideAnimationChanged(Animation<double>? slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool? isOpen) {
    setState(() {
      _fabColor = isOpen! ? Colors.green : Colors.blue;
    });
  }

  List<String> subList = [];
  testFunc() async {
    print('hi');
    CollectionReference users = FirebaseFirestore.instance.collection('test');

    print('gg ');

    FirebaseFirestore.instance.collection('test')
      .get()
      .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // Create a reference to the document the transaction will use
        DocumentReference documentReference = FirebaseFirestore.instance.collection('test').doc(doc.id);

        FirebaseFirestore.instance.runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            throw Exception("User does not exist!");
          }

          Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

          String str = data?['data'];
          str = (int.parse(str) + 1).toString();

          transaction.update(documentReference, {'data': str});

          // Return the new count



        })
            .then((value) => print("Follower count updated to $value"))
            .catchError((error) => print("Failed to update user followers: $error"));

      });
    });
  }

  testLoopData() {


    for(int i=0; i<1; i++) {
      testFunc();
    }
  }

  @override
  void initState() {
    print('home_page' + 'sub1'.substring(3,4));


    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    slidableController1 = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );

    WidgetsFlutterBinding.ensureInitialized();
    setState(() {
      tabs = [
        TabItem(
          tabName: "Champions",
          icon: Icon(
            Icons.add,
          ),
          page: HomeFragment(
            toggleCoinCallback: () {},
          ),
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
          page: CustomersFragment(toggleCoinCallback2: addCustomer2Cart),
        ),
        TabItem(
          tabName: "Settings",
          icon: Icon(
            Icons.add,
          ),
          page: ProductsFragment(
              toggleCoinCallback: addNewProd2,
              toggleCoinCallback2: addProduct,
              toggleCoinCallback3: addProduct3),
        ),
        TabItem(
          tabName: "Settings",
          icon: Icon(
            Icons.add,
          ),
          page: MerchantsFragment(toggleCoinCallback3: addMerchant2Cart),
        ),
        TabItem(
          tabName: "Settings",
          icon: Icon(
            Icons.add,
          ),
          page: BuyListFragment(),
        ),
      ];
    });

    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }

  closeNewProduct() {
    Navigator.pop(context);
  }

  addNewProd2() {
    final List<String> prodFieldsValue = [];
    final _formKey = GlobalKey<FormState>();
    // myController.clear();
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleAssetPage(toggleCoinCallback: closeNewProduct);
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
                    padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
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
                child: new Column(children: [
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
                            color: AppTheme.secButtonColor),
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 10.0),
                              child: Icon(
                                Icons.home_filled,
                                size: 26,
                              ),
                            ),
                            Text(
                              'Home',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
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
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 10.0),
                              child: Icon(
                                Icons.home_filled,
                                size: 26,
                              ),
                            ),
                            Text(
                              'Orders',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
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
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 10.0),
                              child: Icon(
                                Icons.home_filled,
                                size: 26,
                              ),
                            ),
                            Text(
                              'Customers',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
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
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 10.0),
                              child: Icon(
                                Icons.home_filled,
                                size: 26,
                              ),
                            ),
                            Text(
                              'Products',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectTab(4);
                      });

                      _scaffoldKey.currentState!.openEndDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: new Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.transparent),
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 10.0),
                              child: Icon(
                                Icons.home_filled,
                                size: 26,
                              ),
                            ),
                            Text(
                              'Merchants',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectTab(5);
                      });

                      _scaffoldKey.currentState!.openEndDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: new Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.transparent),
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 10.0),
                              child: Icon(
                                Icons.home_filled,
                                size: 26,
                              ),
                            ),
                            Text(
                              'Buy List',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
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
          // backgroundColor: Colors.white,
          // indexed stack shows only one child
            body: IndexedStack(
              index: currentTab,
              children: tabs.map((e) => e.page).toList(),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.width > 900 ? 57 : 142,
                child: Column(
                  children: [
                    MediaQuery.of(context).size.width > 900
                        ? Container()
                        : Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                                color: AppTheme.skBorderColor2,
                                width: 1.0),
                          )
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                        child: Container(
                          height: 50,
                          child: GestureDetector(
                            onTap: () {
                     if (prodList.length == 0) {
                       addDailyExp2(context);
                         } else if(prodList2.length == 0){
                       addDailyExp(context);
                         }},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: AppTheme.buttonColor2,
                                // color: Colors.blue
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 13.0, bottom: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 2.0),
                                        child: Container(
                                            child: Text(
                                              'Go to cart',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
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
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0,top:0.0
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        _scaffoldKey.currentState!.openDrawer();
                                      },
                                      child: Icon(
                                        Icons.home_filled,
                                        size: 26,
                                      )
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 1.0),
                                        child: Text(
                                          'Home',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  child: Text(
                                    '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6)),
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                print('sub ' + subList.toString());
                                testLoopData();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 13.0,top:2.0
                                ),
                                child: Container(
                                    child: Image.asset('assets/system/menu.png', height: 33,)
                                ),
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
  late final SlidableController slidableController;
  addProduct(data) async {
    for (var i = 0; i < prodList.length; i++) {
      if (prodList[i].split('-')[0] == data.split('-')[0] &&
          prodList[i].split('-')[3] == data.split('-')[3]) {
        data = data.split('-')[0] +
            '-' +
            data.split('-')[1] +
            '-' +
            data.split('-')[2] +
            '-' +
            data.split('-')[3] +
            '-' +
            (int.parse(prodList[i].split('-')[4]) + 1).toString();
        prodList[i] = data + '-0';
        return;
      }
    }
    if (data != 'null') {
      prodList.add(data + '-0');
    }
  }

  List<String> prodList2 = [];
  late final SlidableController slidableController1;
  addProduct3(data) {
    if (data != 'null') {
      prodList2.add(data + '-0-');
    }
  }

  String customerId = 'name-name';

  addCustomer2Cart(data) {
    customerId = data.toString();
  }

  String merchantId = 'name-name';

  addMerchant2Cart(data) {
    merchantId = data.toString();
  }

  addString2Sub(data){

    DateTime now =
    DateTime.now();
    CollectionReference
    daily_order =
    FirebaseFirestore
        .instance
        .collection(
        'space')
        .doc(
        '0NHIS0Jbn26wsgCzVBKT')
        .collection(
        'shops')
        .doc(
        'PucvhZDuUz3XlkTgzcjb')
        .collection(
        'buyOrders');
    var length = 0;
    setState(() {
      orderLoading = true;
    });

    print('order creating');

    FirebaseFirestore
        .instance
        .collection('space')
        .doc(
        '0NHIS0Jbn26wsgCzVBKT')
        .collection('shops')
        .doc(
        'PucvhZDuUz3XlkTgzcjb')
        .collection(
        'buyOrders')
    // FirebaseFirestore.instance.collection('space')
        .get()
        .then((QuerySnapshot
    querySnapshot) async {
      querySnapshot.docs
          .forEach((doc) {
        length += int.parse(
            doc['daily_order']
                .length
                .toString());
      });
      length =
          1000 + length + 1;

      //Check new date or not
      var dateExist = false;
      var dateId = '';

      FirebaseFirestore
          .instance
          .collection(
          'space')
          .doc(
          '0NHIS0Jbn26wsgCzVBKT')
          .collection(
          'shops')
          .doc(
          'PucvhZDuUz3XlkTgzcjb')
          .collection(
          'buyOrders')
      // FirebaseFirestore.instance.collection('space')
          .where('date',
          isEqualTo: now
              .year
              .toString() +
              zeroToTen(now
                  .month
                  .toString()) +
              zeroToTen(now
                  .day
                  .toString()))
          .get()
          .then((QuerySnapshot
      querySnapshot) {
        querySnapshot.docs
            .forEach((doc) {
          dateExist = true;
          dateId = doc.id;
        });

        if (dateExist) {
          daily_order
              .doc(dateId)
              .update({
            'daily_order':
            FieldValue
                .arrayUnion([
              now.year.toString() +
                  zeroToTen(now
                      .month
                      .toString()) +
                  zeroToTen(now
                      .day
                      .toString()) +
                  zeroToTen(now
                      .hour
                      .toString()) +
                  zeroToTen(now
                      .minute
                      .toString()) +
                  zeroToTen(now
                      .second
                      .toString()) +
                  deviceIdNum
                      .toString() +
                  length
                      .toString() +
                  '^' +
                  deviceIdNum
                      .toString() +
                  '-' +
                  length
                      .toString() +
                  '^' +
                  TtlProdListPrice2() +
                  '^' +
                  merchantId
                      .split(
                      '-')[0] +
                  '^pf'
            ])
          }).then((value) {
            print(
                'User updated');
            setState(() {
              orderLoading =
              false;
            });

            FirebaseFirestore
                .instance
                .collection(
                'space')
                .doc(
                '0NHIS0Jbn26wsgCzVBKT')
                .collection(
                'shops')
                .doc(
                'PucvhZDuUz3XlkTgzcjb')
                .collection(
                'buyOrders')
                .doc(dateId)
                .collection(
                'expansion')
                .doc(now
                .year
                .toString() +
                zeroToTen(now
                    .month
                    .toString()) +
                zeroToTen(now
                    .day
                    .toString()) +
                zeroToTen(now
                    .hour
                    .toString()) +
                zeroToTen(now
                    .minute
                    .toString()) +
                zeroToTen(now
                    .second
                    .toString()) +
                deviceIdNum
                    .toString() +
                length
                    .toString())
                .set({
              'main':
              'total',
              'subs':
              data,
            }).then((value) {
              print(
                  'order added');
            });
          });
        } else {
          daily_order.add({
            'daily_order': [
              now.year.toString() +
                  zeroToTen(now
                      .month
                      .toString()) +
                  zeroToTen(now
                      .day
                      .toString()) +
                  zeroToTen(now
                      .hour
                      .toString()) +
                  zeroToTen(now
                      .minute
                      .toString()) +
                  zeroToTen(now
                      .second
                      .toString()) +
                  deviceIdNum
                      .toString() +
                  length
                      .toString() +
                  '^' +
                  deviceIdNum
                      .toString() +
                  '-' +
                  length
                      .toString() +
                  '^' +
                  TtlProdListPrice2() +
                  '^' +
                  merchantId
                      .split(
                      '-')[0] +
                  '^pf'
            ],
            'date': now.year
                .toString() +
                zeroToTen(now
                    .month
                    .toString()) +
                zeroToTen(now
                    .day
                    .toString())
          }).then((value) {
            print(
                'order added');

            FirebaseFirestore
                .instance
                .collection(
                'space')
                .doc(
                '0NHIS0Jbn26wsgCzVBKT')
                .collection(
                'shops')
                .doc(
                'PucvhZDuUz3XlkTgzcjb')
                .collection(
                'buyOrders')
                .doc(value
                .id)
                .collection(
                'expansion')
                .doc(now
                .year
                .toString() +
                zeroToTen(now
                    .month
                    .toString()) +
                zeroToTen(now
                    .day
                    .toString()) +
                zeroToTen(now
                    .hour
                    .toString()) +
                zeroToTen(now
                    .minute
                    .toString()) +
                zeroToTen(now
                    .second
                    .toString()) +
                deviceIdNum
                    .toString() +
                length
                    .toString())
                .set({
              'main':
              'total',
              'subs':
              data,
            }).then((value) {
              print(
                  'order added');
            });
          });
        }
      });

    });

  }

  addDailyExp(priContext) {
    // myController.clear();
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              return Scaffold(
                backgroundColor: Colors.grey.withOpacity(0.3),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top + 45,
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
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                color: Colors.white,
                              ),
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  width: 1.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0, top: 0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                    Radius.circular(20.0),
                                                  ),
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
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
                                                  fontWeight: FontWeight.w600),
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
                                    // checkoutCart()
                                    Container(
                                      height:
                                      MediaQuery.of(context).size.height -
                                          105,
                                      width: double.infinity,
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                top: 15.0),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    // addCounter();/z
                                                  },
                                                  child: Container(
                                                    width:
                                                    (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                        2) -
                                                        22.5,
                                                    height: 55,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(10.0),
                                                        color: Colors.grey
                                                            .withOpacity(0.2)),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          top: 15.0,
                                                          bottom: 15.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Expanded(
                                                            child:
                                                            GestureDetector(
                                                              onTap: () {
                                                                mystate(() {
                                                                  prodList = [];
                                                                });
                                                                // DateTime now = DateTime.now();
                                                                // CollectionReference daily_order = FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders');
                                                                // var length = 0;
                                                                // setState(() {
                                                                //   orderLoading = true;
                                                                // });
                                                                //
                                                                // print('order creating');
                                                                //
                                                                //
                                                                // FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
                                                                // // FirebaseFirestore.instance.collection('space')
                                                                //     .get()
                                                                //     .then((QuerySnapshot querySnapshot) {
                                                                //
                                                                //   querySnapshot.docs.forEach((doc) {
                                                                //     length += int.parse(doc['daily_order'].length.toString());
                                                                //   });
                                                                //   length=1000+length+1;
                                                                //
                                                                //
                                                                //   //Check new date or not
                                                                //   var dateExist = false;
                                                                //   var dateId = '';
                                                                //
                                                                //   FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
                                                                //   // FirebaseFirestore.instance.collection('space')
                                                                //       .where('date', isEqualTo: now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()))
                                                                //       .get()
                                                                //       .then((QuerySnapshot querySnapshot) {
                                                                //
                                                                //     querySnapshot.docs.forEach((doc) {
                                                                //       dateExist = true;
                                                                //       dateId = doc.id;
                                                                //     });
                                                                //
                                                                //     if(dateExist) {
                                                                //       daily_order
                                                                //           .doc(dateId).update({
                                                                //         'daily_order': FieldValue.arrayUnion([now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString()+'-'+length.toString() + '^total^name^pf'])
                                                                //       }).then((value) {
                                                                //         print('User updated');
                                                                //         setState(() {
                                                                //           orderLoading = false;
                                                                //         });
                                                                //
                                                                //
                                                                //         FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId).collection('detail')
                                                                //             .doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString())
                                                                //             .set({
                                                                //           'main': 'total',
                                                                //           'subs': ['name'],
                                                                //         })
                                                                //             .then((value) {
                                                                //           print('order added');
                                                                //         });
                                                                //       });
                                                                //     } else {
                                                                //       daily_order
                                                                //           .add({
                                                                //         'daily_order': [now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString()+'-'+length.toString() + '^total^name^pf'],
                                                                //         'date': now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString())
                                                                //       })
                                                                //           .then((value) {
                                                                //         print('order added');
                                                                //
                                                                //
                                                                //         FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(value.id).collection('detail')
                                                                //             .doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString())
                                                                //             .set({
                                                                //           'main': 'total',
                                                                //           'subs': ['name'],
                                                                //         })
                                                                //             .then((value) {
                                                                //           print('order added');
                                                                //         });
                                                                //       });
                                                                //     }
                                                                //   });
                                                                // });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left:
                                                                    8.0,
                                                                    right:
                                                                    8.0,
                                                                    bottom:
                                                                    3.0),
                                                                child: Container(
                                                                    child: Text(
                                                                      'Clear cart',
                                                                      textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          18,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(
                                                                              0.6)),
                                                                    )),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15.0,
                                                ),
                                                Container(
                                                  width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      2) -
                                                      22.5,
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                      color: Colors.grey
                                                          .withOpacity(0.2)),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 15.0,
                                                        bottom: 15.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Expanded(
                                                          child:
                                                          GestureDetector(
                                                            onTap: () {
                                                            },
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  right:
                                                                  8.0,
                                                                  bottom:
                                                                  3.0),
                                                              child: Container(
                                                                  child: Text(
                                                                    'More actions',
                                                                    textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        18,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                            0.6)),
                                                                  )),
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
                                            padding: const EdgeInsets.only(
                                                top: 80.0,
                                                left: 0.0,
                                                right: 0.0),
                                            child: Container(
                                                child: ListView(
                                                  children: [
                                                    Text(customerId.split('-')[1]),
                                                    for (int i = 0;
                                                    i < prodList.length;
                                                    i++)
                                                      Text(prodList[i]),

                                                    for (int i = 0;
                                                    i < prodList.length;
                                                    i++)

                                                    // Slidable(
                                                    //   key: UniqueKey(),
                                                    //   // controller: slidableController,
                                                    //   direction: Axis.horizontal,
                                                    //   dismissal: SlidableDismissal(
                                                    //     child: SlidableDrawerDismissal(),
                                                    //     onDismissed: (actionType) {
                                                    //       mystate(() {
                                                    //         prodList.removeAt(i);
                                                    //       });
                                                    //       // return true;
                                                    //     },
                                                    //   ),
                                                    //   actionPane: SlidableDrawerActionPane(),
                                                    //   // actionExtentRatio: 0.25,
                                                    //   child: ListTile(
                                                    //     leading: CircleAvatar(
                                                    //       backgroundColor: Colors.indigoAccent,
                                                    //       child: Text(prodList[i].split('-')[4]),
                                                    //       foregroundColor: Colors.white,
                                                    //     ),
                                                    //     title: Text(
                                                    //       'Text',
                                                    //       // output2?['prod_name'] + ' (' + output2?[prodList[i].split('-')[3]] + ')',
                                                    //       style: TextStyle(
                                                    //           height: 1
                                                    //       ),
                                                    //     )
                                                    //   ),
                                                    //   actions: <Widget>[
                                                    //     IconSlideAction(
                                                    //       caption: 'Archive',
                                                    //       color: Colors.blue,
                                                    //       icon: Icons.archive,
                                                    //       // onTap: () => _showSnackBar(context, 'Archive'),
                                                    //     ),
                                                    //     IconSlideAction(
                                                    //       caption: 'Share',
                                                    //       color: Colors.indigo,
                                                    //       icon: Icons.share,
                                                    //       // onTap: () => _showSnackBar(context, 'Share'),
                                                    //     ),
                                                    //   ],
                                                    //   secondaryActions: <Widget>[
                                                    //     Container(
                                                    //       height: 800,
                                                    //       color: Colors.green,
                                                    //       child: Text('a'),
                                                    //     ),
                                                    //     IconSlideAction(
                                                    //       caption: 'More',
                                                    //       color: Colors.grey.shade200,
                                                    //       icon: Icons.more_horiz,
                                                    //       // onTap: () => _showSnackBar(context, 'More'),
                                                    //       closeOnTap: false,
                                                    //     ),
                                                    //     IconSlideAction(
                                                    //       caption: 'Delete',
                                                    //       color: Colors.red,
                                                    //       icon: Icons.delete,
                                                    //       // onTap: () => _showSnackBar(context, 'Delete'),
                                                    //     ),
                                                    //   ],
                                                    // )

                                                      StreamBuilder<
                                                          DocumentSnapshot<
                                                              Map<String,
                                                                  dynamic>>>(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection('space')
                                                            .doc(
                                                            '0NHIS0Jbn26wsgCzVBKT')
                                                            .collection('shops')
                                                            .doc(
                                                            'PucvhZDuUz3XlkTgzcjb')
                                                            .collection('products')
                                                            .doc(prodList[i]
                                                            .split('-')[0])
                                                            .snapshots(),
                                                        builder:
                                                            (BuildContext context,
                                                            snapshot2) {
                                                          if (snapshot2.hasData) {
                                                            var output2 = snapshot2
                                                                .data!
                                                                .data();
                                                            return Slidable(
                                                              key: UniqueKey(),
                                                              actionPane:
                                                              SlidableDrawerActionPane(),
                                                              actionExtentRatio:
                                                              0.25,
                                                              child: Container(
                                                                color: Colors.white,
                                                                child: ListTile(
                                                                  leading:
                                                                  CircleAvatar(
                                                                    backgroundColor:
                                                                    Colors
                                                                        .indigoAccent,
                                                                    child: Text(
                                                                        prodList[i]
                                                                            .split(
                                                                            '-')[4]),
                                                                    foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                  ),
                                                                  title: Text(
                                                                    output2?[
                                                                      'prod_name'] +
                                                                        ' (' +
                                                                        output2?[prodList[
                                                                    i]
                                                                        .split(
                                                                        '-')[3]] +
                                                                        ')',
                                                                    style:
                                                                    TextStyle(
                                                                        height:
                                                                        1),
                                                                  ),
                                                                  subtitle: Text(
                                                                      prodList[i].split(
                                                                          '-')[2] +
                                                                          ' MMK'),
                                                                  trailing: Text((int.parse(
                                                                      prodList[i].split('-')[
                                                                      2]) *
                                                                      int.parse(prodList[
                                                                      i]
                                                                          .split(
                                                                          '-')[4]))
                                                                      .toString()),
                                                                ),
                                                              ),
                                                              dismissal:
                                                              SlidableDismissal(
                                                                child:
                                                                SlidableDrawerDismissal(),
                                                                onDismissed:
                                                                    (actionType) {
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

                                                                  mystate(() {
                                                                    prodList
                                                                        .removeAt(
                                                                        i);
                                                                  });
                                                                },
                                                              ),
                                                              secondaryActions: <
                                                                  Widget>[
                                                                IconSlideAction(
                                                                  caption: 'Delete',
                                                                  color: Colors.red,
                                                                  icon:
                                                                  Icons.delete,
                                                                  onTap: () =>
                                                                      mystate(() {
                                                                        prodList
                                                                            .removeAt(
                                                                            i);
                                                                      }),
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                          return Container();
                                                        },
                                                      )

                                                    // orderLoading?Text('Loading'):Text('')
                                                  ],
                                                )),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                        color:
                                                        AppTheme.skBorderColor2,
                                                        width: 1.0),
                                                  )),
                                              width: double.infinity,
                                              height: 160,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15.0,
                                                    right: 15.0,
                                                    top: 0.0,
                                                    bottom:
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .bottom +
                                                        15),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        print('sub click ' + subList.toString());
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Total',
                                                            style: TextStyle(
                                                                fontSize: 19,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          ),
                                                          Expanded(
                                                            child: Container(),
                                                          ),
                                                          Text(
                                                            TtlProdListPrice(),
                                                            style: TextStyle(
                                                                fontSize: 19,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        subList = [];
                                                        DateTime now = DateTime.now();
                                                        CollectionReference daily_order = await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders');
                                                        var length = 0;
                                                        print('order creating');

                                                        await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').get().then((QuerySnapshot querySnapshot) async {
                                                          querySnapshot.docs.forEach((doc) {
                                                            length += int.parse(doc['daily_order'].length.toString());
                                                          });
                                                          length = 1000 + length + 1;
                                                          //Check new date or not
                                                          var dateExist = false;
                                                          var dateId = '';



                                                          for (String str in prodList) {
                                                            List<String> subSell = [];
                                                            List<String> subLink = [];
                                                            List<String> subName = [];
                                                            var docSnapshot10 = await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0])
                                                                .get();

                                                            if (docSnapshot10.exists) {
                                                              Map<String, dynamic>? data10 = docSnapshot10.data();
                                                              // String subExist = data10 ? ['subExist'];
                                                              // String prodName = data10 ? ['prod_name']

                                                              // print('h10 ' + subExist);


                                                              for(int i = 0; i < int.parse(data10 ? ["sub_exist"]); i++) {
                                                                subSell.add(data10 ? ['sub' + (i+1).toString() + '_sell']);
                                                                subLink.add(data10 ? ['sub' + (i+1).toString() + '_link']);
                                                                subName.add(data10 ? ['sub' + (i+1).toString() + '_name']);
                                                              }

                                                            }

                                                            if (str.split('-')[3] == 'unit_name') {
                                                              await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions')
                                                                .orderBy('date', descending: false)
                                                                .where('type', isEqualTo: 'main')
                                                                .get()
                                                                .then((QuerySnapshot querySnapshot) async {
                                                                  int value = int.parse(str.split('-')[4]);
                                                                  double ttlPrice = 0.0;
                                                                  double ttlQtity = 0.0;
                                                                  for(int j = 0; j < querySnapshot.docs.length; j++) {
                                                                    if(value != 0 && querySnapshot.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshot.docs[j]["unit_qtity"]) < value) {
                                                                      int newValue = 0;
                                                                      ttlPrice += double.parse(querySnapshot.docs[j]["buy_price"]) * double.parse(querySnapshot.docs[j]["unit_qtity"]);
                                                                      ttlQtity += double.parse(querySnapshot.docs[j]["unit_qtity"]);
                                                                      await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions').doc(querySnapshot.docs[j].id)
                                                                        .update({'unit_qtity': newValue.toString()
                                                                      });

                                                                      // DocumentReference documentReference = FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions').doc(querySnapshot.docs[j].id);
                                                                      // await FirebaseFirestore.instance.runTransaction((transaction) async {
                                                                      //   DocumentSnapshot snapshot = await transaction.get(documentReference);
                                                                      //   if (!snapshot.exists) {
                                                                      //     throw Exception("User does not exist!");
                                                                      //   }
                                                                      //   Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
                                                                      //   String str = data?['data'];
                                                                      //   transaction.update(documentReference, {'unit_qtity': newValue.toString()});
                                                                      // });

                                                                      value = (int.parse(querySnapshot.docs[j]["unit_qtity"]) - value).abs();
                                                                      subList.add(str.split('-')[0] + '-' + querySnapshot.docs[j].id + '-' + querySnapshot.docs[j]["buy_price"] + '-' + querySnapshot.docs[j]["unit_qtity"] +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + querySnapshot.docs[j]["date"]);
                                                                    } else if (value != 0 && querySnapshot.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshot.docs[j]["unit_qtity"]) >= value) {
                                                                      print(querySnapshot.docs[j]["unit_qtity"]);

                                                                      int newValue = int.parse(querySnapshot.docs[j]["unit_qtity"]) - value;
                                                                      ttlPrice += double.parse(querySnapshot.docs[j]["buy_price"]) * double.parse(value.toString());
                                                                      ttlQtity += double.parse(querySnapshot.docs[j]["unit_qtity"]);

                                                                      await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions').doc(querySnapshot.docs[j].id).update({'unit_qtity': newValue.toString()});

                                                                      subList.add(str.split('-')[0] + '-' + querySnapshot.docs[j].id + '-' + querySnapshot.docs[j]["buy_price"] + '-' + value.toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4]+  '-0-' + querySnapshot.docs[j]["date"]);
                                                                      break;
                                                                    }
                                                                  }
                                                              });
                                                            } else if (str.split('-')[3] == 'sub1_name') {
                                                              await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions')
                                                                  .orderBy('date', descending: false)
                                                                  .where('type', isEqualTo: 'sub1')
                                                                  .get()
                                                                  .then((QuerySnapshot querySnapshot) async {
                                                                int value = int.parse(str.split('-')[4]);
                                                                double ttlPrice = 0.0;
                                                                double ttlQtity = 0.0;
                                                                for(int j = 0; j < querySnapshot.docs.length; j++) {
                                                                  print('val ' + value.toString() + ' ' + querySnapshot.docs[j]["unit_qtity"]);
                                                                  if(value != 0 && querySnapshot.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshot.docs[j]["unit_qtity"]) < value) {
                                                                    int newValue = 0;
                                                                    ttlPrice += double.parse(querySnapshot.docs[j]["buy_price"]) * double.parse(querySnapshot.docs[j]["unit_qtity"]);
                                                                    ttlQtity += double.parse(querySnapshot.docs[j]["unit_qtity"]);
                                                                    await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions').doc(querySnapshot.docs[j].id)
                                                                        .update({'unit_qtity': newValue.toString()
                                                                    });

                                                                    value = (int.parse(querySnapshot.docs[j]["unit_qtity"]) - value).abs();
                                                                    subList.add(str.split('-')[0] + '-' + querySnapshot.docs[j].id + '-' + querySnapshot.docs[j]["buy_price"] + '-' + querySnapshot.docs[j]["unit_qtity"] +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + querySnapshot.docs[j]["date"]);
                                                                  } else if (value != 0 && querySnapshot.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshot.docs[j]["unit_qtity"]) >= value) {
                                                                    print(querySnapshot.docs[j]["unit_qtity"]);

                                                                    int newValue = int.parse(querySnapshot.docs[j]["unit_qtity"]) - value;
                                                                    ttlPrice += double.parse(querySnapshot.docs[j]["buy_price"]) * double.parse(value.toString());
                                                                    ttlQtity += double.parse(querySnapshot.docs[j]["unit_qtity"]);

                                                                    await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions').doc(querySnapshot.docs[j].id).update({'unit_qtity': newValue.toString()});

                                                                    subList.add(str.split('-')[0] + '-' + querySnapshot.docs[j].id + '-' + querySnapshot.docs[j]["buy_price"] + '-' + value.toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4]+  '-0-' + querySnapshot.docs[j]["date"]);
                                                                    value = 0;
                                                                    break;
                                                                  } else {

                                                                  }
                                                                }

                                                                if(value != 0) {
                                                                  print('sub1 out' + (value/int.parse(subLink[0])).ceil().toString() + ' ' + subLink[0].toString());
                                                                  await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions')
                                                                      .orderBy('date', descending: false)
                                                                      .where('type', isEqualTo: 'main')
                                                                      .get()
                                                                      .then((QuerySnapshot querySnapshotSub1Main) async {
                                                                    int mainNhote = (value/int.parse(subLink[0])).ceil();
                                                                    double ttlPrice = 0.0;
                                                                    double ttlQtity = 0.0;
                                                                    double sub1OutP = 0.0;
                                                                    for(int j = 0; j < querySnapshotSub1Main.docs.length; j++) {
                                                                      if(mainNhote != 0 && querySnapshotSub1Main.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) < mainNhote) {
                                                                        int newValue = 0;
                                                                        ttlPrice += double.parse(querySnapshotSub1Main.docs[j]["buy_price"]) * double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                                                                        ttlQtity += double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                                                                        await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions').doc(querySnapshotSub1Main.docs[j].id)
                                                                            .update({'unit_qtity': newValue.toString()
                                                                        });
                                                                        sub1OutP = double.parse(querySnapshotSub1Main.docs[j]["buy_price"]);

                                                                        mainNhote = (int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) - mainNhote).abs();
                                                                      } else if (mainNhote != 0 && querySnapshotSub1Main.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) >= mainNhote) {
                                                                        print(querySnapshotSub1Main.docs[j]["unit_qtity"]);

                                                                        int newValue = int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) - mainNhote;
                                                                        ttlPrice += double.parse(querySnapshotSub1Main.docs[j]["buy_price"]) * double.parse(mainNhote.toString());
                                                                        ttlQtity += double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                                                                        sub1OutP = double.parse(querySnapshotSub1Main.docs[j]["buy_price"]);

                                                                        await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions').doc(querySnapshotSub1Main.docs[j].id).update({'unit_qtity': newValue.toString()});
                                                                        break;
                                                                      }
                                                                    }

                                                                    await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions')
                                                                        .add({
                                                                      'date': zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()) + zeroToTen(DateTime.now().hour.toString()) + zeroToTen(DateTime.now().minute.toString()) + zeroToTen(DateTime.now().second.toString()),
                                                                      'unit_qtity': value%int.parse(subLink[0]) == 0? '0': (int.parse(subLink[0]) - (value%int.parse(subLink[0]))).toString(),
                                                                      'buy_price': (sub1OutP/double.parse(subLink[0])).toString(),
                                                                      'type': 'sub1',
                                                                    }).then((val) {
                                                                      subList.add(str.split('-')[0] + '-' + val.id + '-' + (sub1OutP/double.parse(subLink[0])).toString() + '-' + value.toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()));

                                                                    });
                                                                  });
                                                                }
                                                              });
                                                            } else if (str.split('-')[3] == 'sub2_name') {
                                                              await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions')
                                                                  .orderBy('date', descending: false)
                                                                  .where('type', isEqualTo: 'sub2')
                                                                  .get()
                                                                  .then((QuerySnapshot querySnapshot) async {
                                                                int value = int.parse(str.split('-')[4]);
                                                                double ttlPrice = 0.0;
                                                                double ttlQtity = 0.0;
                                                                for(int j = 0; j < querySnapshot.docs.length; j++) {
                                                                  print('val ' + value.toString() + ' ' + querySnapshot.docs[j]["unit_qtity"]);
                                                                  if(value != 0 && querySnapshot.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshot.docs[j]["unit_qtity"]) < value) {
                                                                    int newValue = 0;
                                                                    ttlPrice += double.parse(querySnapshot.docs[j]["buy_price"]) * double.parse(querySnapshot.docs[j]["unit_qtity"]);
                                                                    ttlQtity += double.parse(querySnapshot.docs[j]["unit_qtity"]);
                                                                    await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions').doc(querySnapshot.docs[j].id)
                                                                        .update({'unit_qtity': newValue.toString()
                                                                    });

                                                                    value = (int.parse(querySnapshot.docs[j]["unit_qtity"]) - value).abs();
                                                                    subList.add(str.split('-')[0] + '-' + querySnapshot.docs[j].id + '-' + querySnapshot.docs[j]["buy_price"] + '-' + querySnapshot.docs[j]["unit_qtity"] +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + querySnapshot.docs[j]["date"]);
                                                                  } else if (value != 0 && querySnapshot.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshot.docs[j]["unit_qtity"]) >= value) {
                                                                    print(querySnapshot.docs[j]["unit_qtity"]);

                                                                    int newValue = int.parse(querySnapshot.docs[j]["unit_qtity"]) - value;
                                                                    ttlPrice += double.parse(querySnapshot.docs[j]["buy_price"]) * double.parse(value.toString());
                                                                    ttlQtity += double.parse(querySnapshot.docs[j]["unit_qtity"]);

                                                                    await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions').doc(querySnapshot.docs[j].id).update({'unit_qtity': newValue.toString()});

                                                                    subList.add(str.split('-')[0] + '-' + querySnapshot.docs[j].id + '-' + querySnapshot.docs[j]["buy_price"] + '-' + value.toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4]+  '-0-' + querySnapshot.docs[j]["date"]);
                                                                    value = 0;
                                                                    break;
                                                                  } else {

                                                                  }
                                                                }

                                                                if(value != 0) {
                                                                  print('sub2 out' + (value/int.parse(subLink[1])).ceil().toString() + ' ' + subLink[1].toString());
                                                                  await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions')
                                                                      .orderBy('date', descending: false)
                                                                      .where('type', isEqualTo: 'sub1')
                                                                      .get()
                                                                      .then((QuerySnapshot querySnapshotSub1Main) async {
                                                                    int mainNhote = (value/int.parse(subLink[1])).ceil();
                                                                    bool mainNhoted = false;
                                                                    double ttlPrice = 0.0;
                                                                    double ttlQtity = 0.0;
                                                                    double sub2OutP = 0.0;
                                                                    for(int j = 0; j < querySnapshotSub1Main.docs.length; j++) {
                                                                      print('situation ' + value.toString() + ' ' + mainNhote.toString());
                                                                      if(mainNhote != 0 && querySnapshotSub1Main.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) < mainNhote) {
                                                                        int newValue = 0;
                                                                        ttlPrice += double.parse(querySnapshotSub1Main.docs[j]["buy_price"]) * double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                                                                        ttlQtity += double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                                                                        await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions').doc(querySnapshotSub1Main.docs[j].id)
                                                                            .update({'unit_qtity': newValue.toString()
                                                                        });
                                                                        sub2OutP = double.parse(querySnapshotSub1Main.docs[j]["buy_price"]);

                                                                        mainNhote = (int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) - mainNhote).abs();
                                                                        mainNhoted = true;

                                                                        await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions')
                                                                            .add({
                                                                          'date': zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()) + zeroToTen(DateTime.now().hour.toString()) + zeroToTen(DateTime.now().minute.toString()) + zeroToTen(DateTime.now().second.toString()),
                                                                          'unit_qtity': '0',
                                                                          'buy_price': (sub2OutP/double.parse(subLink[1])).toString(),
                                                                          'type': 'sub2',
                                                                          'check': '2'
                                                                        }).then((val) {
                                                                          subList.add(str.split('-')[0] + '-' + val.id + '-' + (sub2OutP/double.parse(subLink[1])).toString() + '-' + (int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"])*int.parse(subLink[1])).toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()));
                                                                          value = value - (int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"])*int.parse(subLink[1]));
                                                                        });
                                                                      } else if (mainNhote != 0 && querySnapshotSub1Main.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) >= mainNhote) {
                                                                        print(querySnapshotSub1Main.docs[j]["unit_qtity"]);

                                                                        int newValue = int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) - mainNhote;
                                                                        ttlPrice += double.parse(querySnapshotSub1Main.docs[j]["buy_price"]) * double.parse(mainNhote.toString());
                                                                        ttlQtity += double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                                                                        sub2OutP = double.parse(querySnapshotSub1Main.docs[j]["buy_price"]);
                                                                        mainNhote = 0;

                                                                        await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions').doc(querySnapshotSub1Main.docs[j].id).update({'unit_qtity': newValue.toString()});
                                                                        // break;
                                                                      }

                                                                      if(querySnapshotSub1Main.docs.length-1 == j){
                                                                        print('1 situation ' + value.toString() + ' ' + mainNhote.toString() + sub2OutP.toString());

                                                                        if(sub2OutP!=0.0 && mainNhote==0) {
                                                                          await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions')
                                                                              .add({
                                                                            'date': zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()) + zeroToTen(DateTime.now().hour.toString()) + zeroToTen(DateTime.now().minute.toString()) + zeroToTen(DateTime.now().second.toString()),
                                                                            'unit_qtity': value%int.parse(subLink[1]) == 0? '0': (int.parse(subLink[1]) - (value%int.parse(subLink[1]))).toString(),
                                                                            'buy_price': (sub2OutP/double.parse(subLink[1])).toString(),
                                                                            'type': 'sub2',
                                                                            'check': '1'
                                                                          }).then((val) {
                                                                            subList.add(str.split('-')[0] + '-' + val.id + '-' + (sub2OutP/double.parse(subLink[1])).toString() + '-' + value.toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()));

                                                                          });
                                                                        } else {
                                                                          if(value != 0) {
                                                                            print('sub2 Main out' + (value/int.parse(subLink[0])).ceil().toString() + ' ' + subLink[0].toString());
                                                                            await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions')
                                                                                .orderBy('date', descending: false)
                                                                                .where('type', isEqualTo: 'main')
                                                                                .get()
                                                                                .then((QuerySnapshot querySnapshotSub1Main) async {
                                                                              int mainNhoteSub2 = (value/(int.parse(subLink[0]) * int.parse(subLink[1]))).ceil();
                                                                              print('sub2 Main out two ' + mainNhoteSub2.toString() + ' ' + value.toString());
                                                                              double ttlPrice = 0.0;
                                                                              double ttlQtity = 0.0;
                                                                              double sub1OutP = 0.0;
                                                                              for(int j = 0; j < querySnapshotSub1Main.docs.length; j++) {
                                                                                if(mainNhoteSub2 != 0 && querySnapshotSub1Main.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) < mainNhoteSub2) {
                                                                                  int newValue = 0;
                                                                                  ttlPrice += double.parse(querySnapshotSub1Main.docs[j]["buy_price"]) * double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                                                                                  ttlQtity += double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                                                                                  await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions').doc(querySnapshotSub1Main.docs[j].id)
                                                                                      .update({'unit_qtity': newValue.toString()
                                                                                  });
                                                                                  sub1OutP = double.parse(querySnapshotSub1Main.docs[j]["buy_price"]);

                                                                                  mainNhoteSub2 = (int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) - mainNhoteSub2).abs();
                                                                                } else if (mainNhoteSub2 != 0 && querySnapshotSub1Main.docs[j]["unit_qtity"] != '0' && int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) >= mainNhoteSub2) {
                                                                                  print(querySnapshotSub1Main.docs[j]["unit_qtity"]);

                                                                                  int newValue = int.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]) - mainNhoteSub2;
                                                                                  ttlPrice += double.parse(querySnapshotSub1Main.docs[j]["buy_price"]) * double.parse(mainNhoteSub2.toString());
                                                                                  ttlQtity += double.parse(querySnapshotSub1Main.docs[j]["unit_qtity"]);
                                                                                  sub1OutP = double.parse(querySnapshotSub1Main.docs[j]["buy_price"]);

                                                                                  await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions').doc(querySnapshotSub1Main.docs[j].id).update({'unit_qtity': newValue.toString()});
                                                                                  break;
                                                                                }
                                                                              }

                                                                              int newVal = 0;
                                                                              if(mainNhoted) {
                                                                                newVal = value;
                                                                              } else {
                                                                                newVal = value;
                                                                              }

                                                                              await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions')
                                                                                  .add({
                                                                                'date': zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()) + zeroToTen(DateTime.now().hour.toString()) + zeroToTen(DateTime.now().minute.toString()) + zeroToTen(DateTime.now().second.toString()),
                                                                                'unit_qtity': (newVal%(int.parse(subLink[0]) * int.parse(subLink[1])))/int.parse(subLink[1]) == 0? '0': (int.parse(subLink[0]) - ((newVal%(int.parse(subLink[0]) * int.parse(subLink[1])))/int.parse(subLink[1])).ceil()).toString(),
                                                                                'buy_price': (sub1OutP/double.parse(subLink[0])).toString(),
                                                                                'type': 'sub1',
                                                                              }).then((val) async {
                                                                                // break
                                                                                //subList.add(str.split('-')[0] + '-' + val.id + '-' + (sub1OutP/double.parse(subLink[0])).toString() + '-' + value.toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()));
                                                                                await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(str.split('-')[0]).collection('versions')
                                                                                    .add({
                                                                                  'date': zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()) + zeroToTen(DateTime.now().hour.toString()) + zeroToTen(DateTime.now().minute.toString()) + zeroToTen(DateTime.now().second.toString()),
                                                                                  'unit_qtity': value%int.parse(subLink[1]) == 0? '0' : (int.parse(subLink[1])-(value%int.parse(subLink[1]))).toString(),
                                                                                  'buy_price': ((sub1OutP/double.parse(subLink[0]))/double.parse(subLink[1])).toString(),
                                                                                  'type': 'sub2',
                                                                                }).then((val) {
                                                                                  // break
                                                                                  subList.add(str.split('-')[0] + '-' + val.id + '-' + ((sub1OutP/double.parse(subLink[0]))/double.parse(subLink[1])).toString() + '-' + value.toString() +'-' + str.split('-')[2] + '-' + str.split('-')[3] +'-' + str.split('-')[4] + '-0-' + zeroToTen(DateTime.now().year.toString()) + zeroToTen(DateTime.now().month.toString()) + zeroToTen(DateTime.now().day.toString()));

                                                                                });
                                                                              });


                                                                            });
                                                                          }
                                                                        }
                                                                      }
                                                                    }








                                                                  });
                                                                  // if(querySnapshot.docs.length-1 == j && int.parse(querySnapshot.docs[j]["unit_qtity"]) < value) {
                                                                  //
                                                                  //
                                                                  // }
                                                                }
                                                              });
                                                            }
                                                          }

                                                          print('subList ' + subList.toString());

                                                          //Order Add
                                                          FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
                                                          // FirebaseFirestore.instance.collection('space')
                                                              .where('date', isEqualTo: now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()))
                                                              .get()
                                                              .then((QuerySnapshot querySnapshot) {
                                                            querySnapshot.docs.forEach((doc) {
                                                              dateExist = true;
                                                              dateId = doc.id;
                                                            });

                                                            if (dateExist) {
                                                              daily_order.doc(dateId).update({
                                                                'daily_order': FieldValue.arrayUnion([now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice() + '^' + customerId.split('-')[0] + '^pf'
                                                                ])
                                                              }).then((value) {
                                                                print('User updated');
                                                                setState(() {
                                                                  orderLoading = false;
                                                                });

                                                                FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(dateId).collection('detail')
                                                                .doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString())
                                                                .set({
                                                                  'main': 'total',
                                                                  'subs': subList,
                                                                }).then((value) {
                                                                  print('order added');
                                                                });
                                                              });
                                                            } else {
                                                              daily_order.add({
                                                                'daily_order': [now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString() + '^' + deviceIdNum.toString() + '-' + length.toString() + '^' + TtlProdListPrice() + '^' + customerId.split('-')[0] + '^pf'],
                                                                'date': now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString())
                                                              }).then((value) {
                                                                print('order added');
                                                                FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc(value.id).collection('detail').doc(now.year.toString() + zeroToTen(now.month.toString()) + zeroToTen(now.day.toString()) + zeroToTen(now.hour.toString()) + zeroToTen(now.minute.toString()) + zeroToTen(now.second.toString()) + deviceIdNum.toString() + length.toString())
                                                                    .set({
                                                                  'main': 'total',
                                                                  'subs': subList,
                                                                }).then((value) {
                                                                  print('order added');
                                                                });
                                                              });
                                                            }
                                                          });

                                                        });
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width - 30,
                                                        height: 55,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(10.0),
                                                          color: AppTheme.skThemeColor2),
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(
                                                            top: 15.0,
                                                            bottom: 15.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3.0),
                                                                  child: Container(
                                                                    child: Text(
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
                                    )
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
            },
          );
        });
  }

  addDailyExp2(priContext) {
    // myController.clear();
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter mystate) {
              return Scaffold(
                backgroundColor: Colors.grey.withOpacity(0.3),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top + 45,
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
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                color: Colors.white,
                              ),
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  width: 1.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0, top: 0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                    Radius.circular(20.0),
                                                  ),
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
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
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.left,
                                            ),
                                            Container(
                                              width: 35,
                                              height: 35,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    // checkoutCart()
                                    Container(
                                      height:
                                      MediaQuery.of(context).size.height -
                                          105,
                                      width: double.infinity,
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                top: 15.0),
                                            child: Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    // addCounter();/z
                                                  },
                                                  child: Container(
                                                    width:
                                                    (MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                        2) -
                                                        22.5,
                                                    height: 55,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(10.0),
                                                        color: Colors.grey
                                                            .withOpacity(0.2)),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          top: 15.0,
                                                          bottom: 15.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Expanded(
                                                            child:
                                                            GestureDetector(
                                                              onTap: () {
                                                                mystate(() {
                                                                  prodList2 =
                                                                  [];
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left:
                                                                    8.0,
                                                                    right:
                                                                    8.0,
                                                                    bottom:
                                                                    3.0),
                                                                child: Container(
                                                                    child: Text(
                                                                      'Clear cart',
                                                                      textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          18,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(
                                                                              0.6)),
                                                                    )),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15.0,
                                                ),
                                                Container(
                                                  width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      2) -
                                                      22.5,
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                      color: Colors.grey
                                                          .withOpacity(0.2)),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 15.0,
                                                        bottom: 15.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Expanded(
                                                          child:
                                                          GestureDetector(
                                                            onTap: () {
                                                              print('Lee ' +
                                                                  prodList2.toString());

                                                            },
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  right:
                                                                  8.0,
                                                                  bottom:
                                                                  3.0),
                                                              child: Container(
                                                                  child: Text(
                                                                    'More actions',
                                                                    textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        18,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                            0.6)),
                                                                  )),
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
                                            padding: const EdgeInsets.only(
                                                top: 80.0,
                                                left: 0.0,
                                                right: 0.0),
                                            child: Container(
                                                child: ListView(
                                                  children: [
                                                    Text(merchantId.split('-')[1]),
                                                    for (int i = 0;
                                                    i < prodList2.length;
                                                    i++)
                                                      Text(prodList2[i]),
                                                    for (int i = 0;
                                                    i < prodList2.length;
                                                    i++)
                                                      StreamBuilder<
                                                          DocumentSnapshot<
                                                              Map<String,
                                                                  dynamic>>>(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection('space')
                                                            .doc(
                                                            '0NHIS0Jbn26wsgCzVBKT')
                                                            .collection('shops')
                                                            .doc(
                                                            'PucvhZDuUz3XlkTgzcjb')
                                                            .collection('products')
                                                            .doc(prodList2[i]
                                                            .split('-')[0])
                                                            .snapshots(),
                                                        builder:
                                                            (BuildContext context,
                                                            snapshot2) {
                                                          if (snapshot2.hasData) {
                                                            var output2 = snapshot2
                                                                .data!
                                                                .data();
                                                            return Slidable(
                                                              key: UniqueKey(),
                                                              actionPane:
                                                              SlidableDrawerActionPane(),
                                                              actionExtentRatio:
                                                              0.25,
                                                              child: Container(
                                                                color: Colors.white,
                                                                child: ListTile(
                                                                  leading:
                                                                  CircleAvatar(
                                                                    backgroundColor:
                                                                    Colors
                                                                        .indigoAccent,
                                                                    child: Text(
                                                                        prodList2[i]
                                                                            .split(
                                                                            '-')[2]),
                                                                    foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                  ),
                                                                  title: Text(
                                                                    output2?[
                                                                    'prod_name'] +
                                                                        ' (' +
                                                                        output2?[prodList2[
                                                                        i]
                                                                            .split(
                                                                            '-')[4]] +
                                                                        ')',
                                                                    style:
                                                                    TextStyle(
                                                                        height:
                                                                        1),
                                                                  ),
                                                                  subtitle: Text(
                                                                      prodList2[i].split(
                                                                          '-')[1] +
                                                                          ' MMK'),
                                                                  trailing: Text((int.parse(
                                                                      prodList2[i].split('-')[
                                                                      2]) *
                                                                      int.parse(prodList2[
                                                                      i]
                                                                          .split(
                                                                          '-')[1]))
                                                                      .toString()),
                                                                ),
                                                              ),
                                                              dismissal:
                                                              SlidableDismissal(
                                                                child:
                                                                SlidableDrawerDismissal(),
                                                                onDismissed:
                                                                    (actionType) {
                                                                  mystate(() {
                                                                    prodList2
                                                                        .removeAt(
                                                                        i);
                                                                  });
                                                                },
                                                              ),
                                                              secondaryActions: <
                                                                  Widget>[
                                                                IconSlideAction(
                                                                  caption: 'Delete',
                                                                  color: Colors.red,
                                                                  icon:
                                                                  Icons.delete,
                                                                  onTap: () =>
                                                                      mystate(() {
                                                                        prodList2
                                                                            .removeAt(
                                                                            i);
                                                                      }),
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                          return Container();
                                                        },
                                                      )
                                                  ],
                                                )),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                        color:
                                                        AppTheme.skBorderColor2,
                                                        width: 1.0),
                                                  )),
                                              width: double.infinity,
                                              height: 160,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15.0,
                                                    right: 15.0,
                                                    top: 0.0,
                                                    bottom:
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .bottom +
                                                        15),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Total',
                                                          style: TextStyle(
                                                              fontSize: 19,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        ),
                                                        Expanded(
                                                          child: Container(),
                                                        ),
                                                        Text(
                                                          TtlProdListPrice2(),
                                                          style: TextStyle(
                                                              fontSize: 19,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        ScaffoldMessenger.of(
                                                            context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  'Processing Data')),
                                                        );

                                                        DateTime now =
                                                        DateTime.now();
                                                        List<String> prodList3 =[];
                                                        for (int i=0; i<prodList2.length; i++) {
                                                          if(prodList2[i].split('-')[4]=='unit_name') {
                                                            DocumentReference docRef = await FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('products').doc(prodList2[i].split('-')[0]).collection('versions')
                                                                .add({
                                                              'date': zeroToTen(now.day.toString()) + zeroToTen(now.month.toString()) + zeroToTen(now.year.toString()),
                                                              'unit_qtity': prodList2[i].split('-')[2],
                                                              'buy_price': prodList2[i].split('-')[1],
                                                              'type': 'main',
                                                            },
                                                            );
                                                            prodList3.add(prodList2[i] + docRef.id);
                                                            if (i == prodList2.length - 1) {
                                                              addString2Sub(prodList3);
                                                            }
                                                          }else if(prodList2[i].split(
                                                              '-')[4]=='sub1_name') {
                                                            DocumentReference docRef = await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                'space')
                                                                .doc(
                                                                '0NHIS0Jbn26wsgCzVBKT')
                                                                .collection(
                                                                'shops')
                                                                .doc(
                                                                'PucvhZDuUz3XlkTgzcjb')
                                                                .collection(
                                                                'products')
                                                                .doc(
                                                                prodList2[i]
                                                                    .split(
                                                                    '-')[0])
                                                                .collection(
                                                                'versions')
                                                                .add(

                                                              {
                                                                'date': zeroToTen(
                                                                    now
                                                                        .day
                                                                        .toString()) +
                                                                    zeroToTen(
                                                                        now
                                                                            .month
                                                                            .toString()) +
                                                                    zeroToTen(
                                                                        now
                                                                            .year
                                                                            .toString()),
                                                                'unit_qtity':
                                                                prodList2[i]
                                                                    .split(
                                                                    '-')[2],
                                                                'buy_price':
                                                                prodList2[i]
                                                                    .split(
                                                                    '-')[1],
                                                                'type': 'sub1',
                                                              },
                                                            );
                                                            prodList3.add(
                                                                prodList2[i] +
                                                                    docRef
                                                                        .id);
                                                            if (i == prodList2
                                                                .length - 1) {
                                                              addString2Sub(
                                                                  prodList3);
                                                            }
                                                          } else if(prodList2[i].split(
                                                              '-')[4]=='sub2_name') {
                                                            DocumentReference docRef = await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                'space')
                                                                .doc(
                                                                '0NHIS0Jbn26wsgCzVBKT')
                                                                .collection(
                                                                'shops')
                                                                .doc(
                                                                'PucvhZDuUz3XlkTgzcjb')
                                                                .collection(
                                                                'products')
                                                                .doc(
                                                                prodList2[i]
                                                                    .split(
                                                                    '-')[0])
                                                                .collection(
                                                                'versions')
                                                                .add(

                                                              {
                                                                'date': zeroToTen(
                                                                    now
                                                                        .day
                                                                        .toString()) +
                                                                    zeroToTen(
                                                                        now
                                                                            .month
                                                                            .toString()) +
                                                                    zeroToTen(
                                                                        now
                                                                            .year
                                                                            .toString()),
                                                                'unit_qtity':
                                                                prodList2[i]
                                                                    .split(
                                                                    '-')[2],
                                                                'buy_price':
                                                                prodList2[i]
                                                                    .split(
                                                                    '-')[1],
                                                                'type': 'sub2',
                                                              },
                                                            );
                                                            prodList3.add(
                                                                prodList2[i] +
                                                                    docRef
                                                                        .id);
                                                            if (i == prodList2
                                                                .length - 1) {
                                                              addString2Sub(
                                                                  prodList3);
                                                            }
                                                          } else if(prodList2[i].split(
                                                              '-')[4]=='sub3_name') {
                                                            DocumentReference docRef = await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                'space')
                                                                .doc(
                                                                '0NHIS0Jbn26wsgCzVBKT')
                                                                .collection(
                                                                'shops')
                                                                .doc(
                                                                'PucvhZDuUz3XlkTgzcjb')
                                                                .collection(
                                                                'products')
                                                                .doc(
                                                                prodList2[i]
                                                                    .split(
                                                                    '-')[0])
                                                                .collection(
                                                                'versions')
                                                                .add(

                                                              {
                                                                'date': zeroToTen(
                                                                    now
                                                                        .day
                                                                        .toString()) +
                                                                    zeroToTen(
                                                                        now
                                                                            .month
                                                                            .toString()) +
                                                                    zeroToTen(
                                                                        now
                                                                            .year
                                                                            .toString()),
                                                                'unit_qtity':
                                                                prodList2[i]
                                                                    .split(
                                                                    '-')[2],
                                                                'buy_price':
                                                                prodList2[i]
                                                                    .split(
                                                                    '-')[1],
                                                                'type': 'sub3',
                                                              },
                                                            );
                                                            prodList3.add(
                                                                prodList2[i] +
                                                                    docRef
                                                                        .id);
                                                            if (i == prodList2
                                                                .length - 1) {
                                                              addString2Sub(
                                                                  prodList3);
                                                            }
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width -
                                                            30,
                                                        height: 55,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10.0),
                                                            color: AppTheme
                                                                .skThemeColor2),
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              top: 15.0,
                                                              bottom: 15.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      left: 8.0,
                                                                      right:
                                                                      8.0,
                                                                      bottom:
                                                                      3.0),
                                                                  child:
                                                                  Container(
                                                                      child:
                                                                      Text(
                                                                        'Checkout',
                                                                        textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            18,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                            color: Colors
                                                                                .white),
                                                                      )),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  var counter = 0;
  var orderLoading = false;

  String total = 'T';


  TtlProdListPrice() {
    int total = 0;
    print(prodList.toString());
    for (String str in prodList) {
      total += int.parse(str.split('-')[2]) * int.parse(str.split('-')[4]);
    }
    return total.toString();
  }

  TtlProdListPrice2() {
    int total = 0;
    //print(prodList.toString());
    for (String str in prodList2) {
      total += int.parse(str.split('-')[1]) * int.parse(str.split('-')[2]);
    }
    return total.toString();
  }

  zeroToTen(String string) {
    if (int.parse(string) > 9) {
      return string;
    } else {
      return '0' + string;
    }
  }
}
