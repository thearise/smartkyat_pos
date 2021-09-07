import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ai_awesome_message/ai_awesome_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartkyat_pos/fragments/customers_fragment.dart';
import 'package:smartkyat_pos/fragments/home_fragment.dart';
import 'package:flutter/material.dart';
import 'package:smartkyat_pos/fragments/main_fragment.dart';
import 'package:smartkyat_pos/fragments/orders_fragment.dart';
import 'package:smartkyat_pos/fragments/products_fragment.dart';
import 'package:smartkyat_pos/fragments/settings_fragment.dart';
import 'package:smartkyat_pos/fragments/staff_fragment.dart';
import 'package:smartkyat_pos/fragments/support_fragment.dart';
import 'package:smartkyat_pos/pages2/single_assets_page.dart';

import '../app_theme.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Home", Icons.home_filled),
    new DrawerItem("Orders", Icons.inbox),
    new DrawerItem("Customers", Icons.person),
    new DrawerItem("Products", Icons.tag),
    new DrawerItem("Staff", Icons.person_add),
    new DrawerItem("Setting", Icons.settings),
    new DrawerItem("Support", Icons.support),
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage>{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedDrawerIndex = 0;
  Future? store;
  var deviceIdNum = 0;
  int routeIndex = 0;
  @override
  void initState() {
    print('user ' + FirebaseAuth.instance.currentUser!.uid);
    print('newUserCheck ' + newUserCheck(FirebaseAuth.instance.currentUser!.uid).toString());

    // setStoreId('PucvhZDuUz3XlkTgzcjb').then((String result) {
    //   getStoreId().then((String result2) {
    //     print('store id ' + result2.toString());
    //   });
    //   print('resutl');
    // });
    store = getStoreId();


    // print('store id ' + ());


    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('exits ');
      } else {
        print('no exits ');
      }
    });
    super.initState();
    _getId().then((result) {
      var deviceAdded = false;
      FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('devices')
        .where('id', isEqualTo: result.toString())
        .get()
        .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          deviceAdded = true;
          deviceIdNum = doc['num'];
        });

        if(deviceAdded) {
          // FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('devices')
          //     .doc(dateId).update({
          //   'daily_order': FieldValue.arrayUnion([now.year.toString() + now.month.toString() + now.day.toString() + now.hour.toString() + now.minute.toString() + now.second.toString()+'~'+length.toString()])
          // }).then((value) {
          //   print('User updated');
          //   setState(() {
          //     orderLoading = false;
          //   });
          // });
        } else {
          var length = 0;
          FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('devices')
          // FirebaseFirestore.instance.collection('space')
              .get()
              .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              length++;
            });

            FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('devices')
                .add({
              'id': result.toString(),
              'num': length+1
            })
                .then((value) {
              deviceIdNum = length+1;
              print('order added');
            });
          });

        }
      });
    });
  }


  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return 'ios-' + iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return 'and-' + androidDeviceInfo.androidId; // unique ID on Android
    }
  }


  Future<String> setStoreId(storeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // int counter = (prefs.getInt('counter') ?? 0) + 1;
    // print('Pressed $counter times.');
    prefs.setString('store', storeId).then((bool success) {
      return 'success store saved';
    });
    return 'error store saved';
  }

  Future<String> getStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // return(prefs.getString('store'));

    var index = prefs.getString('store');
    print(index);
    if(index == null) {
      return 'idk';
    } else {
      return index;
    }
  }

  newUserCheck(userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('aHHin46ulpdoxOGh6kav8EDE4xn2')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('here exits ');
      } else {
        print('here no exits ');
      }
    });
  }


  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {

    print(MediaQuery.of(context).size.width.toString());
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(GestureDetector(
        onTap: () {
          _onSelectItem(i);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: new Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: i == _selectedDrawerIndex
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.transparent),
            height: 55,
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                  child: Icon(
                    d.icon,
                    size: 26,
                  ),
                ),
                Text(
                  d.title,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      )
          // new ListTile(
          //   leading: new Icon(d.icon),
          //   title: new Text(d.title),
          //   selected: i == _selectedDrawerIndex,
          //   onTap: () => _onSelectItem(i),
          // )
          );
    }

    return new Scaffold(
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
                          MainFragmentState().changeState(1);
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
                            FutureBuilder(
                              future: store,
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.data.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                );
                              }
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
                            _navigatorKey.currentState!.pushNamed('/');
                            setState(() {
                              routeIndex = 0;
                            });
                            _scaffoldKey.currentState!.openEndDrawer();

                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: new Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: 0 == routeIndex
                                      ? Colors.grey.withOpacity(0.2)
                                      : Colors.transparent),
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
                            _navigatorKey.currentState!.pushNamed('/orders');
                            setState(() {
                              routeIndex = 1;
                            });
                            _scaffoldKey.currentState!.openEndDrawer();



                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: new Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: 1 == routeIndex
                                      ? Colors.grey.withOpacity(0.2)
                                      : Colors.transparent),
                              height: 55,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                                    child: Icon(
                                      Icons.inbox,
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
                            _navigatorKey.currentState!.pushNamed('/customers');
                            setState(() {
                              routeIndex = 2;
                            });
                            _scaffoldKey.currentState!.openEndDrawer();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: new Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: 2 == routeIndex
                                      ? Colors.grey.withOpacity(0.2)
                                      : Colors.transparent),
                              height: 55,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                                    child: Icon(
                                      Icons.person,
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
                            _navigatorKey.currentState!.pushNamed('/products');
                            setState(() {
                              routeIndex = 3;
                            });
                            _scaffoldKey.currentState!.openEndDrawer();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: new Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: 3 == routeIndex
                                      ? Colors.grey.withOpacity(0.2)
                                      : Colors.transparent),
                              height: 55,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                                    child: Icon(
                                      Icons.tag,
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


                        GestureDetector(
                          onTap: () {
                            _navigatorKey.currentState!.pushNamed('/staff');
                            setState(() {
                              routeIndex = 4;
                            });
                            _scaffoldKey.currentState!.openEndDrawer();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: new Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: 4 == routeIndex
                                      ? Colors.grey.withOpacity(0.2)
                                      : Colors.transparent),
                              height: 55,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                                    child: Icon(
                                      Icons.person_add,
                                      size: 26,
                                    ),
                                  ),
                                  Text(
                                    'Staff',
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),


                        GestureDetector(
                          onTap: () {
                            _navigatorKey.currentState!.pushNamed('/settings');
                            // Navigator.pushNamed(context, '/second');
                            setState(() {
                              routeIndex = 5;
                            });
                            _scaffoldKey.currentState!.openEndDrawer();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: new Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: 5 == routeIndex
                                      ? Colors.grey.withOpacity(0.2)
                                      : Colors.transparent),
                              height: 55,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                                    child: Icon(
                                      Icons.settings,
                                      size: 26,
                                    ),
                                  ),
                                  Text(
                                    'Settings',
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),


                        GestureDetector(
                          onTap: () {
                            _navigatorKey.currentState!.pushNamed('/support');
                            setState(() {
                              routeIndex = 6;
                            });
                            _scaffoldKey.currentState!.openEndDrawer();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: new Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: 6 == routeIndex
                                      ? Colors.grey.withOpacity(0.2)
                                      : Colors.transparent),
                              height: 55,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                                    child: Icon(
                                      Icons.support,
                                      size: 26,
                                    ),
                                  ),
                                  Text(
                                    'Support',
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
        ),

        body: Navigator(
          key: _navigatorKey,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            // Manage your route names here
            switch (settings.name) {
              case '/':
                return new NoAnimationMaterialPageRoute(
                  builder: (_) => new HomeFragment(toggleCoinCallback: addCounter),
                  settings: settings,
                );
              // break;
              case '/orders':
                return new NoAnimationMaterialPageRoute(
                  builder: (_) => new OrdersFragment(),
                  settings: settings,
                );
              case '/customers':
                return new NoAnimationMaterialPageRoute(
                  builder: (_) => new CustomersFragment(toggleCoinCallback2: (String str) {  },),
                  settings: settings,
                );
              case '/products':
                return new NoAnimationMaterialPageRoute(
                  builder: (_) => new ProductsFragment(toggleCoinCallback: addNewProd2, toggleCoinCallback2: addProduct, toggleCoinCallback3: (String str) {  },),
                  settings: settings,
                );
              case '/staff':
                return new NoAnimationMaterialPageRoute(
                  builder: (_) => new StaffFragment(),
                  settings: settings,
                );
              case '/settings':
                return new NoAnimationMaterialPageRoute(
                  builder: (_) => new SettingsFragment(),
                  settings: settings,
                );
              case '/support':
                return new NoAnimationMaterialPageRoute(
                  builder: (_) => new SupportFragment(),
                  settings: settings,
                );
              case '/others':
                builder = (BuildContext context) => ProductsFragment(toggleCoinCallback: () {  }, toggleCoinCallback2: addProduct, toggleCoinCallback3: (String str) {  },);
                break;
              default:
                throw Exception('Invalid route: ${settings.name}');
            }
            // You can also return a PageRouteBuilder and
            // define custom transitions between pages
            return MaterialPageRoute(
              builder: builder,
              settings: settings,
            );
          },
        ),
        // body: Builder(builder: (context) {
        //   return SafeArea(
        //     top: true,
        //     bottom: true,
        //     child: Stack(
        //       children: [
        //         _getDrawerItemWidget(_selectedDrawerIndex),
        //         MediaQuery.of(context).size.width>900?Align(
        //           alignment: Alignment.centerRight,
        //           child: Padding(
        //             padding: const EdgeInsets.only(bottom: 56.0),
        //             child: Container(
        //               height: double.infinity,
        //               width: MediaQuery.of(context).size.width*(1.5/3.5),
        //               child: checkoutCart(),
        //             ),
        //           ),
        //         ):Container(),
        //         Align(
        //           alignment: Alignment.bottomCenter,
        //           child: Container(
        //             color: Colors.white,
        //             height: MediaQuery.of(context).size.width>900?57:157,
        //             child: Column(
        //               children: [
        //                 MediaQuery.of(context).size.width>900?Container():Padding(
        //                   padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        //                   child: Container(
        //                     height: 70,
        //                     decoration: BoxDecoration(
        //                       color: Colors.white,
        //                         border: Border(
        //                           top: BorderSide(
        //                               color: Colors.grey, width: 1.0),
        //                         )
        //                     ),
        //                     child: Padding(
        //                       padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
        //                       child: GestureDetector(
        //                         onTap: () {
        //                           addDailyExp(context);
        //                         },
        //                         child: Container(
        //                           decoration: BoxDecoration(
        //                             borderRadius:
        //                             BorderRadius.circular(10.0),
        //                             color: Colors.grey,
        //                           ),
        //                           child: Padding(
        //                             padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        //                             child: Row(
        //                               mainAxisAlignment: MainAxisAlignment.center,
        //                               children: [
        //                                 Expanded(
        //                                   child: Padding(
        //                                     padding: const EdgeInsets.only(left:8.0, right: 8.0, bottom: 3.0),
        //                                     child: Container(child:
        //                                     Text(
        //                                       'Go to cart',
        //                                       textAlign: TextAlign.center,
        //                                       style: TextStyle(
        //
        //                                           fontSize: 18,
        //                                           fontWeight: FontWeight.w600,
        //                                           color: Colors.black
        //                                       ),
        //                                     )
        //                                     ),
        //                                   ),
        //                                 ),
        //                               ],
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 Container(
        //                   height: 57,
        //                   decoration: BoxDecoration(
        //                       border: Border(
        //                     top: BorderSide(
        //                         color: Colors.grey, width: 1.0),
        //                   )),
        //                   child: Padding(
        //                     padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        //                     child: Row(
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       children: [
        //                         Padding(
        //                           padding: const EdgeInsets.only(
        //                             left: 15.0,
        //                           ),
        //                           child: GestureDetector(
        //                               onTap: () {
        //                                 Scaffold.of(context).openDrawer();
        //                               },
        //                               child: Icon(
        //                                 Icons.home_filled,
        //                                 size: 26,
        //                               )),
        //                         ),
        //                         Expanded(
        //                           child: GestureDetector(
        //                             onTap: () async {
        //                               showFlash(
        //                                 context: context,
        //                                 duration: const Duration(seconds: 2),
        //                                 persistent: false,
        //                                 builder: (_, controller) {
        //                                   return Flash(
        //                                     controller: controller,
        //                                     backgroundColor: Colors.transparent,
        //                                     brightness: Brightness.light,
        //                                     // boxShadows: [BoxShadow(blurRadius: 4)],
        //                                     // barrierBlur: 3.0,
        //                                     // barrierColor: Colors.black38,
        //                                     barrierDismissible: true,
        //                                     behavior: FlashBehavior.floating,
        //                                     position: FlashPosition.top,
        //                                     child: Padding(
        //                                       padding: const EdgeInsets.only(top: 10.0),
        //                                       child: Padding(
        //                                         padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        //                                         child: Container(
        //                                           height: 56,
        //                                           decoration: BoxDecoration(
        //                                             borderRadius:
        //                                             BorderRadius.circular(10.0),
        //                                             color: Colors.green,
        //                                           ),
        //                                           child: FlashBar(
        //                                             // title: Text('Title'),
        //                                             content: Text('Hello world!'),
        //                                             // // showProgressIndicator: true,
        //                                             // primaryAction: TextButton(
        //                                             //   onPressed: () => controller.dismiss(),
        //                                             //   child: Text('DISMISS', style: TextStyle(color: Colors.amber)),
        //                                             // ),
        //                                           ),
        //                                         ),
        //                                       ),
        //                                     ),
        //                                   );
        //                                 },
        //                               );
        //                               //logger.info(result);
        //                             },
        //                             child: Container(
        //                               child: Text(
        //                                 'Phyo Pyae Sohn',
        //                                 textAlign: TextAlign.center,
        //                                 style: TextStyle(
        //                                     fontSize: 16.5,
        //                                     fontWeight: FontWeight.w600,
        //                                     color: Colors.black.withOpacity(0.6)),
        //                               )
        //                             ),
        //                           ),
        //                         ),
        //                         Padding(
        //                           padding: const EdgeInsets.only(
        //                             right: 15.0,
        //                           ),
        //                           child: Icon(
        //                             Icons.circle,
        //                             color: Colors.green,
        //                             size: 22,
        //                           ),
        //                         )
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         Container(
        //           child: orderLoading?Text('Loading'):Text('')
        //         )
        //       ],
        //     ),
        //   );
        // }
        // )
    );
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
        return SingleAssetPage(toggleCoinCallback: () {});
      }
    );
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
                  Slidable(
                    key: const ValueKey(1),
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,

                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigoAccent,
                          child: Text('3'),
                          foregroundColor: Colors.white,
                        ),
                        title: Text('Tile n3'),
                        subtitle: Text('SlidableDrawerDelegate'),
                      ),
                    ),
                    // actions: <Widget>[
                    //   IconSlideAction(
                    //     caption: 'Archive',
                    //     color: Colors.blue,
                    //     icon: Icons.archive,
                    //     onTap: () => print('Archive'),
                    //   ),
                    //   IconSlideAction(
                    //     caption: 'Share',
                    //     color: Colors.indigo,
                    //     icon: Icons.share,
                    //     onTap: () => print('Share'),
                    //   ),
                    // ],
                    dismissal: SlidableDismissal(
                        child: SlidableDrawerDismissal(),
                        onWillDismiss: (actionType) {
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
                  )
                  // for(String str in prodList) Row(
                  //   children: [
                  //     // Text(str), Text('unit'), Text('count'), Text('price')
                  //     Text(
                  //       str,
                  //       style: TextStyle(
                  //         fontSize: 10
                  //       ),
                  //     ),
                  //   ],
                  // )


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
                          '2500 MMK',
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
                        // print(prodFieldsValue);

                        CollectionReference orders = FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders').doc('GhitGLyZLoQekKhan9Xd').collection('detail');
                        orders
                            .add({
                          'cust_name': 'U Pyaung'
                        })
                            .then((value) {
                          print('order added');

                          FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
                          // FirebaseFirestore.instance.collection('space')
                              .where('date', isEqualTo: 'saturday')
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            // querySnapshot.docs.forEach((doc) {
                            //   // spaceDocId = doc.id;
                            // });some thing 2~IXFrkXcaIzgIbJJCcuu6^hay hay~QM1BYslqNxfeTKwn9vaT^working?~SxLgzSmAdv5Ni6P3lKfR^yeah its worked~V2lfzHGwHH0vZ9hu3Wek




                            querySnapshot.docs.forEach((doc) {

                              FirebaseFirestore.instance.collection('space').doc('0NHIS0Jbn26wsgCzVBKT').collection('shops').doc('PucvhZDuUz3XlkTgzcjb').collection('orders')
                                  .doc(doc.id)
                                  .update({'data': doc['data']+'^U Pyaung~'+value.id})
                                  .then((value) => print("User Updated"))
                                  .catchError((error) => print("Failed to update user: $error"));

                            });

                          }).then((value) {
                          });

                          // Navigator.pop(context);
                        });
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

  zeroToTen(String string) {
    if(int.parse(string) > 9) {
      return string;
    } else {
      return '0'+string;
    }
  }

  addCounter() {
    setState(() {
      counter++;
    });
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

}



// class MyCustomRoute<T> extends MaterialPageRoute<T> {
//   MyCustomRoute({ required WidgetBuilder builder, required RouteSettings settings })
//       : super(builder: builder, settings: settings);
//
//   @override
//   Widget buildTransitions(BuildContext context,
//       Animation<double> animation,
//       Animation<double> secondaryAnimation,
//       Widget child) {
//     if (settings.isInitialRoute)
//       return child;
//     // Fades between routes. (If you don't want any animation,
//     // just return child.)
//     return new FadeTransition(opacity: animation, child: child);
//   }
// }


class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = true,
  }) : super(
      builder: builder,
      maintainState: maintainState,
      settings: settings,
      fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}




